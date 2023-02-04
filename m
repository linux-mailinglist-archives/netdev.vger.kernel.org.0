Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5F568ABD0
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 19:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjBDSVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 13:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjBDSVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 13:21:41 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2121.outbound.protection.outlook.com [40.107.102.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F55A3028F;
        Sat,  4 Feb 2023 10:21:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jz3gnUQgIA/Y6yl+5tvGP8RC9uIh7b2FP1O+ugYRfFfrYurXjId47NTXYt7ov6RpfiOQuLLNOBtJeWiIWFjMiuvCbXVWr8X+CUxSs+xi17Zdp7Ua7/RVP1+nqTCd3tHBDUHoMi75RAGmUGEORLWQvqIxC94rZZD2I1j58GF6Rma2p+JlKrHXW0HXQUAr64xYT5uk8Un4uP430YbQBAKnJjYV+FoROSuEgRx315op6NB/cIat4mSP+hrffhkVlfmVl617TIUNqtJgA3p4v1vPkMk9OtksJxqrnbl8lk9wcHmAfkIzkkDmvl3oadCS1iFUBUKYj4DpRjzFgnwu7Ic8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7g4CIy5giawJaV1qKsMe3aP0JronI23iBUrcNeMDKU=;
 b=bjQ9KwutypJ17g6kNXTrcLoPw4ZZWE+2K5y6dab3wdM9AHsV31JBlfqZW/aXMKhxs8+Wsdjfn3/cZ4lnBphRrMESWQcJf9Kp3+1z5mk6DIjsqO2NHLW4nS36sSOjaGfzfHtmT8T8x1qzRpPxX7/OxYC+H2F6fQaJUZEQ1n062Mjxl9pIneknbBIq/snvk5nPtJ/mRXny3PKRpM+9RttMZNgUw76yI+VHYsXYSGTp0934KQIqVfGdyjvOK1MDPOyFgumcDINHJJ+m/xqiNaxccKEzTxgKAPlDRgY6dFuxhOqPYi16D4HwSutfejgLF+twnM+/t1Cym1zmZquWT4f6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7g4CIy5giawJaV1qKsMe3aP0JronI23iBUrcNeMDKU=;
 b=xMnlrT7Sx8tdU3sWYtroiAubU+5Yb1l6byVXEJKGy4Mj+uQ6o/lstSuP5AL4l/pD1r7MB8Ae3vu0XIobxQomJq7REu1UOkwEp930Y4uIrhkAg/nSkzxUfAgQRJ/FM13gI4y/UhG5+UZ76tHiRQOOHBvLNktJEVJA32kcQ4imcTU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5032.namprd10.prod.outlook.com
 (2603:10b6:408:122::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.8; Sat, 4 Feb
 2023 18:21:37 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6064.019; Sat, 4 Feb 2023
 18:21:18 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next] net: mscc: ocelot: un-export unused regmap symbols
Date:   Sat,  4 Feb 2023 10:20:56 -0800
Message-Id: <20230204182056.25502-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:303:dc::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB5032:EE_
X-MS-Office365-Filtering-Correlation-Id: c7966573-4c0f-4109-96e8-08db06dc9ba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/Jp3O4ed5H/PfKRB+oPJQPBOHVqeASx2ysPM18dR4ykN6geuKySO70JIlrmpkLsEe5WoVvmEcDZjPUHT4QnEExfZehzqLZhn8Hsx604NorGFUeJ7KWjo10obV/Q/M7gkYFnH555uSiRwXvStY6VYq+biduK8cMO5qgqIb1FarcxlRKoPSd6MSl0ZWYG2+093VAy80QIhuWILOfaZ2fZbpIe/ivNKFmSu2uEjPEXK5XthuMpfQkBhN/8BS7P5HpGFboOIsbhFdepKWmRRQNzqZI/dnwlYzGdN0Fw5QEXs9XYr+/tgv6x4/K8GefUPC0qSm000dABx958tpb+BFryLb9uT0MMENRsnomrxFTWObYTx/utqCRPjiUMg8gUP7JXMM07rgjtDVlRLQckh9Qa+rcit1xg2WPKmOM0ybJJAbpU9dsi+zcDvGQP8Z44O2D8cl+dy5rqpQEgLn5KtTmX+8jPSiS2p8/yNJp5nTPLWYbavFxC22b5OKfmCaopkcixkFXZsw9P7HIomkkmt0U9tZBiyVTyY4gAgloJcqkmQg/tZYw7pLZpHo21/sFI0acQygA0+WJcADeyLU6NjipLt36xR5d9tUq/t6MrfO5AdYcpbzxlanbXwuWyDsAxPxdTFsl4Jcl67UmcrM1aKdz46XQJKw753SH8bvtHrn2hhoVReNzmyE783vpAn7n/sXUy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(396003)(136003)(39830400003)(376002)(451199018)(6666004)(2906002)(44832011)(36756003)(6486002)(7416002)(66556008)(6512007)(186003)(5660300002)(478600001)(1076003)(26005)(2616005)(52116002)(8936002)(86362001)(66476007)(41300700001)(66946007)(316002)(8676002)(83380400001)(38100700002)(4326008)(54906003)(6506007)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rZz9YBDWaOjjHThYRsMOH2L6PWNYVSa1wo9qLMLFns+SwOiJnpTjV8D+dwmT?=
 =?us-ascii?Q?L/17udwImM4grsuFvNB8jNBvPQhwh0lYcMPCBppvMMwWSDR34E6KpZYWDlrp?=
 =?us-ascii?Q?ZxzQigpUBEUOBGhiQ60EKviE/9J2uJk39LnwGgEPxeg14OgemqTR2MvfOf75?=
 =?us-ascii?Q?D6Z0BI8s1BLnnAKQTcdK5Y+Wbonx7/2e7osh7vqUiNIoYN/nbm4RDC/PDcp3?=
 =?us-ascii?Q?6bWeSZOgJf3M6u2qCsclkT2FMdDiQQFJj+XMw+11B80UcDnWQsOM2HsGd45o?=
 =?us-ascii?Q?3zeLBtCVKHKrGtarJilQGqir8GtqAtCiUZZwaKCf2otRJ/RLS/N3zlcXDArx?=
 =?us-ascii?Q?/qC0Z1ntWpU9/osnFCn2+vI6yTamI4HmxsInt1R4WO4ya75dXynNCMZ7ALUy?=
 =?us-ascii?Q?nOf3qg7CFp6lTtEMsllHGIiOCUbnv5OE2r6dgkL1lD9s2F54KtoeAqq+L5Zu?=
 =?us-ascii?Q?RMxF197kOB7vAzFEx59v+XRpuLHxCW8UWgU3S8yUdb3GFbS2IHuAr1oZux7O?=
 =?us-ascii?Q?vBfN6QB5KStCnDZhlIQuXVwAQLbxY+rt061ncQ52o3lOLQOkuIdXFp7LAAPI?=
 =?us-ascii?Q?3pykOj/X4L7ljDSIKuT8tJO0C51lPDY/zfK9YkqtfkZ9Kxc8xCgtMfUX7piX?=
 =?us-ascii?Q?WAm1Gpfki/xw5S2eplykLEPvCgOShRUcqxF/+Ak7fRSqiYpdTub9nQOEJ5y/?=
 =?us-ascii?Q?xkvDA2RkhpC61rW1sVR7xTZeUy8YtvyHByNIzEnsdy8oF+lb+ZsLZQjBHT8/?=
 =?us-ascii?Q?6GFjYA2Ppvpfp+osVw9ZMRvaXsn9OhRJ2lPXVkPKwgmmbb4hGjy+8WhknbHa?=
 =?us-ascii?Q?Z+ya4Nx16kYQDSHg4qdf80RXAK3QO5o8A7hFj7Wuem68gcEzI1Svr2w8+jNb?=
 =?us-ascii?Q?XMrc23UOyFytGvfrUCal2zp6C+fV6/Q3kGVl5Xg2H8apKjh6XtzOHzvbkn9k?=
 =?us-ascii?Q?FsGjjKp1KJGoI3DV3zkZgTiWouPzZxLuXseHQc0+NphkwtEGTA8qLy03p/r4?=
 =?us-ascii?Q?/97qbT13/AsKnoQRHU1yKsnpO0SGIjfu/BhB1dkTCgoGc4aiTojOcmRUS8aD?=
 =?us-ascii?Q?T5gW7eCSzw4kMz/3f6S8hKF3z1z5FKgxMTs2aEIVxzXMyigu45fe4uQFJdIs?=
 =?us-ascii?Q?pXR58ReeVHD3auIRfk/ybvuU3WgM1aRf1Z5CrI5BQ0bE8NG8ntoiCjlFU7mY?=
 =?us-ascii?Q?8VRo2vtjHOFsj93nhbZulk/idA9WWWqpQnL6uOYYr1E1QBg1hjWWs5emmJeb?=
 =?us-ascii?Q?FBVgt3MGv0aqt29SclOYxupCgnbo4IV1h7Kdr/QZ9si5vQGuWuI1uFnMyVS9?=
 =?us-ascii?Q?7u1KkN5jRxfCl7G+7AUXDAGFViDfUIDxrFfpK87iN77XMx95eHTiQoE/+aQ4?=
 =?us-ascii?Q?F00BX6po9+buXykAHZ1jUKnUAafMiBgoDz2kO3qK8CUxIvns/57/Pip8c0bj?=
 =?us-ascii?Q?N1lrXomseDy4GTMTNppGJEkJNjCYQYnxb6ouTRWiwHh5x2jrgGh7cI164c5Y?=
 =?us-ascii?Q?KoAoJ33vq9I1r69sRNnkqRgZ8kiMeJa08Kyba9Yv1lqb7onqhYKlk6+3YAIT?=
 =?us-ascii?Q?r2vAZrnUc8gqL77R8/rVTTjeapiLXY/20fVA6hJ8FVR9gFuHJCIf+e+PeeqG?=
 =?us-ascii?Q?s+YAD6TUckj7G5wXM0FlYNw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7966573-4c0f-4109-96e8-08db06dc9ba5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 18:21:18.2730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LzdfLbhfA9GXCXVaKeErz5ihYkganqbMDSSW7mzdhJ1vgS5gZ4mozGfVTgBrV55hIW9Yew/bopsIvPMvbWzk5R7toGy5HJlLwOrAMOKWW7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5032
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no external users of the vsc7514_*_regmap[] symbols or
vsc7514_vcap_* functions. They were exported in commit 32ecd22ba60b ("net:
mscc: ocelot: split register definitions to a separate file") with the
intention of being used, but the actual structure used in commit
2efaca411c96 ("net: mscc: ocelot: expose vsc7514_regmap definition") ended
up being all that was needed.

Bury these unnecessary symbols.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v1 -> v2
    * Remove additional vsc7514_vcap_* symbols - update commit message
      accordingly

---
 drivers/net/ethernet/mscc/vsc7514_regs.c | 42 ++++++++----------------
 include/soc/mscc/vsc7514_regs.h          | 16 ---------
 2 files changed, 14 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index da0c0dcc8f81..ef6fd3f6be30 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -68,7 +68,7 @@ const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
 };
 EXPORT_SYMBOL(vsc7514_regfields);

-const u32 vsc7514_ana_regmap[] = {
+static const u32 vsc7514_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
 	REG(ANA_VLANMASK,				0x009004),
 	REG(ANA_PORT_B_DOMAIN,				0x009008),
@@ -148,9 +148,8 @@ const u32 vsc7514_ana_regmap[] = {
 	REG(ANA_POL_HYST,				0x008bec),
 	REG(ANA_POL_MISC_CFG,				0x008bf0),
 };
-EXPORT_SYMBOL(vsc7514_ana_regmap);

-const u32 vsc7514_qs_regmap[] = {
+static const u32 vsc7514_qs_regmap[] = {
 	REG(QS_XTR_GRP_CFG,				0x000000),
 	REG(QS_XTR_RD,					0x000008),
 	REG(QS_XTR_FRM_PRUNING,				0x000010),
@@ -164,9 +163,8 @@ const u32 vsc7514_qs_regmap[] = {
 	REG(QS_INJ_ERR,					0x000040),
 	REG(QS_INH_DBG,					0x000048),
 };
-EXPORT_SYMBOL(vsc7514_qs_regmap);

-const u32 vsc7514_qsys_regmap[] = {
+static const u32 vsc7514_qsys_regmap[] = {
 	REG(QSYS_PORT_MODE,				0x011200),
 	REG(QSYS_SWITCH_PORT_MODE,			0x011234),
 	REG(QSYS_STAT_CNT_CFG,				0x011264),
@@ -209,9 +207,8 @@ const u32 vsc7514_qsys_regmap[] = {
 	REG(QSYS_SE_STATE,				0x00004c),
 	REG(QSYS_HSCH_MISC_CFG,				0x011388),
 };
-EXPORT_SYMBOL(vsc7514_qsys_regmap);

-const u32 vsc7514_rew_regmap[] = {
+static const u32 vsc7514_rew_regmap[] = {
 	REG(REW_PORT_VLAN_CFG,				0x000000),
 	REG(REW_TAG_CFG,				0x000004),
 	REG(REW_PORT_CFG,				0x000008),
@@ -224,9 +221,8 @@ const u32 vsc7514_rew_regmap[] = {
 	REG(REW_STAT_CFG,				0x000890),
 	REG(REW_PPT,					0x000680),
 };
-EXPORT_SYMBOL(vsc7514_rew_regmap);

-const u32 vsc7514_sys_regmap[] = {
+static const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_RX_OCTETS,			0x000000),
 	REG(SYS_COUNT_RX_UNICAST,			0x000004),
 	REG(SYS_COUNT_RX_MULTICAST,			0x000008),
@@ -347,9 +343,8 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_PTP_NXT,				0x0006c0),
 	REG(SYS_PTP_CFG,				0x0006c4),
 };
-EXPORT_SYMBOL(vsc7514_sys_regmap);

-const u32 vsc7514_vcap_regmap[] = {
+static const u32 vsc7514_vcap_regmap[] = {
 	/* VCAP_CORE_CFG */
 	REG(VCAP_CORE_UPDATE_CTRL,			0x000000),
 	REG(VCAP_CORE_MV_CFG,				0x000004),
@@ -371,9 +366,8 @@ const u32 vsc7514_vcap_regmap[] = {
 	REG(VCAP_CONST_CORE_CNT,			0x0003b8),
 	REG(VCAP_CONST_IF_CNT,				0x0003bc),
 };
-EXPORT_SYMBOL(vsc7514_vcap_regmap);

-const u32 vsc7514_ptp_regmap[] = {
+static const u32 vsc7514_ptp_regmap[] = {
 	REG(PTP_PIN_CFG,				0x000000),
 	REG(PTP_PIN_TOD_SEC_MSB,			0x000004),
 	REG(PTP_PIN_TOD_SEC_LSB,			0x000008),
@@ -384,9 +378,8 @@ const u32 vsc7514_ptp_regmap[] = {
 	REG(PTP_CLK_CFG_ADJ_CFG,			0x0000a4),
 	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
 };
-EXPORT_SYMBOL(vsc7514_ptp_regmap);

-const u32 vsc7514_dev_gmii_regmap[] = {
+static const u32 vsc7514_dev_gmii_regmap[] = {
 	REG(DEV_CLOCK_CFG,				0x0),
 	REG(DEV_PORT_MISC,				0x4),
 	REG(DEV_EVENTS,					0x8),
@@ -427,7 +420,6 @@ const u32 vsc7514_dev_gmii_regmap[] = {
 	REG(DEV_PCS_FX100_CFG,				0x94),
 	REG(DEV_PCS_FX100_STATUS,			0x98),
 };
-EXPORT_SYMBOL(vsc7514_dev_gmii_regmap);

 const u32 *vsc7514_regmap[TARGET_MAX] = {
 	[ANA] = vsc7514_ana_regmap,
@@ -443,7 +435,7 @@ const u32 *vsc7514_regmap[TARGET_MAX] = {
 };
 EXPORT_SYMBOL(vsc7514_regmap);

-const struct vcap_field vsc7514_vcap_es0_keys[] = {
+static const struct vcap_field vsc7514_vcap_es0_keys[] = {
 	[VCAP_ES0_EGR_PORT]			= { 0,   4 },
 	[VCAP_ES0_IGR_PORT]			= { 4,   4 },
 	[VCAP_ES0_RSV]				= { 8,   2 },
@@ -453,9 +445,8 @@ const struct vcap_field vsc7514_vcap_es0_keys[] = {
 	[VCAP_ES0_DP]				= { 24,  1 },
 	[VCAP_ES0_PCP]				= { 25,  3 },
 };
-EXPORT_SYMBOL(vsc7514_vcap_es0_keys);

-const struct vcap_field vsc7514_vcap_es0_actions[]   = {
+static const struct vcap_field vsc7514_vcap_es0_actions[]   = {
 	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= { 0,   2 },
 	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= { 2,   1 },
 	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= { 3,   2 },
@@ -475,9 +466,8 @@ const struct vcap_field vsc7514_vcap_es0_actions[]   = {
 	[VCAP_ES0_ACT_RSV]			= { 49, 24 },
 	[VCAP_ES0_ACT_HIT_STICKY]		= { 73,  1 },
 };
-EXPORT_SYMBOL(vsc7514_vcap_es0_actions);

-const struct vcap_field vsc7514_vcap_is1_keys[] = {
+static const struct vcap_field vsc7514_vcap_is1_keys[] = {
 	[VCAP_IS1_HK_TYPE]			= { 0,    1 },
 	[VCAP_IS1_HK_LOOKUP]			= { 1,    2 },
 	[VCAP_IS1_HK_IGR_PORT_MASK]		= { 3,   12 },
@@ -527,9 +517,8 @@ const struct vcap_field vsc7514_vcap_is1_keys[] = {
 	[VCAP_IS1_HK_IP4_L4_RNG]		= { 148,  8 },
 	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]	= { 156, 32 },
 };
-EXPORT_SYMBOL(vsc7514_vcap_is1_keys);

-const struct vcap_field vsc7514_vcap_is1_actions[] = {
+static const struct vcap_field vsc7514_vcap_is1_actions[] = {
 	[VCAP_IS1_ACT_DSCP_ENA]			= { 0,   1 },
 	[VCAP_IS1_ACT_DSCP_VAL]			= { 1,   6 },
 	[VCAP_IS1_ACT_QOS_ENA]			= { 7,   1 },
@@ -552,9 +541,8 @@ const struct vcap_field vsc7514_vcap_is1_actions[] = {
 	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]	= { 74,  4 },
 	[VCAP_IS1_ACT_HIT_STICKY]		= { 78,  1 },
 };
-EXPORT_SYMBOL(vsc7514_vcap_is1_actions);

-const struct vcap_field vsc7514_vcap_is2_keys[] = {
+static const struct vcap_field vsc7514_vcap_is2_keys[] = {
 	/* Common: 46 bits */
 	[VCAP_IS2_TYPE]				= { 0,    4 },
 	[VCAP_IS2_HK_FIRST]			= { 4,    1 },
@@ -633,9 +621,8 @@ const struct vcap_field vsc7514_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_OAM_CCM_CNTS_EQ0]		= { 186,  1 },
 	[VCAP_IS2_HK_OAM_IS_Y1731]		= { 187,  1 },
 };
-EXPORT_SYMBOL(vsc7514_vcap_is2_keys);

-const struct vcap_field vsc7514_vcap_is2_actions[] = {
+static const struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_ME_ONCE]		= { 0,   1 },
 	[VCAP_IS2_ACT_CPU_COPY_ENA]		= { 1,   1 },
 	[VCAP_IS2_ACT_CPU_QU_NUM]		= { 2,   3 },
@@ -652,7 +639,6 @@ const struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_ACL_ID]			= { 43,  6 },
 	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32 },
 };
-EXPORT_SYMBOL(vsc7514_vcap_is2_actions);

 struct vcap_props vsc7514_vcap_props[] = {
 	[VCAP_ES0] = {
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index dfb91629c8bd..ffe343a9c04b 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -14,22 +14,6 @@ extern struct vcap_props vsc7514_vcap_props[];

 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];

-extern const u32 vsc7514_ana_regmap[];
-extern const u32 vsc7514_qs_regmap[];
-extern const u32 vsc7514_qsys_regmap[];
-extern const u32 vsc7514_rew_regmap[];
-extern const u32 vsc7514_sys_regmap[];
-extern const u32 vsc7514_vcap_regmap[];
-extern const u32 vsc7514_ptp_regmap[];
-extern const u32 vsc7514_dev_gmii_regmap[];
-
 extern const u32 *vsc7514_regmap[TARGET_MAX];

-extern const struct vcap_field vsc7514_vcap_es0_keys[];
-extern const struct vcap_field vsc7514_vcap_es0_actions[];
-extern const struct vcap_field vsc7514_vcap_is1_keys[];
-extern const struct vcap_field vsc7514_vcap_is1_actions[];
-extern const struct vcap_field vsc7514_vcap_is2_keys[];
-extern const struct vcap_field vsc7514_vcap_is2_actions[];
-
 #endif
--
2.25.1

