Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7966B735B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjCMKBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCMKBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:01:18 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1BD1166D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:00:22 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id 4so6671423ilz.6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678701619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hV8NpzEgHG1y0Z0XL8b5eNFbbUtoNAm6IAZfNB2gADI=;
        b=XCDalpWt0B1EE1I1x+9dMatizNrkYpHoPO1a8cOFjFpS57eitqoEp2WLS4ZaU47gqJ
         E3ZbqUoq5gTtlUhDK0dZIoeIl5uJKlVa3DPba10JypIXDGwsKz3TtEmB7ARP401JsqrO
         QHEey5SVLSoBwzVVWxavVr6uE9rFyb/SWCKMdv2Or6szN12L0cmVweNqsqrqYqjQKzcg
         bskxZhx7wBhKA9pon9xlDkERVCvxAEayt1eih7ugwIY+pEcLeey+R4UiBqQ4j90D/uoA
         ME3p+xeahJM1I36NnxkO3rZzX4RWp2i80Sh1IWVCgJzSy9ERYeXuisV9p18XY4+kSCGT
         8Pkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678701619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hV8NpzEgHG1y0Z0XL8b5eNFbbUtoNAm6IAZfNB2gADI=;
        b=X6LUl2GCpUGXqJlfKeeQopovuqHzmeanGyu8JkiYvUUE38dU8Wvzbdi0O4KMn+5zDD
         f9TQugwLCRcbk9AW++vW3cD+G6LB5f7VVkYm7wjp1jvEKir7a2Sc/7AlMEhW1D1y2mwC
         68FJjp7vTPtz/IJZts/rKMUC6wg1W2ydV7UOPDWtWNlifQIzIJmiEY3uXktvKo9ETJOj
         FAXPosqy6nvyz3UJmM63ksGBjBVh1YBJUzJKjAUggAcPuScsgG75GPFqYynUi91FzhUG
         Ouuu/DulIK4M8R0tBv2jO34zlbx4Imu1iR4TU5MYcCD8jJa3EBA2nOsJtazyyivXq07Y
         p1WA==
X-Gm-Message-State: AO0yUKWWbW2GGP4yXjcIuGNJk9fBo/W0VHMg1p2ZsQy8Dx+E1kIRNo6K
        Ba2BzhWiWRccIUqZsM43MzWpkoTpfIo=
X-Google-Smtp-Source: AK7set8W8Eo0tTLBQeCq6/2HrAEMGnL5Z6dGxajoC7+urYPNlj4svo6MNj5+pn6PWIL3SLEgl7q/XQ==
X-Received: by 2002:a92:dc0a:0:b0:323:338:cc36 with SMTP id t10-20020a92dc0a000000b003230338cc36mr2648733iln.8.1678701619324;
        Mon, 13 Mar 2023 03:00:19 -0700 (PDT)
Received: from ThinkStation-P340.tmt.telital.com ([2a01:7d0:4800:7:178e:18b4:6fc0:1c5d])
        by smtp.gmail.com with ESMTPSA id m9-20020a924b09000000b003230b8aa2d6sm640481ilg.57.2023.03.13.03.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 03:00:19 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH ethtool-next 1/1] netlink: settings: add netlink support for coalesce tx aggr params
Date:   Mon, 13 Mar 2023 10:51:07 +0100
Message-Id: <20230313095107.2319823-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
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

Add support for getting/setting coalesce tx aggregation parameters
(max bytes, max frames, max time).

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 ethtool.8.in                  |  3 +++
 ethtool.c                     |  3 +++
 netlink/coalesce.c            | 25 +++++++++++++++++++++++++
 netlink/desc-ethtool.c        |  3 +++
 shell-completion/bash/ethtool |  3 +++
 5 files changed, 37 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 3672e44..d171972 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -188,6 +188,9 @@ ethtool \- query or control network driver and hardware settings
 .BN sample\-interval
 .B2 cqe\-mode\-rx on off
 .B2 cqe\-mode\-tx on off
+.BN tx\-aggr\-max\-bytes
+.BN tx\-aggr\-max\-frames
+.BN tx\-aggr\-time\-usecs
 .HP
 .B ethtool \-g|\-\-show\-ring
 .I devname
diff --git a/ethtool.c b/ethtool.c
index 6022a6e..9e99831 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5730,6 +5730,9 @@ static const struct option args[] = {
 			  "		[sample-interval N]\n"
 			  "		[cqe-mode-rx on|off]\n"
 			  "		[cqe-mode-tx on|off]\n"
+			  "		[tx-aggr-max-bytes N]\n"
+			  "		[tx-aggr-max-frames N]\n"
+			  "		[tx-aggr-time-usecs N]\n"
 	},
 	{
 		.opts	= "-g|--show-ring",
diff --git a/netlink/coalesce.c b/netlink/coalesce.c
index 17a814b..bc34d3d 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -89,6 +89,13 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		  tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]);
 	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]);
 	show_cr();
+	show_u32("tx-aggr-max-bytes", "tx-aggr-max-bytes:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES]);
+	show_u32("tx-aggr-max-frames", "tx-aggr-max-frames:\t",
+		 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES]);
+	show_u32("tx-aggr-time-usecs", "tx-aggr-time-usecs\t",
+		 tb[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS]);
+	show_cr();
 
 	close_json_object();
 
@@ -267,6 +274,24 @@ static const struct param_parser scoalesce_params[] = {
 		.handler	= nl_parse_u8bool,
 		.min_argc	= 1,
 	},
+	{
+		.arg		= "tx-aggr-max-bytes",
+		.type		= ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-aggr-max-frames",
+		.type		= ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-aggr-time-usecs",
+		.type		= ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
 	{}
 };
 
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 2d8aa39..7b77f88 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -201,6 +201,9 @@ static const struct pretty_nla_desc __coalesce_desc[] = {
 	NLATTR_DESC_U32(ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL),
 	NLATTR_DESC_BOOL(ETHTOOL_A_COALESCE_USE_CQE_MODE_TX),
 	NLATTR_DESC_BOOL(ETHTOOL_A_COALESCE_USE_CQE_MODE_RX),
+	NLATTR_DESC_U32(ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES),
+	NLATTR_DESC_U32(ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES),
+	NLATTR_DESC_U32(ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS),
 };
 
 static const struct pretty_nla_desc __pause_stats_desc[] = {
diff --git a/shell-completion/bash/ethtool b/shell-completion/bash/ethtool
index 46334b5..99c5f6f 100644
--- a/shell-completion/bash/ethtool
+++ b/shell-completion/bash/ethtool
@@ -254,6 +254,9 @@ _ethtool_coalesce()
 		[tx-usecs-high]=1
 		[tx-usecs-irq]=1
 		[tx-usecs-low]=1
+		[tx-aggr-max-bytes]=1
+		[tx-aggr-max-frames]=1
+		[tx-aggr-time-usecs]=1
 	)
 
 	case "$prev" in
-- 
2.37.1

