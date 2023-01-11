Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1037E665C30
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjAKNNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjAKNNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:13:14 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5495FC7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:13:13 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g19-20020a05600c4ed300b003d9eb1dbc0aso9637178wmq.3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X37DPZFIbrBRn2IaTru3al+fjanPoBrChw6LBBTY2lw=;
        b=e4uXo40Y6BgV5/hmZLnCcGKw1wRcYpVSR+0Ro0sDrSWg8HpXlBjINOzDUgPdPG3UWi
         yCT6rkzZE8WGtp1yoMe/+qAn39524WTGeZ+lkMjdy5Nf/wP5Ix2vIGblQ2lg9NTCfWQv
         u+AaWqU+GM+03Ephn4AClsAkHAzDPo/xMztJseyG1AECLaSn0Y8lsZ+xSrcCbfKKf7dM
         Q2J+Uc6Cg+TG5E367WmvPn1uiTTGkreIzCWGChJKBHNnrhMXrvEEsMsOyif0rn+cCxFO
         ykXs1z7fkaloncRnjWP6g2xYj9rMDmZ8u9W+3GSNUDuRRowjOjPIFhGofNmpuokOOJ2Y
         1xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X37DPZFIbrBRn2IaTru3al+fjanPoBrChw6LBBTY2lw=;
        b=wTYGRt9N3G3k8m6+Wm07h/h+nkWmJR4yQlWeOYq9KzXE6YfOKFm+to4Fk3lpAE7RYu
         rx/MomTyeMEYfqDkXj9WaxsXr+Kdg/GC2E7eyNJDvDaCVciCcPwvBdOtJi0e8iDnKihq
         IBDQ2kUutijeYzzvkPLEAbv6oqS/IHYt1Nt1NPzmHP8ohGUmpWuXcflgNqJJNV7Xte7+
         5p61CEPuyTf7966NltPbwuQwtiOg32znGfJgsJwn2pNHKQKD+1z2SiNM+BrS8pDenu/Q
         X9wEmR2vTSUlrE0tka0ClqNqBiBY5z3XU15oOkh7zl26FxItbzEcXiLdvXcOmLFzknHn
         MyeQ==
X-Gm-Message-State: AFqh2kqARMNao9nPeKnqLNUysL+rYTrvMuJqxtm6tQwlVNlKjXD8Ukj+
        tsTfKJFrSmM8CnAOvwWzjiE=
X-Google-Smtp-Source: AMrXdXsYz5a+EZUkpxv+Sw0hKqTRYB6d4Wbq2ifCeckAKbVyBYJS1mgc3aPCHu87IGNu54V8+nq2Xg==
X-Received: by 2002:a05:600c:3550:b0:3d9:ed30:6a73 with SMTP id i16-20020a05600c355000b003d9ed306a73mr9443904wmq.9.1673442791445;
        Wed, 11 Jan 2023 05:13:11 -0800 (PST)
Received: from ThinkStation-P340.tmt.telital.com ([2a01:7d0:4800:7:4ce:b9aa:c77:7d5e])
        by smtp.gmail.com with ESMTPSA id m7-20020a05600c3b0700b003cfd4cf0761sm25796521wms.1.2023.01.11.05.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:13:11 -0800 (PST)
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
Subject: [PATCH net-next v4 1/3] ethtool: add tx aggregation parameters
Date:   Wed, 11 Jan 2023 14:05:18 +0100
Message-Id: <20230111130520.483222-2-dnlplm@gmail.com>
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

Add the following ethtool tx aggregation parameters:

ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES
Maximum size in bytes of a tx aggregated block of frames.

ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES
Maximum number of frames that can be aggregated into a block.

ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS
Time in usecs after the first packet arrival in an aggregated
block for the block to be sent.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
v4
- No change
v3
- Fixed ethtool-netlink.rst content out of table bounds
v2
- Replaced the generic 'size' word with 'bytes' in the related ETHTOOL define
- Changed all the names making the word 'aggr' to follow 'tx'
- Improved documentation on the feature in ethtool-netlink.rst
---
 Documentation/networking/ethtool-netlink.rst | 17 +++++++++++++++
 include/linux/ethtool.h                      | 12 ++++++++++-
 include/uapi/linux/ethtool_netlink.h         |  3 +++
 net/ethtool/coalesce.c                       | 22 ++++++++++++++++++--
 4 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f10f8eb44255..06ea91bde164 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1004,6 +1004,9 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
   ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
   ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``     u32     max aggr size, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES``    u32     max aggr packets, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS``    u32     time (us), aggr, Tx
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
@@ -1022,6 +1025,17 @@ each packet event resets the timer. In this mode timer is used to force
 the interrupt if queue goes idle, while busy queues depend on the packet
 limit to trigger interrupts.
 
+Tx aggregation consists of copying frames into a contiguous buffer so that they
+can be submitted as a single IO operation. ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``
+describes the maximum size in bytes for the submitted buffer.
+``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES`` describes the maximum number of frames
+that can be aggregated into a single buffer.
+``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS`` describes the amount of time in usecs,
+counted since the first packet arrival in an aggregated block, after which the
+block should be sent.
+This feature is mainly of interest for specific USB devices which does not cope
+well with frequent small-sized URBs transmissions.
+
 COALESCE_SET
 ============
 
@@ -1055,6 +1069,9 @@ Request contents:
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
   ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
   ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``     u32     max aggr size, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES``    u32     max aggr packets, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS``    u32     time (us), aggr, Tx
   ===========================================  ======  =======================
 
 Request is rejected if it attributes declared as unsupported by driver (i.e.
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9e0a76fc7de9..a1ff1ca0a5b6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -217,6 +217,9 @@ __ethtool_get_link_ksettings(struct net_device *dev,
 struct kernel_ethtool_coalesce {
 	u8 use_cqe_mode_tx;
 	u8 use_cqe_mode_rx;
+	u32 tx_aggr_max_bytes;
+	u32 tx_aggr_max_frames;
+	u32 tx_aggr_time_usecs;
 };
 
 /**
@@ -260,7 +263,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
 #define ETHTOOL_COALESCE_USE_CQE_RX		BIT(22)
 #define ETHTOOL_COALESCE_USE_CQE_TX		BIT(23)
-#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(23, 0)
+#define ETHTOOL_COALESCE_TX_AGGR_MAX_BYTES	BIT(24)
+#define ETHTOOL_COALESCE_TX_AGGR_MAX_FRAMES	BIT(25)
+#define ETHTOOL_COALESCE_TX_AGGR_TIME_USECS	BIT(26)
+#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(26, 0)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
@@ -288,6 +294,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
 #define ETHTOOL_COALESCE_USE_CQE					\
 	(ETHTOOL_COALESCE_USE_CQE_RX | ETHTOOL_COALESCE_USE_CQE_TX)
+#define ETHTOOL_COALESCE_TX_AGGR		\
+	(ETHTOOL_COALESCE_TX_AGGR_MAX_BYTES |	\
+	 ETHTOOL_COALESCE_TX_AGGR_MAX_FRAMES |	\
+	 ETHTOOL_COALESCE_TX_AGGR_TIME_USECS)
 
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 5799a9db034e..62cffbf157b1 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -400,6 +400,9 @@ enum {
 	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
 	ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,		/* u8 */
 	ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,		/* u8 */
+	ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_COALESCE_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 487bdf345541..e405b47f7eed 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -105,7 +105,10 @@ static int coalesce_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _RATE_SAMPLE_INTERVAL */
 	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_TX */
-	       nla_total_size(sizeof(u8));	/* _USE_CQE_MODE_RX */
+	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_RX */
+	       nla_total_size(sizeof(u32)) +	/* _TX_AGGR_MAX_BYTES */
+	       nla_total_size(sizeof(u32)) +	/* _TX_AGGR_MAX_FRAMES */
+	       nla_total_size(sizeof(u32));	/* _TX_AGGR_TIME_USECS */
 }
 
 static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
@@ -180,7 +183,13 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
 			      kcoal->use_cqe_mode_tx, supported) ||
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
-			      kcoal->use_cqe_mode_rx, supported))
+			      kcoal->use_cqe_mode_rx, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES,
+			     kcoal->tx_aggr_max_bytes, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES,
+			     kcoal->tx_aggr_max_frames, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS,
+			     kcoal->tx_aggr_time_usecs, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -227,6 +236,9 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= NLA_POLICY_MAX(NLA_U8, 1),
 	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS] = { .type = NLA_U32 },
 };
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
@@ -321,6 +333,12 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX], &mod);
 	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_rx,
 			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_aggr_max_bytes,
+			 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_aggr_max_frames,
+			 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_aggr_time_usecs,
+			 tb[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
-- 
2.37.1

