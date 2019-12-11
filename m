Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03B311B421
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388736AbfLKPqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:46:13 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43814 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732716AbfLKPqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:46:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Dec 2019 17:46:08 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xBBFk7xb022467;
        Wed, 11 Dec 2019 17:46:07 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, moshe@mellanox.com,
        jiri@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 3/3] devlink: Fix fmsg nesting in non JSON output
Date:   Wed, 11 Dec 2019 17:45:36 +0200
Message-Id: <20191211154536.5701-4-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191211154536.5701-1-tariqt@mellanox.com>
References: <20191211154536.5701-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When an object or an array opening follows a name (label), add a new
line and indentation before printing the label. When name (label) is
followed by a value, print both at the same line.

Prior to this patch nesting was not visible in a non JSON output:
JSON:
{
    "Common config": {
        "SQ": {
            "stride size": 64,
            "size": 1024
        },
        "CQ": {
            "stride size": 64,
            "size": 1024
        } },
    "SQs": [ {
            "channel ix": 0,
            "sqn": 10,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 6,
                "HW status": 0
            }
         },{
            "channel ix": 0,
            "sqn": 14,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 10,
                "HW status": 0
            }
         } ]
}

Before this patch:
Common Config: SQ: stride size: 64 size: 1024
CQ: stride size: 64 size: 1024
SQs:
  channel ix: 0 tc: 0 txq ix: 0 sqn: 10 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 6 HW status: 0
  channel ix: 1 tc: 0 txq ix: 1 sqn: 14 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 10 HW status: 0

With this patch:
Common config:
  SQ:
    stride size: 64 size: 1024
    CQ:
      stride size: 64 size: 1024
SQs:
  channel ix: 0 sqn: 10 HW state: 1 stopped: false cc: 0 pc: 0
  CQ:
    cqn: 6 HW status: 0
  channel ix: 1 sqn: 14 HW state: 1 stopped: false cc: 0 pc: 0
  CQ:
    cqn: 10 HW status: 0

Fixes: 7b8baf834d5e ("devlink: Add devlink health diagnose command")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 106 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 88 insertions(+), 18 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index f0181e41faa4..95f05a0b5223 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6463,12 +6463,23 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 	return MNL_CB_OK;
 }
 
+static void pr_out_fmsg_name(struct dl *dl, char **name)
+{
+	if (!*name)
+		return;
+
+	pr_out_name(dl, *name);
+	free(*name);
+	*name = NULL;
+}
+
 struct nest_entry {
 	int attr_type;
 	struct list_head list;
 };
 
 struct fmsg_cb_data {
+	char *name;
 	struct dl *dl;
 	uint8_t value_type;
 	struct list_head entry_list;
@@ -6498,6 +6509,56 @@ static int cmd_fmsg_nest_queue(struct fmsg_cb_data *fmsg_data,
 	return MNL_CB_OK;
 }
 
+static void pr_out_fmsg_group_start(struct dl *dl, char **name)
+{
+	__pr_out_newline();
+	pr_out_fmsg_name(dl, name);
+	__pr_out_newline();
+	__pr_out_indent_inc();
+}
+
+static void pr_out_fmsg_group_end(struct dl *dl)
+{
+	__pr_out_newline();
+	__pr_out_indent_dec();
+}
+
+static void pr_out_fmsg_start_object(struct dl *dl, char **name)
+{
+	if (dl->json_output) {
+		pr_out_fmsg_name(dl, name);
+		jsonw_start_object(dl->jw);
+	} else {
+		pr_out_fmsg_group_start(dl, name);
+	}
+}
+
+static void pr_out_fmsg_end_object(struct dl *dl)
+{
+	if (dl->json_output)
+		jsonw_end_object(dl->jw);
+	else
+		pr_out_fmsg_group_end(dl);
+}
+
+static void pr_out_fmsg_start_array(struct dl *dl, char **name)
+{
+	if (dl->json_output) {
+		pr_out_fmsg_name(dl, name);
+		jsonw_start_array(dl->jw);
+	} else {
+		pr_out_fmsg_group_start(dl, name);
+	}
+}
+
+static void pr_out_fmsg_end_array(struct dl *dl)
+{
+	if (dl->json_output)
+		jsonw_end_array(dl->jw);
+	else
+		pr_out_fmsg_group_end(dl);
+}
+
 static int cmd_fmsg_nest(struct fmsg_cb_data *fmsg_data, uint8_t nest_value,
 			 bool start)
 {
@@ -6512,26 +6573,17 @@ static int cmd_fmsg_nest(struct fmsg_cb_data *fmsg_data, uint8_t nest_value,
 	switch (value) {
 	case DEVLINK_ATTR_FMSG_OBJ_NEST_START:
 		if (start)
-			pr_out_entry_start(dl);
+			pr_out_fmsg_start_object(dl, &fmsg_data->name);
 		else
-			pr_out_entry_end(dl);
+			pr_out_fmsg_end_object(dl);
 		break;
 	case DEVLINK_ATTR_FMSG_PAIR_NEST_START:
 		break;
 	case DEVLINK_ATTR_FMSG_ARR_NEST_START:
-		if (dl->json_output) {
-			if (start)
-				jsonw_start_array(dl->jw);
-			else
-				jsonw_end_array(dl->jw);
-		} else {
-			if (start) {
-				__pr_out_newline();
-				__pr_out_indent_inc();
-			} else {
-				__pr_out_indent_dec();
-			}
-		}
+		if (start)
+			pr_out_fmsg_start_array(dl, &fmsg_data->name);
+		else
+			pr_out_fmsg_end_array(dl);
 		break;
 	default:
 		return -EINVAL;
@@ -6569,12 +6621,16 @@ static int cmd_fmsg_object_cb(const struct nlmsghdr *nlh, void *data)
 				return err;
 			break;
 		case DEVLINK_ATTR_FMSG_OBJ_NAME:
-			pr_out_name(dl, mnl_attr_get_str(nla_object));
+			free(fmsg_data->name);
+			fmsg_data->name = strdup(mnl_attr_get_str(nla_object));
+			if (!fmsg_data->name)
+				return -ENOMEM;
 			break;
 		case DEVLINK_ATTR_FMSG_OBJ_VALUE_TYPE:
 			fmsg_data->value_type = mnl_attr_get_u8(nla_object);
 			break;
 		case DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA:
+			pr_out_fmsg_name(dl, &fmsg_data->name);
 			err = fmsg_value_show(dl, fmsg_data->value_type,
 					      nla_object);
 			if (err != MNL_CB_OK)
@@ -6587,6 +6643,20 @@ static int cmd_fmsg_object_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+static void cmd_fmsg_init(struct dl *dl, struct fmsg_cb_data *data)
+{
+	/* FMSG is dynamic: opening of an object or array causes a
+	 * newline. JSON starts with an { or [, but plain text should
+	 * not start with a new line. Ensure this by setting
+	 * g_new_line_count to 1: avoiding newline before the first
+	 * print.
+	 */
+	g_new_line_count = 1;
+	data->name = NULL;
+	data->dl = dl;
+	INIT_LIST_HEAD(&data->entry_list);
+}
+
 static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
 {
 	struct fmsg_cb_data data;
@@ -6600,9 +6670,9 @@ static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
 	if (err)
 		return err;
 
-	data.dl = dl;
-	INIT_LIST_HEAD(&data.entry_list);
+	cmd_fmsg_init(dl, &data);
 	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_fmsg_object_cb, &data);
+	free(data.name);
 	return err;
 }
 
-- 
2.21.0

