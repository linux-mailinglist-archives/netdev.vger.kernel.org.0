Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5FB2AF724
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgKKRFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:05:06 -0500
Received: from mail-vi1eur05on2098.outbound.protection.outlook.com ([40.107.21.98]:52321
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726523AbgKKRFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 12:05:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CImt+fNEvScOEw3SMk0wZCKXAA10rVudttrz2NNxQUcSp6eA+TmazBXmebaPemKmuNSH0r5oT3x0JQt0RpYSg2tNThUJZxmrcQdrXU2QeW0NxYx/O3rKzzL06zcnQkHDuOq054sz+I6OzXmNdCkGW8gHuoJRBLp+xqngQO38zAq+hl4ZlVf8T267k5wS6NMiJpO+8Gagv22PJgad1DuHYfVA4FSRIBTuu/+roehJB0WI/buFFbZJ0mPwFIh8m49Uw7NPim7K+7LgwSdjrDFlfaTkclpNrE2wrZXbvJ1Pma4982lDVh6Ij12mvMNOav6c/xs4/ALMnzp1Gf9tQfs2/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ML1Jr4rpGhlSJnhscDV85+BFh0iJabHWLoHDPCVXwQ=;
 b=fmJ5i3M73UqopIAFHamW7FOMU1tz/A2Q6bTiX7bli/xQlpayOZfzeHrdpgcne5TiKOua0VNJNYPLv40qIZWT52EWoQ4K5r8v77quKPyjO71McjWz+DZ+e4n7zyFqV5a2pjL8B1QouzVvE3JLCs0FFEAOQbB7UMV697OJNTOXGk26PiJXR7zg8qVyjuZ1+uFuCS9t/GMnYDTjNc7C0dqCH4/CUum8I16vCnQb+nl6NzcBvA9223vQWTbaws1ajdhpHAmmcen6THKgOUN+wswkCkgFUJtkoRd0u/LqpRdpPh22XAouOcT31nAKD/MP2mgWF5Tz8EfIz32qr9KzYrhvDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ML1Jr4rpGhlSJnhscDV85+BFh0iJabHWLoHDPCVXwQ=;
 b=NyOEnRm9IklNiNk9p/RtKFbnLEt6AeY2k9Gkvn1yM/eNTPjnEG5JG9PM046nQsMGgkTrOt13I/2dw8xIcgMIA4cBRWltUiorfYfFfbzzefxdXkTP7Gi2hfBBBojKmrFsKZ9bgyWGx7xY5OsQjJySXKvEfDPUHqhUC+tBaisy7zQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM8PR05MB7524.eurprd05.prod.outlook.com (2603:10a6:20b:1d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 17:04:57 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 17:04:57 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com,
        pmenzel@molgen.mpg.de
Subject: [PATCH v4 1/6] igb: XDP xmit back fix error code
Date:   Wed, 11 Nov 2020 18:04:48 +0100
Message-Id: <20201111170453.32693-2-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201111170453.32693-1-sven.auhagen@voleatech.de>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::23) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (37.209.79.82) by FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Wed, 11 Nov 2020 17:04:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbc60987-e140-4da8-82c7-08d88663eaee
X-MS-TrafficTypeDiagnostic: AM8PR05MB7524:
X-Microsoft-Antispam-PRVS: <AM8PR05MB7524C70665E8B4E9A45BC8E0EFE80@AM8PR05MB7524.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2rHLhijPYHaHSmC3xLO1q9G5oNOuAFUJHsKsbvk98wPQ4sB1l0Upfi7FU/HbyRyrGu++uqAdpvmq4Atwp0e+DhHhJ9QaktcF8GnLaFAvRi57eFUOhWUFpFn4i6SmH69ifwBf25VT6rwTX5FYaJGMBwA8P5zEc+CHPBslmOeOiQ/ZstT1CSJbLGlwuMxDaORyoDr+/Tb1Tbb6nFqANLvJS5cROkudZJfDq6N5m0DUQmlzFSIcKu3P0ygw8io+JUzbrxZ0lN9nOZdGJy69dZc4mKwyH2mXQXCIw4AT6rswR7ciFMp6o/iI1/TTL5SdEbBmohou1xsTuXy9kMqwn8D7z+lujmyV9g0xMHw6fAN3REvv2u+chA4ylaPCqw7a3Fj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39830400003)(346002)(366004)(136003)(396003)(6506007)(5660300002)(69590400008)(66476007)(66556008)(1076003)(66946007)(86362001)(8676002)(8936002)(9686003)(7416002)(26005)(52116002)(316002)(956004)(4326008)(6666004)(2616005)(6512007)(16526019)(186003)(2906002)(6486002)(36756003)(478600001)(83380400001)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8nqMr3WHPUMtK/nx6UOr8MdMRe2DBwj4iDgK2OYmhHZI6oVv60WyThDiDOo8CUuPR0d6Y3yGqTtuU7/wbFgfuKKgL2XG0xkdTvtxQfY8ETAJA681sds82a483za20XYdPSEMjANL8PzR8/7k1wsMZbs5BbsLYn9SNs5gLz6JgqSrj4FJjaEC7aKjn64gqHc8rmOlH2ixvd2FfRysWIWYW6zXBKrpaBryGrjKhcvc1jW50JFulCirxwkD0d8PgSQrM8cdSWqTJmvB28LBPmOH+mV/tV+xLUEO3LyDr8N43X0OJyJIiFUkCRXVPWMkB8vb5mYs5AxHKVu0fvCXUUQndiCavfilof0JVTD8D74MoHezUXw8BJHPUqhZfJOxC0bFx8W6DwRd9jHJgyJ2iPkKisyKvfWaBPJWaF1L5r5vkKkDVUhIZEWx1FppvlhnHVpSO0SFgiFZH1/1g1vcJGdrqlqWIJ2c3bDn9QgIA6hAIxRXhY9btjshSK2KJNt5memLSZ+71BK5jyq98YUS1M02C5LyYBI88Mv/SFW5MyUfh9NBMMX9h5sgu6GqOHpCdM5Rf+n7XpE0xRhtMU1047hATCdBc+cjbIPD1vSyzWPmEzw3ygh/uzr3/90UCJiuBLAylh9hC4pU4Zf1hEqEe4uotA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc60987-e140-4da8-82c7-08d88663eaee
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 17:04:57.6768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGHWdg7dG5GIfZVTiwYunt7wGYGf2Gzf22vb+ew2aNpH0tzAjHzO6cuFsJ6ZH6YHA4x1Y0UYPEQvig7cTQgnDwbmPF7nTczLVYgQ53Ty6Y4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7524
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

The igb XDP xmit back function should only return
defined error codes.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5fc2c381da55..08cc6f59aa2e 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2910,7 +2910,7 @@ static int igb_xdp_xmit_back(struct igb_adapter *adapter, struct xdp_buff *xdp)
 	 */
 	tx_ring = adapter->xdp_prog ? igb_xdp_tx_queue_mapping(adapter) : NULL;
 	if (unlikely(!tx_ring))
-		return -ENXIO;
+		return IGB_XDP_CONSUMED;
 
 	nq = txring_txq(tx_ring);
 	__netif_tx_lock(nq, cpu);
-- 
2.20.1

