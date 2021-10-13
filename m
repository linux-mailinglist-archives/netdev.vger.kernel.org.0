Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EBC42CE30
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhJMWeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhJMWeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:34:36 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABBBC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:32:33 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 66so3674687pgc.9
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qWPTPIJDnvPdEiRkoLkZ93QW5GtRiH1iZyD5pZQJVEI=;
        b=EGlAzoDsNL6DW0GDRsulFD7zb3OhpH1XrFE5oqrAFAsqJPPWZ22fTjFi3VEXZHI8lf
         QcJh0brVPe/LyCk4lNeLTiSUBtlDO3y4tB/F04D3WSyQRZtdOWtR1tokj2rN4yuVYlWi
         QZHsmC0Pku8Dw0GR3mLSUu6bnOO0OturOV8nHJewBzR37GiCgt8fZr2oWGY4/X4Ic4xV
         6AE+x7vtZtSBjpiLPAG34ol/Ib8D2cqcsi62eogzaeet0MD4qr4pwSGG+eLKdRGm8yfC
         eWna7lj0b9jD+uUZQD0RfRu68AFrUh0ImBzmccoapG4YqC3kjMcCs10EblJYulOwHvuo
         J7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWPTPIJDnvPdEiRkoLkZ93QW5GtRiH1iZyD5pZQJVEI=;
        b=QrINqYxv+yhgXONjiLJg406anifSHaqxGVqzzYqvQn0HMAdSGm8z+d9KewRTc4nH3C
         lUy08EKG3wM8M8AGbNuO/nOe3xSJ4hBDya+A1fWTJbha5Oy61NPF5yZLBtH6x7QxLvMX
         9oTkfi1RSSuxREKb3eHivFPP+eElo1PiXnSfLOstMEwAUp/HMW6M6At7Vn7suhjDOeze
         zJj8xEBhoLFhIJlYOqFDdfpdjEJ8EXvKvTeIVb/QDDtGZgXubSZmBKir1nAo30m1jXWP
         kG6usEkPgh98fS4f0cxJr0dp4PHlLkyPT85OyzRufeDwcAQu2A/XX1GiQZh/fbFaXtbY
         0sFA==
X-Gm-Message-State: AOAM530z/g9im92B9FICvpOgW78GwWqfsBocvJLvHeAbAdxjCaIs064V
        QQqhEhODOIoJBobJKSWFIgq2jEDAK2A=
X-Google-Smtp-Source: ABdhPJxzsStXeFn7nqdjQltGIWOwnD9wiyEbeT+ezPaRFLhO8bTatQs4uNMDY38cg7nAgO/tT3oYZQ==
X-Received: by 2002:a62:8ccf:0:b0:44c:7db2:344e with SMTP id m198-20020a628ccf000000b0044c7db2344emr1661855pfd.66.1634164352438;
        Wed, 13 Oct 2021 15:32:32 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id i2sm6546091pjt.19.2021.10.13.15.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:32:32 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>
Subject: [PATCH 2/4] net: ndisc: introduce ndisc_evict_nocarrier sysctl parameter
Date:   Wed, 13 Oct 2021 15:27:08 -0700
Message-Id: <20211013222710.4162634-2-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013222710.4162634-1-prestwoj@gmail.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In most situations the neighbor discovery cache should be cleared on a
NOCARRIER event which is currently done unconditionally. But for wireless
roams the neighbor discovery cache can and should remain intact since
the underlying network has not changed.

This patch introduces a sysctl option ndisc_evict_nocarrier which can
be disabled by a wireless supplicant during a roam. This allows packets
to be sent after a roam immediately without having to wait for
neighbor discovery.

A user reported roughly a 1 second delay after a roam before packets
could be sent out (note, on IPv4). This delay was due to the ARP
cache being cleared. During testing of this same scenario using IPv6
no delay was noticed, but regardless there is no reason to clear
the ndisc cache for wireless roams.

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 include/linux/ipv6.h      |  1 +
 include/uapi/linux/ipv6.h |  1 +
 net/ipv6/addrconf.c       | 10 ++++++++++
 net/ipv6/ndisc.c          |  5 ++++-
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 70b2ad3b9884..72297d759a23 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -76,6 +76,7 @@ struct ipv6_devconf {
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
 	__s32		rpl_seg_enabled;
+	__u32		ndisc_evict_nocarrier;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 70603775fe91..999b290d79c3 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -190,6 +190,7 @@ enum {
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
 	DEVCONF_RA_DEFRTR_METRIC,
+	DEVCONF_NDISC_EVICT_NOCARRIER,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 701eb82acd1c..b538054f8d0d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -237,6 +237,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.ndisc_evict_nocarrier	= 1,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -293,6 +294,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.ndisc_evict_nocarrier	= 1,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -5526,6 +5528,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
 	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
 	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
+	array[DEVCONF_NDISC_EVICT_NOCARRIER] = cnf->ndisc_evict_nocarrier;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6932,6 +6935,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "ndisc_evict_nocarrier",
+		.data		= &ipv6_devconf.ndisc_evict_nocarrier,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index c467c6419893..d80346a2a789 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1805,10 +1805,13 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
 		in6_dev_put(idev);
 		break;
 	case NETDEV_CHANGE:
+		idev = in6_dev_get(dev);
+		if (!idev)
+			break;
 		change_info = ptr;
 		if (change_info->flags_changed & IFF_NOARP)
 			neigh_changeaddr(&nd_tbl, dev);
-		if (!netif_carrier_ok(dev))
+		if (!netif_carrier_ok(dev) && idev->cnf.ndisc_evict_nocarrier)
 			neigh_carrier_down(&nd_tbl, dev);
 		break;
 	case NETDEV_DOWN:
-- 
2.31.1

