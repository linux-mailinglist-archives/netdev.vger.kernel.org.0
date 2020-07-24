Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9224B22BCC2
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 06:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgGXEO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 00:14:27 -0400
Received: from linux.microsoft.com ([13.77.154.182]:50692 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGXEO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 00:14:27 -0400
Received: by linux.microsoft.com (Postfix, from userid 1070)
        id 7E94E20B4908; Thu, 23 Jul 2020 21:14:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E94E20B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1595564066;
        bh=Aks2zkb0GLN2is1SIlOFjLMBbc/dujHnALytnlqRNGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NM0Z9D+PIYcGxg/DkXDnwF5G3WpWreEBYx0Z8sw5p9EJf9QI77/q/+s4VbzO3UibU
         mTvMgV/FZEhWbIQqZLIrMY8/pLj/rnb7c4tOrL7H35sQPQzENolmhyUqmqACTSY40l
         ScIuCpDEtsW9qSEHdTkMm6OTXSIE8ATAxRZnHVno=
Date:   Thu, 23 Jul 2020 21:14:26 -0700
From:   Chi Song <chisong@linux.microsoft.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
Message-ID: <20200724041426.GB25409@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An imbalanced TX indirection table causes netvsc to have low
performance. This table is created and managed during runtime. To help
better diagnose performance issues caused by imbalanced tables, it needs
make TX indirection tables visible.

Because TX indirection table is driver specified information, so
display it via ethtool register dump.

Signed-off-by: Chi Song <chisong@microsoft.com>
---
v8: fix corrupt patch file
v7: move to ethtool register dump
v6: update names to be more precise, remove useless assignment
v5: update variable orders
v4: use a separated group to organize tx_indirection better, change 
 location of attributes init/exit to netvsc_drv_init/exit

 drivers/net/hyperv/netvsc_drv.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 6267f706e8ee..3288221726ea 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1934,6 +1934,23 @@ static int netvsc_set_features(struct net_device *ndev,
 	return ret;
 }
 
+static int netvsc_get_regs_len(struct net_device *netdev)
+{
+	return VRSS_SEND_TAB_SIZE * sizeof(u32);
+}
+
+static void netvsc_get_regs(struct net_device *netdev,
+			    struct ethtool_regs *regs, void *p)
+{
+	struct net_device_context *ndc = netdev_priv(netdev);
+	u32 *regs_buff = p;
+
+	/* increase the version, if buffer format is changed. */
+	regs->version = 1;
+
+	memcpy(regs_buff, ndc->tx_table, VRSS_SEND_TAB_SIZE * sizeof(u32));
+}
+
 static u32 netvsc_get_msglevel(struct net_device *ndev)
 {
 	struct net_device_context *ndev_ctx = netdev_priv(ndev);
@@ -1950,6 +1967,8 @@ static void netvsc_set_msglevel(struct net_device *ndev, u32 val)
 
 static const struct ethtool_ops ethtool_ops = {
 	.get_drvinfo	= netvsc_get_drvinfo,
+	.get_regs_len	= netvsc_get_regs_len,
+	.get_regs	= netvsc_get_regs,
 	.get_msglevel	= netvsc_get_msglevel,
 	.set_msglevel	= netvsc_set_msglevel,
 	.get_link	= ethtool_op_get_link,
-- 
2.25.1
