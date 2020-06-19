Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4532000D1
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgFSDdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:41 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:25892
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730924AbgFSDdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+l/W3ZjYYVwc7D2tdx6rRfoJT0igg0EAdltgn4v1+pkrehIp8g2Vg94i72koRGEpRMT8+2Ky1+1ajQKBtvGY+QXAZVtvklzEdaUGx7UDu+iasPi+JXYImNGdaqtRkaqR1QhpX0E3WCoyjEMjzz2IBiKWnbRNWPTJ+9ytSUmbafqsjl+TZwlyx81OZP8b5eq0JiCBwoyfZzt0TSIJINQv734oLsh5VsC0EaFbtERjyfz7VkTWOj4fzCUxsTVp6CjVtd3wqoY/NJ55I2Jeb6NbWYOJmTVhZaiV7geW6kukgcBQqHKS9AxoDXB8j4/m9gKm+K5278xTXFa3i74XYqLrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96eyhbksGJ6SGyuLtRHdY2YS43qPzEeyxY3S69N7olc=;
 b=YQT6QC350jFfMDs3UY1AVzlAN/PmvD4VtW2qdLAzIjrGfQ1gL3derBXFYFwPkqQLey8f/RwY6E11/M419NpKn/R6Dp4dQqF2Pcf36b5C/5OmwOdBukSDdkEr1llPDB0n52PoWz60DiNUBqhjuFLM3EkW68sbAqqOC+ev9GQvr4AnUJ/sNwN1KAe51mDk2uzgigark+K/qekLSTevB+3/CaoooJwLlihfe90arw3E4+Y6W2Fbh4WxlF/Fh2Ut9tV1m+suOi7N6JU9OojBZyuVTr6TlPaZSdbkexWX7zEhkt56EvMOaekOFeSfSkteiAyeVqJl27EwmpqKSoDT4w3/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96eyhbksGJ6SGyuLtRHdY2YS43qPzEeyxY3S69N7olc=;
 b=UmHihxAui9K869A9t3++XE0UTwmE2NMG7P1grdEdbizFBN2z3swepS0kwSskMezhZ7VheSTGskTFE6szDiZMwybuv2ciDtt6tP5sV52ReEueII53zJSgWCOrMhxJSEeYugok9YcOouPs4VKB2CqiJk1RkYpGKBWSoOvbFMKViWA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:25 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:24 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 3/9] net/devlink: Support setting hardware address of port function
Date:   Fri, 19 Jun 2020 03:32:49 +0000
Message-Id: <20200619033255.163-4-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200619033255.163-1-parav@mellanox.com>
References: <20200619033255.163-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0019.namprd04.prod.outlook.com
 (2603:10b6:803:21::29) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:23 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 67c54e3f-0cf2-4688-bb9a-08d8140185d9
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB680465B5347D649BF266EB11D1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:128;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bo7ImGUKErIjsaJm2G52UXCUou1sNGo9uAjG6EkxdpgOdlVdlFny5yaIvM6bzFBzEURhvZfDb9J5mTvbgO4uavObT0KQUsEBWw0/DW5VQGbcxIPKBmUFhEI3rS2C6K6KK+SJPxQx3dHrMeIeZaKFttj3rSaXC4GOjo1P8xpnUnwsIeg6uPj+z9uMBFjBHRmqAtM3e14BKdrf1Dv2x+NlTja0StqiAa94NtRo20ko1XTeU9aVIO+GkINtoVL/YBhdWLPmifT+ges6qHI4GCpHGKtBHnk5ZZa2dzhY07uQQz9TfFn7X5gGdQXuxVyqNQJ5SPYHZQrrXzXFtuQXYtZfLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(316002)(6506007)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WmvzZPKMSB5KArBpUEzp0Jp3kCTwMyk+J6JcU334gtuD3KN7d/AcEug8gIbb2oS6tHMjw1OIrGEPXhl5689NdRDaxwRHFWF3M50biRfxfu7EEH0jsL1ylP/u0nsioocxiohwPntWXJzL/purLwa+5B5dhEjryOsSwAz2wN+VcNxTAHNrD4v4VhKLVaqXsMnUcEBlEACv1X4lVADqf4S1D+aP+CaDvPb6vF0Mgb/ZidKv8nO8ChVBpeV9wNqp3KItR/0EDmMil0pOxq3zLsfurtyByqj9gBqcyfSe62YfNBnCk9Cr8hSr35/a5wCaCAs9ca1bTzSWsdXgQP/Xcx690Wm8WxgQnxK1CzXFAQe5i/BYQp/ykXHVSc6GT3lNRQv7LlKvMGnHIebfyjMJoi9L/YO6kVEbON6VjpXH6hFVwLp/uZt3vEos+umTPSSJSeZ8VY+Jjo3I0kDkwAfxjbNEUmkrQqJI9j+CCpVV/tccMLjtIjxlnA7KaEC6yjYGf7iv
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c54e3f-0cf2-4688-bb9a-08d8140185d9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:24.8115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQ5oOHAA40NQx3nGMeYXxxQiEF//55s/b/CgcdFqVTaMwALNFmRjrvqlCe1Cv3TttnJqgv14bpUtNWYpryTZwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI PF and VF devlink port can manage the function represented by a
devlink port.

Allow users to set port function's hardware address.

Example of a PCI VF port which supports a port function:
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
 include/net/devlink.h | 10 ++++++
 net/core/devlink.c    | 76 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 56fc9cdb189d..7007f93585a5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1119,6 +1119,16 @@ struct devlink_ops {
 	int (*port_function_hw_addr_get)(struct devlink *devlink, struct devlink_port *port,
 					 u8 *hw_addr, int *hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_hw_addr_set: Port function's hardware address set function.
+	 *
+	 * Should be used by device drivers to set the hardware address of a function managed
+	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
+	 * function handling for a particular port.
+	 */
+	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
+					 const u8 *hw_addr, int hw_addr_len,
+					 struct netlink_ext_ack *extack);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b6848b607e9c..baa45eca6b5a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -85,6 +85,10 @@ EXPORT_SYMBOL(devlink_dpipe_header_ipv6);
 EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwmsg);
 EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwerr);
 
+static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] = {
+	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] = { .type = NLA_BINARY },
+};
+
 static LIST_HEAD(devlink_list);
 
 /* devlink_mutex
@@ -827,6 +831,67 @@ static int devlink_port_type_set(struct devlink *devlink,
 	return -EOPNOTSUPP;
 }
 
+static int
+devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_port *port,
+				  const struct nlattr *attr, struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops;
+	const u8 *hw_addr;
+	int hw_addr_len;
+	int err;
+
+	hw_addr = nla_data(attr);
+	hw_addr_len = nla_len(attr);
+	if (hw_addr_len > MAX_ADDR_LEN) {
+		NL_SET_ERR_MSG_MOD(extack, "Port function hardware address too long");
+		return -EINVAL;
+	}
+	if (port->type == DEVLINK_PORT_TYPE_ETH) {
+		if (hw_addr_len != ETH_ALEN) {
+			NL_SET_ERR_MSG_MOD(extack, "Address must be 6 bytes for Ethernet device");
+			return -EINVAL;
+		}
+		if (!is_unicast_ether_addr(hw_addr)) {
+			NL_SET_ERR_MSG_MOD(extack, "Non-unicast hardware address unsupported");
+			return -EINVAL;
+		}
+	}
+
+	ops = devlink->ops;
+	if (!ops->port_function_hw_addr_set) {
+		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support function attributes");
+		return -EOPNOTSUPP;
+	}
+
+	err = ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len, extack);
+	if (err)
+		return err;
+
+	devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
+	return 0;
+}
+
+static int
+devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
+			  const struct nlattr *attr, struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, DEVLINK_PORT_FUNCTION_ATTR_MAX, attr,
+			       devlink_function_nl_policy, extack);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Fail to parse port function attributes");
+		return err;
+	}
+
+	attr = tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR];
+	if (attr)
+		err = devlink_port_function_hw_addr_set(devlink, port, attr, extack);
+
+	return err;
+}
+
 static int devlink_nl_cmd_port_set_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
@@ -842,6 +907,16 @@ static int devlink_nl_cmd_port_set_doit(struct sk_buff *skb,
 		if (err)
 			return err;
 	}
+
+	if (info->attrs[DEVLINK_ATTR_PORT_FUNCTION]) {
+		struct nlattr *attr = info->attrs[DEVLINK_ATTR_PORT_FUNCTION];
+		struct netlink_ext_ack *extack = info->extack;
+
+		err = devlink_port_function_set(devlink, devlink_port, attr, extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -6758,6 +6833,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_ID] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
-- 
2.19.2

