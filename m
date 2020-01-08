Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DFC133912
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 03:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgAHCTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 21:19:08 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:34127 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbgAHCTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 21:19:08 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 328264B0F0;
        Wed,  8 Jan 2020 13:19:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1578449946; bh=7kL6G
        d9QgVrVwNcdQwfxjYZY0q6jSTK5JkdTcnXIoYk=; b=SZs18tdq2ZYxEdh9W5rkI
        Nh40jjVjarDuiTXI74W5+V2Dz39lyUDhLTC0+HzMQ+VmEAtr204MN7YhmShfIDOy
        32plgbLOL6hJT6VNsACHmOcm7AeIT/5szIDSjuhtYwB94kNWrnxw6PEJsRCwilw9
        nIuMdB8BBcHqzRcJF+/Uls=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0wpjIOWH2xcz; Wed,  8 Jan 2020 13:19:06 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 07C364C137;
        Wed,  8 Jan 2020 13:19:06 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id CB18B4B0F0;
        Wed,  8 Jan 2020 13:19:04 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix wrong connect() return code
Date:   Wed,  8 Jan 2020 09:19:00 +0700
Message-Id: <20200108021900.24802-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current 'tipc_wait_for_connect()' function does a wait-loop for the
condition 'sk->sk_state != TIPC_CONNECTING' to conclude if the socket
connecting has done. However, when the condition is met, it returns '0'
even in the case the connecting is actually failed, the socket state is
set to 'TIPC_DISCONNECTING' (e.g. when the server socket has closed..).
This results in a wrong return code for the 'connect()' call from user,
making it believe that the connection is established and go ahead with
building, sending a message, etc. but finally failed e.g. '-EPIPE'.

This commit fixes the issue by changing the wait condition to the
'tipc_sk_connected(sk)', so the function will return '0' only when the
connection is really established. Otherwise, either the socket 'sk_err'
if any or '-ETIMEDOUT'/'-EINTR' will be returned correspondingly.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 6ebd809ef207..f9b4fb92c0b1 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2443,8 +2443,8 @@ static int tipc_wait_for_connect(struct socket *sock, long *timeo_p)
 			return sock_intr_errno(*timeo_p);
 
 		add_wait_queue(sk_sleep(sk), &wait);
-		done = sk_wait_event(sk, timeo_p,
-				     sk->sk_state != TIPC_CONNECTING, &wait);
+		done = sk_wait_event(sk, timeo_p, tipc_sk_connected(sk),
+				     &wait);
 		remove_wait_queue(sk_sleep(sk), &wait);
 	} while (!done);
 	return 0;
-- 
2.13.7

