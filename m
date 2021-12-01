Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0A74644A4
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 02:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345549AbhLABzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 20:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhLABzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 20:55:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF9FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 17:52:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1893CB81DB3
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 01:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90495C53FCB;
        Wed,  1 Dec 2021 01:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638323520;
        bh=i0jEIYa4n6F7d9rfYCW9ktrYsB5r1/WGj3e+y6KRd6w=;
        h=From:To:Cc:Subject:Date:From;
        b=qJCoAhFc1NTwjPGiFROkvg841taP6aLWMsLYXm6Tp4TmjDdLPfUOKc+ztIl1DtCv3
         vTZv8rDHevrScbeUKLckFQO9sL7cWc1O6yapqbOC5jXAtdAyTfKnIyCpcgjORkJsDS
         QDheNQkrQ55gU+olI2Vgq2ul+X5rW6esvf715h6VV3si8Q2TC09HXI4/84aT4fybLZ
         NV/mpPRek7pAyWWlm97eIxSPAotIFQDnj/9Zg12eNqIgl+7hiuTpn+hgrXekabMaRa
         QBbhcoBvRqpXljJRY22TEEuu61S4BLSzRL2gwuSNCZQtwj3A0mHuAY+Dely9DKB4g7
         x948b85kMqkog==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        imagedong@tencent.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] tcp: remove the TCPSmallQueueFailure counter
Date:   Tue, 30 Nov 2021 17:51:44 -0800
Message-Id: <20211201015144.112701-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit aeeecb889165 ("net: snmp: add statistics for
tcp small queue check").

The recently added TSQ-limit-hit metric does not provide clear,
actionable signal and can be confusing to the user as it may
well increment under normal operation (yet it has Failure in
its name). Menglong mentioned that the condition he was
targetting arised due to a bug in the virtio driver.

Link: https://lore.kernel.org/r/20211128060102.6504-1-imagedong@tencent.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/snmp.h | 1 -
 net/ipv4/proc.c           | 1 -
 net/ipv4/tcp_output.c     | 5 +----
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index e32ec6932e82..904909d020e2 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -292,7 +292,6 @@ enum
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
-	LINUX_MIB_TCPSMALLQUEUEFAILURE,		/* TCPSmallQueueFailure */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 43b7a77cd6b4..f30273afb539 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -297,7 +297,6 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
-	SNMP_MIB_ITEM("TCPSmallQueueFailure", LINUX_MIB_TCPSMALLQUEUEFAILURE),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c4ab6c8f0c77..5079832af5c1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2524,11 +2524,8 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 		 * test again the condition.
 		 */
 		smp_mb__after_atomic();
-		if (refcount_read(&sk->sk_wmem_alloc) > limit) {
-			NET_INC_STATS(sock_net(sk),
-				      LINUX_MIB_TCPSMALLQUEUEFAILURE);
+		if (refcount_read(&sk->sk_wmem_alloc) > limit)
 			return true;
-		}
 	}
 	return false;
 }
-- 
2.31.1

