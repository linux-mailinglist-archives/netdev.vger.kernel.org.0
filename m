Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0FD1570E4
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 09:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgBJIf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 03:35:56 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33259 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727452AbgBJIf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 03:35:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id CAC474CED9;
        Mon, 10 Feb 2020 19:35:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:content-type:content-type
        :mime-version:x-mailer:message-id:date:date:subject:subject:from
        :from:received:received:received; s=mail_dkim; t=1581323751; bh=
        qvB3o0SkGfxHZGh9syTq9zEyk3CFUBn0LIH0pAV5lII=; b=gQlEbqkPB3QFeiJ7
        PDizSFPqdyL6WlAJ/Bdoxz+lg727S8TdhEAKyDSyqsp31f4XRXHD+DGqxR/1fnvw
        QrPNokME9G/c0CTPYiBWS0iDczewuou+dpzLRySyndgW57Fqgto+41nGZa8Es13G
        e02SSzxi5T1gZQZNLPNphlVygEM=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Jp1gaIMIONHN; Mon, 10 Feb 2020 19:35:51 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 431954CEDE;
        Mon, 10 Feb 2020 19:35:51 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id D5C3C4CED9;
        Mon, 10 Feb 2020 19:35:49 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix successful connect() but timed out
Date:   Mon, 10 Feb 2020 15:35:44 +0700
Message-Id: <20200210083544.31501-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 9546a0b7ce00 ("tipc: fix wrong connect() return code"), we
fixed the issue with the 'connect()' that returns zero even though the
connecting has failed by waiting for the connection to be 'ESTABLISHED'
really. However, the approach has one drawback in conjunction with our
'lightweight' connection setup mechanism that the following scenario
can happen:

          (server)                        (client)

   +- accept()|                      |             wait_for_conn()
   |          |                      |connect() -------+
   |          |<-------[SYN]---------|                 > sleeping
   |          |                      *CONNECTING       |
   |--------->*ESTABLISHED           |                 |
              |--------[ACK]-------->*ESTABLISHED      > wakeup()
        send()|--------[DATA]------->|\                > wakeup()
        send()|--------[DATA]------->| |               > wakeup()
          .   .          .           . |-> recvq       .
          .   .          .           . |               .
        send()|--------[DATA]------->|/                > wakeup()
       close()|--------[FIN]-------->*DISCONNECTING    |
              *DISCONNECTING         |                 |
              |                      ~~~~~~~~~~~~~~~~~~> schedule()
                                                       | wait again
                                                       .
                                                       .
                                                       | ETIMEDOUT

Upon the receipt of the server 'ACK', the client becomes 'ESTABLISHED'
and the 'wait_for_conn()' process is woken up but not run. Meanwhile,
the server starts to send a number of data following by a 'close()'
shortly without waiting any response from the client, which then forces
the client socket to be 'DISCONNECTING' immediately. When the wait
process is switched to be running, it continues to wait until the timer
expires because of the unexpected socket state. The client 'connect()'
will finally get =E2=80=98-ETIMEDOUT=E2=80=99 and force to release the so=
cket whereas
there remains the messages in its receive queue.

Obviously the issue would not happen if the server had some delay prior
to its 'close()' (or the number of 'DATA' messages is large enough),
but any kind of delay would make the connection setup/shutdown "heavy".
We solve this by simply allowing the 'connect()' returns zero in this
particular case. The socket is already 'DISCONNECTING', so any further
write will get '-EPIPE' but the socket is still able to read the
messages existing in its receive queue.

Note: This solution doesn't break the previous one as it deals with a
different situation that the socket state is 'DISCONNECTING' but has no
error (i.e. sk->sk_err =3D 0).

Fixes: 9546a0b7ce00 ("tipc: fix wrong connect() return code")
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index f9b4fb92c0b1..693e8902161e 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2441,6 +2441,8 @@ static int tipc_wait_for_connect(struct socket *soc=
k, long *timeo_p)
 			return -ETIMEDOUT;
 		if (signal_pending(current))
 			return sock_intr_errno(*timeo_p);
+		if (sk->sk_state =3D=3D TIPC_DISCONNECTING)
+			break;
=20
 		add_wait_queue(sk_sleep(sk), &wait);
 		done =3D sk_wait_event(sk, timeo_p, tipc_sk_connected(sk),
--=20
2.13.7

