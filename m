Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7026267A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIIEvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:51:36 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:49412
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726555AbgIIEv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:51:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPDY+Nec/rUc62JcCnCYALyMDOOQ6moc1iuCznpdS5PPgXbVCg4OYxcCcG2zCqFNr2TKh2ynwT0CcXcgoYj8cvPxxDAioVdLvTyHoeNCYGUQlIwTdEvMEsB9/CDgXBHuWPy+Xlgo6Lq2abG93+6oIyviqM3KimJhjZFbpKZFphuP9woZMDz8W3vaDDxQb2QmmnYhb+755NQabPxc1QdsMEGk2u8/JeRHB9ROkKGpKN1pFJMpdVpa2OZ1prssnEVV7Qi/vxVBwkmeiEnDwfUeo3TZ/VqXxcqIvbw5AKJ51lH3eZYYUlk7VepjrFvY4NSD5KkztSJJoYNdqvN4vnHUGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZfo7fw2oXyFycIP8mBNtK3m0omfP7EdL7Y5sj4CvVw=;
 b=hdgz/slnvpbNWvOfpBF88QLrb0TGL0UQAl+unKzCCqE1g8zo5JJM/SVswCr9fkTjgxeuAKMN+FnjF7Z4UlGxEKJYy07ZrEJOxjNNkPZlTQq4Qvom3mKC+imYNUfZ7u/Gkv5ayx7KW2l9iGDNtrcbk5iQG3N3WX7krPM1Dq7+c6Otm7lssSr1vm1aDeadnY66omAJNVaN2wnXQau6u7SY0Zhq+yKq1G41QoYvCWx9S+wrGl0b9TFuVdqAGDVGf3dRJuPcVxBwQAo4tQUg+6V9oDqjjIlfbp1zNOjjLTX2yWLrrOtuBiyXrBkHxclKhc3M0SXlwXN2es9dYeLgWkIe7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZfo7fw2oXyFycIP8mBNtK3m0omfP7EdL7Y5sj4CvVw=;
 b=UrbOfNcQk8CojzJBATpZgCeNs0pwBg9ksYb9vYn4iPpGAJH+LpRooend8XOTXThgJoBgYXLEngsJPRJ60mImne7pAL3BLyZuhhSJ2dZMRB2SapHv4sbKrIL4gMKjNieBVTYNpz95gsQVeONHnMETdvXekeVO6HPpAf8B62wZVeI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB5907.eurprd05.prod.outlook.com (2603:10a6:208:12c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 9 Sep
 2020 04:51:15 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 04:51:15 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v3 6/6] devlink: Use controller while building phys_port_name
Date:   Wed,  9 Sep 2020 07:50:38 +0300
Message-Id: <20200909045038.63181-7-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909045038.63181-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200909045038.63181-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:805:f2::32) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN6PR04CA0091.namprd04.prod.outlook.com (2603:10b6:805:f2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 04:51:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb84b04f-db69-4464-794a-08d8547bfb95
X-MS-TrafficTypeDiagnostic: AM0PR05MB5907:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB59077D3DC97F598BEC654D41D1260@AM0PR05MB5907.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGfQqIH7b6j/YL8Jg/DxL8J6jlr7xnV1dIo53D+V9Zu89RrVSjbm9H8bBhcBm5pe9arpx4secwLR7g80Pq2tumSeFcaf4W2OO8CM0ROSxyTpWPDpW/Oid3jBuAYt+BfQ2xKIh587KRKKbJ7HD6tXOOj+QKh6DQ3m1WDv3MGSYhcIVhMy5kc3tQBhKBKy2pcUQCU4adjg50d8vPvTT4s1T71TCAkAz3eJ3p5DZCYXiN0TIjCdCTWitzF05gNiKZBdU0gU1chBQ3jhJzbCp8pxLD4QCuCTpyIB38Bv9XHtrdMzMHAL/gT1CCFNd9ARmEtlSVtn5DDAWOwBTDv9c01K7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(1076003)(86362001)(16526019)(54906003)(52116002)(4326008)(2906002)(26005)(6506007)(186003)(2616005)(316002)(508600001)(956004)(6486002)(8676002)(66946007)(8936002)(66556008)(66476007)(6666004)(6512007)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DDQT+/76iVfnsdk9ZdZ2OfXPnvItQWSsqgCx5MrrP4O0uhuLDbPckGzvY2khO7f12KrfvGxTa3oCuT4GXnfCcWe4bE3cZ6OovBQRQ+lfE81uJXQR6wjpWTb8pwj1k9//YBbTJQznqvHYnhCLGSlTDONSX3ixz/MGah04QHkFuIRTkAMnb/8DOztV0YuJ5T9bvc90whxjhOgtPy5RgJ9B3sOP6I6IjmEPSLQaZojZFHUoEgGmoHdPg12ApLzdluf0aqoqf+09xEEHJqgO0KnSfxSXPh+4ESFCLGVd1ab1/0vLETdoYHPbTnkvpM69p1bQXEgE4GpcblxgLUOvoPTB4CCIiipsHwUH+fXi5XSp+SHpmKrZ1s5tr6RIaiACCRZKoE9D/Db19UhDISGJRJXucgZkFoF05ieJTTz3hZ+oGZP6M5LwM+13YfGbh4OTFYFBlFoeZYWjG0VrMDNpzkp4r9ng1gZ4xWdszamPYJ60SqW/ZqtrnHtXDNuQON8oPK8DzaqqX5ZwQ+gd5gNUqc3cdTAr2PpyRDE4lISoQrhji/dNug5OVZ3meS8hq/Yb9aeRQe37iajs38xDeV3JiMVBvnTI03YQ03lsIwxqnhkDaCNHBFmxTaPkiqi4gG8ALorWvn+0DDfCgnpjcvam5FXuOA==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb84b04f-db69-4464-794a-08d8547bfb95
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:51:15.6170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5WPaysfDvqwtTQ1LBlyQX1Vi134Oj7jWYZEvmLG+PLEqT79p4acnOru0e/KxNOKG33WGgwI+7Ke2PFRx6ipjDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5907
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

