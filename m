Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA3B26132D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbgIHPG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:06:29 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:62631
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729773AbgIHPEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:04:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3/54HbzFlpfHa57qy+20Z8yr+pCvScbwhOuf/o6MpIAnF0s7wxo7mySOcgHB0tSdQLCfBLOEQTnSbMQxMwv417sFG0pxw5+PNxZzTEnYE9vA0un7G4XfTPozKrzBnfu9RisA10QyU9wTLYS0oTnzCFxS/OWdPdW6E05njjXgOsQ7dZHG4XuN5nMULAW1lk/0P9t87NefvplbnbBkxciVjR6rYWsDHv4sC4VxEMH+1jJ0MJtvmqotaOHbLVj1lzowC0p9qLDKHMIXHych5ovd1/eTl7gc9G6YQx34xPkqGfBA3GFEg68zrOu9ti5VUXu4jY84sMhynR4pt96O/YQgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZfo7fw2oXyFycIP8mBNtK3m0omfP7EdL7Y5sj4CvVw=;
 b=EBTmjczQgUM1Zzv6PwYXRps7NWN+7uy63zOpg3f9UsMbEsYLFN9mGQg8UylbDRP2JdL5cRzQ9ghgv5VX6HEgrRKXDg3grNCYb7T5O//x6wEu9r2jpa3GMcII1tQi/qb8lNLsbSNYdSjQzCEMiJiEqeYIx+S/AWzN9r/u3fIrZE/5YA47zoxoeQJ6NgTVRxtiL6l0IGiBJCvd9TgQdEP1jnHgs+kaQ8FsRXYsMQX+ziEs82OYSR981rAnWGIT0bgQ9Se/NQUYWsUeIAsyaSL28F75fOvnprYTwuAhm04ic35VvSj0016GLVARKDHo8KmovEoCQ2iv9jiA6lnSFhk2Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZfo7fw2oXyFycIP8mBNtK3m0omfP7EdL7Y5sj4CvVw=;
 b=EYVDhTO8xQMMsBUT4eh3lt3y17SfrtEhCGTjaS+uMHYq6WhEUtgMB+LvahzXsMKdWZlSMoTVED95JllyxJuDbf/ox0xr4lRSWBZzSaPa364YDqP8ob5irH5ImvIWKgkEGcyp+iFQxaEpkil/UbMPBi+IysO3gGE6dGoRQ+BV0pw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM8PR05MB7331.eurprd05.prod.outlook.com (2603:10a6:20b:1dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 8 Sep
 2020 14:43:21 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 14:43:21 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 6/6] devlink: Use controller while building phys_port_name
Date:   Tue,  8 Sep 2020 17:42:41 +0300
Message-Id: <20200908144241.21673-7-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908144241.21673-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200908144241.21673-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:6e::25) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SA9PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:6e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 14:43:20 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a878b64c-6a09-4acd-7839-08d854058859
X-MS-TrafficTypeDiagnostic: AM8PR05MB7331:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM8PR05MB7331AD05D9A91791CF55EB61D1290@AM8PR05MB7331.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uMPcH+v9z38wMTZGc9NFTd8sSJTQeCcYJETMy6aoGiT/WVhfXMeu8oxkOx4EkxbbklL5oAdf4dQ6gyoB2Yxz/VjwM43c/zKj8/QMLYaX5MN0ofXv8TzfGb4YNyfS2q/UivTpsH9lknTllH/eGn5n9BEONNS9Qryq5Riokku5wBcnlxMxGhmcyOE+Fgu2003SiLfz8j/KyAR3GZeE/wJ5GWuKOP9qB/VqYn64qPyif7E4zbma0Ult/ENMdF2YxX+1yXEf6Rz/NbcH9vkbW0Im44iQM4g7TvteTGgFbJHOXrxZfae+6rgaEIbMK+msvGousehS37RqNh3vAOpclbmYZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(8676002)(5660300002)(66476007)(66946007)(66556008)(2906002)(36756003)(2616005)(956004)(54906003)(186003)(8936002)(86362001)(498600001)(16526019)(6506007)(26005)(6486002)(1076003)(52116002)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MVDh8PfTUGW7JQvyQEo1JDtiJYIEjExNnHVf2gm8r8ZTolAU96Chcv5DPfhl9/mOLV/GcQlk0BqcekeYr5hrn223mv3v5qg9wi5+cRhca6Ii9HTfKBn8TsYqouCT+AGI32zKTkTzfZO3b29cPc7/4eq5sIgB58CS9JUCUZMiPzRJ7VPEGc0DPyEvOzSewlk+fZjsV21O3/Tt1lI5a0AYpfUUV8cFIpmVHLxpoCO9VBk37Hscy5CPzkj2NGkNraw5mG42CTOjc09ihW9cNeF8hUKnY7wm3M0mEGb6NWbfobegB7fVRjoqzqMNR16/DVmeg7OZhF5T9MBmVkeOJIrkQ938qY1V8y3SP5pmcoQBAU7I8ih1qlRsrd+ctG1p/0pWQH4iA5IGHmKOgflmHeCr9E71EDLczj+h5307Psu6Yq1SiJ58oOaGsKt0IP2do2U4Hb3d35y3slWqMIj6mesXohY5qa/50hm12KP97Q/GzvPQT0H+XYfjJgdC/S+XeVsCslQVH+zqNHaINdyHHg8C3Afj0/38KtGg40ccmrUv6cHHd1DG977Op6Mb/dPOgMR09UtMyvSJPgfSfW2J+bmH1NOoqRLsP6pgBLmhHAE/eJRjaz5zBZso52s0lBE2Ca1L3zRJngWaU1gPac3fXN4a+A==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a878b64c-6a09-4acd-7839-08d854058859
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 14:43:21.7096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dCZvppl9ZG4LYNiK94pfjk+PQ/rOyh4tg3RNAAOo6+BxVhmFV6oDaAFmDRqZCDgnU+m50hizaJ+jUJQSK2seJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7331
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Now that controller number attribute is available, use it when
building phsy_port_name for external controller ports.

An example devlink port and representor netdev name consist of controller
annotation for external controller with controller number = 1,
for a VF 1 of PF 0:

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev ens2f0c1pf0vf1 flavour pcivf controller 1 pfnum 0 vfnum 1 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port show pci/0000:06:00.0/2 -jp
{
    "port": {
        "pci/0000:06:00.0/2": {
            "type": "eth",
            "netdev": "ens2f0c1pf0vf1",
            "flavour": "pcivf",
            "controller": 1,
            "pfnum": 0,
            "vfnum": 1,
            "external": true,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

Controller number annotation is skipped for non external controllers to
maintain backward compatibility.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
Changelog:
v1->v2:
 - New patch
---
 net/core/devlink.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9cf5b118253b..91c12612f2b7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7793,9 +7793,23 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		WARN_ON(1);
 		return -EINVAL;
 	case DEVLINK_PORT_FLAVOUR_PCI_PF:
+		if (attrs->pci_pf.external) {
+			n = snprintf(name, len, "c%u", attrs->pci_pf.controller);
+			if (n >= len)
+				return -EINVAL;
+			len -= n;
+			name += n;
+		}
 		n = snprintf(name, len, "pf%u", attrs->pci_pf.pf);
 		break;
 	case DEVLINK_PORT_FLAVOUR_PCI_VF:
+		if (attrs->pci_vf.external) {
+			n = snprintf(name, len, "c%u", attrs->pci_vf.controller);
+			if (n >= len)
+				return -EINVAL;
+			len -= n;
+			name += n;
+		}
 		n = snprintf(name, len, "pf%uvf%u",
 			     attrs->pci_vf.pf, attrs->pci_vf.vf);
 		break;
-- 
2.26.2

