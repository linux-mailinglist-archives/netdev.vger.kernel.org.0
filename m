Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FEF58B2CE
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 01:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241740AbiHEXmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 19:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241880AbiHEXmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 19:42:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4DA18E27
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 16:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659742924; x=1691278924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A4aBE3/4vzSQoxMuDS5tvQDOxwgtBLlVD7xcwd8Lpko=;
  b=JKgDQ5kfuvpmX+aNG668ZNIN08DdvqgESOHiPpv+aRDnarU80WapgXP9
   +ghMIecvJY9rS/ZXk5h3EUHdSxiP4GK7jP6tpagWvB9a+Hz/SD5onlAoE
   y2sTxu+JpIHNlqNmqKe+iqb/Psg6M5qdi17Yg1aW6xN+rA21mOcLO//iI
   /2ty+OMJ5ioDEvuzz0ypeuPoo7GVMNsRrI2EIw/LTpShpP406rWHEdnI8
   JREvziKav/w6rNc4aUvX4an5OvfRQ26KiB4uD/dzNHC2Z53VmV6we6Afe
   2L5XZvdflJf6bvAvOk6YEyujdPVJ5GFkwEbncMI7hrNboox9QDmfA/3D+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289072933"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="289072933"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="931401653"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:02 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 2/6] utils: extract CTRL_ATTR_MAXATTR and save it
Date:   Fri,  5 Aug 2022 16:41:51 -0700
Message-Id: <20220805234155.2878160-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
In-Reply-To: <20220805234155.2878160-1-jacob.e.keller@intel.com>
References: <20220805234155.2878160-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.37.1.208.ge72d93e88cb2

