Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC686425F6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiLEJnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiLEJm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:42:56 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4C45FE8
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:42:55 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id x22so3966602ejs.11
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVghtv5JQAXEEPM7oX7ZU78hstl1u8AyhdGqnB9TpEc=;
        b=eTAv35QwJdDNy8Jfz5J0MoQikKh8ckOXxDhSgOiI5kxXejSC+l2LsbIUo3a54I1z88
         Wl2TKzjf019X5gnVKzxWpJrMTle56VCTgg8P7tN/XNiB5KDJK6qFdWJH6ktVeTonjEt+
         uYyabD71dvRrKA3t5mXw/c5A0p4YilDrMJyACfGk97lZ2+A6yw6tWg1eM4x7Ck/OUmPS
         zYVPYRz2FKa/c0ktnSPfX45nwdtXFiSzm4cCk9WrNKE1yArIzpO1YeIjd5IxqE65Ib+w
         gLCrFepSWOrqCi9IPkKeYMDHkaIsyyFzQoIv7R3rQ54iUuE0o9hJZw1s0Qk4UivecSDh
         hgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tVghtv5JQAXEEPM7oX7ZU78hstl1u8AyhdGqnB9TpEc=;
        b=1Iq8nT13WFMNOGDTu69VJ5YHGEX9Fwp1Wh15qX9oKN+qr+a1pmYoDlfLuCE7a4VaZ8
         +uYTymo6OZ0OZMYrJVyJC+l1XM+uXizCW4jnxAL1a5Y8+0MAlR2nV6uowKcTIHb/NbcT
         WXS1wH3NgxIns4e4cuqoKySiDmijE+A7sqwtg8FAYjS0bb78MAEcv+KWgfAxjvd2iNjS
         WNAqw6Px+QhAYG8A00duNK0nLJUOaup36BLJUF4YfTYJtUHPacfePte3UsD147xMWEfJ
         yf2Y0HcN9k33DTxZczSsA+dCmum6M6+k0GSzd5UBzOln+OnmdA8kcsxDCfwROd8JZHlT
         SOvw==
X-Gm-Message-State: ANoB5pkiLXq7s78dK3SiXLUzPt41k6dqrGO5hxSEymLjStW/jhVbo4EM
        dCBVdebnks0MM/V9VyXZ768=
X-Google-Smtp-Source: AA0mqf7d79LsQXQRn7GyqP5VCe5ygD8zwanH0OrsCrQl2AIZ88JRhArw4kXqIoOMpP7WPf54FYBQIg==
X-Received: by 2002:a17:906:49d0:b0:79f:e0b3:3b9b with SMTP id w16-20020a17090649d000b0079fe0b33b9bmr6519956ejv.378.1670233375184;
        Mon, 05 Dec 2022 01:42:55 -0800 (PST)
Received: from ThinkStation-P340.. (host-217-57-98-66.business.telecomitalia.it. [217.57.98.66])
        by smtp.gmail.com with ESMTPSA id bn18-20020a170906c0d200b0077a1dd3e7b7sm6083866ejb.102.2022.12.05.01.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:42:54 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v3 3/3] net: qualcomm: rmnet: add ethtool support for configuring tx aggregation
Date:   Mon,  5 Dec 2022 10:33:59 +0100
Message-Id: <20221205093359.49350-4-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221205093359.49350-1-dnlplm@gmail.com>
References: <20221205093359.49350-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

