Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445871C043E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD3R6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgD3R6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:58:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64DE92186A;
        Thu, 30 Apr 2020 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588269487;
        bh=u6lh7i0RF+50nlLLhra5FXFScY3H5zwR91jK44f1LFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vS7xSqC7UVSEAI9v+woXfRoOxmryOxX3LKNx3quz+RM+8SRYDrlwI+d47bPXtb25d
         4lYQ78fK3YcqGjamjaNzxF7lUCj7oVho8EgcZncpkxzz0xxcP7aEshZV1FCvGm6+I+
         dhDi3mpZ0zi184EKq6xceeqxyRD6h4Xo+PZI8m3s=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH iproute2-next v3] devlink: support kernel-side snapshot id allocation
Date:   Thu, 30 Apr 2020 10:57:59 -0700
Message-Id: <20200430175759.1301789-5-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430175759.1301789-1-kuba@kernel.org>
References: <20200430175759.1301789-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make ID argument optional and read the snapshot info
that kernel sends us.

$ devlink region new netdevsim/netdevsim1/dummy
netdevsim/netdevsim1/dummy: snapshot 0
$ devlink -jp region new netdevsim/netdevsim1/dummy
{
    "regions": {
        "netdevsim/netdevsim1/dummy": {
            "snapshot": [ 1 ]
        }
    }
}
$ devlink region show netdevsim/netdevsim1/dummy
netdevsim/netdevsim1/dummy: size 32768 snapshot [0 1]

v3: back to v1..

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 devlink/devlink.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index bd48a73bc0e4..507972c360a7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6476,6 +6476,23 @@ static int cmd_region_read(struct dl *dl)
 	return err;
 }
 
+static int cmd_region_snapshot_new_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_REGION_NAME] ||
+	    !tb[DEVLINK_ATTR_REGION_SNAPSHOT_ID])
+		return MNL_CB_ERROR;
+
+	pr_out_region(dl, tb);
+
+	return MNL_CB_OK;
+}
+
 static int cmd_region_snapshot_new(struct dl *dl)
 {
 	struct nlmsghdr *nlh;
@@ -6484,12 +6501,15 @@ static int cmd_region_snapshot_new(struct dl *dl)
 	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_NEW,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION,
+				DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	pr_out_section_start(dl, "regions");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_region_snapshot_new_cb, dl);
+	pr_out_section_end(dl);
+	return err;
 }
 
 static void cmd_region_help(void)
-- 
2.25.4

