Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD456145B
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfGGICn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:02:43 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38333 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGICm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:02:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 826611B3D;
        Sun,  7 Jul 2019 04:02:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=myUabCjU6u4no0R68aK5cjFytSwi/RnzNINif7vBZ6c=; b=NORmeCpt
        S3en3YgLD37bR/oaxSPMNo1wRR7GMOGQkJtcBKGtay+ApvXD6zGoeBYHljJPpDOu
        j1Qm94AOkh4sjSUADWYFf84B7S4VyeDrqDc5pd3rJgKvQCVuOJ/iJUpOAwWqHT7F
        hWFjineOuj/43fosMjTE6bvlLK0w820AJkR6zMsSEBQqmoiwjPBscVKLiew9wOFl
        aK2Re5V9OE6879PnxbeyUPDewzs1x5N/xz/Abho/3I+SrenYcHfRLR619jG9rsZv
        X+Jh58EX1T975cAgm8tSeWFAirphFKqSIPQCgQ7MK6zzhWX3YDiHRVJd8ZmPvDgS
        YSHVIUqC/xwnjA==
X-ME-Sender: <xms:IachXQoWQiuo49HpKPUGn0495G0E04kSA5aBpgB0hoDHvqdqiGrHaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:IachXVLmkueq2O-2jfurF0uaEDlcQfwo-i2hH1nOy5nkABAwUnEc1Q>
    <xmx:IachXQv8L6J1cgvQ2ZZkjTfscYCR-ZC6lOynymrSIbk_-7dlT3Ialg>
    <xmx:IachXSDGf_FkN7ch1abn0oNVhmmw2jyYWW0vnyBsiYahk3z79K-rHA>
    <xmx:IachXf0Yzu_eYtoez2gEV0ySHNlArYY3nEOb6RfJwKFJge6cvGi2bg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D78C88005A;
        Sun,  7 Jul 2019 04:02:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 4/7] devlink: Add devlink trap monitor support
Date:   Sun,  7 Jul 2019 11:01:57 +0300
Message-Id: <20190707080200.3699-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080200.3699-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080200.3699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

According to the reporting state of individual traps, a notification is
sent to user space about each trapped packet. Allow the user to monitor
such events by having iproute2 subscribe to the
'DEVLINK_GENL_MCGRP_TRAP_NAME' group. An error is not returned in case
subscription failed in order not to cause regression with old kernels
and new iproute2.

When '-v' is specified trap metadata (e.g., input port) is also shown.
Example:

# devlink -jvp mon trap-report
[trap-report,report]
"netdevsim/netdevsim10": {
    "name": "blackhole_route",
    "type": "drop",
    "group": "l3_drops",
    "length": 146,
    "timestamp": "Tue May 28 13:03:09 2019 801360651 nsec",
    "input_port": {
        "netdevsim/netdevsim10/0": {
            "type": "eth",
            "netdev": "eth0"
        }
    }
}

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 79 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ad62b6162f0b..b9fce850ee00 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3849,6 +3849,7 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_GROUP_SET: return "set";
 	case DEVLINK_CMD_TRAP_GROUP_NEW: return "new";
 	case DEVLINK_CMD_TRAP_GROUP_DEL: return "del";
+	case DEVLINK_CMD_TRAP_REPORT: return "report";
 	default: return "<unknown cmd>";
 	}
 }
@@ -3887,6 +3888,8 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_GROUP_NEW:
 	case DEVLINK_CMD_TRAP_GROUP_DEL:
 		return "trap-group";
+	case DEVLINK_CMD_TRAP_REPORT:
+		return "trap-report";
 	default: return "<unknown obj>";
 	}
 }
@@ -3914,6 +3917,7 @@ static bool cmd_filter_check(struct dl *dl, uint8_t cmd)
 static void pr_out_region(struct dl *dl, struct nlattr **tb);
 static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
 static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array);
+static void pr_out_trap_report(struct dl *dl, struct nlattr **tb);
 
 static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -3998,6 +4002,18 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap_group(dl, tb, false);
 		break;
+	case DEVLINK_CMD_TRAP_REPORT:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_TYPE] ||
+		    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_PAYLOAD] ||
+		    !tb[DEVLINK_ATTR_TRAP_TIMESTAMP])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_trap_report(dl, tb);
+		break;
 	}
 	return MNL_CB_OK;
 }
@@ -4013,7 +4029,8 @@ static int cmd_mon_show(struct dl *dl)
 		    strcmp(cur_obj, "dev") != 0 &&
 		    strcmp(cur_obj, "port") != 0 &&
 		    strcmp(cur_obj, "trap") != 0 &&
-		    strcmp(cur_obj, "trap-group") != 0) {
+		    strcmp(cur_obj, "trap-group") != 0 &&
+		    strcmp(cur_obj, "trap-report") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -4021,6 +4038,10 @@ static int cmd_mon_show(struct dl *dl)
 	err = _mnlg_socket_group_add(dl->nlg, DEVLINK_GENL_MCGRP_CONFIG_NAME);
 	if (err)
 		return err;
+	/* Do not bail in order to be compatible with old kernels that do not
+	 * support this multicast group.
+	 */
+	mnlg_socket_group_add(dl->nlg, DEVLINK_GENL_MCGRP_TRAP_NAME);
 	err = _mnlg_socket_recv_run(dl->nlg, cmd_mon_show_cb, dl);
 	if (err)
 		return err;
@@ -4030,7 +4051,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | trap | trap-group }\n");
+	       "where  OBJECT-LIST := { dev | port | trap | trap-group | trap-report }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -6486,6 +6507,60 @@ static const char *trap_metadata_name(const struct nlattr *attr)
 		return "<unknown metadata type>";
 	}
 }
+
+static void pr_out_trap_report_timestamp(struct dl *dl,
+					 const struct nlattr *attr)
+{
+	struct timespec *ts;
+	struct tm *tm;
+	char buf[80];
+	char *tstr;
+
+	ts = mnl_attr_get_payload(attr);
+	tm = localtime(&ts->tv_sec);
+
+	tstr = asctime(tm);
+	tstr[strlen(tstr) - 1] = 0;
+	snprintf(buf, sizeof(buf), "%s %09ld nsec", tstr, ts->tv_nsec);
+
+	pr_out_str(dl, "timestamp", buf);
+}
+
+static void pr_out_trap_report_port(struct dl *dl, struct nlattr *attr,
+				    const char *name, struct nlattr **tb)
+{
+	int err;
+
+	if (!dl->verbose)
+		return;
+
+	err = mnl_attr_parse_nested(attr, attr_cb, tb);
+	if (err != MNL_CB_OK)
+		return;
+
+	pr_out_object_start(dl, name);
+	pr_out_port(dl, tb);
+	pr_out_object_end(dl);
+}
+
+static void pr_out_trap_report(struct dl *dl, struct nlattr **tb)
+{
+	uint8_t type = mnl_attr_get_u8(tb[DEVLINK_ATTR_TRAP_TYPE]);
+
+	__pr_out_handle_start(dl, tb, true, false);
+	pr_out_str(dl, "name", mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_NAME]));
+	pr_out_str(dl, "type", trap_type_name(type));
+	pr_out_str(dl, "group",
+		   mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
+	pr_out_uint(dl, "length",
+		    mnl_attr_get_payload_len(tb[DEVLINK_ATTR_TRAP_PAYLOAD]));
+	pr_out_trap_report_timestamp(dl, tb[DEVLINK_ATTR_TRAP_TIMESTAMP]);
+	if (tb[DEVLINK_ATTR_TRAP_IN_PORT])
+		pr_out_trap_report_port(dl, tb[DEVLINK_ATTR_TRAP_IN_PORT],
+					"input_port", tb);
+	pr_out_handle_end(dl);
+}
+
 static void pr_out_trap_metadata(struct dl *dl, struct nlattr *attr)
 {
 	struct nlattr *attr_metadata;
-- 
2.20.1

