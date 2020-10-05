Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B142832C7
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 11:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgJEJJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 05:09:26 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:32832
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725885AbgJEJJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 05:09:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlE95H1arqLe4nT9YZtlJl2ZZex05Dbn87j7KVGbgyQWNgsC/HBc4rCwdO3cbSN2bOXdC/02i7ARc3RkvaPxzCRSKamr6eFL2nutvW7XoHjh83zHvw5u4Zx7FHeCKkSx5Or/2620OSwzf+hRw4MCiUp8FITf7C15n1ppZ7+BMBm+FRJjJ52BG91kxB3CxVX+jX8vtmKRDh+L4dsRuEzfUBezS0r/Bvp8D5CL4E9Ed+wVaDgJ5KjK7w7hIwwn7NkW/S1NdAH1fGDlth9nuDbkQ8oDcZsDkfbDqZwjr5cHFCuz/djWYMuvaASBa2IyNLfQPVwZTglWA3Whkg2Uv2VUDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ANCFyv6UILG4rAu0EnB39YshH8ic/yYYJgmYPI95Ms=;
 b=kgUs9UGnh6xuoiaYnWCaKnJJP/TKU7Ota+9iV95AfGce9ljbXH5ehKH7FC6KC4lZV0FT4NSd99PXlUaH8dPAT8W/qkeVVdYiUJ3zKmeg1AYoGZAc2jABCnvR/SaeWQXF3ZpYu/8Bk70+wtMPP3voo/hCj2kf/BEpfM3oTLbLjMCEXXoHK6WEnQHe6cecB3QiLS77qRNTAoV3R4s/DeI7GpY5nbVNk+capVgQ6xEDGod1BHLVLaVLq2nInHp7nq+EdWYyK7k367EAzuX5QEHwi8jw80Hcz/u13kpQiP2/uEQnQugfnR8svEgEsPxlVbVr5WodlxqGb/bY97fWfRmKIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ANCFyv6UILG4rAu0EnB39YshH8ic/yYYJgmYPI95Ms=;
 b=cNmuM7wPHrg/IA7OHez8IFb++8efdWgDP3KZuN+50/VGBCwgzzloAY1giPC7b4TFkF3bO5vryPi3vBiZq9qZuzmx86mPpHUn4UTp9n0WKO2BTfjEZodprAKIcq/VnKf/hqtm2FNLQs1AqmpzKS4yjKGRFfu2HWfQN/OMfFOif4A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39; Mon, 5 Oct
 2020 09:09:22 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 09:09:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net 0/2] Fix tail dropping watermarks for Ocelot switches
Date:   Mon,  5 Oct 2020 12:09:10 +0300
Message-Id: <20201005090912.424121-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR06CA0198.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR06CA0198.eurprd06.prod.outlook.com (2603:10a6:802:2c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Mon, 5 Oct 2020 09:09:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0fc8bcbd-35a3-44b6-7d6b-08d8690e58e2
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28614A1CD0B38A3E5581DB68E00C0@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hzHIpDqBOI8iiPLS7B+0y2d6hnYTCOcn3TQP9NFMv1kiucfs615wr9+olZks8nIn0QhUVTKE8wpYSS/1YSYbmAnVZokWL4Ucoxvptti5s8BAyy7Uxi0yS32ONsb/mTd8xZIGrmPKR3ETcGQVvXDfGGVQowc7EiYh+2gMzfrXCp55sXSsM+MAhbii4rT25o+eWKV2ncsgxmQwtkZadGJG/jin7S8Bh2qpZrNLKRyyAZSlphoLLCNIbY1ASneSCMx3WbfyNrhWf+xksRpltgULWoVgI0RPFWVWLrFqKPJjnAx8+NiDxneoXfbNCbcqLYSImonJ3dj2XVcsuWBF5y/jM2ZbCw9G68oMQsJ8EnuVAdyfD2l+lSTBAGc9y1GdFyxe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(52116002)(186003)(16526019)(1076003)(66556008)(66476007)(8676002)(2906002)(2616005)(956004)(478600001)(4744005)(83380400001)(86362001)(36756003)(69590400008)(4326008)(316002)(5660300002)(6512007)(6506007)(26005)(6666004)(6916009)(44832011)(8936002)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9MV21+Z0dIy8KMZbt093zkLAi+K5Cwt8znFX9RVUFs+fvl3OOKnWXi/gfvfLdKmIaZ5WqHtSazweC92//lwQk9+etgk9ORx6R8LneoRBCGDjZwqY9y6VtXdtpziCGFbJp6Od11Xe32lbxIGgJs85BWGGPuJtxatGPr+201ZpHvYKY4yyRJpfis3F69ECOYRTG1AllQ/sRaRGeQndznRrKNtEdE5/xAVu1rQUgMF/01NXOK4zjhwtdoDm58MVCiRIFRMXh+Du0tXMVfvhwTTSb2KXe7SKviWi9nBIQK5Wc4RfTA+jKKBME+C49LtTnTPjkTpVENzrUoUia+kiGe7ZC7Y4PFBigM/26wfxadIWKt77/L1DVSF4I6/H5PEcxsSUq+kc1bIrQtptlhlVPIp6kK0nnHbMr0NfuBJvavow+wEpB0cc5B9a4LPll0On+MSGNk/hHJpACEtXxDP1swd2bCr8E8UAx12ZNvI3lGrHdilRF2OQZNZoiaubpGhCi79EQ4apu+Oa3VaM45I4cBMsDIfz7MYWO6oZ54oig4hDL5wp/3TfgCZCjejN4sawr4qm+2DV1CwqQhRvx1AKj8jwuGUUabM71GnW6i7sGVd5GS08xm2/V5JZMtTjMMvUBBsXJ608Rn6LRoE+Ocrkj+i/0Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc8bcbd-35a3-44b6-7d6b-08d8690e58e2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 09:09:21.7240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcZv88Fo51RS9X99NzHvO6qgR0XDGagU8fZMMq5Q8OvGYwP5wqlSDmBDryQ5oGx0ODHmDhwWKfrCjU5cNvRcug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a missing division by 60, and a warning to prevent that
in the future.

Vladimir Oltean (2):
  net: mscc: ocelot: divide watermark value by 60 when writing to
    SYS_ATOP
  net: mscc: ocelot: warn when encoding an out-of-bounds watermark value

 drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  2 ++
 drivers/net/ethernet/mscc/ocelot.c         | 12 ++++++------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 ++
 4 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.25.1

