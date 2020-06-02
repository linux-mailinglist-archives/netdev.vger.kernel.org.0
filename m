Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4DB1EBA6A
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgFBLbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:31:50 -0400
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:10724
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726728AbgFBLbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:31:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1RVr48Xd0D619GgB1t+WxcOHiiF0pdXu1ejT1Xha3HZVT+dGRdvQMTFdIKZidhWzil6blkIjRj2/xxxPLf+xF6ZkK5IIBauOWHiEqutIHTRQvBRODR+4M2TSTKkpzK6aVGhBTu2ht5opaEuM8UmCHhiaRuE2nq8AeOehlbBeSli2LN9Zcyf3orErWeRur2oldcg9e3OatyrLWx/6176T8YnRy/YKEgIsMnnakmlHZD61jlgOHInCPvqvdDaI7lX9Z7j+tIZCKhgVFDYMqBi5nJcZ5cnz4yELs3Gu64JSksvQFqqMY9IMUb3cxpWuwaI+TVT3EAo6QWJS4qDW5mG2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90kUULobvupA+b00To4xjFWqhQhveWUxiNAMFFWpGNk=;
 b=OXhiXY1pehpsxWwVUafGXx2AFv+cSMYGPRRCN7Seczd09Fcikb+Tmbw4U1OVA1nxrU/pRiSz79H4oS7tCdXK4oq27w+kSChaaqPjxLdHouPkkZMTkbWpQzDCz6st4SxxpLetSCLSPeu0o/npC4RxKFBdjWybrFhl552tUsPmBJ3Gnz1USRZeZ1zVFqbsmlSLsvnl6iLU1ZPuqWC1x8FaHWolMkMgQCHmH0niEcMpKUxrLfgj2gNS9llg/YR99sbfHQaXW54SBVBkoWwvPjtxFVm+iG9QD+l1llVppgt1gWJH0PTvsWq5fT9b3QMBMSeAlZD/dZ43CgQqJiSQ/RKkpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90kUULobvupA+b00To4xjFWqhQhveWUxiNAMFFWpGNk=;
 b=p+hVDIqvosV68ZML0bQP9yYNfPFdznnpMdCMmEPOt3M5Jma/JVCXfYljLo0rGziLCvPeka5HmV5LVYEjxZqlKU/WsJZjIsyAOVFlZwckJyf7YDQlPUpK2PbzCAnU+mTjW35mwhRknRN9CDYRWpd6fuK5g6+hZcbORmJ3Kbjewe0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4129.eurprd05.prod.outlook.com (2603:10a6:208:64::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 2 Jun
 2020 11:31:45 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:31:45 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next 1/8] devlink: Move set attribute of devlink_port_attrs to devlink_port
Date:   Tue,  2 Jun 2020 14:31:12 +0300
Message-Id: <20200602113119.36665-2-danieller@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:31:42 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 46bb1cba-ccf7-4b66-4f63-08d806e88785
X-MS-TrafficTypeDiagnostic: AM0PR05MB4129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB41292AE4425350C7849608DAD58B0@AM0PR05MB4129.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+yNT/ILBQB9HNNG65o6NgwcNDWGnSmBfky9uMbBimtRvnfidyZDbP8bUo5mdj32rYX02uZsaVqw0mDG7R5UdBYtiNXSjikxCjk2npELvpmUqfXOMqVox40/hEQcd7k8j+MmhRQg382+KJBffGf4WLqW7yuoVW7/5wpHuNmA0qiogMyii6wEvlP/cYQvonYmIDw0Dq1qBs1a8xYxl2WIiiv6o9jucHvYtTsRzLpjK0q6D6Xvy1h7FbYo8EFkshXz1bXrDWpcfIXAMEOOFbIP66kU4W4M6a62KNJDlvm+/XSqcqa7iDk6uz5R67ElDV3tkE5fK4Bg+wbU3rS7E14Kfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(4326008)(7416002)(6506007)(478600001)(6916009)(52116002)(6486002)(2906002)(36756003)(5660300002)(316002)(6666004)(1076003)(26005)(86362001)(83380400001)(66946007)(66556008)(66476007)(16526019)(186003)(107886003)(8936002)(6512007)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GOMqXTooT/XHaEWl5baGER7DJJKjPMKllPDrXF3vOVnwaZ5qY7kp4cy7/dF0faUNOdcVjBbhYgPA6YhMhTjuc/BHsAKtRRRpzfZeL+Br56PMOxmYeIAv3TivEK7sy05zgK/D9aPyyjXaFY4BPci9mS657B8wSnP4FUJUMuxmcuvMWrDrwkdRqOeM5v5BWElZxJ+2R4afayPdgbfAemKRXL5xSCQPZ8sWr62X9Z2I7L2KUXeeczzqb3UXcYYQgPiZ8zW6ZCk/MOJ/NeVnyqjlfearJEzc35zHqfwTDMRWlpkrXrqZ+dpxju8hHPSAMbyxiGSvlQTqj8EdGz/TPD5B3GynNsF0+OVE36qHscZpSZs9WysvgjUA27dd2V8bhiKVCpRqC/DTBraY3MUna9ZmoTGv31bHMLkp/7RPgpP7p+lkh/CkgH/ki0JMMbjlRnjlbHr+gA2kR2q4ZwOquME2NrDPKWxZgLsBg+URLEj6JXL9Ne0ApUvL+C23j6UZN0d2
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46bb1cba-ccf7-4b66-4f63-08d806e88785
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:31:45.0484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O6vxxkha4TICyfyN/aHps3sLdJlBQ+cLoDdQfReNIc8ScVP6STq/vzPocCvlA5u8HmrVN9nrVdb/p2wvjrlZkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct devlink_port_attrs holds the attributes of devlink_port.

The 'set' field is not devlink_port's attribute as opposed to most of the
others.

Move 'set' to be devlink_port's field called 'attrs_set'.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h | 4 ++--
 net/core/devlink.c    | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1df6dfec26c2..3e4efd51d5c5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -65,8 +65,7 @@ struct devlink_port_pci_vf_attrs {
 };
 
 struct devlink_port_attrs {
-	u8 set:1,
-	   split:1,
+	u8 split:1,
 	   switch_port:1;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
@@ -90,6 +89,7 @@ struct devlink_port {
 	enum devlink_port_type desired_type;
 	void *type_dev;
 	struct devlink_port_attrs attrs;
+	u8 attrs_set:1;
 	struct delayed_work type_warn_dw;
 };
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2cafbc808b09..e5e594d15d3e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -524,7 +524,7 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 
-	if (!attrs->set)
+	if (!devlink_port->attrs_set)
 		return 0;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
@@ -7385,7 +7385,7 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
 
 	if (WARN_ON(devlink_port->registered))
 		return -EEXIST;
-	attrs->set = true;
+	devlink_port->attrs_set = true;
 	attrs->flavour = flavour;
 	if (switch_id) {
 		attrs->switch_port = true;
@@ -7493,7 +7493,7 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int n = 0;
 
-	if (!attrs->set)
+	if (!devlink_port->attrs_set)
 		return -EOPNOTSUPP;
 
 	switch (attrs->flavour) {
-- 
2.20.1

