Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B181EBA70
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgFBLcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:32:10 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:6161
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgFBLcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:32:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SechwI9iDIKmUXMdlAwGZ0Rh9xZqhw4MDeYAQYgSKkZsE+yrfQDKGMnMXEmTZEdwuxSs+Cd4nx9rCPhjZBrNqeCO6lPN6FzLHQYB0bjvX+wobN0aRB4LXzvs+KNSQISZd6ogpkOxroRmeH4nTA6YWbagEN8feokoHor7OOmfs0zlI1W2jBu8PD8MG5PHCsl6KmPSH44Eau7Yj+e+Kp6orQPCyxwywux97/R0u9mujGsPQzlkx5+UM5rq9J/PZ/sToCSWQOSNsUh1cFJorL2RKwxdaLYfDZh97SJisGoJdpreqY7DR6r5XBrXLGJOZnzdpssofQLK/dKjxji88v7Lkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSsjUEMecom8Fv0/H07+XLJG/S3QU3de7Iqvu+1xYDQ=;
 b=Kczytv7nHu1vFpRuMfQidWTEVOeleZ82tivusrrV/oD0AjpeztH35Hc2t1PY0rtGjAjddJFBtZiLQ8KzR1ZbznDRGJfF16yT5jYPAvcoyRgGwXRKsFeMSLZ85or80Bhbpeo89+zSH1FYnCbunTwe/5IOshXj7xEqM/cK3pgpQm11U5eUw7xVtWaVAu8JsSZvmUv1zLV+C2vlNiGrxtJY+pNNyrgd0y7ucaDv6AO2gMwomwfhoV2hqYye66rha7OcQ7InuADXgE3oZj7uUUBG1uLovORftyjN7GjTwGQo8eVid8yR1daAKoVxtwIfTzq+pXVsjleDfnqmjmGxr98p9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSsjUEMecom8Fv0/H07+XLJG/S3QU3de7Iqvu+1xYDQ=;
 b=i91/bKsWwl6bTQtYAUkKgRTvGuuLiVytebj0KlWiS3i6IFnkTaHOAHe5WCNmkaVKisWAH+a4WZqIR9PUha+TyfuHhffwSQZ+vpGZqWCq/4JJsUxfmFOuYYf53EzvGvNt6rNi/Q6ub/k12ZOGwQTTM7WuE+rDQPdRHXRNAuUy5mw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6628.eurprd05.prod.outlook.com (2603:10a6:20b:15b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 11:31:58 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:31:58 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next 5/8] devlink: Add a new devlink port lanes attribute and pass to netlink
Date:   Tue,  2 Jun 2020 14:31:16 +0300
Message-Id: <20200602113119.36665-6-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:31:56 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8610a9a2-7d83-4e12-40c7-08d806e88f56
X-MS-TrafficTypeDiagnostic: AM0PR05MB6628:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB66285B8A16239BD493C42E55D58B0@AM0PR05MB6628.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pj73bncKUM53NSVkuFTx5y5S+I72FB6clXMvS1Knb0tkeqOubJw+lMSvVgKeeBPGkzJDf5WR0A9t6GMkx/v5+Iig5xCqhnu+KqAb8Kto5EabUKRrW14mCe7XU4j5tIWJf6TVQN7ctbaNgghnFHpm22Xlhi+Nd0oNa3oKr6pA4N9Zc/qS8XC8NTg78nzfdSCFZZtnGVOdQBDN1K72OX+lOoml227QA1YTRT4MQ8UzL9POuDHsh/ScTMRISxB8c7RLJPhZM9lUF1VPdjSmDe9dhQLR7UgmXyS44ot/yRUzSSZDl2TC92MdBcM0JkZndzxW2t5uBoqvbGqM8pL4+U9KEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(186003)(16526019)(26005)(83380400001)(6506007)(86362001)(36756003)(2616005)(2906002)(52116002)(107886003)(6916009)(956004)(6486002)(8676002)(7416002)(66556008)(478600001)(6666004)(6512007)(66476007)(66946007)(5660300002)(316002)(4326008)(8936002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 79+eATXKMwaWLPsSIcOjcmtpescSj3W9ykFjDq8LnLIBHUZwaaHBIbz55MKsbDLOcDNtjFkW4GLUpmH5YvYOkuJK5nwyLUduiIlA5qbFgDCwcaDYVpxdSRqCWD+yM32s3FRSyFJPEzGfKA4+xk+ZeTCZbO33xnHGNuR+9MvUZH47tnTqTAxJKwwcaw/xWYDJbOuMIr5D0Yer1rwrTj1X+yY361VRDKRNy6mPPAzQMCuUuFY49448ySsKeAE4GwAyAZxrLo5CfQV5th/OT0q2a/P0/Mjj/708bvy1j72RDJxvNz0hdxkpQCLhX6Ok6tfQsRpyN4qEqd21Twz33VPbx660lEjAskiHvxTHSpSO/4hlzj4Qh6LoEFY/sZoBfV4abjvFmucW2a8LKFux9d5OyCppt45Kn9AtdxbtFLqFfqa36T4Ju+VlQ0zGtFoVzTCReaKowXQ8sexcN1y+ZQw6ZBJyaQ0vGtJrsof1QF3TfoI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8610a9a2-7d83-4e12-40c7-08d806e88f56
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:31:58.1538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gnsarl70KYJGMJTq65adRYQyfIiJiAst/aEfkXsGgST14oyfRFToxJ5+pjP2BEP2nF47C4W9dUyHfpz8+uTbRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new devlink port attribute that indicates the port's number of lanes.

Drivers are expected to set it via devlink_port_attrs_set(), before
registering the port.

The attribute is not passed to user space in case the number of lanes is
invalid (0).

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 1 +
 include/net/devlink.h                      | 1 +
 include/uapi/linux/devlink.h               | 2 ++
 net/core/devlink.c                         | 7 +++++++
 4 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f44cb1a537f3..6cde196f6b70 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2134,6 +2134,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 	int err;
 
 	attrs.split = split;
+	attrs.lanes = lanes;
 	attrs.flavour = flavour;
 	attrs.phys.port_number = port_number;
 	attrs.phys.split_subport_number = split_port_subnumber;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 96fe5c05f62f..ee088cead80a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -66,6 +66,7 @@ struct devlink_port_pci_vf_attrs {
 
 struct devlink_port_attrs {
 	u8 split:1;
+	u32 lanes;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
 	union {
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 08563e6a424d..806c6a437fa2 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -451,6 +451,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_POLICER_RATE,			/* u64 */
 	DEVLINK_ATTR_TRAP_POLICER_BURST,		/* u64 */
 
+	DEVLINK_ATTR_PORT_LANES,			/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6a783e712794..ce82629b7386 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -526,6 +526,10 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 
 	if (!devlink_port->attrs_set)
 		return 0;
+	if (attrs->lanes) {
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_LANES, attrs->lanes))
+			return -EMSGSIZE;
+	}
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
 	switch (devlink_port->attrs.flavour) {
@@ -7405,6 +7409,9 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
  *					   user, for example the front panel
  *			                   port number
  *			     @split: indicates if this is split port
+ *			     @lanes: maximum number of lanes the port supports.
+ *				     0 value is not passed to netlink and valid
+ *				     number is a power of 2.
  *			     @split_subport_number: if the port is split, this
  *			                            is the number of subport.
  *			     @switch_id: if the port is part of switch, this is
-- 
2.20.1

