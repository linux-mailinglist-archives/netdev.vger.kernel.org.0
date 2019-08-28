Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627CA9F9DE
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfH1Fgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:36:49 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37570 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfH1Fgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:36:49 -0400
Received: by mail-ed1-f66.google.com with SMTP id f22so1558112edt.4
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kOTW3RMU4LD/zZ74izY8KvVvG1eG4L/lufZCQeOlzHg=;
        b=IueZEBiUfHbrU0D54ypMG4Zcyq0hRNJg1MA6yH9am/N1DOj+efV8P/3/lSxG0qCHdT
         ms7NvSUQCSEjv3EF2/fttYFPZPjOFGvmBIWgmEyfQOqwl3aI+QQF8gCRmJ47PsMpswkU
         0u34zjFncucSOBdI/WzgsLCcykfmiWtSuVxDcDfB+k2DlJ/yyb6iBHoRGuXnyWLKJyN8
         Fde/YK0CqnBDf4xmhqfD51yetJPzUXVzQNjauIDyAqE3+QGNm2vGdDmiRb6lcNSPPCrd
         gsHXNZip7Nf9+TTwnaBPujdsvQpq3R55uMrx6EbeTgZGfD3hf5ZfZNtvqd88V1ssORUY
         L+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kOTW3RMU4LD/zZ74izY8KvVvG1eG4L/lufZCQeOlzHg=;
        b=Z8EYuJaYVhaOPADeG5Y5gaFaawsa5zb8dadDnMlzEKGPLApo8jp5rSXgZEiZUHxBmU
         NTrmKQvB46fnl2Nt8buCt1IopB3a0fXw8iLNnQi/kBgOCA4T087eF0VwfwFMs+jkTOlG
         T0v7QFfi6hujbBeOyXzsYy9sLerUMa/Fif3JNqWFahk9c46PplX0GjLhKqkDX8wKe3hJ
         ldQl7N+DUaHIeM+x/Qo6W3eH5QZ/m7wGCKjsGafeKm7dhpp8JtyHghG+1XjsAmIZdj5R
         +TFku54G45cn+yqt9dlfHJJwydR69FrHAZK8Q7wWob8Bhxb0HODSwYyMAiX3X+myYPJO
         gCJg==
X-Gm-Message-State: APjAAAV8fA7vmh84vzvjbu5dMiNYwkHVSlVJn/RRgE2fdl6Pmki7FvkK
        wmgJsC7pZewnIvoEctbbma/UVA==
X-Google-Smtp-Source: APXvYqzjN4c5vO8zSJ1Y9Pl55zO79H72+qNdHIW72UM+DOAtYoIsYtl09wYe8r2KIH/Ka8dSqoP8ZA==
X-Received: by 2002:aa7:c2ca:: with SMTP id m10mr2152310edp.297.1566970606863;
        Tue, 27 Aug 2019 22:36:46 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i23sm237334edv.11.2019.08.27.22.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 22:36:46 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jaco.gericke@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 1/2] nfp: bpf: rework MTU checking
Date:   Tue, 27 Aug 2019 22:36:28 -0700
Message-Id: <20190828053629.28658-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828053629.28658-1-jakub.kicinski@netronome.com>
References: <20190828053629.28658-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If control channel MTU is too low to support map operations a warning
will be printed. This is not enough, we want to make sure probe fails
in such scenario, as this would clearly be a faulty configuration.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c     | 10 +++++++---
 drivers/net/ethernet/netronome/nfp/bpf/main.c     | 15 +++++++++++++++
 drivers/net/ethernet/netronome/nfp/bpf/main.h     |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h      |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c   |  9 +--------
 5 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
index bc9850e4ec5e..fcf880c82f3f 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
@@ -267,11 +267,15 @@ int nfp_bpf_ctrl_getnext_entry(struct bpf_offloaded_map *offmap,
 				     key, NULL, 0, next_key, NULL);
 }
 
+unsigned int nfp_bpf_ctrl_cmsg_min_mtu(struct nfp_app_bpf *bpf)
+{
+	return max(nfp_bpf_cmsg_map_req_size(bpf, 1),
+		   nfp_bpf_cmsg_map_reply_size(bpf, 1));
+}
+
 unsigned int nfp_bpf_ctrl_cmsg_mtu(struct nfp_app_bpf *bpf)
 {
-	return max3((unsigned int)NFP_NET_DEFAULT_MTU,
-		    nfp_bpf_cmsg_map_req_size(bpf, 1),
-		    nfp_bpf_cmsg_map_reply_size(bpf, 1));
+	return max(NFP_NET_DEFAULT_MTU, nfp_bpf_ctrl_cmsg_min_mtu(bpf));
 }
 
 void nfp_bpf_ctrl_msg_rx(struct nfp_app *app, struct sk_buff *skb)
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 1c9fb11470df..2b1773ed3de9 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -415,6 +415,20 @@ static void nfp_bpf_ndo_uninit(struct nfp_app *app, struct net_device *netdev)
 	bpf_offload_dev_netdev_unregister(bpf->bpf_dev, netdev);
 }
 
+static int nfp_bpf_start(struct nfp_app *app)
+{
+	struct nfp_app_bpf *bpf = app->priv;
+
+	if (app->ctrl->dp.mtu < nfp_bpf_ctrl_cmsg_min_mtu(bpf)) {
+		nfp_err(bpf->app->cpp,
+			"ctrl channel MTU below min required %u < %u\n",
+			app->ctrl->dp.mtu, nfp_bpf_ctrl_cmsg_min_mtu(bpf));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nfp_bpf_init(struct nfp_app *app)
 {
 	struct nfp_app_bpf *bpf;
@@ -488,6 +502,7 @@ const struct nfp_app_type app_bpf = {
 
 	.init		= nfp_bpf_init,
 	.clean		= nfp_bpf_clean,
+	.start		= nfp_bpf_start,
 
 	.check_mtu	= nfp_bpf_check_mtu,
 
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
index 57d6ff51e980..f4802036eb42 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
@@ -564,6 +564,7 @@ nfp_bpf_goto_meta(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 
 void *nfp_bpf_relo_for_vnic(struct nfp_prog *nfp_prog, struct nfp_bpf_vnic *bv);
 
+unsigned int nfp_bpf_ctrl_cmsg_min_mtu(struct nfp_app_bpf *bpf);
 unsigned int nfp_bpf_ctrl_cmsg_mtu(struct nfp_app_bpf *bpf);
 long long int
 nfp_bpf_ctrl_alloc_map(struct nfp_app_bpf *bpf, struct bpf_map *map);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 5d6c3738b494..250f510b1d21 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -66,7 +66,7 @@
 #define NFP_NET_MAX_DMA_BITS	40
 
 /* Default size for MTU and freelist buffer sizes */
-#define NFP_NET_DEFAULT_MTU		1500
+#define NFP_NET_DEFAULT_MTU		1500U
 
 /* Maximum number of bytes prepended to a packet */
 #define NFP_NET_MAX_PREPEND		64
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 6f97b554f7da..61aabffc8888 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -4116,14 +4116,7 @@ int nfp_net_init(struct nfp_net *nn)
 
 	/* Set default MTU and Freelist buffer size */
 	if (!nfp_net_is_data_vnic(nn) && nn->app->ctrl_mtu) {
-		if (nn->app->ctrl_mtu <= nn->max_mtu) {
-			nn->dp.mtu = nn->app->ctrl_mtu;
-		} else {
-			if (nn->app->ctrl_mtu != NFP_APP_CTRL_MTU_MAX)
-				nn_warn(nn, "app requested MTU above max supported %u > %u\n",
-					nn->app->ctrl_mtu, nn->max_mtu);
-			nn->dp.mtu = nn->max_mtu;
-		}
+		nn->dp.mtu = min(nn->app->ctrl_mtu, nn->max_mtu);
 	} else if (nn->max_mtu < NFP_NET_DEFAULT_MTU) {
 		nn->dp.mtu = nn->max_mtu;
 	} else {
-- 
2.21.0

