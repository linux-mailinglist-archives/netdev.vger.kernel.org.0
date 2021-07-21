Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C996D3D18A3
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhGUUZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:25:21 -0400
Received: from mail-sn1anam02on2096.outbound.protection.outlook.com ([40.107.96.96]:53294
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229553AbhGUUZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 16:25:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccdnwFQ9sN4HgMZ8HJkBbzohQScWYyMrgFqjaDIupPVwIJbKo2+ayh4XCj+UyoD0W1AuFWmuReye4yVpESGC9pZH50DTYQ5NpxjFJNAisNTuiDvjmVbSnUINq8sJHD4byfA4p5TUcJ56dUsozN+OEzBETplimukd1bzoUVVrwrNiFsIytJDm+MTrD9JyxJ0FOoimWkN9NfgnuosCjM4wmRy4UtySi52vIWtzDt4xBWnmRPJIrj5QRArRoDqJHnif8GHlbplgC+vtutiAXZZyRI5M7PqMXOl5pIqO0SQj+yXOd4cjGPEzl1owny/Djvqd55V37+Wf1s5Cmm9JEFdJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W35GdinijwmZVnYTo+diF2CEeDFrcpUAibySQPZF14k=;
 b=CSlRsQdVgVoyNUwgYLStyCuBEPuc2RgFBn/DSC7cTJ/mHZ6Hv5rnubyn1QX7hZLxd2+cUvwHdU3fdSO42CaRoTFaP7Ez8aJPx25B6gEI82L3HWZiHnwzra+46K1vAO8uvQx8+zkujdW7wP8BSAzVZ6G2vV4wZ9R9SvFOgLdVLRRhYGtQjpRN2nOG7Xns/Kabs6TdzTLTCQZrHnM/IKugGEETnUmvqVxcFDH2/p+9T7ZnUh5qejSf9d0UHlM3eV/feFDYeN/SdD/ERPNZT6wBu5CV2xepRAIvNGIPn3TzxG+Oe0bYiqHK8YZRReI6bwvnpYTek7lK4seInAxsojS75w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W35GdinijwmZVnYTo+diF2CEeDFrcpUAibySQPZF14k=;
 b=TuVT3/XUzD8B7qhkuZJ3TjBwv68CPzk4SBDF3azMgSpgEbSBZSU5xnQxE5ecBu3gcy2TULGgAvcnUk1s7SgqsceerKEPB/WPsrU5B41/h4PPEo++EWG82vGpdPLnTwiTyzKZLQy59jSrjQzHLbXv/CdCHueKFVA/keeYlK7eb8M=
Authentication-Results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1454.namprd10.prod.outlook.com
 (2603:10b6:300:23::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Wed, 21 Jul
 2021 21:05:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 21:05:52 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 net-next 1/1] net: ethernet: ti: cpsw: allow MTU > 1500 when overridden by module parameter
Date:   Wed, 21 Jul 2021 14:05:38 -0700
Message-Id: <20210721210538.22394-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR14CA0046.namprd14.prod.outlook.com
 (2603:10b6:300:12b::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MSI.localdomain (96.93.101.165) by MWHPR14CA0046.namprd14.prod.outlook.com (2603:10b6:300:12b::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Wed, 21 Jul 2021 21:05:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3664e91e-2c83-4f49-dc80-08d94c8b529d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1454:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1454BE706A2686C017FABC5CA4E39@MWHPR10MB1454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M37NpeaKPTwFaTl7N6d6oOym3KlXIpvDZkvrYydJPeolWPDdVuLU3xZjVyXEuoJCCnILpHVCnB1pKDoY8KEgiEoa9s3YRJ0xagOBkOz1uNaOhp3MLan5WBZP8zeH8diTNDGhYwzZcSpOsBlCCk3m2T4IFWlsthdE4HX8cOdQh0NKyJrEbMjiqUUUQXQ+hU68VgMQxoENOxYml2TvFC0n6KbFToNyNNk6GbO//u3tYqhW6HvyhIeLW1cqHk68ED2pr5mqdMACm9QYv7ulwIxdDxyrW7XQ62GlTA0uxK/Fg8q2wiJTc+nPMz4zoBK9RURQ8T8522zTS5qyU5dqEcT30Qq5rnSrdUb5WPsYvhSxbanSZrubHkpAqAuTWRDkgJUgfkMCsJrgtXcwWFYN6+k+raMMFqGdSH2In7xWPj3YLV/A/skPxq2oPVdu49roW89mqKMxcw/MMZPjQk2ojIGrYU0MCQiKdOdKnymqsIP9a8XO+zQaCHlmb/7pZ4ZJ6MSZr/pnGiCa2IADlT6lN6R+k6/gsHn27FhM9WfcwUlDT3Sdv3QL0bHcmSY2ytg/Uxu/z2yKVY3vGoRcqMZTswhJtWOcOq2d73hQaBTThuuWQhrnSzGdc6cvJuyVkZy1e5tio2I2QPMV+VgiNkPKeAvyElifasNCDWUaeCY7ST3+kBwW4Z4MrNrwChdQJ0KlRXg89anrG6Wvi7pncWmLaZML6V6D8+PeI2NpVYz3bebVPng=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(376002)(39830400003)(316002)(86362001)(6486002)(956004)(44832011)(66946007)(6506007)(508600001)(66556008)(186003)(26005)(2616005)(66476007)(83380400001)(52116002)(2906002)(6512007)(8936002)(6666004)(5660300002)(4326008)(38100700002)(110136005)(1076003)(38350700002)(8676002)(36756003)(221023002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DEw7lsEKewmpJzcUoY0p8r1FI4SELkKZEBerU1KN1jMW+74vQuMAgztOAMUm?=
 =?us-ascii?Q?h5XmvzzbV5mm7d539dduUjbxvhaPVTv4YUrUOZLn52ts/6JoNQi9X3r35luF?=
 =?us-ascii?Q?rd0fy0i33URWtnjNIh1c2nX1ut5xQ7jY8XmgOS1oZevoQMvJ0x7enC5xyf7M?=
 =?us-ascii?Q?E0Nmd6x+FrmKUWj+tETLXqh82ixkDkrdTLaZ3WUNacBZiaem1qdLXRwXwn3C?=
 =?us-ascii?Q?JOoMcjM9m2Mc8MKrF1LqQ13iFCEg+hisXCfTGHIzqPa/Dy2fGos/NUaQ+Cn9?=
 =?us-ascii?Q?QZQwn6jEJfJ87Mf8yj5IAVQp44kLiRaMtl58hMT+dIwBtVEuzqitqQHCPrK+?=
 =?us-ascii?Q?cEiVTrZ+hGuO97Chd/MDEKZCSpobw+IdhiF8flmKiXgCr9+IuGKwEVQxvqNB?=
 =?us-ascii?Q?IE5T4uBpSlUR78pc11DX3mrDFrBcOanRenYmyNpXzsCUHV3gIdEzvt+PxGBk?=
 =?us-ascii?Q?2nBaYpMapKZirxuNbTx6f/SOfAEAcnw6MzMqWmzvUajndZwxCarihpAPPkbF?=
 =?us-ascii?Q?iOvJj1K5whPFImjBFrgjd9j/p1ohxk3pQM4Nh+hmdjfvfGl3gs8TAONLeUv5?=
 =?us-ascii?Q?Iti2/CMEiC3fOWHook8NVVV8EceL+m+ofYsQb5t2ZIy8M0nAeIxtcFwHhM76?=
 =?us-ascii?Q?S+5YUSQgFIRBQeagX2UEqWNiVuIGlfMp8NlxfLScDNNALdCBhon0C9i7Kcc3?=
 =?us-ascii?Q?ZhKxgS84O6Mt0KL1BFceZLSww/SLermmi6677E35vYGr13eiNf4ezMuZH9QE?=
 =?us-ascii?Q?I01C1/C0y6G0tkqm8g83GJk1m2VV7x0d/72ezHOtMpCl55jKJL3IBLvrs58z?=
 =?us-ascii?Q?FOGOCa75BNF1XLV/aWUlcn/JgE8oUeyvSPab/gGDXm5CQZCf3giernEWZRjl?=
 =?us-ascii?Q?uc2QrqT9rB9aXzK0VoW0A/Td/0yzFU7n96qBYtzE9x6Vw1KJ47kybYXqT5XV?=
 =?us-ascii?Q?4YU36qXvh+mJ2h2LTwbVv6hB+3xNyTzHzn4J62153x+5yL4/S5s/+23hroqO?=
 =?us-ascii?Q?fSe3Yioc5FucsRlJrIAFO2zOGpfZvWG8FOSCk3IQoJD1oxwCx5s+J9NjHYGa?=
 =?us-ascii?Q?8yHYyk4JyfIAJ0bhVZkQCYGeebnP27z6cN33+vweTxt87WGMDotezQ4wLdBa?=
 =?us-ascii?Q?GU1EKrcGgOi8KM00kgAXFAiThvp1Zf9bCREt8I9AOuyQG4C+80XoIyILVUdl?=
 =?us-ascii?Q?j13iekCFDIn9gHpdPhf9FyWOzOl6fOCd/PG9YGwNNPKmUB4nPTmow5r3yXGJ?=
 =?us-ascii?Q?5TasilokcgvDFn3asqUbMD+Fxgu76uZyZNqqiBHNbWfsm9JEwRog8B7jwmjq?=
 =?us-ascii?Q?4CYAkhEMetNIkQz5D6tb3lVJ?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3664e91e-2c83-4f49-dc80-08d94c8b529d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 21:05:52.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yeY5HOKlqOm5WAteF4SmpAcPQAc+o9/Qmwmq3PYz/rCgS6PS6AHII9K8k04z6Ziyc1KkUiSzru8Dr4AHL4L0Yh/M2my0OeJQiMZYR79XPJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1454
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The module parameter rx_packet_max can be overridden at module load or
boot args. But it doesn't adjust the max_mtu for the device accordingly.

If a CPSW device is to be used in a DSA architecture, increasing the
MTU by small amounts to account for switch overhead becomes necessary.
This way, a boot arg of cpsw.rx_packet_max=1600 should allow the MTU
to be increased to values of 1520, which is necessary for DSA tagging
protocols like "ocelot" and "seville".

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/ti/cpsw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c0cd7de88316..d400163c4ef2 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1625,6 +1625,14 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_cpts;
 	}
 
+	/* adjust max_mtu to match module parameter rx_packet_max */
+	if (cpsw->rx_packet_max > CPSW_MAX_PACKET_SIZE) {
+		ndev->max_mtu = ETH_DATA_LEN + (cpsw->rx_packet_max -
+				CPSW_MAX_PACKET_SIZE);
+		dev_info(dev, "overriding default MTU to %d\n\n",
+			 ndev->max_mtu);
+	}
+
 	priv = netdev_priv(ndev);
 	priv->cpsw = cpsw;
 	priv->ndev = ndev;
-- 
2.25.1

