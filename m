Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C3F322B62
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhBWNZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhBWNZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 08:25:39 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8FCC06178A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 05:24:59 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id v64so257095qtd.5
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 05:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=krsypgdXcaHIQO9PXuO2j91G39uHw7y/0Ra9DAqv6IY=;
        b=m3TFHB8+wFXD80Byzvp5V3RG2+CNkkTybWBxyQceK2L2wOgxiULn4ryngJnaABMIHd
         txHRrrtr2+Afdo5+b1QQXJF+Gok0UAzITqvKdg+QyqrrwHQhijZBaQsF3EXTjbjOKKo+
         e/arutSq8Y41T14k9R3/gAUd3QC88UQ/O17THPGHWDo4k4Rb0Ip/uyBjQB+dl62C+6Ku
         gIP1HpdSHBfqQsJUTCol0xsQCefw5cnFWFeLg03ULyqpDao+EGu5Z7sps5qydZQxdWOb
         JIQqtIu6pW+kn5oZ9bgdHQmlTIbm3IPjSg5GjLLGgNmwVVzMaIworv4B5Wes91kQC3kI
         OL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=krsypgdXcaHIQO9PXuO2j91G39uHw7y/0Ra9DAqv6IY=;
        b=o74MfGJu1AzZF9lpKBFcQZTSvg+r77iagHbPclW7So//EzQVq8FQ6Db1BrYGZDkfx+
         1clJ6NAzsM+IzCZ/WY2oEvuz3rrsBZYZd5LdtcPFMr6M72vxfhfRLwUbbYb6B/r54rBG
         +K1EdfT2sQAIeNsBVUr52+mN9A4+f6gCObTx31dOoGI2efr0kc5EiuBnLndpC5SQ9npa
         j3TEr876DsI/7r/mFrAlYI45VK9lRH1tSB43ZQehd4iUHmwfKTGj9OMCNHPRttVsmkgt
         0Sjj/SbnTK4+WjHsWQhx8SEQfEUe9z4EVu+lPe9GSUKGtbA5bGPY/rIq7Fk+GWqjXHWD
         7T9Q==
X-Gm-Message-State: AOAM531z5FARtDEEt4JKO52W9eUZXoR4anuAK6ZHrqgSdLaDyVIbbRv5
        YknMmA5CJ/ANiWp6Yk9JLSNBOjcePh6+RQ==
X-Google-Smtp-Source: ABdhPJyVBUtBUgubNerbTvzWAUgDZUPN7KqqHXzFvGExuSjq/U9gMf7cUHlD5I/rYFU9mazNso7c/Q==
X-Received: by 2002:a05:622a:514:: with SMTP id l20mr25375278qtx.62.1614086698421;
        Tue, 23 Feb 2021 05:24:58 -0800 (PST)
Received: from madeliefje.horms.nl.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id d27sm538998qkk.34.2021.02.23.05.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 05:24:57 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: [PATCH net] ethtool: fix the check logic of at least one channel for RX/TX
Date:   Tue, 23 Feb 2021 14:24:40 +0100
Message-Id: <20210223132440.810-1-simon.horman@netronome.com>
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
 net/ethtool/channels.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 25a9e566ef5c..e35ef627f61f 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -175,14 +175,14 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 
 	/* ensure there is at least one RX and one TX channel */
 	if (!channels.combined_count && !channels.rx_count)
-		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+		err_attr = mod_combined ? tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT] :
+					  tb[ETHTOOL_A_CHANNELS_RX_COUNT];
 	else if (!channels.combined_count && !channels.tx_count)
-		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+		err_attr = mod_combined ? tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT] :
+					  tb[ETHTOOL_A_CHANNELS_TX_COUNT];
 	else
 		err_attr = NULL;
 	if (err_attr) {
-		if (mod_combined)
-			err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
 		ret = -EINVAL;
 		NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts would result in no RX or TX channel being configured");
 		goto out_ops;
-- 
2.20.1

