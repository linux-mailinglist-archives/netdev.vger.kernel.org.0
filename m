Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1884E4819
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiCVVJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbiCVVJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:09:15 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3216151
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:46 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id i186so2694405wma.3
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4gY9w4G273mp/X5m017v5e4gJ/MFTlUqy6e7fxJy9R4=;
        b=stPV/SWYUBBHr4/BQ+3zUfFIXkLZnFB8nPEp1MDspMzENhFCUzTyDPyV39TwMzN/Cf
         WXiaE6hWDNA+eF4XXkt9IKVSrpAZkK9yjTCT4JTSxrxZBYQLkUqW3cqx3fUg29eZvIcX
         PMCI24KI389rAAg4JI4Iexa6FFsRI7yC29iQIkL93ZN7G2jQCJfUikXIX9Hk5WhB2KT8
         HN0wvfKuZYicFkVlPxmSxtgzbq+SMW8VapFzfoqSdd14TQy3TWdoe/BjP353CJNq+ptr
         1zlQhk3gRxMomct46ktNfrXvdN/gDnKLzVzenwt2ke24+irL0cGF/d2d0nIiWCMvlnba
         SiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4gY9w4G273mp/X5m017v5e4gJ/MFTlUqy6e7fxJy9R4=;
        b=c7cIXilN24OqvwfVJrcdOk6R4iXQyYIKCiImLKUxn58DYVlPOHzpXXYp5y+MLKBO+h
         InMsIt3+J3Pr0MRdAEFlEq9KzL+E8hQOA8HzqPNJcdkAjxbHU7MJtbJYZMWQ2FCbKVaX
         ghqIK0rpqjb8Dcl5Khdu+jUMoEb3GXLiq/Toqw3e35OXZwOhvR6P/4D4Bsgcm0ZuqHdC
         d1M6FlVwka7lLoxhbraO/MifIRnnns8pS5ULXOIDZA1jJZeqSzU4ajLAwj1Wi4HXgmAd
         ipLg1FKTtRqrVUJtwSLjReBZVEl7omsgO8ovFjBpMEUCVqU0zcuwIBqqILVKi1JfleCB
         wPKw==
X-Gm-Message-State: AOAM533bzzdhd1oFlZt0gT8Tn5h41+RVBtbiHKUMkexAUidy1M3eDxmG
        UkvxhYOPlMthNkUlXET3z9sWIw==
X-Google-Smtp-Source: ABdhPJzDvtSHfVPQjjTyq/iofflRrNfz2n0/pdyapCldVDh86rT38MN5EgQlxvh4uGEltgkaAkYg4A==
X-Received: by 2002:a7b:c5d1:0:b0:37f:a8a3:9e17 with SMTP id n17-20020a7bc5d1000000b0037fa8a39e17mr5648420wmk.109.1647983265543;
        Tue, 22 Mar 2022 14:07:45 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm16281805wru.75.2022.03.22.14.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 14:07:45 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v1 4/6] ethtool: Add kernel API for PHC index
Date:   Tue, 22 Mar 2022 22:07:20 +0100
Message-Id: <20220322210722.6405-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220322210722.6405-1-gerhard@engleder-embedded.com>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new function, which returns the physical clock index of a
networking device. This function will be used to get the physical clock
of a device for timestamp manipulation in the receive path.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 include/linux/ethtool.h |  8 ++++++++
 net/ethtool/common.c    | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4af58459a1e7..e107069f37a4 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -820,6 +820,14 @@ void
 ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
 			      enum ethtool_link_mode_bit_indices link_mode);
 
+/**
+ * ethtool_get_phc - Get phc index
+ * @dev: pointer to net_device structure
+ *
+ * Return index of phc
+ */
+int ethtool_get_phc(struct net_device *dev);
+
 /**
  * ethtool_get_phc_vclocks - Derive phc vclocks information, and caller
  *                           is responsible to free memory of vclock_index
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 0c5210015911..8218e3b3e98a 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -557,6 +557,19 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	return 0;
 }
 
+int ethtool_get_phc(struct net_device *dev)
+{
+	struct ethtool_ts_info info;
+	int ret;
+
+	ret = __ethtool_get_ts_info(dev, &info);
+	if (ret)
+		return ret;
+
+	return info.phc_index;
+}
+EXPORT_SYMBOL(ethtool_get_phc);
+
 int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index)
 {
 	struct ethtool_ts_info info = { };
-- 
2.20.1

