Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E636666751
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 00:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjAKX5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 18:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbjAKX5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 18:57:41 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899221DF18
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 15:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673481460; x=1705017460;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fJZ0A4O1ocRZVmxZe3VZMM2QpKhNdmc7mLQUCXc0PDo=;
  b=QA9Oo1728SG+r/hZvi3C7VqADW2F/M3+MghvkoguabtDiiOLuHcnAqYx
   sdK6eEuDJRZMTkG09HRGIR2cfUvGDDfiFlGVQu7fpIAGBvzQUimxadYk4
   Lrr27S19t30b/qYsFYNlLl5swDePf1nvNussiAC8/SSxu+WKfjWYZgx4J
   nqlxEtQiC0rmfbS8jNSBBtfa/36FH8Kcch1wEeb+lQz3oHcuoxv0lrnly
   5aLDfL3/hYvj44w4dZ9xTJBI5fRJhpaTET4hoM1NYCiGIf53ITU2FQaFd
   gNqZbbTIvU1ZJ8OwDuxGGggsNoF5DQAQlwrQNM8HjLVoGHXubfQ8UogJg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="322270916"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="322270916"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 15:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="720886160"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="720886160"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jan 2023 15:57:40 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net] ethtool:add netlink attr in rss get reply only if value is not null
Date:   Wed, 11 Jan 2023 15:56:07 -0800
Message-Id: <20230111235607.85509-1-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code for RSS_GET ethtool command includes netlink attributes
in reply message to user space even if they are null. Added checks
to include netlink attribute in reply message only if a value is
received from driver. Drivers might return null for RSS indirection
table or hash key. Instead of including attributes with empty value
in the reply message, add netlink attribute only if there is content.

Fixes: 7112a04664bf ("ethtool: add netlink based get rss support")
Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
 net/ethtool/rss.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index ebe6145aed3f..be260ab34e58 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -122,10 +122,13 @@ rss_fill_reply(struct sk_buff *skb, const struct ethnl_req_info *req_base,
 {
 	const struct rss_reply_data *data = RSS_REPDATA(reply_base);
 
-	if (nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc) ||
-	    nla_put(skb, ETHTOOL_A_RSS_INDIR,
-		    sizeof(u32) * data->indir_size, data->indir_table) ||
-	    nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data->hkey))
+	if ((data->hfunc &&
+	     nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc)) ||
+	    (data->indir_size &&
+	     nla_put(skb, ETHTOOL_A_RSS_INDIR,
+		     sizeof(u32) * data->indir_size, data->indir_table)) ||
+	    (data->hkey_size &&
+	     nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data->hkey)))
 		return -EMSGSIZE;
 
 	return 0;
-- 
2.31.1

