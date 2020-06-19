Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107802000CF
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbgFSDdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:35 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:57212
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730924AbgFSDde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuWBgxwojxARXmJISAXoTzFH0S1DaTMDyvbR2AgpqR0BjE4TV5JcCikV1EtXV2SmKAA4IBh5fkXRHy2Dt5hx3eHx8Zd0ONJCvO85KkfZOdhHnk5Uqg0B1EQtivbwpSlpgrjT2L0TMl8xl1vzhERTN1tmFojLzZkYgYWQ1WJkjwr0rYdK5ImiG0GlqONTUBH1GfUC/JT4UBbRu7mB1EUTAs34gZuzotWhGkL9iwea/xoR7VPqk3eWrBigUardazcJvJfq94rrGGrzo4aXk58ob49FKfRsUhVJJozHK6WDw8geWt+c3sJsAjlw+1MWFsSeeUovdsifsakxwMTvK58+Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U8VmZzfsTSpDZdwKaJrhfac/24y3K5Mq39qQUo/g7w=;
 b=lqrKVTxU/ogA4vhNhxBrMaKdYUpotPsC/+AKcmvg4ElgHUYqOchvs7WKDxLLJIyuyHRIDrrXyGNPZhAy59p2Hd4VV4u58OP7Ir6VqX8oBxOuU/G6cJla+TTlTOdtF8NmABLwOsgkAqvB4Bd/yGyOB4JXR0tszbX2vuR1CKkr6a7CBqlD27lbXbz7WgfuiThRTqZJwszcMHUjoEiyHqhEeOrcpspEGHXhnGabBZ8aBl3ql+t6dznS37O0jEK8wh6hG2cTCof/ZA37kTigazrVrqs5loWp7BYn742nGEJDql3b+GWY9qDJ4ySH08HvMtPFMNMjePqN/ieqRD5Htk+afQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U8VmZzfsTSpDZdwKaJrhfac/24y3K5Mq39qQUo/g7w=;
 b=atuRGE1qMBZLULsU/XgJdFZdnAUSXKZtccsOROk+ZLXkXwt2cTO5HOKEoI8FoykxyREiQK7e6KIY3L4wZNBxAo0PVmUVgY1OlLiqhxulbY0I0b6hDhCMdAub3efmXvh463baV7/SlhJd0QJRKslM1xbCesfK1bAxlLBchS976nY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:23 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:23 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 2/9] net/devlink: Support querying hardware address of port function
Date:   Fri, 19 Jun 2020 03:32:48 +0000
Message-Id: <20200619033255.163-3-parav@mellanox.com>
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
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:22 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1686761c-38c5-4dfb-e16d-08d8140184f7
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6804A4780646181EEF3490A9D1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dA61wloD5LrY2AO9zMQbvBX+fdQVP67Bosz1OccL4bUjIUFsKKHffaxOIb1djVMOIrbmlVTCfZm+EYmhrYMrTir164Rh/Drd5rtCHeTaioqLk9dphT9bwAfx9PfO9y5brLPes5sZ98i/MLXrgGHR1YaOa/UlSOF8odcP8s7Zv125SrwdOlHQa/CX0HiV1JTRLrpw9GAMt0MjmikV2QO4foKpsV88nFafsHNh+edj347uHQSGHlQDrjWVHD0U/YDOBdAGqtxOeuXBivlkAraU+WTaPWvglmXNW3YpblPgJpWVbhXjW/7PExy7+mIG/p48/mj0zVJjcb32VEvquSdhqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: atHAqIn6YpMVeKAbsOHdRT5WsglxJW/Rp5ooiinLo9MVotijQGzxTdo998NEwZdnP20HOnPnZG7j6DTS4AHJOaGGGawSF/HkUENqmZPzHN8RinIVFGvAdQgvKiOWm+4F4Lz4fJN4zt37pIVTte9R7N0tAUbrDMfU2faOoVKV82oPGaYA7THtl2Dfmolsy1ZHYEm3B9YjTkrtVDATpcKp149YfJUmV5Aer66qzUeEj9n6Cv+V52KpDlkCbNTzczNi+F3FcNWU8b64brvSFObSusPo2npx2Q2QmnvZERIXDoO7JjuHY4j9+jLd3VcdQB8GNS8FE+fJVMyqhreBHsCtQ1jbQp7llV/0VAOZWzd4WYm3WsI0mlhOHEgdNFyyeWhYjEqVEqBhZ3IDgRFnhHV+mPyi3931kFRmfWwt6LzqUQ+OhurzXGPx1mSLuVUiidf6aGgARFaPE1B31eBXUlP+kDHnOkmoX9vAqf9me1VhvT1z/sdMOYTQeLvMh8H/sYqo
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1686761c-38c5-4dfb-e16d-08d8140184f7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:23.2884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7IzOMTCa2+k0JL0V2d0TJ87xNTXTu3zy2bCi6YLzUNYpIJSND4i3PbPUJU1/l1Fnl9X9mJbWE/CpsSQZat6Usw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI PF and VF devlink port can manage the function represented by
a devlink port.

Enable users to query port function's hardware address.

Example of a PCI VF port which supports a port function:
$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
  function:
    hw_addr 00:11:22:33:44:66

$ devlink port show pci/0000:06:00.0/2 -jp
{
    "port": {
        "pci/0000:06:00.0/2": {
            "type": "eth",
            "netdev": "enp6s0pf0vf1",
            "flavour": "pcivf",
            "pfnum": 0,
            "vfnum": 1,
            "function": {
                "hw_addr": "00:11:22:33:44:66"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h        | 12 ++++++++++
 include/uapi/linux/devlink.h | 10 ++++++++
 net/core/devlink.c           | 45 ++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1df6dfec26c2..56fc9cdb189d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1107,6 +1107,18 @@ struct devlink_ops {
 	int (*trap_policer_counter_get)(struct devlink *devlink,
 					const struct devlink_trap_policer *policer,
 					u64 *p_drops);
+	/**
+	 * @port_function_hw_addr_get: Port function's hardware address get function.
+	 *
+	 * Should be used by device drivers to report the hardware address of a function managed
+	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
+	 * function handling for a particular port.
+	 *
+	 * Note: @extack can be NULL when port notifier queries the port function.
+	 */
+	int (*port_function_hw_addr_get)(struct devlink *devlink, struct devlink_port *port,
+					 u8 *hw_addr, int *hw_addr_len,
+					 struct netlink_ext_ack *extack);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 08563e6a424d..07d0af8f5923 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -451,6 +451,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_POLICER_RATE,			/* u64 */
 	DEVLINK_ATTR_TRAP_POLICER_BURST,		/* u64 */
 
+	DEVLINK_ATTR_PORT_FUNCTION,			/* nested */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
@@ -497,4 +499,12 @@ enum devlink_resource_unit {
 	DEVLINK_RESOURCE_UNIT_ENTRY,
 };
 
+enum devlink_port_function_attr {
+	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
+	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
+
+	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
+	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
+};
+
 #endif /* _UAPI_LINUX_DEVLINK_H_ */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 05197631d52a..b6848b607e9c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -563,6 +563,49 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	return 0;
 }
 
+static int
+devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
+				   struct netlink_ext_ack *extack)
+{
+	struct devlink *devlink = port->devlink;
+	const struct devlink_ops *ops;
+	struct nlattr *function_attr;
+	bool empty_nest = true;
+	int err = 0;
+
+	function_attr = nla_nest_start_noflag(msg, DEVLINK_ATTR_PORT_FUNCTION);
+	if (!function_attr)
+		return -EMSGSIZE;
+
+	ops = devlink->ops;
+	if (ops->port_function_hw_addr_get) {
+		int uninitialized_var(hw_addr_len);
+		u8 hw_addr[MAX_ADDR_LEN];
+
+		err = ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_len, extack);
+		if (err == -EOPNOTSUPP) {
+			/* Port function attributes are optional for a port. If port doesn't
+			 * support function attribute, returning -EOPNOTSUPP is not an error.
+			 */
+			err = 0;
+			goto out;
+		} else if (err) {
+			goto out;
+		}
+		err = nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw_addr);
+		if (err)
+			goto out;
+		empty_nest = false;
+	}
+
+out:
+	if (err || empty_nest)
+		nla_nest_cancel(msg, function_attr);
+	else
+		nla_nest_end(msg, function_attr);
+	return err;
+}
+
 static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 				struct devlink_port *devlink_port,
 				enum devlink_command cmd, u32 portid,
@@ -608,6 +651,8 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 	spin_unlock_bh(&devlink_port->type_lock);
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
+	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
+		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
 	return 0;
-- 
2.19.2

