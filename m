Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF64F1BECAC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgD2Xi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD2XiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 19:38:25 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFEA2072A;
        Wed, 29 Apr 2020 23:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588203504;
        bh=GAaILOZKhlAXc62oIv4G0lZqcm+xKtQqG/FAJ016kKo=;
        h=From:To:Cc:Subject:Date:From;
        b=tFN4yNufGUlFyQuncO/T1niTLzvtWoImobg+4CShQZ28C7vOQuLJmc0nc9DhVYqBX
         K7P0AtGzM1b3pqBWRuXN3Nv/32vCSDbN1fe/4p8aV/SWDVjZYVYn4+OYa89tWPCHb1
         jFWXfNYvtmxL9pc7ozuZ60qXQa/8ggDBeaLPpZQs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     dsahern@gmail.com, stephen@networkplumber.org, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH iproute2-next v2] devlink: support kernel-side snapshot id allocation
Date:   Wed, 29 Apr 2020 16:38:19 -0700
Message-Id: <20200429233819.1137483-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
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

In case the operation fails only the error is printed:

  $ devlink region new netdevsim/netdevsim1/dummy
  Error: devlink: failure injected after ID notification was sent.
  devlink answers: Input/output error
  $

v2:
 - make sure we don't print anything on failure.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 devlink/devlink.c | 66 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index bd48a73bc0e4..73a1f02a5339 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6476,20 +6476,80 @@ static int cmd_region_read(struct dl *dl)
 	return err;
 }
 
+static int cmd_region_snapshot_new_response_print(struct dl *dl,
+						  const struct nlmsghdr *nlh)
+{
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+
+	if (dl->opts.present & DL_OPT_REGION_SNAPSHOT_ID)
+		return 0;
+
+	if (!nlh->nlmsg_len) {
+		pr_err("no response from the kernel\n");
+		return -EINVAL;
+	}
+
+	mnl_attr_parse(nlh, sizeof(struct genlmsghdr), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_REGION_NAME] ||
+	    !tb[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+		pr_err("kernel response does not contain expected attributes\n");
+		return -EINVAL;
+	}
+
+	pr_out_section_start(dl, "regions");
+	pr_out_region(dl, tb);
+	pr_out_section_end(dl);
+
+	return 0;
+}
+
+static int cmd_region_snapshot_new_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlmsghdr *nlh_copy = data;
+
+	if (genl->cmd != DEVLINK_CMD_REGION_NEW)
+		return MNL_CB_OK;
+
+	/* Make sure we only receive one message from the kernel */
+	if (nlh_copy->nlmsg_len)
+		return MNL_CB_ERROR;
+
+	if (nlh->nlmsg_len > MNL_SOCKET_BUFFER_SIZE)
+		return MNL_CB_ERROR;
+
+	memcpy(data, nlh, nlh->nlmsg_len);
+
+	return MNL_CB_OK;
+}
+
 static int cmd_region_snapshot_new(struct dl *dl)
 {
+	unsigned char *msg_copy;
 	struct nlmsghdr *nlh;
 	int err;
 
 	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_NEW,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION,
+				DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	msg_copy = calloc(MNL_SOCKET_BUFFER_SIZE, 1);
+
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_region_snapshot_new_cb,
+				  msg_copy);
+	if (err)
+		goto out;
+
+	err = cmd_region_snapshot_new_response_print(dl, (void *)msg_copy);
+out:
+	free(msg_copy);
+
+	return err;
 }
 
 static void cmd_region_help(void)
-- 
2.25.4

