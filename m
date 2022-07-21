Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7457D5B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiGUVPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiGUVP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:15:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAB558871;
        Thu, 21 Jul 2022 14:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658438128; x=1689974128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/DbLDxdU8oHRtgWd+kF8AfuKz6dLM/ogY++Th6kdzbU=;
  b=Vllz8lONX0Z7qiahUJ2DyJARQC4et2fGDtI72v2aMoPybBU241eILE49
   CfXe+9tW1ZkB2uunu6gF3fD7SNgWnYs0rItnWGRLdMvZETRR9Glv35JQh
   EP4ntsATGFGjM30SNokSHvF0YtkYyEdfee9rLYhzwJTKMsYS/dapPOIRn
   h8p90mqdaJen96qzmezwhZ28w4znU1uPvLQi3pBK063dAtjKxO/Aj5ISA
   +TP/QgCAp+LLi58uiwfdWr8tyKqVaUZ1o7brlfRU87JlsTOvyelKM8ikV
   KPCsxDQL8/xckYPBLVZO3P7Kkp/mVhTfu0YeQU3ZmXF59oMoHPS9B1uGm
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="312892795"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="312892795"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:15:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="925816223"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:15:00 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [iproute2-next v2 2/3] mnlg: add function to get CTRL_ATTR_MAXATTR value
Date:   Thu, 21 Jul 2022 14:14:50 -0700
Message-Id: <20220721211451.2475600-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
In-Reply-To: <20220721211451.2475600-1-jacob.e.keller@intel.com>
References: <20220721211451.2475600-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new function to extract the CTRL_ATTR_MAXATTR attribute of the
CTRL_CMD_GETFAMILY request. This will be used to allow reading the
maximum supported devlink attribute of the running kernel in an upcoming
change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/mnlg.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 devlink/mnlg.h |  1 +
 2 files changed, 57 insertions(+)

diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index e6d92742c150..348c3ff5c959 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -41,6 +41,10 @@ struct group_info {
 	const char *name;
 };
 
+struct family_info {
+	uint32_t max_attr;
+};
+
 static int parse_mc_grps_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
@@ -149,6 +153,58 @@ int mnlg_socket_group_add(struct mnlu_gen_socket *nlg, const char *group_name)
 	return 0;
 }
 
+static int get_family_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, CTRL_ATTR_MAX) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int get_family_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct family_info *family = data;
+	struct nlattr *tb[CTRL_ATTR_MAX + 1] = {};
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+
+	mnl_attr_parse(nlh, sizeof(*genl), get_family_attr_cb, tb);
+	if (!tb[CTRL_ATTR_MAXATTR])
+		return MNL_CB_ERROR;
+
+	family->max_attr = mnl_attr_get_u32(tb[CTRL_ATTR_MAXATTR]);
+
+	return MNL_CB_OK;
+}
+
+int mnlg_socket_get_max_attr(struct mnlu_gen_socket *nlg, uint32_t *max_attr)
+{
+	struct nlmsghdr *nlh;
+	struct family_info family;
+	int err;
+
+	nlh = _mnlu_gen_socket_cmd_prepare(nlg, CTRL_CMD_GETFAMILY,
+					   NLM_F_REQUEST | NLM_F_ACK,
+					   GENL_ID_CTRL, 1);
+
+	mnl_attr_put_u16(nlh, CTRL_ATTR_FAMILY_ID, nlg->family);
+
+	err = mnlg_socket_send(nlg, nlh);
+	if (err < 0)
+		return err;
+
+	err = mnlu_gen_socket_recv_run(nlg, get_family_cb, &family);
+	if (err < 0)
+		return err;
+
+	*max_attr = family.max_attr;
+
+	return 0;
+}
+
 int mnlg_socket_get_fd(struct mnlu_gen_socket *nlg)
 {
 	return mnl_socket_get_fd(nlg->nl);
diff --git a/devlink/mnlg.h b/devlink/mnlg.h
index 24aa17566a9b..6348ad45ed26 100644
--- a/devlink/mnlg.h
+++ b/devlink/mnlg.h
@@ -18,6 +18,7 @@ struct mnlu_gen_socket;
 
 int mnlg_socket_send(struct mnlu_gen_socket *nlg, const struct nlmsghdr *nlh);
 int mnlg_socket_group_add(struct mnlu_gen_socket *nlg, const char *group_name);
+int mnlg_socket_get_max_attr(struct mnlu_gen_socket *nlg, uint32_t *max_attr);
 int mnlg_socket_get_fd(struct mnlu_gen_socket *nlg);
 
 #endif /* _MNLG_H_ */
-- 
2.36.1

