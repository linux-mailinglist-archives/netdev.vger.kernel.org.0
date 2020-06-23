Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD2D204F76
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbgFWKpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:45:08 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:11647
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732135AbgFWKpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 06:45:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHxZ6g53Vo+PIxhlQP/Bc73b+8f1eYkwgCQZNHxxtkJA0XJ/5BxW2Q0l07CScdm46NkDo2+ftwbC0bsIHzVapHRoX5hRN1PpCxhvNV5m9fv6+ASL6qPq6XlD5u6wSlezNyudFTB48llWQpy6OaLdvoSh/jB7WF+s1Olu86A/xT8aNBIOvq417JYaH0z6TI20UDUrihnGdCwov4gHRcFoGln6IibFJNUsviQPLzbiZ49F8t+B8nODE+XIQQmiuGpkOMXLx56RxoVckmxg5hwUQpOpQPFAbcuh2B0zQyZlNOCXr9lOb1wRYYjAo1G6Z/vkJ2WXdos23xRd2N/7BlVGPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgiwAC6kK1jtqGLuNXKonr0d+5jgTrghZJR9ysXFknQ=;
 b=NFleV4MP7ZVkFhZ1fWIlz2d4N1HYrDznUpw7PwMhk+7CJtgpYECvnkG7q5Epf6EIvOA+ep3Pa2p+m7Cox07LC5CG2jf6BRYUiZ4tZA8l4sGbIt683yB6eEm7uUBh41aseaY84q7y7Izr72ohVKMEdbjoc3uneT9oJ3xfKizVU/vjcVlcPIWd543WmR3aeyKGQKlq0qtEs3SHKrNI6vUPn/SqkWAlOXq7m5g8HFVi3hE6eGN7yt13+jNnoxX6ncR3xr3a7HXQB4raBe57NOTYw6rguttcFuf5Jy7FJZZkNLOXx3Jl9UAcg7xUWESf0/Og+M6M7CATLe6UWOzBTACqUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgiwAC6kK1jtqGLuNXKonr0d+5jgTrghZJR9ysXFknQ=;
 b=qe5c3Vd+IFqirG3V1kCPHo+ghxklOcAYJfmAidNcCK4DnLQOKsPr7jFL/ED5ZtOPOEUxS2t/08dxfcsxdZPxsuGeB0pT2+RjpYRgQe6AsY6xEipyoUeOEe1F7aiQ7TNfI7Ubxsr+n+/zG7US0t7sLk+b/eBeBlMy9klP8j7ux8E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6034.eurprd05.prod.outlook.com (2603:10a6:208:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 10:44:57 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 10:44:57 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH iproute2-next 4/4] devlink: Support setting port function hardware address
Date:   Tue, 23 Jun 2020 10:44:25 +0000
Message-Id: <20200623104425.2324-5-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623104425.2324-1-parav@mellanox.com>
References: <20200623104425.2324-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0035.namprd02.prod.outlook.com
 (2603:10b6:803:2e::21) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0201CA0035.namprd02.prod.outlook.com (2603:10b6:803:2e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 10:44:56 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 518a8bce-d0ce-4890-1d16-08d817627884
X-MS-TrafficTypeDiagnostic: AM0PR05MB6034:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6034D8A8FE4FD2E4033B0410D1940@AM0PR05MB6034.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:160;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lokuDahy3xDf+VqykNm32i07NBHpkbzjmgHBSbq8otq8cHSk28GGa87bZ8Yc228FG2wmGxKloQFdkbS7soaLSUBMwp63qhNYLqqOH8lylu3qQz733tnGmWCOK+vTP4rmWOO6NNObSn8qITlPK6ZWMJEPygW4ll/TdJhLgSbf0wiEgOxJfLsTyz/UR6Ge0Uw61U8epeyXdzUT+NM4nurF+5R4SE20lBZaLT+XRiwvmizHNeY9iZlNnz6kd5sW0C/sIj8eaKyLpXrjvqReSicqLRKMh7cwmjbCjSP5ZDWT3pGBTUYWWCi0BcJpAxad5yK+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(5660300002)(66556008)(66946007)(66476007)(1076003)(478600001)(6666004)(316002)(16526019)(186003)(26005)(8676002)(52116002)(6506007)(107886003)(83380400001)(6512007)(86362001)(8936002)(4326008)(956004)(2616005)(6486002)(36756003)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IczTgUcZVSNyCQA63LbfRqOy2ChlP8LbwOedr5VW6Przq2gloUFjMXc3FjDBP8tOX/FTvJxN4geDxvP3MAsJTVvdi3fnxKll700Hti7QOKOhmfnQA5CVWzcDGjvlK4qEKGr3tfd6adFw8Rr/sbtgNasDFw7g8iDF/KvvTOtq+3MHQPhY1TCCOIPyO/ZtD+OQCDSQwO2mF7p047jK5T6G2AW/E2FI7qrA/D/81sqIRGLJ3Y9YPaiDQQJ9psdfussf73+M/f4/kX+Fh6J1Sap0GC0huQETGZp3c0EBRwtzd8SZYTMRuB5A3VRVuUMP6qxtCvytpvbvUoOD+5rrOLtuGTATNWU0myciYlY+Z/jkZ/0MpAEGcO+2yQvMv8Sv/1oG7levpYPtCPj0WNberFdDXJHtQFju2HDguBjwW05BhHjgTDge5dMDj+UQf9k4Y1ouLI3SiVcJRqOrrjmJ3t2xY52sPHLkeUEpKSNIJ3Lv7++/61mxzJf4qQu5FUndx0+j
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 518a8bce-d0ce-4890-1d16-08d817627884
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 10:44:57.0622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPAEWJ9LrgtdVmyTDsbKiY7hqjf20O7t1KfdkY5VD7r9z/PF9fmpbxUqArPmD4qXOOZVxZnk5110Q2khIp/sng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support setting devlink port function hardware address.

Example of a PCI VF port which supports a port function:
Set hardware address of the VF's port function.

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port function set pci/0000:06:00.0/2 hw_addr 00:11:22:33:44:55

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
  function:
    hw_addr 00:11:22:33:44:55

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 16fc834e..75182cac 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_TRAP_POLICER_RATE	BIT(35)
 #define DL_OPT_TRAP_POLICER_BURST	BIT(36)
 #define DL_OPT_HEALTH_REPORTER_AUTO_DUMP     BIT(37)
+#define DL_OPT_PORT_FUNCTION_HW_ADDR BIT(38)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -339,6 +340,8 @@ struct dl_opts {
 	uint32_t trap_policer_id;
 	uint64_t trap_policer_rate;
 	uint64_t trap_policer_burst;
+	char port_function_hw_addr[MAX_ADDR_LEN];
+	uint32_t port_function_hw_addr_len;
 };
 
 struct dl {
@@ -1302,6 +1305,17 @@ static int trap_action_get(const char *actionstr,
 	return 0;
 }
 
+static int hw_addr_parse(const char *addrstr, char *hw_addr, uint32_t *len)
+{
+	int alen;
+
+	alen = ll_addr_a2n(hw_addr, MAX_ADDR_LEN, addrstr);
+	if (alen < 0)
+		return -EINVAL;
+	*len = alen;
+	return 0;
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -1332,6 +1346,7 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_HEALTH_REPORTER_NAME, "Reporter's name is expected."},
 	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
 	{DL_OPT_TRAP_GROUP_NAME,      "Trap group's name is expected."},
+	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1698,6 +1713,20 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_TRAP_POLICER_BURST;
+		} else if (dl_argv_match(dl, "hw_addr") &&
+			   (o_all & DL_OPT_PORT_FUNCTION_HW_ADDR)) {
+			const char *addrstr;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &addrstr);
+			if (err)
+				return err;
+			err = hw_addr_parse(addrstr, opts->port_function_hw_addr,
+					    &opts->port_function_hw_addr_len);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FUNCTION_HW_ADDR;
+
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -1714,6 +1743,18 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 	return dl_args_finding_required_validate(o_required, o_found);
 }
 
+static void
+dl_function_attr_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
+{
+	struct nlattr *nest;
+
+	nest = mnl_attr_nest_start(nlh, DEVLINK_ATTR_PORT_FUNCTION);
+	mnl_attr_put(nlh, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,
+		     opts->port_function_hw_addr_len,
+		     opts->port_function_hw_addr);
+	mnl_attr_nest_end(nlh, nest);
+}
+
 static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 {
 	struct dl_opts *opts = &dl->opts;
@@ -1837,6 +1878,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_TRAP_POLICER_BURST)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_TRAP_POLICER_BURST,
 				 opts->trap_policer_burst);
+	if (opts->present & DL_OPT_PORT_FUNCTION_HW_ADDR)
+		dl_function_attr_put(nlh, opts);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -3221,6 +3264,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port set DEV/PORT_INDEX [ type { eth | ib | auto} ]\n");
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
+	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\n");
 }
 
 static const char *port_type_name(uint32_t type)
@@ -3438,6 +3482,38 @@ static int cmd_port_unsplit(struct dl *dl)
 	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
 }
 
+static void cmd_port_function_help(void)
+{
+	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\n");
+}
+
+static int cmd_port_function_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_SET, NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_PORT_FUNCTION_HW_ADDR, 0);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_port_function(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
+		cmd_port_function_help();
+		return 0;
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_port_function_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_port(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -3456,6 +3532,9 @@ static int cmd_port(struct dl *dl)
 	} else if (dl_argv_match(dl, "unsplit")) {
 		dl_arg_inc(dl);
 		return cmd_port_unsplit(dl);
+	} else if (dl_argv_match(dl, "function")) {
+		dl_arg_inc(dl);
+		return cmd_port_function(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
-- 
2.25.4

