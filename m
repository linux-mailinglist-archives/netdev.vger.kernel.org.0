Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907F15A2E1F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245565AbiHZSRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245175AbiHZSRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:17:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2EBD31E5
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 11:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661537871; x=1693073871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ei5DukfQ66bobxhqpjTsx4PcaHKb+Ra8CJ+BQ8ZRLpQ=;
  b=nB1hsRTxCwKyQatZjhm9W9K3SCu8N6ra7xnsuzvOJr/pACXMYxdbjAao
   XBxZ3jJ2/JoMLJsqWcYdzqSVV9lpJUdd4twUqCGpg5qyaSELDZudt2rbA
   cCcgrhZT0Ka2W0ffTiU+ydGJBI5tGcrUwAJ2/AK7gwfo0lGbjzlpjWg7a
   A2i6n4vh1RbMywL3jxyPj5Bv1mRPFhLE9mAK35+Ahs5gDXlNCdD80lr0B
   s2iD/pxjZRXNxv3n+35v6jpXS2jVIgCqgzS5w3txB+7h4/iISbIhY5OMt
   rc4sqoUoS/a0TMC2ADbwwpcRTz/CbxhdpK8kkpdepYPzCOT8IpF+6uBvc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="274970455"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="274970455"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 11:17:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="643754624"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 11:17:48 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH iproute2-next 2/2] utils: extract CTRL_ATTR_MAXATTR and save it
Date:   Fri, 26 Aug 2022 11:17:41 -0700
Message-Id: <20220826181741.3878852-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
In-Reply-To: <20220826181741.3878852-1-jacob.e.keller@intel.com>
References: <20220826181741.3878852-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mnlu_gen_socket_open opens a socket and configures it for use with a
generic netlink family. As part of this process it sends a
CTRL_CMD_GETFAMILY to get the ID for the family name requested.

In addition to the family id, this command reports a few other useful
values including the maximum attribute. The maximum attribute is useful in
order to know whether a given attribute is supported and for knowing the
necessary size to allocate for other operations such as policy dumping.

Since we already have to issue a CTRL_CMD_GETFAMILY to get the id, we can
also store the maximum attribute as well. Modify the callback functions to
parse the maximum attribute NLA and store it in the mnlu_gen_socket
structure.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/mnl_utils.h |  1 +
 lib/mnl_utils.c     | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/mnl_utils.h b/include/mnl_utils.h
index aa5f0a9b17c7..2193934849e1 100644
--- a/include/mnl_utils.h
+++ b/include/mnl_utils.h
@@ -6,6 +6,7 @@ struct mnlu_gen_socket {
 	struct mnl_socket *nl;
 	char *buf;
 	uint32_t family;
+	uint32_t maxattr;
 	unsigned int seq;
 	uint8_t version;
 };
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index d5abff58d816..79bac5cfd4de 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -110,7 +110,7 @@ int mnlu_socket_recv_run(struct mnl_socket *nl, unsigned int seq, void *buf, siz
 	return err;
 }
 
-static int get_family_id_attr_cb(const struct nlattr *attr, void *data)
+static int get_family_attrs_cb(const struct nlattr *attr, void *data)
 {
 	int type = mnl_attr_get_type(attr);
 	const struct nlattr **tb = data;
@@ -121,20 +121,26 @@ static int get_family_id_attr_cb(const struct nlattr *attr, void *data)
 	if (type == CTRL_ATTR_FAMILY_ID &&
 	    mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
 		return MNL_CB_ERROR;
+	if (type == CTRL_ATTR_MAXATTR &&
+	    mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+		return MNL_CB_ERROR;
 	tb[type] = attr;
 	return MNL_CB_OK;
 }
 
-static int get_family_id_cb(const struct nlmsghdr *nlh, void *data)
+static int get_family_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
 	struct nlattr *tb[CTRL_ATTR_MAX + 1] = {};
-	uint32_t *p_id = data;
+	struct mnlu_gen_socket *nlg = data;
 
-	mnl_attr_parse(nlh, sizeof(*genl), get_family_id_attr_cb, tb);
+	mnl_attr_parse(nlh, sizeof(*genl), get_family_attrs_cb, tb);
 	if (!tb[CTRL_ATTR_FAMILY_ID])
 		return MNL_CB_ERROR;
-	*p_id = mnl_attr_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
+	if (!tb[CTRL_ATTR_MAXATTR])
+		return MNL_CB_ERROR;
+	nlg->family = mnl_attr_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
+	nlg->maxattr = mnl_attr_get_u32(tb[CTRL_ATTR_MAXATTR]);
 	return MNL_CB_OK;
 }
 
@@ -159,7 +165,7 @@ static int family_get(struct mnlu_gen_socket *nlg, const char *family_name)
 
 	err = mnlu_socket_recv_run(nlg->nl, nlh->nlmsg_seq, nlg->buf,
 				   MNL_SOCKET_BUFFER_SIZE,
-				   get_family_id_cb, &nlg->family);
+				   get_family_cb, nlg);
 	return err;
 }
 
-- 
2.37.1.394.gc50926e1f488

