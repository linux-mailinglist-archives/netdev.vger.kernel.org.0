Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5574502969
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353088AbiDOMMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353132AbiDOMMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:12:36 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2117.outbound.protection.outlook.com [40.107.255.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A435AA6C;
        Fri, 15 Apr 2022 05:10:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/k50dhZGtvdJKkEBxbdPPSymNndfuX02fnCv98+8LH5GBTRFXQeATYf8cqx5Z10C+7PtSBJTAQRyHVXxSjOgbITTjOBHYJ5Kr0QkSL/qJQcDu2XHvTbbKWjd00gqcNyKNz5mBWPwlwHuETqI/ogRA/JkMeCRonqnyUbX4Z3PkBfB9tas5Mj3rtpmHVxMhNAnJj/KxyMYZofReH/NGFWyKXKwmrjDNHLklxGeoqjukVQTVQpLh91zl5UeGtBlBiazNuqx57td1Nn0Y56fQuUjKYKJpxBYHX7Fq4j7ElU/EGV7DFnBJ26J1q4gwC6srH44XYHQSEyeQjAzjx2ogURQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZY5wDb1CkjUVVVFsZxpSgk/70VpFE31iXuqrFpcIDk=;
 b=IDoBPVmoVyY8Jk1jdpt78Uhz8Tz+/tu5KC5CIa6NyYRFBU+h6TETZXENQhc0AGfcLSvfoDQ9DhK4uQ+/o4pGuiPKu5jil1sC66KcMCulGN3+w1VRMfAolFDdpVN6SnsPg8ljDWBMJqbivdbZETDj5ygzrDj4P3+yDNhXjPMZUUx8YnZ14iRbZqI7Z6w7pUvGPCHzRZiRA1e3iv3W2Iuy8az+W4NVcWsDRR+c7+hyFSF0h2AuarUPzo3/qRwapOJ7Qv5EHwpGqTbuTm/pUz4Gy7IGqr8nKw5bxGPoxFvbRbIdzZnFv4gIhKsSmShMwBAdVVRDCG1gHJ4IjwqMOwwqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZY5wDb1CkjUVVVFsZxpSgk/70VpFE31iXuqrFpcIDk=;
 b=fq2dNk9IkELSLxJkBzD31AgFrN9GAWcs8fjhBNnAYgyI7mzk+quMV5K0D7nzZ/lYy+lSvbrX4hi8b6obXHVJTyeZyRbLhBru5COpKOWX/OYTgFjB2vW3y6Fhd6ph/H/bpEr4q6URcJW48FhE7RNicEtvO7vfqPZ3biWvLY4pDv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by SI2PR06MB4444.apcprd06.prod.outlook.com (2603:1096:4:15d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 12:10:03 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 12:10:03 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH v2] net: qlogic: qlcnic: simplify if-if to if-else
Date:   Fri, 15 Apr 2022 05:09:49 -0700
Message-Id: <20220415120949.86169-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0192.jpnprd01.prod.outlook.com (2603:1096:403::22)
 To TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6057960-55f2-4986-9525-08da1ed8df49
X-MS-TrafficTypeDiagnostic: SI2PR06MB4444:EE_
X-Microsoft-Antispam-PRVS: <SI2PR06MB444409FD49452B61C4D234B5A2EE9@SI2PR06MB4444.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I8Q8RRiX8jXQGVb6SHHlAu36qWmd7NhSrYLY/m91GBbUFjP/f7OFWRfN6jjoEYc8nTLl1AvlHATUiYNx6lU4XcFfgKr/uENmJDMHStlbZxHG5hdLqbsCUdT43obKDNfWtLxhyZCfdirrXFc6gndvji0TclGrOjXL1LUqZTJ6lohm9wy8paOV1jg7TRRqZLvJXjAd3t44/GueO7hCoH10OLID0+WaUbZRxf1boB45Frfre/5c+c07maQIrhMsnqbMvi/5swFVx+2lvEstCINn+p3WzWnBN0B172hxicQH8XbZ/moaH9eu3f9uBKSbZIxdvEgemVuewd3vWDl8hP+8E2EcAo5D54bW3txXall5IdjZVq0bGwHXs1u7+JDkdkS6Qg0TBqrDMG61/3y2ZewJ9aJBbj0u/V7FaqoT8bbLtL+8mXGKTunFp1vU9aSw1RrvphCFZUWd3H7SV4kuBtCsi26ywHtsad+lxxl7vQDhfACpJErSnipmehSOmz4rRCP5uzaDREj4dRIy5/k+TqVl6I2pdKB+8+3CT+cRGzpUZzlAFKpYzwLIjc5meGIr0q2Ifohb5j0QnxFud+xcOUWYfWiDv3Iox7gg/Gzu9miuhg4P1lvNE+OuOeE3DgBrdGAJzLH3g/jYbvRG85gkFjj4J3kQ1eeuhaI0vZhinpsdI3xAn5NpJI7kURBOymFXr9gCZo6DZHevMnacb/hZXMfhThc/OuIezdr3PEueDlqR0xLmNdE8SGgZbFjvdW221qJfDuEpJH8w240YxAmci0ANxgbR7MJoLAulxBGNvzXzwjQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(107886003)(6506007)(186003)(36756003)(83380400001)(1076003)(2906002)(2616005)(8936002)(6666004)(6512007)(52116002)(5660300002)(66476007)(26005)(66556008)(38350700002)(38100700002)(66946007)(4326008)(316002)(86362001)(110136005)(508600001)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?er6HrqUYb5OkrnzLuMSFqhJsiVQge3xO/h1Rkmkzxwv4aYnNzzAg+PqlZsKI?=
 =?us-ascii?Q?feZtP9jmC4GT4xifDd+L0AmhldfJCmRb/r35IBTsZUbgtyVcVeuXpLJb+CNo?=
 =?us-ascii?Q?k79uGSevA4RHag8lM7MTph/r3YHqNabdyaxNHOhJlq4grL3AEu8BB0muZTMX?=
 =?us-ascii?Q?D7++HouZDWsW9AEZgFj1VOi24cO53NrawV6eVQ99IaT2TzpFvyfHDReSPyOc?=
 =?us-ascii?Q?rxnFuy6zXFoq9XoQOsV6MVPQ+k0JKxAc0Ss3yFI5zBwH5yGz83ps28CPeFFe?=
 =?us-ascii?Q?orpLy7P9ABkCBMWn6cZPyl7Js+aaBmtLsr4NPWIA5fb9T40v5nuhVxltsdN5?=
 =?us-ascii?Q?Rhb0esLmDMfRPJLOkBSCk4VmL1/h1dNes4OQKdd3nnSuFnvnnHTeS1C3LWKj?=
 =?us-ascii?Q?XSPq5TkaVPvC8USN3tTGHy9bSEu7xHJ4+X8UatOP+Kiva2gjTKMwgto8lmsx?=
 =?us-ascii?Q?D4ryRaKPEDdqRWfdP2Tz7h+3GYjNsCQCP/xBByxXpShjFGCBmD9jAeEodckg?=
 =?us-ascii?Q?38hhoKqV+GgkEHew9T1xV3jNpNUUznzs5a4xm1lQIyqXxMyRUoR8fMLP3XIa?=
 =?us-ascii?Q?r91zq+EzZQf43WuDznyed/7aq42lcxudfTN5sAHYFUOSDSazDt5uXSA9SdIt?=
 =?us-ascii?Q?8zHzRwf5gTLpN8aIgMYfD1pLnxcA8pOqhlVBhZCmhz65eAK3EM1noGn17oWy?=
 =?us-ascii?Q?HpHb7hIR7kVNnpZj3M2qnW+bIRuBI8JtxSX3e9myeiLhqi8Xc6cJf4sPox89?=
 =?us-ascii?Q?OywziOz4TdEaxXFuBI696tVL3048EUH6rl026eWfp6t7bLzT+4JAOjzWb6KK?=
 =?us-ascii?Q?I2Klu2e6E4Nfht1nUUfQzXlwLftLX9+0hwesT3UYpiJdMQATZE7L8Sme+d6J?=
 =?us-ascii?Q?LlBEYxJMncxkMe91qIKSlnhd4VKruznnWWTU8V87qZsp9qd9W7TiJKrybCI/?=
 =?us-ascii?Q?QiY18ZXBZe4BsMQiWMqkdNvipO9URSXUS07lKJrFjdWhtCVdEk82M4fihGpX?=
 =?us-ascii?Q?F7uKIQF08mx2ZHgpFqUajYrdUpPzN+IxxBoDLBgRi7DaVE3diHL7dvKXfDAB?=
 =?us-ascii?Q?ljOHx/9HNHBvNtQ6FqSYN/KaCOB67y5yr5LWv3vCyjbxgbj5yvjAmD9Kv9qh?=
 =?us-ascii?Q?tplHb7AUi9T/jM8tFrZ53H26mOoqiPdba/qyQ+/GDGy0veaiJt8mGZzbDJZr?=
 =?us-ascii?Q?wiLpDxSQlgBMA9N21xKqXRNSSnMtl1EEwqsdb0LIHJOK+pkeNYSSiXmhTB6/?=
 =?us-ascii?Q?aRIxeqTezM1iuera6AUPVakn3WxJkC3i+Bj+Pp4iiY9eq4Zp4JQr1/AJvpxt?=
 =?us-ascii?Q?yIn1jefzstrIfaDq2uJdGfDmWPdkPhPQHEKvCAX1HGxPGhXrFNMqWLpkFHgZ?=
 =?us-ascii?Q?LjAC53PbfXnt8tJOqoEmMXdNwrUOrhuDC6rBJl4DSXGX/EJ6q/GI0MmUZ7rg?=
 =?us-ascii?Q?p1Qikd1xzw5ls0Lk8mVTpHbtlK253B3PwVi6/vEU2oVq/8K0hjmBVu4tBcEK?=
 =?us-ascii?Q?elfLbnSxc+PKo+v3dSOUTdobbryr/iifYsI49O/NkcEabO6ce+AnuzLZDDLS?=
 =?us-ascii?Q?ncH6EB1dQVRXL/1HucGX1j5iL/rY2/SI96SuaJoch7wknLGehHJiE5/MLRgZ?=
 =?us-ascii?Q?IUGKt1kU0/pmrWNLoqEHjHe1uJq/pBVIHEYc49KmmR0XB2fFKfVw2CgUN9c7?=
 =?us-ascii?Q?sFxCfB/R5XTXU0nyktkNByg9/gj5T7APNUcgyu0Erm9Z6K7TfFQ9Xg6DrVUi?=
 =?us-ascii?Q?j2D6HA2R4w=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6057960-55f2-4986-9525-08da1ed8df49
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 12:10:03.5820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ave+atBXLmUSEthf0XhQVEF5XBclHB5g/VXPC98CL3J5IyolTkQ7YMl9RYStWi9zlBZLB+dbQL7BnTJmx55Fig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4444
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace `if (!pause->autoneg)` with `else` for simplification
according to the kernel coding style:

"Do not unnecessarily use braces where a single statement will do."

...

"This does not apply if only one branch of a conditional statement is
a single statement; in the latter case use braces in both branches"

Please refer to:
https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html

Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
v2:edit commit message
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index bd0607680329..e3842eaf1532 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3752,7 +3752,7 @@ int qlcnic_83xx_set_pauseparam(struct qlcnic_adapter *adapter,
 	if (ahw->port_type == QLCNIC_GBE) {
 		if (pause->autoneg)
 			ahw->port_config |= QLC_83XX_ENABLE_AUTONEG;
-		if (!pause->autoneg)
+		else
 			ahw->port_config &= ~QLC_83XX_ENABLE_AUTONEG;
 	} else if ((ahw->port_type == QLCNIC_XGBE) && (pause->autoneg)) {
 		return -EOPNOTSUPP;
-- 
2.17.1

