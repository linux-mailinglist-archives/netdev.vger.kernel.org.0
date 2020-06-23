Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C52E205528
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732849AbgFWOx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732738AbgFWOxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 10:53:55 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1365DC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 07:53:55 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d7so11822625lfi.12
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 07:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IaNND0q48lsLX+wQHUWkI/1J3TqyuwPidODIiW6YgTM=;
        b=xmOn8is9WO7cBlx/mrE/8knaaJRKNvRPntkf4KLv3zrA1Ak9VCJlU54rGE+7pl3I5k
         QkdYQwfCdncputIqYcav8uMOSZQYV1FzKXEQVpfWQrc2DqWBDgY6J+nwGp82uNjrX5NK
         MN5D25j4KMZRwUftAGH15GFIAugCf5eZEaJu3e8jE+dcv2gURK05skAhWR0pUojoBfNd
         A8m0du5V+QCStwXYcvdYLCA1iAia3WQciJx3+L4x/bK6dHnnWeuUl9jTIzf2KvqiP526
         sGGTbRzPBk47wCee+r7r2D+3dLxNPZflHyBsZf/IeQj6fkypjYPjmyYBs5EUOufcrBHM
         DaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IaNND0q48lsLX+wQHUWkI/1J3TqyuwPidODIiW6YgTM=;
        b=Fzp1k7bCiSG/KUd0rEhqiw2KSbHh3ai3DZ0HQ78aJXZme8y6EI5P2HFfeiUnjNxpX3
         hE1jibTVVCPuIjYgl+Tzj4qBe6tDC+oMKXza52E4ANfZzL/Shy+pAJViz1jRNgPfIQ2E
         a6TLvgonysqr6uVYmfzgvP+uVVZE8/OWfR9sBUNZhKLgLbT+ZIsz+9hqH1s7Y4/n5WQ+
         GTLdtTyze6Pw/Qf5fDok11qJ2dHqiN5f+z/votkMDezbi3gz+kAfPLd+rWHUHDo/cXEy
         iLVFz7S/dYEOfemDqX6RWEXniH31KBy+tQKBwUGJBcE2kqr/UM98e5OGmIdbOWOWk8LQ
         G9kQ==
X-Gm-Message-State: AOAM532VC1o2PQu9mKACnppivCpgLe+dRN/Beor9JAaQjy0mulnGitLL
        DvIfBSK61s+PFPitR4MUdb/3TWP23y30qQ==
X-Google-Smtp-Source: ABdhPJxz5/cGYOUhyVbpHvNdz1o3C9sj+VyLhMaypxCNnaqoVpfXX2ojidPRdQgXO9t1hqg4tAV9pQ==
X-Received: by 2002:a19:c657:: with SMTP id w84mr9037168lff.144.1592924033008;
        Tue, 23 Jun 2020 07:53:53 -0700 (PDT)
Received: from localhost.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id c27sm1791894lfm.56.2020.06.23.07.53.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 07:53:52 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <denis.kirjanov@suse.com>
To:     netdev@vger.kernel.org
Subject: [PATCH] tcp: don't ignore ECN CWR on pure ACK
Date:   Tue, 23 Jun 2020 17:53:43 +0300
Message-Id: <20200623145343.7546-1-denis.kirjanov@suse.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is a problem with the CWR flag set in an incoming ACK segment
and it leads to the situation when the ECE flag is latched forever

the following packetdrill script shows what happens:

// Stack receives incoming segments with CE set
+0.1 <[ect0]  . 11001:12001(1000) ack 1001 win 65535
+0.0 <[ce]    . 12001:13001(1000) ack 1001 win 65535
+0.0 <[ect0] P. 13001:14001(1000) ack 1001 win 65535

// Stack repsonds with ECN ECHO
+0.0 >[noecn]  . 1001:1001(0) ack 12001
+0.0 >[noecn] E. 1001:1001(0) ack 13001
+0.0 >[noecn] E. 1001:1001(0) ack 14001

// Write a packet
+0.1 write(3, ..., 1000) = 1000
+0.0 >[ect0] PE. 1001:2001(1000) ack 14001

// Pure ACK received
+0.01 <[noecn] W. 14001:14001(0) ack 2001 win 65535

// Since CWR was sent, this packet should NOT have ECE set

+0.1 write(3, ..., 1000) = 1000
+0.0 >[ect0]  P. 2001:3001(1000) ack 14001
// but Linux will still keep ECE latched here, with packetdrill
// flagging a missing ECE flag, expecting
// >[ect0] PE. 2001:3001(1000) ack 14001
// in the script

In the situation above we will continue to send ECN ECHO packets
and trigger the peer to reduce the congestion window.

Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
---
 net/ipv4/tcp_input.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 12fda8f27b08..e00b88c8598d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3696,8 +3696,13 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 				      &rexmit);
 	}
 
-	if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
+	if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP)) {
+		/* If we miss the CWR flag then ECE will be
+		 * latched forever.
+		 */
+		tcp_ecn_accept_cwr(sk, skb);
 		sk_dst_confirm(sk);
+	}
 
 	delivered = tcp_newly_delivered(sk, delivered, flag);
 	lost = tp->lost - lost;			/* freshly marked lost */
@@ -4800,8 +4805,6 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	skb_dst_drop(skb);
 	__skb_pull(skb, tcp_hdr(skb)->doff * 4);
 
-	tcp_ecn_accept_cwr(sk, skb);
-
 	tp->rx_opt.dsack = 0;
 
 	/*  Queue data for delivery to the user.
-- 
2.27.0

