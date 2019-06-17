Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202F848997
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbfFQREh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:04:37 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:50350 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfFQREg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:04:36 -0400
Received: by mail-qt1-f201.google.com with SMTP id g30so9791853qtm.17
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Zm3dsp+4c4Dzvg1A7uPwIxj0li9zDT8Y3ELdlF7uors=;
        b=evLjwvEGgiNgQBesTmz3yPZnfhbYobecnwlOmxNpXpo1yaICUAljUHct8f82HuboO7
         otBebs7eeDdLizzJc7mgJbNqQ4pJAw7LYu6SZpWr3IxPiZvLb8369y0YUtEY4yhgdFfH
         TXorT8lhAY4P3fpBzXliaxkkuW8wTpg9+OjoEOqMFJo//wCg8U/hB+O+xR/pVByZ3HdM
         7R2r5WFzyHbK+gqLWlrFx9vl/a+ytw2BzxMxfRXwHuTJKTi1unP9XvScTwa49itDTus2
         I9i5T7hj/1VlBeezf5SuA2GfF+hMTKbOLh9nnG9XkhO2TJ0JH/10DFZpENej/tqvz/Pv
         ZNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Zm3dsp+4c4Dzvg1A7uPwIxj0li9zDT8Y3ELdlF7uors=;
        b=pUwmil+NlOsSiwcf+inPtDnfBY0126HYDK+1lyCXcYI2tXdwTS4MgAFdpW1HmXnL6L
         cO+rGTlNAxj7kpd+OjJs2wjuiw9B+rnS7MkiWRacCh63YMM5OUQM8gKTpRreiR2DogMu
         iwmQCHU3H70pTUzJSdCMbK7Tnkx3710oAisJMem3PFCA6+ZDjZiWJEaPhv6ICm20pArB
         SIyEcOqL7nDS3W+zjMguLqghJ0pLuaoWQn2RLy9zYEoWH+tUP8DQUxKuqovHOndoAfxs
         hoXI0JqLBz7e016NxeS1jjDqIH7Kn4PdSfVE1aXDeikHKm6rbcqvnoTZOlT1MRRSeulY
         MQOQ==
X-Gm-Message-State: APjAAAVrDKAstR3LizlnnJ5JaNb59DTblN8lFmlwXoQaNF3L6NGSoLss
        VecUrkNKgGoSCMGjIhMklMbhYG/F5TdDoA==
X-Google-Smtp-Source: APXvYqwAgZqsi5C1NKJbo4OBxYDCKIS24DbNUFKebKjpOEapkfCxXuIT+3a636BE02j2zQpxd4bTmlzJ2OOB9Q==
X-Received: by 2002:ac8:82a:: with SMTP id u39mr38710867qth.370.1560791075610;
 Mon, 17 Jun 2019 10:04:35 -0700 (PDT)
Date:   Mon, 17 Jun 2019 10:03:52 -0700
In-Reply-To: <20190617170354.37770-1-edumazet@google.com>
Message-Id: <20190617170354.37770-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190617170354.37770-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory limits
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Looney reported that a malicious peer can force a sender
to fragment its retransmit queue into tiny skbs, inflating memory
usage and/or overflow 32bit counters.

TCP allows an application to queue up to sk_sndbuf bytes,
so we need to give some allowance for non malicious splitting
of retransmit queue.

A new SNMP counter is added to monitor how many times TCP
did not allow to split an skb if the allowance was exceeded.

Note that this counter might increase in the case applications
use SO_SNDBUF socket option to lower sk_sndbuf.

CVE-2019-11478 : tcp_fragment, prevent fragmenting a packet when the
	socket is already using more than half the allowed space

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jonathan Looney <jtl@netflix.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Bruce Curtis <brucec@netflix.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/linux/snmp.h | 1 +
 net/ipv4/proc.c           | 1 +
 net/ipv4/tcp_output.c     | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 86dc24a96c90ab047d5173d625450facd6c6dd79..fd42c1316d3d112ecd8a00d2b499d6f6901c5e81 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -283,6 +283,7 @@ enum
 	LINUX_MIB_TCPACKCOMPRESSED,		/* TCPAckCompressed */
 	LINUX_MIB_TCPZEROWINDOWDROP,		/* TCPZeroWindowDrop */
 	LINUX_MIB_TCPRCVQDROP,			/* TCPRcvQDrop */
+	LINUX_MIB_TCPWQUEUETOOBIG,		/* TCPWqueueTooBig */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 4370f4246e86dfe06a9e07cace848baeaf6cc4da..073273b751f8fcda1c9c79cd1ab566f2939b2517 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -287,6 +287,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPAckCompressed", LINUX_MIB_TCPACKCOMPRESSED),
 	SNMP_MIB_ITEM("TCPZeroWindowDrop", LINUX_MIB_TCPZEROWINDOWDROP),
 	SNMP_MIB_ITEM("TCPRcvQDrop", LINUX_MIB_TCPRCVQDROP),
+	SNMP_MIB_ITEM("TCPWqueueTooBig", LINUX_MIB_TCPWQUEUETOOBIG),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b8e3bbb852117459d131fbb41d69ae63bd251a3e..1bb1c46b4abad100622d3f101a0a3ca0a6c8e881 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1296,6 +1296,11 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	if (nsize < 0)
 		nsize = 0;
 
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
+		return -ENOMEM;
+	}
+
 	if (skb_unclone(skb, gfp))
 		return -ENOMEM;
 
-- 
2.22.0.410.gd8fdbe21b5-goog

