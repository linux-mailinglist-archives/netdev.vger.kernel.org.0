Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05228334728
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhCJSv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:51:26 -0500
Received: from z11.mailgun.us ([104.130.96.11]:58198 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhCJSvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 13:51:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615402278; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=cBKHhBbJTMWXn9V6I+Im4MZl8Vu1tPdJozwSyOcsf3k=; b=KsBy3vEcvjMYYMjeG6+JMHl8D1awS5jTMI1I5u11zxQYMfy5eR2CoAEQ+89BLgLyMmIP0R2H
 4SdhlzwCd1DTtaunwda+y8xmtZuQpG9XLI+K5OY6yoPEr2zADihyNUBm256hgp0E8LHde81O
 1XpYySl4Agizha4kFQsRaZQSeOQ=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60491521155a7cd234c680b0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Mar 2021 18:51:13
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9AE29C433C6; Wed, 10 Mar 2021 18:51:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1BAE1C433C6;
        Wed, 10 Mar 2021 18:51:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1BAE1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net-next] net: ipv6: addrconf: Add accept_ra_prefix_route.
Date:   Wed, 10 Mar 2021 11:49:53 -0700
Message-Id: <1615402193-12122-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added new procfs flag to toggle the automatic addition of prefix
routes on a per device basis. The new flag is accept_ra_prefix_route.

A value of 0 for the flag maybe used in some forwarding scenarios
when a userspace daemon is managing the routing.
Manual deletion of the kernel installed route was not sufficient as
kernel was adding back the route.

Defaults to 1 as to not break existing behavior.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 Documentation/networking/ip-sysctl.rst | 10 ++++++++++
 include/linux/ipv6.h                   |  1 +
 include/uapi/linux/ipv6.h              |  1 +
 net/ipv6/addrconf.c                    | 16 +++++++++++++---
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c7952ac..9f0d92d 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2022,6 +2022,16 @@ accept_ra_mtu - BOOLEAN
 		- enabled if accept_ra is enabled.
 		- disabled if accept_ra is disabled.
 
+accept_ra_prefix_route - BOOLEAN
+	Apply the prefix route based on the RA. If disabled, kernel
+	does not install the route. This can be used if a userspace
+	daemon is managing the routing.
+
+	Functional default:
+
+		- enabled if accept_ra_prefix_route is enabled
+		- disabled if accept_ra_prefix_route is disabled
+
 accept_redirects - BOOLEAN
 	Accept Redirects.
 
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 70b2ad3..ae81f7d 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -76,6 +76,7 @@ struct ipv6_devconf {
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
 	__s32		rpl_seg_enabled;
+	__s32		accept_ra_prefix_route;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 70603775..194b272 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -190,6 +190,7 @@ enum {
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
 	DEVCONF_RA_DEFRTR_METRIC,
+	DEVCONF_ACCEPT_RA_PREFIX_ROUTE,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f2337fb..5ddef05 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -237,6 +237,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.accept_ra_prefix_route = 1,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -293,6 +294,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.accept_ra_prefix_route = 1,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -2750,9 +2752,10 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 				flags |= RTF_EXPIRES;
 				expires = jiffies_to_clock_t(rt_expires);
 			}
-			addrconf_prefix_route(&pinfo->prefix, pinfo->prefix_len,
-					      0, dev, expires, flags,
-					      GFP_ATOMIC);
+			if (dev->ip6_ptr->cnf.accept_ra_prefix_route) {
+				addrconf_prefix_route(&pinfo->prefix, pinfo->prefix_len,
+						      0, dev, expires, flags, GFP_ATOMIC);
+			}
 		}
 		fib6_info_release(rt);
 	}
@@ -6859,6 +6862,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 	{
 		.procname	= "seg6_enabled",
 		.data		= &ipv6_devconf.seg6_enabled,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+	},
+	{
+		.procname	= "accept_ra_prefix_route",
+		.data		= &ipv6_devconf.accept_ra_prefix_route,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

