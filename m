Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B707439C18
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhJYQxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbhJYQxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:53:52 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1613C061348
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:51:30 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v16so2963932ple.9
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xHjJC2hu3BeM9XpNkNBh8SQc9YF+9x8//PYp1Z4GPYU=;
        b=nOSPnMP0AUcGKgSeUPeDJW6pGrmC7v7u6RXqle+RRInvDmtFVovsDvTXvNyFhyXbxL
         cBXg7QfkgZuclVFqdzjW32Rf3vBFVY78DaDXW+3l1W+y1DYhMsjYP1KAUw6qOk6EjbCO
         mItsYBzVvhhH6ECTUDM65H6BCr2DtlyohDSQA5ZqWhZS0sEja1LRjdxRkm8sB+eMQroj
         4pxYWaF7Yvuq5Je7AD0H+5d6HjJDNAFC4k+VmflAPQRIB6vC61Ppahm3Dwq4U0Da+Cdu
         f+a1N3TETy/pcrFO32VgyOKz5r4GFeaCbpI8/PImb8YRz198yp+hM9T/QnAr6sqVaJcl
         2f9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xHjJC2hu3BeM9XpNkNBh8SQc9YF+9x8//PYp1Z4GPYU=;
        b=LFoIM/CNQZeuMqfuiD+/ify1/kiza/+sLHgTpoVwSTDMSkcFFZZ2f2mHUk/xyosirD
         h2mcQEXbpzMSsMF2voUjHZKkgaLbGWIkXXYFx45yAUpDORSMg4cF8K7AWA0n9lHH9wB0
         hdASrPhBrreDqQ77a2sbyDeFuKy7GFwp3xXy17tdJJp0pWvAFAF/2TsFhFiqYAMBxJy0
         REbfI8BS2/GYQHjeET47KztkMW/+UlSksnbKf8LjhUdNvl7c+S5+9qN72Ld6RxyE6qa1
         acxjc59NM+JHrM0Nypy17lFupLDseXQcTbcw8l56itihmD6SGR4d85hWIPRDiON/BMKo
         iNiA==
X-Gm-Message-State: AOAM531R/BJyHtj9E52odnOPNddo/jVHXzSAngQCd0GD4R0RYDZxe//5
        /gA1o/2Uf1vLySxgO0jrNWeKQeyMOnI=
X-Google-Smtp-Source: ABdhPJyhtKOsClK4ECo2nCMtuV03D+E97heItnMaDbilti2vp7gt5/g3yo993yKto7sKtfzy043yLA==
X-Received: by 2002:a17:90b:314c:: with SMTP id ip12mr11364145pjb.23.1635180689861;
        Mon, 25 Oct 2021 09:51:29 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id h1sm13390531pfh.118.2021.10.25.09.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:51:29 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org,
        James Prestwood <prestwoj@gmail.com>
Subject: [RESEND PATCH v7 2/3] net: ndisc: introduce ndisc_evict_nocarrier sysctl parameter
Date:   Mon, 25 Oct 2021 09:45:46 -0700
Message-Id: <20211025164547.1097091-3-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025164547.1097091-1-prestwoj@gmail.com>
References: <20211025164547.1097091-1-prestwoj@gmail.com>
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
 Documentation/networking/ip-sysctl.rst |  9 +++++++++
 include/linux/ipv6.h                   |  1 +
 include/uapi/linux/ipv6.h              |  1 +
 net/ipv6/addrconf.c                    | 12 ++++++++++++
 net/ipv6/ndisc.c                       | 12 +++++++++++-
 5 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 18fde4ed7a5e..c61cc0219f4c 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2350,6 +2350,15 @@ ndisc_tclass - INTEGER
 
 	* 0 - (default)
 
+ndisc_evict_nocarrier - BOOLEAN
+	Clears the neighbor discovery table on NOCARRIER events. This option is
+	important for wireless devices where the neighbor discovery cache should
+	not be cleared when roaming between access points on the same network.
+	In most cases this should remain as the default (1).
+
+	- 1 - (default): Clear neighbor discover cache on NOCARRIER events.
+	- 0 - Do not clear neighbor discovery cache on NOCARRIER events.
+
 mldv1_unsolicited_report_interval - INTEGER
 	The interval in milliseconds in which the next unsolicited
 	MLDv1 report retransmit will take place.
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index ef4a69865737..753e5c0db2a3 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -79,6 +79,7 @@ struct ipv6_devconf {
 	__u32		ioam6_id;
 	__u32		ioam6_id_wide;
 	__u8		ioam6_enabled;
+	__u8		ndisc_evict_nocarrier;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index b243a53fa985..d4178dace0bf 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -193,6 +193,7 @@ enum {
 	DEVCONF_IOAM6_ENABLED,
 	DEVCONF_IOAM6_ID,
 	DEVCONF_IOAM6_ID_WIDE,
+	DEVCONF_NDISC_EVICT_NOCARRIER,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index d4fae16deec4..398294aa8348 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -241,6 +241,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.ioam6_enabled		= 0,
 	.ioam6_id               = IOAM6_DEFAULT_IF_ID,
 	.ioam6_id_wide		= IOAM6_DEFAULT_IF_ID_WIDE,
+	.ndisc_evict_nocarrier	= 1,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -300,6 +301,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.ioam6_enabled		= 0,
 	.ioam6_id               = IOAM6_DEFAULT_IF_ID,
 	.ioam6_id_wide		= IOAM6_DEFAULT_IF_ID_WIDE,
+	.ndisc_evict_nocarrier	= 1,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -5542,6 +5544,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_IOAM6_ENABLED] = cnf->ioam6_enabled;
 	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
 	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
+	array[DEVCONF_NDISC_EVICT_NOCARRIER] = cnf->ndisc_evict_nocarrier;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6983,6 +6986,15 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_douintvec,
 	},
+	{
+		.procname	= "ndisc_evict_nocarrier",
+		.data		= &ipv6_devconf.ndisc_evict_nocarrier,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= (void *)SYSCTL_ZERO,
+		.extra2		= (void *)SYSCTL_ONE,
+	},
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 184190b9ea25..f03b597e4121 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1794,6 +1794,7 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
 	struct netdev_notifier_change_info *change_info;
 	struct net *net = dev_net(dev);
 	struct inet6_dev *idev;
+	bool evict_nocarrier;
 
 	switch (event) {
 	case NETDEV_CHANGEADDR:
@@ -1810,10 +1811,19 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
 		in6_dev_put(idev);
 		break;
 	case NETDEV_CHANGE:
+		idev = in6_dev_get(dev);
+		if (!idev)
+			evict_nocarrier = true;
+		else {
+			evict_nocarrier = idev->cnf.ndisc_evict_nocarrier &&
+					  net->ipv6.devconf_all->ndisc_evict_nocarrier;
+			in6_dev_put(idev);
+		}
+
 		change_info = ptr;
 		if (change_info->flags_changed & IFF_NOARP)
 			neigh_changeaddr(&nd_tbl, dev);
-		if (!netif_carrier_ok(dev))
+		if (evict_nocarrier && !netif_carrier_ok(dev))
 			neigh_carrier_down(&nd_tbl, dev);
 		break;
 	case NETDEV_DOWN:
-- 
2.31.1

