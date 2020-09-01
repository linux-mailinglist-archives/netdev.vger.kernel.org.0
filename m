Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1114E25A0BD
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgIAVVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIAVU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:20:59 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF218C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:20:58 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id k20so1952469qvf.19
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=G/uvmwOQiong405GLxpGQI/Bp4s14NFBsWqzgHzIA/E=;
        b=Ck6tdaKCe1COA5TCusvYdj+Hr5Ap164URDkRYSjo2bGflI7vcsqFSrsgIZhXZd45ZA
         jK2kDu/P68BZJqQsyUNeN2JifGdBwCiRANI64fu5UhUOpHc0/SintJAUf51TQKUrzLZm
         vMiimWkT8KOfcF1P9g/ICK88h+BWvcQyubku4YSxywZQUvM05/MvB4Jw6wiKb1tUR3h1
         oZvxCT1sZRGc8OyrluKqFBvXgr9Xm836PF/rMsAEIM3wBy+NuP1Oqv/nXffh/dwqbIxc
         t77m1unEAcjyPr3l9VG/yjuDapQrhGYfFlMK09zZPP2mgTTofuYUS3wOTxWsKhupVHZR
         1H8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=G/uvmwOQiong405GLxpGQI/Bp4s14NFBsWqzgHzIA/E=;
        b=OhmrAf4IxuYAy937s64fJrYqVKGRtCs641u3aDWLlghHggsrmKYFI68GxADiWH19B5
         Yb0SX4gQPRWSUj+DL+buFrHQ3uvA6KS5BMq55y3Emn0tCT5nDOXVfRWsvSqPi2cI1kAO
         j/EOO1gB4wUWdVbOtlMr0F+DPn/8ZSICAn1TJvaZ+IXrQPbyTpdcKNZHHci+WJ2MdvMe
         w7oXkA9pk43zb45Zs2LvK7BdqI9iB9l1WEoPmbBY3WKMcvi988Kmm9HLuzlALnyS8K8y
         lLG3U6bzGDL7dWs3a73W50kuU/LCFD7OjNbAJCHzTnnDjheX0vJ8IOmjSzCbU9qS1lY9
         VYWw==
X-Gm-Message-State: AOAM530x6864AcJzFq7+cN8Nr5z3GtA3dLXsNy+C4/mb/sLjbi8ZKRAv
        TmGFd6mu4wlEVoFk2Sh6lMVYCgM=
X-Google-Smtp-Source: ABdhPJzXd362A9ubtJ8RYaWukVMzEUuJpBjkyLFld1MSJIKbzV0nCYmKc58S9knZs8oNUMl0PwsVyw4=
X-Received: from yyd.nyc.corp.google.com ([2620:0:1003:31c:1ea0:b8ff:fe75:b9d4])
 (user=yyd job=sendgmr) by 2002:a05:6214:128:: with SMTP id
 w8mr4018589qvs.1.1598995258010; Tue, 01 Sep 2020 14:20:58 -0700 (PDT)
Date:   Tue,  1 Sep 2020 17:20:09 -0400
Message-Id: <20200901212009.1314401-1-yyd@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH ethtool] ethtool: add support show/set-hwtstamp
From:   "Kevin(Yudong) Yang" <yyd@google.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, "Kevin(Yudong) Yang" <yyd@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch, ethtool has -T/--show-time-stamping that only
shows the device's time stamping capabilities but not the time
stamping policy that is used by the device.

This patch adds support to set/get device time stamping policy at
the driver level by calling ioctl(SIOCSHWTSTAMP).

Tested: ran following cmds on a Mellanox NIC with mlx4_en driver:
./ethtool -T eth1
Hardware Transmit Timestamp Modes:
        off                   (HWTSTAMP_TX_OFF)
        on                    (HWTSTAMP_TX_ON)
Hardware Receive Filter Modes:
        none                  (HWTSTAMP_FILTER_NONE)
        all                   (HWTSTAMP_FILTER_ALL)

./ethtool --show-hwtstamp eth1;
Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
Tx type 0, off                   (HWTSTAMP_TX_OFF)

./ethtool --set-hwtstamp eth1 rx 1; ./ethtool --show-hwtstamp eth1;
Rx filter 1, all                   (HWTSTAMP_FILTER_ALL)
Tx type 0, off                   (HWTSTAMP_TX_OFF)

./ethtool --set-hwtstamp eth1 rx 1 tx 1; ./ethtool --show-hwtstamp eth1;
rx unmodified, ignoring
Rx filter 1, all                   (HWTSTAMP_FILTER_ALL)
Tx type 1, on                    (HWTSTAMP_TX_ON)

./ethtool --set-hwtstamp eth1 rx 0; ./ethtool --show-hwtstamp eth1;
Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
Tx type 1, on                    (HWTSTAMP_TX_ON)

./ethtool --set-hwtstamp eth1 tx 0; ./ethtool --show-hwtstamp eth1
Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
Tx type 0, off                   (HWTSTAMP_TX_OFF)

./ethtool --set-hwtstamp eth1 rx 123 tx 456
rx should be in [0..15], tx should be in [0..2]

Signed-off-by: Kevin Yang <yyd@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 ethtool.8.in | 14 +++++++++
 ethtool.c    | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index a50a476..c2d1b42 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -315,6 +315,14 @@ ethtool \- query or control network driver and hardware settings
 .B ethtool \-T|\-\-show\-time\-stamping
 .I devname
 .HP
+.B ethtool \-\-show\-hwtstamp
+.I devname
+.HP
+.B ethtool \-\-set\-hwtstamp
+.I devname
+.BN rx
+.BN tx
+.HP
 .B ethtool \-x|\-\-show\-rxfh\-indir|\-\-show\-rxfh
 .I devname
 .HP
@@ -1026,6 +1034,12 @@ Sets the dump flag for the device.
 Show the device's time stamping capabilities and associated PTP
 hardware clock.
 .TP
+.B \-\-show\-hwtstamp
+Show the device's time stamping policy at the driver level.
+.TP
+.B \-\-set\-hwtstamp
+Set the device's time stamping policy at the driver level.
+.TP
 .B \-x \-\-show\-rxfh\-indir \-\-show\-rxfh
 Retrieves the receive flow hash indirection table and/or RSS hash key.
 .TP
diff --git a/ethtool.c b/ethtool.c
index 606af3e..466b3a3 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4719,6 +4719,79 @@ static int do_tsinfo(struct cmd_context *ctx)
 	return 0;
 }
 
+static int do_ghwtstamp(struct cmd_context *ctx)
+{
+	struct hwtstamp_config cfg = { 0 };
+
+	ctx->ifr.ifr_data = (void *)&cfg;
+	if (ioctl(ctx->fd, SIOCGHWTSTAMP, &ctx->ifr)) {
+		perror("Cannot get device time stamping settings");
+		return -1;
+	}
+
+	printf("Rx filter %d", cfg.rx_filter);
+	if (cfg.rx_filter < N_RX_FILTERS)
+		printf(", %s\n", rx_filter_labels[cfg.rx_filter]);
+	else
+		printf("\n");
+
+	printf("Tx type %d", cfg.tx_type);
+	if (cfg.tx_type < N_TX_TYPES)
+		printf(", %s\n", tx_type_labels[cfg.tx_type]);
+	else
+		printf("\n");
+	return 0;
+}
+
+static int do_shwtstamp(struct cmd_context *ctx)
+{
+	struct hwtstamp_config cfg = { .rx_filter = -1, .tx_type = -1 },
+			       pre_cfg;
+	int changed = 0;
+	struct cmdline_info cmdline_config[] = {
+		{
+			.name		= "rx",
+			.type		= CMDL_S32,
+			.wanted_val	= &cfg.rx_filter,
+			.ioctl_val	= &pre_cfg.rx_filter,
+		},
+		{
+			.name		= "tx",
+			.type		= CMDL_S32,
+			.wanted_val	= &cfg.tx_type,
+			.ioctl_val	= &pre_cfg.tx_type,
+		},
+	};
+
+	parse_generic_cmdline(ctx, &changed,
+			      cmdline_config, ARRAY_SIZE(cmdline_config));
+
+	ctx->ifr.ifr_data = (void *)&pre_cfg;
+	if (ioctl(ctx->fd, SIOCGHWTSTAMP, &ctx->ifr)) {
+		perror("Cannot get device time stamping settings");
+		return -1;
+	}
+
+	changed = 0;
+	do_generic_set(cmdline_config, ARRAY_SIZE(cmdline_config), &changed);
+	if (!changed) {
+		fprintf(stderr, "no time-stamping policy changed.\n");
+		return 0;
+	}
+
+	if (cfg.tx_type >= N_TX_TYPES || cfg.rx_filter >= N_RX_FILTERS) {
+		printf("rx should be in [0..%d], tx should be in [0..%d]\n",
+		       N_RX_FILTERS - 1, N_TX_TYPES - 1);
+		return 1;
+	}
+
+	if (ioctl(ctx->fd, SIOCSHWTSTAMP, &ctx->ifr)) {
+		perror("Cannot set device time stamping settings");
+		return -1;
+	}
+	return 0;
+}
+
 static int do_getmodule(struct cmd_context *ctx)
 {
 	struct ethtool_modinfo modinfo;
@@ -5735,6 +5808,18 @@ static const struct option args[] = {
 		.nlfunc	= nl_tsinfo,
 		.help	= "Show time stamping capabilities"
 	},
+	{
+		.opts	= "--show-hwtstamp",
+		.func	= do_ghwtstamp,
+		.help	= "Show time stamping policy at the driver level"
+	},
+	{
+		.opts	= "--set-hwtstamp",
+		.func	= do_shwtstamp,
+		.help	= "Set time stamping policy at the driver level",
+		.xhelp	= "		[ rx N ]\n"
+			  "		[ tx N ]\n"
+	},
 	{
 		.opts	= "-x|--show-rxfh-indir|--show-rxfh",
 		.func	= do_grxfh,
-- 
2.28.0.402.g5ffc5be6b7-goog

