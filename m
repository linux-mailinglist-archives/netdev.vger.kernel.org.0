Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCC4596D37
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239152AbiHQK7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbiHQK7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:59:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF851208E;
        Wed, 17 Aug 2022 03:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmeHfviEYynfY+tHC10iS46KJD8pI9oQ+g8p/xTYl6IpNEmoKIAtiFtpdUMRGMVTl4JeRbSNH3zgwjvU+6L939brj0vTQHpVXcZromVA36iO6nnWXmu8NZ5OWGLE6lQ6pHVKDSqNohFiXtyckFz51BSsL03lsqJ3pF1hg/sUapOe4Cww8O0Yvyzm56gA+McImhiAanQ76MYoImv11oz8Wn4JOiWuE5k4+/BPPXQyXtucbeDU3PbiYwGywy8to8FK9h5/it7Zrq//3sksJHjW9zSAcvHxRJ1/uibR+XvwOOSy6ND/da3Qr9az6du78qWySSDUFoAOTdBYX5B96+/dyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=337XOeJ39XQZKdtdp1sPqMWBIq1r1YTRGYNOwXnasfw=;
 b=deS4AIAlRrfdMAxOSWwbzFtpzEAW1B03GEMiXXqxXK9R3Syj6JbYOwSlKFL6ehLCW5D+U5hniDvIItEAXOHohbZJNTFYJJ436knVM+f67poblMJVBGrhj50dpRPSAe7gAxAzHGbN8tvWzs/wLM+l68WL+2niC34T4DS5UlYsv975RjmAbyWeeuH6I7Zs1LM0P88xw0BHuLEDbwqSJLvC72EyLz+WAoV6we2GokvktzLCBkIf9/frxDdpQBusoJRKIwEib/Df8BYhPlRwV40LgcTsfbgVBYuTI+/RaU8hfEQLwdMYZZzAKQ3rrhvrgy4M6vg339Y9L76UjvtDbSssSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=337XOeJ39XQZKdtdp1sPqMWBIq1r1YTRGYNOwXnasfw=;
 b=ntBwHM3pwJmJzS18JDjnJD5B8VD3IQwyaq67vgeR5BFNGUf3IWNChixyu1OmXuiJyJ+o9TtfH36oIzW/sqkYBneIAF0wzmbZxKp39Lff1Y+asmVRElIQD01UGWesDlUiLuPJKprwo33pkhlErqH4Qwu1hIIflsepzEnaQQ29GMiAnL6DpgeyjYDW0rHwcoseWU8YESdzos1CzwYvvLCWgk6e5hrZxxqK28INDQKvuOPrQhfO3dyWtzOKipcbcCHEqJs4WX/o47rHlFV1UIbrTE+Fzb45/YqI49zRCgwcag3ye28SlVJapQFBrN+SYOiFc+ZLtpQ3Iy3zU3tBHSf7uA==
Received: from BN9P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::20)
 by LV2PR12MB5919.namprd12.prod.outlook.com (2603:10b6:408:173::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 10:59:04 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::97) by BN9P222CA0015.outlook.office365.com
 (2603:10b6:408:10c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11 via Frontend
 Transport; Wed, 17 Aug 2022 10:59:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Wed, 17 Aug 2022 10:59:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 10:59:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 17 Aug
 2022 03:59:03 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Wed, 17 Aug
 2022 03:59:00 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <edumazet@google.com>, <mayflowerera@gmail.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next 1/1] net: macsec: Expose MACSEC_SALT_LEN definition to user space
Date:   Wed, 17 Aug 2022 13:58:15 +0300
Message-ID: <20220817105815.8712-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 642fa415-ea42-4723-5b62-08da803f8007
X-MS-TrafficTypeDiagnostic: LV2PR12MB5919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKHjmO9FoFZeLR/KZ0OgWW+HDye2I9mwvt85QSemJklczSy4fBIBaSelaxDVlqRxcdctQ6QTs7Ewv0kFby3liiDFbJ28foOGjNbaIe1KGQpTI122GZoIFbGCvAPdOBpxobCupoYRuhaijrPmfhZM5Ff3VCsEaYYiEUW/vZmV5gy4nlPPhqhm56B5phzo610GIjX+f5VdEVCp/VsNSaZNjO28LXOizkXVcDdf+oWt//pDG28DZnQyTJwFs1OkcPH53QMrmwIZhow1CF2zWvMx0kQ5UIGzWDm8s+Yuo9/DoDTrJQ64kWGzYP50a3nC9C6li4ZZgnfugP1emL7nrmCcaVCHj87asD4lzRB3QJVg3+bh5Ovux/RK5lapWMEKKIe8DGsxgPYxFI3//0NpipoWLce+rZN7Py/UhypaouezI7TjDehVWuZDoyMxjaJV1wHiAzznpfuqRWqQwU8EAXY1gcK9iNJRT1VKTJd6RGkIv+udbH5Ml56nXq0706C4Ytq4aFravIWyo+fClKC96Jvvsc4Ek4M6r1mrPc4t9qowtXeUlMgaQbEiTcC+gCq5qPACvvG79ZYHpPrrsTQmJaeUkF90Z92QuCxJTgEuHyPU8wVT5gASggEc0aMgRTm/mrbQRRCBC3GbRyWQe179+Rw8Jg3VDS+/UKNvdRmXhqaSAKVUgIwizWUN2EPWojlJqsfeBNjHZsgf12FcLje6CqIyxTGex6+13eeCiZBlm8HTpYtC0IZEBghop2v20cJviJvIdjHl0n41/JEZg2UG7ijiIW4bakXaJRBRX1jTIwun/RzkK6FH9NPCLW2pI8EhZ8B4qTpdEChBw2kgrhtr181Lxw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966006)(40470700004)(36840700001)(70586007)(2616005)(70206006)(26005)(4326008)(316002)(8676002)(83380400001)(36756003)(107886003)(336012)(426003)(47076005)(1076003)(186003)(81166007)(2906002)(356005)(82740400003)(5660300002)(40480700001)(8936002)(86362001)(478600001)(54906003)(6666004)(82310400005)(7696005)(110136005)(41300700001)(36860700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 10:59:04.3888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 642fa415-ea42-4723-5b62-08da803f8007
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5919
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose MACSEC_SALT_LEN definition to user space to be
used in various user space applications such as iproute.
Iprotue will use this as part of adding macsec extended
packet number support.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 include/net/macsec.h           | 1 -
 include/uapi/linux/if_macsec.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index d6fa6b97f6ef..73780aa73644 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -14,7 +14,6 @@
 #define MACSEC_DEFAULT_PN_LEN 4
 #define MACSEC_XPN_PN_LEN 8
 
-#define MACSEC_SALT_LEN 12
 #define MACSEC_NUM_AN 4 /* 2 bits for the association number */
 
 typedef u64 __bitwise sci_t;
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index 3af2aa069a36..d5b6d1f37353 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -22,6 +22,8 @@
 
 #define MACSEC_KEYID_LEN 16
 
+#define MACSEC_SALT_LEN 12
+
 /* cipher IDs as per IEEE802.1AE-2018 (Table 14-1) */
 #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
 #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
-- 
2.21.3

