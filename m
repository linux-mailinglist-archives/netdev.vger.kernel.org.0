Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1006525C3D0
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgICO7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728646AbgICOHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:07:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F42EC06123E
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 07:07:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d80so3018532ybh.0
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 07:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=oB5vf8HH/Iz5NlPyYMD+ywqzjCQzjmbLVHU30HxOXHo=;
        b=icqTcNhmZLpB6aQ5Mz65LFKLo4mLn7H21GtwpYK/8JlfPLK11pExNGR73vfHiIcq0c
         whtH83o+zT2YRZXmcGYuL4fDX/tjCOEiE9x1+mfRFQEhmPXLkQewg5bX4RBvUo1b4q6w
         WAep1U7w5o9cqRF3/P02T+kMISHWtqhXSEnik6Q6zvFIEAZXPiGPj0RobyL/ajKw32TF
         2iMwSVViH0koQUmD0xPkWApgOhAv/JlkeE/G8Jv4jUiNJmn8z9Bgo84Grifgojuf5RyC
         nwg5U+JKqWIXDhyEB25CuSrHrHTvRXxzu8QnWvdE335JbUAK3ilHOcFj+uNBbZSqTmu7
         vDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=oB5vf8HH/Iz5NlPyYMD+ywqzjCQzjmbLVHU30HxOXHo=;
        b=hEc70VO/1I4zF4OO0JOyGxs9Ij/xP4CufDEc74l4URJIPcyjIQ5znacS177e8TT4Zc
         IfFVyxwys1LMSCwz4bywk+h7SxevpMwo2RvhqSjhkb0IuV227PYA9FgA8SWXLNe0Ysad
         4AAqWOKlZrrkGmZVwGpLORz4Qm8rQkySks9bDBw1eBkOrh0dkXemidC5/bPGu0qy0fzH
         LDjvzQqPYPf5BtybPIY5/bWmdlftFlxtVOJBdZFst0QoGEuMM45DJoqXPBfMNt+a/c3E
         azs7Ng5K/u6KYPs3mXwg+AtmbOmSZrLGmuhe7UUuqBDKhm3pbkC2qMVS3+MaLQRwNU06
         rS0A==
X-Gm-Message-State: AOAM533dRj2eR3vISHFT6YFcIGz9UffevjNZpmrMhHb41mcXXD1oQzhw
        eKV6yoJm4au/N88y4LaxXLingJ4=
X-Google-Smtp-Source: ABdhPJxTOVArnylCsHfXNZ8run1f/K8ihh9foq+Ka4JzO5TAGUSMUG9clROEBpF2m+4iQMp/obOrxT4=
X-Received: from yyd.nyc.corp.google.com ([2620:0:1003:31c:1ea0:b8ff:fe75:b9d4])
 (user=yyd job=sendgmr) by 2002:a25:aca6:: with SMTP id x38mr1329956ybi.517.1599142061117;
 Thu, 03 Sep 2020 07:07:41 -0700 (PDT)
Date:   Thu,  3 Sep 2020 10:07:14 -0400
Message-Id: <20200903140714.1781654-1-yyd@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH ethtool,v2] ethtool: add support show/set-time-stamping
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
...
Hardware Transmit Timestamp Modes:
        off                   (HWTSTAMP_TX_OFF)
        on                    (HWTSTAMP_TX_ON)
Hardware Receive Filter Modes:
        none                  (HWTSTAMP_FILTER_NONE)
        all                   (HWTSTAMP_FILTER_ALL)
Hardware Timestamping Policy:
        Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
        Tx type 0, off                   (HWTSTAMP_TX_OFF)

./ethtool --set-time-stamping eth1 rx 1; ./ethtool -T eth1;
...
Hardware Timestamping Policy:
	Rx filter 1, all                   (HWTSTAMP_FILTER_ALL)
	Tx type 0, off                   (HWTSTAMP_TX_OFF)

./ethtool --set-time-stamping eth1 rx 1 tx 1; ./ethtool -T eth1;
rx unmodified, ignoring
...
Hardware Timestamping Policy:
	Rx filter 1, all                   (HWTSTAMP_FILTER_ALL)
	Tx type 1, on                    (HWTSTAMP_TX_ON)

./ethtool --set-time-stamping eth1 rx 0; ./ethtool -T eth1;
...
Hardware Timestamping Policy:
	Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
	Tx type 1, on                    (HWTSTAMP_TX_ON)

./ethtool --set-time-stamping eth1 tx 0; ./ethtool -T eth1
...
Hardware Timestamping Policy:
	Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
	Tx type 0, off                   (HWTSTAMP_TX_OFF)

./ethtool --set-time-stamping eth1 rx 123 tx 456
rx should be in [0..15], tx should be in [0..2]

Signed-off-by: Kevin Yang <yyd@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 ethtool.8.in | 10 +++++-
 ethtool.c    | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index a50a476..9930804 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -315,6 +315,11 @@ ethtool \- query or control network driver and hardware settings
 .B ethtool \-T|\-\-show\-time\-stamping
 .I devname
 .HP
+.B ethtool \-\-set\-time\-stamping
+.I devname
+.BN rx
+.BN tx
+.HP
 .B ethtool \-x|\-\-show\-rxfh\-indir|\-\-show\-rxfh
 .I devname
 .HP
@@ -1023,9 +1028,12 @@ is indicated, then ethtool fetches the dump data and directs it to a
 Sets the dump flag for the device.
 .TP
 .B \-T \-\-show\-time\-stamping
-Show the device's time stamping capabilities and associated PTP
+Show the device's time stamping capabilities and policy and associated PTP
 hardware clock.
 .TP
+.B \-\-set\-time\-stamping
+Set the device's time stamping policy at the driver level.
+.TP
 .B \-x \-\-show\-rxfh\-indir \-\-show\-rxfh
 Retrieves the receive flow hash indirection table and/or RSS hash key.
 .TP
diff --git a/ethtool.c b/ethtool.c
index 606af3e..039b9a9 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1618,6 +1618,24 @@ static int dump_tsinfo(const struct ethtool_ts_info *info)
 	return 0;
 }
 
+static int dump_hwtstamp_config(const struct hwtstamp_config *cfg)
+{
+	fprintf(stdout, "Hardware Timestamping Policy:\n");
+	fprintf(stdout, "\tRx filter %d", cfg->rx_filter);
+	if (cfg->rx_filter < N_RX_FILTERS)
+		fprintf(stdout, ", %s\n", rx_filter_labels[cfg->rx_filter]);
+	else
+		fprintf(stdout, "\n");
+
+	fprintf(stdout, "\tTx type %d", cfg->tx_type);
+	if (cfg->tx_type < N_TX_TYPES)
+		fprintf(stdout, ", %s\n", tx_type_labels[cfg->tx_type]);
+	else
+		fprintf(stdout, "\n");
+
+	return 0;
+}
+
 static struct ethtool_gstrings *
 get_stringset(struct cmd_context *ctx, enum ethtool_stringset set_id,
 	      ptrdiff_t drvinfo_offset, int null_terminate)
@@ -4705,6 +4723,7 @@ err:
 static int do_tsinfo(struct cmd_context *ctx)
 {
 	struct ethtool_ts_info info;
+	struct hwtstamp_config cfg = { 0 };
 
 	if (ctx->argc != 0)
 		exit_bad_args();
@@ -4716,6 +4735,64 @@ static int do_tsinfo(struct cmd_context *ctx)
 		return -1;
 	}
 	dump_tsinfo(&info);
+
+	ctx->ifr.ifr_data = (void *)&cfg;
+	if (ioctl(ctx->fd, SIOCGHWTSTAMP, &ctx->ifr)) {
+		perror("Cannot get device time stamping policy");
+		return -1;
+	}
+	dump_hwtstamp_config(&cfg);
+
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
+		fprintf(stderr,
+			"rx should be in [0..%d], tx should be in [0..%d]\n",
+			N_RX_FILTERS - 1, N_TX_TYPES - 1);
+		return -1;
+	}
+
+	if (ioctl(ctx->fd, SIOCSHWTSTAMP, &ctx->ifr)) {
+		perror("Cannot set device time stamping settings");
+		return -1;
+	}
 	return 0;
 }
 
@@ -5733,7 +5810,14 @@ static const struct option args[] = {
 		.opts	= "-T|--show-time-stamping",
 		.func	= do_tsinfo,
 		.nlfunc	= nl_tsinfo,
-		.help	= "Show time stamping capabilities"
+		.help	= "Show time stamping capabilities and policy"
+	},
+	{
+		.opts	= "--set-time-stamping",
+		.func	= do_shwtstamp,
+		.help	= "Set time stamping policy at the driver level",
+		.xhelp	= "		[ rx N ]\n"
+			  "		[ tx N ]\n"
 	},
 	{
 		.opts	= "-x|--show-rxfh-indir|--show-rxfh",
-- 
2.28.0.402.g5ffc5be6b7-goog

