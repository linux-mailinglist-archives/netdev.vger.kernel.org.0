Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB7D324FF9
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhBYMwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhBYMwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:52:10 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F251FC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:51:29 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g11so808951wmh.1
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3WDWePWMVLrRxxfzaPAvHt3LxZgHHbL0BCQWNJrfPqs=;
        b=JUYvHHFXpwmO6ikowGdJ2/j2/l7MSyMYn5GuRdpCVgBJXUBqEqhJWkm1vOe0Xvdo+Y
         OqXyGEnOhnI0j17zm7mWukgAXb4nw+sSE6UPtmmv2KopykLrDocrv9HXnGNwEZHfLpwZ
         /ofQgztW7iVQtgESC7IvZF2ZF1R+2e+/cn0p3dLfH1/yhzmkXfZfTm9FVBo0cDFRGURy
         GxBNHUn2IMwKgRDZw2Ir7F6ffeZWIiIXyUY3qaov9KVcnzMQsrZWuIeRKJdLQUpz9YBx
         7rLAQigC0jnY81ryziGtGtS2w7f9cMv7FYoKP66GL76v3wc/bzi8BKCLzx+wp/0XTXMo
         MNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3WDWePWMVLrRxxfzaPAvHt3LxZgHHbL0BCQWNJrfPqs=;
        b=DOeUHt3pv7Xm/GhmByNYZzzdq80lttiBb2M5oGHuOgyB+yrLOM5+edzFWwKHqvy19K
         oonyFfZYHrzUZWTaQbh2qtJ86N/JQDdS3wXvMA+8wqlihFCpfpSzcAErNcpo/mylOmXx
         g+cpvj+E4pjiCTXY14bBoFLZTtpjupL6YIHf+TpYzWC0T5TDCyXAEfVaHbmY85jKMIJx
         tKofPBbQ5ewxAWDKwNv3lM3R5nsNOPffLYHAWKm79rev5b7o7uy/NjA/w6RDSYgbyHfs
         7CJ/bXSqTH0aFlxrHO2v+3cVijBOuKcXTDAq2aZjsv1cqp9G/mru0tbkVfglenzesbkQ
         GhuA==
X-Gm-Message-State: AOAM532ydJf51MYt1EsiIIiMXgbRHencqMUd0L+7OBXxV0BWVdDSidKB
        mvbpUeuabUenRqw12YYpgkYaEA==
X-Google-Smtp-Source: ABdhPJzWJ2WX0QDP/HX4ErQLXkkvMdomh4l0nQkLg0g37T9JMgXT+dQz2D03YIOgpKnTk+tMGWo7Jw==
X-Received: by 2002:a1c:d7:: with SMTP id 206mr3148398wma.68.1614257488513;
        Thu, 25 Feb 2021 04:51:28 -0800 (PST)
Received: from madeliefje.horms.nl.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id f7sm7084710wmh.39.2021.02.25.04.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:51:27 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: [PATCH net v2] ethtool: fix the check logic of at least one channel for RX/TX
Date:   Thu, 25 Feb 2021 13:51:02 +0100
Message-Id: <20210225125102.23989-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The command "ethtool -L <intf> combined 0" may clean the RX/TX channel
count and skip the error path, since the attrs
tb[ETHTOOL_A_CHANNELS_RX_COUNT] and tb[ETHTOOL_A_CHANNELS_TX_COUNT]
are NULL in this case when recent ethtool is used.

Tested using ethtool v5.10.

Fixes: 7be92514b99c ("ethtool: check if there is at least one channel for TX/RX in the core")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
V2: (suggested by Jakub Kicinski)
  - A better change to fix the check of exceeding max count as well
---
 net/ethtool/channels.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 25a9e566ef5c..6a070dc8e4b0 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -116,10 +116,9 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	struct ethtool_channels channels = {};
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
-	const struct nlattr *err_attr;
+	u32 err_attr, max_rx_in_use = 0;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
-	u32 max_rx_in_use = 0;
 	int ret;
 
 	ret = ethnl_parse_header_dev_get(&req_info,
@@ -157,34 +156,35 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 
 	/* ensure new channel counts are within limits */
 	if (channels.rx_count > channels.max_rx)
-		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
 	else if (channels.tx_count > channels.max_tx)
-		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
 	else if (channels.other_count > channels.max_other)
-		err_attr = tb[ETHTOOL_A_CHANNELS_OTHER_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_OTHER_COUNT;
 	else if (channels.combined_count > channels.max_combined)
-		err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
 	else
-		err_attr = NULL;
+		err_attr = 0;
 	if (err_attr) {
 		ret = -EINVAL;
-		NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr],
 				    "requested channel count exceeds maximum");
 		goto out_ops;
 	}
 
 	/* ensure there is at least one RX and one TX channel */
 	if (!channels.combined_count && !channels.rx_count)
-		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
 	else if (!channels.combined_count && !channels.tx_count)
-		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
 	else
-		err_attr = NULL;
+		err_attr = 0;
 	if (err_attr) {
 		if (mod_combined)
-			err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
+			err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
 		ret = -EINVAL;
-		NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts would result in no RX or TX channel being configured");
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr],
+				    "requested channel counts would result in no RX or TX channel being configured");
 		goto out_ops;
 	}
 
-- 
2.20.1

