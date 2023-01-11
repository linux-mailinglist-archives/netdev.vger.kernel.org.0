Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F099665C3B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjAKNN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjAKNNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:13:22 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E8F1A382
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:13:20 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso12597372wms.5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPhwZKLjKuy5t/MDITXEFabWOlmLdiAIKI7RzsAb9+E=;
        b=QLMs7wVGpWWlmn9gjJwduNNsJNjassRBTCtQWdFYkKqpvzS5ZY3/BSJ9t4oajKKQAM
         iFVrg0L03LqnU6BbpliRnTgZs9gjJ/MyOgwV9wQKK9CG5jWWjcPGca0drKvb3nrNKdel
         zCezOiC2QWWtipGhEykrvYtnw7xMkvme0GfmSs1q45syYnpVyoGJCJu4OaJLmDBvRhgf
         LRDf2w/vsT43iyyyz4TJmVyfu7mR5tDVLTqObtU3Em9hKAcU1pxGSTBOyvy9Xan+N8GT
         MPxcvbFze4bXlKateGcqWKY7H3auQDx4t3oTdG5MtJmj8z5bwz6dlyvRYoLcME/h7vnP
         WKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uPhwZKLjKuy5t/MDITXEFabWOlmLdiAIKI7RzsAb9+E=;
        b=zz0p76OXF/85a8SmKSvhwhlbgBxxsb1vXv0cRr9jb1PswEaL2jWgdjywqbjVtQ6Hwr
         PhQYkEANR00+UPQICGPW4Dwac2Neciv2bUZRE38J6IJJwyJWGBUlduYn8fP4mFlbQV6n
         DMJQt8VNK5DBQDpol6EWIJ7UylwQLXmpnWr96CeadMMby7I1JJsvMoSZyebFqUL9NQvD
         v8A3HAc8fkToUOAXQgCxR+9G/qgyYBQObPZVRDPJR4AI0lP6AejY6eK9+ofg3Y4HVKXS
         Q4qWaqd2E9KsTjSMzp5Q80tD6JcjjegEky3Nq8AVC3s71IH8MkFdt46kN1c+acRpWkPV
         qrNA==
X-Gm-Message-State: AFqh2kqmiIk9/UPJ+el2yrqG/F3MbS+OfQIPlVNR0qkq3wko4CuOURdn
        mKg5RKn8RqY5GIOsForQoho=
X-Google-Smtp-Source: AMrXdXuvXN+Z6ynWKNRcuaCr+V0mgDsaOiLfg1k4RGBu6teNGKFhvrmhukO4hnByiFHEXNUiITjnDA==
X-Received: by 2002:a05:600c:4f83:b0:3d2:3f55:f73f with SMTP id n3-20020a05600c4f8300b003d23f55f73fmr53009237wmq.8.1673442799207;
        Wed, 11 Jan 2023 05:13:19 -0800 (PST)
Received: from ThinkStation-P340.tmt.telital.com ([2a01:7d0:4800:7:4ce:b9aa:c77:7d5e])
        by smtp.gmail.com with ESMTPSA id m7-20020a05600c3b0700b003cfd4cf0761sm25796521wms.1.2023.01.11.05.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:13:18 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>, Dave Taht <dave.taht@gmail.com>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v4 3/3] net: qualcomm: rmnet: add ethtool support for configuring tx aggregation
Date:   Wed, 11 Jan 2023 14:05:20 +0100
Message-Id: <20230111130520.483222-4-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230111130520.483222-1-dnlplm@gmail.com>
References: <20230111130520.483222-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ETHTOOL_COALESCE_TX_AGGR for configuring the tx
aggregation settings.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
v4
- No change
v3
- No change
v2
- Fixed undefined reference to `__aeabi_uldivmod' issue with arm, reported-by: kernel test robot
---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 6d8b8fdb9d03..046b5f7d8e7c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -215,7 +215,52 @@ static void rmnet_get_ethtool_stats(struct net_device *dev,
 	memcpy(data, st, ARRAY_SIZE(rmnet_gstrings_stats) * sizeof(u64));
 }
 
+static int rmnet_get_coalesce(struct net_device *dev,
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
+{
+	struct rmnet_priv *priv = netdev_priv(dev);
+	struct rmnet_port *port;
+
+	port = rmnet_get_port_rtnl(priv->real_dev);
+
+	memset(kernel_coal, 0, sizeof(*kernel_coal));
+	kernel_coal->tx_aggr_max_bytes = port->egress_agg_params.bytes;
+	kernel_coal->tx_aggr_max_frames = port->egress_agg_params.count;
+	kernel_coal->tx_aggr_time_usecs = div_u64(port->egress_agg_params.time_nsec,
+						  NSEC_PER_USEC);
+
+	return 0;
+}
+
+static int rmnet_set_coalesce(struct net_device *dev,
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
+{
+	struct rmnet_priv *priv = netdev_priv(dev);
+	struct rmnet_port *port;
+
+	port = rmnet_get_port_rtnl(priv->real_dev);
+
+	if (kernel_coal->tx_aggr_max_frames < 1 || kernel_coal->tx_aggr_max_frames > 64)
+		return -EINVAL;
+
+	if (kernel_coal->tx_aggr_max_bytes > 32768)
+		return -EINVAL;
+
+	rmnet_map_update_ul_agg_config(port, kernel_coal->tx_aggr_max_bytes,
+				       kernel_coal->tx_aggr_max_frames,
+				       kernel_coal->tx_aggr_time_usecs);
+
+	return 0;
+}
+
 static const struct ethtool_ops rmnet_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_TX_AGGR,
+	.get_coalesce = rmnet_get_coalesce,
+	.set_coalesce = rmnet_set_coalesce,
 	.get_ethtool_stats = rmnet_get_ethtool_stats,
 	.get_strings = rmnet_get_strings,
 	.get_sset_count = rmnet_get_sset_count,
-- 
2.37.1

