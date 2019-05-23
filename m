Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11902855E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbfEWRyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:54:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45485 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731401AbfEWRyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:54:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so3633547pfm.12
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=40HjFPwXhb2ogNynNYyx1w4NarVmklPI0c5LLASU9zM=;
        b=zIIT4C+VW9TeEvgdlnegNxOGPhVmBVQZ3Pj0yK75tWjc3Pm63ELGq7L/SQFhHNj8Yo
         3QKc54VmXD/qKGZ9FiQ2/SH2XeZPpqNMQhTJe/LMRXMCLlqvrO6tOen9pZGOmxtowDCE
         PPlRYHHOECurT7thwcISbZ8qIa8YCw4IK1LiX+otkZfCrYBIYmmSPi8pYhKzrWrDMLx3
         pQ2ojNIsysSbrY5uQjezTk90cmEQWslYDkDHNEUrvyMTdRqBQuBltTf58rtNeTI1EauL
         yUfCXEMv3K0aCywfSy/4vLPF/Iy8eUAncEXQ+nxlDMfzNC6nQrDEugAJrk/jmW9T+dnR
         YJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=40HjFPwXhb2ogNynNYyx1w4NarVmklPI0c5LLASU9zM=;
        b=kW/AKjJPc91dHjnKIoNxS7WBtlUju6vtnBQAA6Dqm9jZNP6sjd+WMUpcxeG1zM+xBX
         UvDEFBrtM7coSjRBhhvmiHkU8Zp1Fivb0pP7r79K0IW0uTVy1FPgbBWtfG4guSehWHRJ
         pjlepBSNFuxSepf+LcAlWmUzGXG+X602MtUWgYoluCMaNmtOWADHmviYoZnJnLHMhDPc
         cABUZwmWnE/KTive8GbZ8l0pVjxgwhLgXRtbj7bXdrYSmSRe3DAGrgKBUx+epeiaDT1E
         C5UUSwhc1x7MqCTebSMeyBlwKeoyzoGafkcp9U3AIK47xjLgG2XjKhiX77mOiEU3P4jQ
         htiQ==
X-Gm-Message-State: APjAAAV+DLxVINTp6/fPx8nNW6K644I0WVKVd8YJ5Ch1PeFLtoumjKxB
        BpH7ogwszrmi1k2IDyYALZO3UH2kfEY=
X-Google-Smtp-Source: APXvYqwXsXIh/vhz4OTi3ggZZyRyK4v7Mh6L6Ubq5AvcyX+anjMzqFJ7o84dwWb7dOHSzJdB3qDCXQ==
X-Received: by 2002:a63:a709:: with SMTP id d9mr31271786pgf.263.1558634082129;
        Thu, 23 May 2019 10:54:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n35sm4942pjc.3.2019.05.23.10.54.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 10:54:41 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH v3 2/2] net: core: support XDP generic on stacked devices.
Date:   Thu, 23 May 2019 10:54:29 -0700
Message-Id: <20190523175429.13302-3-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523175429.13302-1-sthemmin@microsoft.com>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a device is stacked like (team, bonding, failsafe or netvsc) the
XDP generic program for the parent device was not called.

Move the call to XDP generic inside __netif_receive_skb_core where
it can be done multiple times for stacked case.

Suggested-by: Jiri Pirko <jiri@resnulli.us>
Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
v1 - call xdp_generic in netvsc handler
v2 - do xdp_generic in generic rx handler processing
v3 - move xdp_generic call inside the another pass loop

 net/core/dev.c | 56 ++++++++++----------------------------------------
 1 file changed, 11 insertions(+), 45 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505cfb3e..696776e14d00 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4502,23 +4502,6 @@ static int netif_rx_internal(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		/* Consider XDP consuming the packet a success from
-		 * the netdev point of view we do not want to count
-		 * this as an error.
-		 */
-		if (ret != XDP_PASS)
-			return NET_RX_SUCCESS;
-	}
-
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
@@ -4858,6 +4841,17 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 
 	__this_cpu_inc(softnet_data.processed);
 
+	if (static_branch_unlikely(&generic_xdp_needed_key)) {
+		int ret2;
+
+		preempt_disable();
+		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		preempt_enable();
+
+		if (ret2 != XDP_PASS)
+			return NET_RX_DROP;
+	}
+
 	if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
 	    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
 		skb = skb_vlan_untag(skb);
@@ -5178,19 +5172,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		if (ret != XDP_PASS)
-			return NET_RX_DROP;
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
@@ -5224,21 +5205,6 @@ static void netif_receive_skb_list_internal(struct list_head *head)
 	}
 	list_splice_init(&sublist, head);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		preempt_disable();
-		rcu_read_lock();
-		list_for_each_entry_safe(skb, next, head, list) {
-			xdp_prog = rcu_dereference(skb->dev->xdp_prog);
-			skb_list_del_init(skb);
-			if (do_xdp_generic(xdp_prog, skb) == XDP_PASS)
-				list_add_tail(&skb->list, &sublist);
-		}
-		rcu_read_unlock();
-		preempt_enable();
-		/* Put passed packets back on main list */
-		list_splice_init(&sublist, head);
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
-- 
2.20.1

