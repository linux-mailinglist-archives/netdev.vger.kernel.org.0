Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E86456450
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhKRUh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbhKRUh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:37:59 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B159CC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:34:58 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np3so6086994pjb.4
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wy7ZFa/vlTHtgg8uQMNJ843aX+ZbzQs1i4QUu9cpwyY=;
        b=FKfwi2Ivo4NmiyvT2tVWOs7r58MIEvYZEOXuGViUBcXpN74o9eypyVH5z0BQzIYu+J
         KloQOQ8pw0FeXpN//jAS2okJxT+w+secrDywySrARz+LKLkZKVndv8dBGYuHUY4iELVu
         EJ2J0sva9U2uDRIY/pa3eDVEzuW4FLwCOBc9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wy7ZFa/vlTHtgg8uQMNJ843aX+ZbzQs1i4QUu9cpwyY=;
        b=zpX/9Q27Id7veT5RQMqBpAhhW+3Xcyo/BkOXrwaW9RLTM4TCKFtrtHz3qyJKYVvoLC
         LsvfRNSrxM874NIGHsVNs/Hk1CwUFQT/DlbnNK1jSyMAaUXDZdhFdmQqi9GvKMwnC9TA
         YiB291opDQMa0+D8XrfJvbYN89eQ52yYnSjqKrxn5jpJkQfcNZV65UCIRqMOlfpQxy8l
         GH//ShHckbgY5ePPG6v7svtSr8wenWZfRRdQg2TYcwLCoI+b2NsGcnN1bMVbqA01fo47
         MyW3MpeqWQIT/2P//OvsxBA7nxyOVkjlJDvVsfbHq6OTebJcxBfUUraMTyxz2NOBVMCk
         7z3A==
X-Gm-Message-State: AOAM533KfPUokGDP3X9IqI6EfS/iEwR3ulrWZ2lnMYk1Bg5m1zLZQGk+
        L8UTCONKtW52LRBzVG9BPm8aiw==
X-Google-Smtp-Source: ABdhPJwv6uDXoEhxsSqoGjLKfrb3/6Kd7ESUUDv7joUBA+7yE9nJXirBGTl+M3FfitWyi/vo0xFwBw==
X-Received: by 2002:a17:902:74cb:b0:143:6fe9:ca4 with SMTP id f11-20020a17090274cb00b001436fe90ca4mr70980340plt.2.1637267698249;
        Thu, 18 Nov 2021 12:34:58 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q9sm489033pfj.88.2021.11.18.12.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:34:58 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] ethtool: stats: Use struct_group() to clear all stats at once
Date:   Thu, 18 Nov 2021 12:34:56 -0800
Message-Id: <20211118203456.1288056-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1822; h=from:subject; bh=nf2hDwlk0YBMeQam31KvtF6X3nn/T4T4psodjHluwA0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlrjv4ay2vSP0iUDUl/jIVt/Blah8KWXvHVH7Wzv7 NYIRQBeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa47wAKCRCJcvTf3G3AJvBJD/ 9Na9qQTVUsisud4heS8I6/Jho/ZfNvhU2k2tn9Jv8ASHEdfY+9rKBmAX0tJUczauv+kWXiRwOxOx1j cyjX0xISkco0aZfG4vj9XQIBc9CPxkBDj0aBaz78+IHKOWr59+S2V0QmYL04Ycdak/MayJzGvfL/ms BBSYWc++4lXP0WYaJNF9zs4hYQvVxJi85u3Z241lUdvn8UPyRvjxOMzMw35oZCGza98pHctIJ+zobA 7BuEbCEL6kjwD9s4XETlcN2NoABT+e4W6HNrNBi/QuOwjP/0KNVbljl43XnBqwqfeBeItZPJOs2X3m Jidx5KHe54mlK+PcMFnJtcRBfnJu14HAX9nymfBRP2Z1vqwECWXdGkHOPfVsIhxjHonSfgVDB4RlaM 1LYUcHgCmJY+biBO46pJTSRx9vt6J5ZTCWlWhlIubJSuakDoRCEhEON+8iaFeWJybYZNJQ+I/JBsRI eVwXeWvkcvE8wFRTtugO1pST327roZ7fIGFcbk9SW2udTvFSoFQgaNnlx3OmSKeKN01a0cAPz7VF6/ h+9yaYmVn29wO+1VqwUS9QH0Km77doUOTyCQr1SRxSVhxE37TLIEdBCBVYxPKtat++V3Ea7YNVOQRf 8oTFbBdf9aBk/R4uU1KGLqFfSVHLFQbQ3CaEc9do1jYpilSFqay8yZQsLa+w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark region of struct stats_reply_data that should
be initialized, which can now be done in a single memset() call.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ethtool/stats.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index ec07f5765e03..a20e0a24ff61 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -14,10 +14,12 @@ struct stats_req_info {
 
 struct stats_reply_data {
 	struct ethnl_reply_data		base;
-	struct ethtool_eth_phy_stats	phy_stats;
-	struct ethtool_eth_mac_stats	mac_stats;
-	struct ethtool_eth_ctrl_stats	ctrl_stats;
-	struct ethtool_rmon_stats	rmon_stats;
+	struct_group(stats,
+		struct ethtool_eth_phy_stats	phy_stats;
+		struct ethtool_eth_mac_stats	mac_stats;
+		struct ethtool_eth_ctrl_stats	ctrl_stats;
+		struct ethtool_rmon_stats	rmon_stats;
+	);
 	const struct ethtool_rmon_hist_range	*rmon_ranges;
 };
 
@@ -117,10 +119,7 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
 	 * from being reported to user space in case driver did not set them.
 	 */
-	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
-	memset(&data->mac_stats, 0xff, sizeof(data->mac_stats));
-	memset(&data->ctrl_stats, 0xff, sizeof(data->ctrl_stats));
-	memset(&data->rmon_stats, 0xff, sizeof(data->rmon_stats));
+	memset(&data->stats, 0xff, sizeof(data->stats));
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_phy_stats)
-- 
2.30.2

