Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C595678B8
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiGEUs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiGEUsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2094.outbound.protection.outlook.com [40.107.95.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE2413CC6;
        Tue,  5 Jul 2022 13:48:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCQoO5mol2NcfkkHGAEevzKtAo2afnR1HOKrvif7/Lb4v3f2i+JZpooUlgVoPGhx71Sekug48e0uV6tedm77SZzWMIFn0zyj+TI2feJm7cQvn4ia9zzLmNLqyTJ/Kh+5YQbTUQL0OKap8DVFsQ1MxFh696GyRQgP5VYMG5jj8pk7SMkDtQ3RxefJ7P5AeLFN+tZ4HNzaID5AD7VcmhTV963Ab39KFbRtwwp2NqVXDKcCzh8BG4z+5Qtj0+3s6dJD325tP6wDEMTyukOekMsgx8uJFov60NsYCdYSTQqg3AChvZayYZaaLfTPE66s/wWMRc1EyhdJKkfPUe2LkBpsTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdpu+ko3VfPuNkeVreHLdBfmtcqZDB3EUVhdCP9JkOI=;
 b=VYeFrR85gZNeUxo51+pjJKv+ZRckMpFVRSqSjC+mX7hYOif3G1j45Ae1d/Art9Mdpigugf/afJBMk/MwqMuKcldcUbM1cAUsZDp0Wh7ol870NaFmXAiCrkseLbrdKD0rlfeK51L9zjDZE8VUjCwwuBKZAWuWsUYkvl6tPaev/UTqGYLHBgKXjb5DHNscKPacFndoAp3r1YCPau/8QAy1XlG6gNPHHKQuWiZrd1wD0z2vbNOxStC/ybF6fLddKN3xzpMVyzfWZvy4TuuhNCYcGSNLabgur4MxLcnu66VJlNhdI8ntqd/iCAgT/skQ8nSbDBm4kR6eVAgWM4qRINlgnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdpu+ko3VfPuNkeVreHLdBfmtcqZDB3EUVhdCP9JkOI=;
 b=nXJF6XbmB8eiv564bU07R7OCPOXvuPCfz2F6DT4UC6P900ETMN3ECV6aai4MMu/Fjg7gMRXPd6InvtCOV/tD14Y9js/V9V0gsTR0K0ecWQVxFHQvj0663p0/cXyUy5vrdfiggWdxU/tDKECscDV7i6av3VZFVdwi4B3AX+IuDmE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1934.namprd10.prod.outlook.com
 (2603:10b6:300:113::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:14 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: [PATCH v13 net-next 7/9] resource: add define macro for register address resources
Date:   Tue,  5 Jul 2022 13:47:41 -0700
Message-Id: <20220705204743.3224692-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705204743.3224692-1-colin.foster@in-advantage.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:302:1::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2f33a5b-60e0-4eb2-ac48-08da5ec7ae7f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1934:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i/jVkTgXBkELhD9Ok/tjil7zdJi5lpUjSdN047pr7ssVXRjtqgo8BNeu/luufN8SJ1gyZU9zsGK8tEMDmxziJkctn+AamoH4BB2WyWKNfVKMKazHysGOHXiVaf3unN+MwznQoVHF4IwVSnqIFxGl2QT5alEBeK7c58m9erj44PH4siSr4o1CHZfrfUBJwnksz2p99aH7sskegBzwAtmKC64CXytFsrwXd6VDF/Me+4l8gIvMxYmjuz6K3amTdIeMMlLQqQPj8BuvsO1u3tJNZ0zrmA0PmNByDZ3GuVDG4Yfrl/taeornXZgF+Jn/vkMTyYqp68ia+XfwarUSaSp8w1+SAoV90wAw1wxckFWc7oa0Acj8fy4FnCJfMH8LAbDOrq+9Z3bRaYs6z6Dtk4xhAMcU9DfKPHGdBLTnyWwah0FOaqYSiAyfl+MrgEov36d0ZnbAzDMM8RvbesMQf8uG2GP+b2AaaLQVK6rHDmhMaVfyGsvyw0pBasplbDYRwvrtYSunh7eiJaVoTGUkPqOa7CcbBpRylwjGLuns6Cf9yRAHunrtimJod3mveWoVp1VUxnE9HOsghIMAh+8ph9nHUjukACXJWucZQzb7p/9UoQAUEQyPMGca9bZvOZm4K8th7mDEmfs0KmiPXpQw85biY7Wwnzqv91SswWDHVJjfVtohunwrY4Ft+7+tJ/unhlwfxSNkdybzaqbKwaiTmfD1Lxs53ay84B5H/7yzaQC3yFIWHNkWBnaGH75idJB437kZsbhxQ0WFlWvtkk5qmtyDr4td+u2vEkpd84NN0KNjA0jVs3AAT0vG/5ngL5CUsNFb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(136003)(39830400003)(366004)(7416002)(4744005)(44832011)(478600001)(5660300002)(8936002)(6486002)(52116002)(6506007)(86362001)(26005)(6512007)(41300700001)(2906002)(6666004)(38100700002)(38350700002)(2616005)(107886003)(186003)(1076003)(66946007)(66556008)(66476007)(54906003)(36756003)(316002)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0/kIXeZIkst3yjAm3SSU7OH2iPjxbira71iDHCknw4eWR1zwS9/h76XvD/2K?=
 =?us-ascii?Q?hSQMUvl2hIty90OTnRWww1O2nKBW0jvDYDhUaORacDn+i716Ssfmv6mG0yaV?=
 =?us-ascii?Q?Mor3tuZVuZJ4i2nf2avXEsTemsaVr5//yd1SUDrrFctQ2HDQPuVrjbp82UON?=
 =?us-ascii?Q?Otr51hHzYFqZHzPWfMtEzgvFAmztakGcfI0PMXvf38kKo0KpX7hldWhGqRSd?=
 =?us-ascii?Q?3CgymJzQZCSbVrSCq3cOkdTI3BiqEWCyP7ZaVo3NvYOuYaKKxsFPhyxyBcWk?=
 =?us-ascii?Q?I4vzBmfKKhkBPXnV8YHxb8sJA/wL3WjsMiQNZQo9kgit5hCSxtrn1OkvxeTE?=
 =?us-ascii?Q?CCqqr1vpKIMVicSUb45JzPpDdkYmy+Tp6z1M9uLoqPJivHpsL5Z5xYWIFCEQ?=
 =?us-ascii?Q?cHSlVlgC1dUJiLcgPoYhZ/Y7FsA/oobjWVbI3CTK9trhiUsw8ZX1jhunO7++?=
 =?us-ascii?Q?g8REIoxmu7C4jhIQZyuRxA+IoW5Ju5dmGEw9XC6zSgquvugRinPVyfEKLXfJ?=
 =?us-ascii?Q?egowDicm0f3BbImc9Z72lVAxVm0eDafsoMzZZp3yKBbex5jPyjadgNi7KpQh?=
 =?us-ascii?Q?nmkFfR3htzY8oXkvUItccRp7lBik8JS82+rsuG9L52WWQsfUIB4mTZKaolYk?=
 =?us-ascii?Q?XOIeTNCwumM8JAiqalc2XApbtyv2RRqbhvveGPuMVfQXtyBoXpVXvWfNjWfx?=
 =?us-ascii?Q?+tAoVQN81QZ/7czgcFsK02WhvruQr1XK0wfqhFbd7q9T4LWVd29e+mrH32I7?=
 =?us-ascii?Q?GQCO3nQZBQOj28ZpQzz9LSW5LDylXF8yQOb+u65KJYB3CupvoK5PsUpe7Uu8?=
 =?us-ascii?Q?wz/PYu0KvGpdVtkDglLqcM9SzzhRil0N7r7ZjPAbXG9Xg8cwg2vYxlpQz2Xd?=
 =?us-ascii?Q?OuZivvWqyH4zU4GjeN44WiOfMkkfZ/uAp3EXiSuPKFzN4S66TFFbMR67Lmig?=
 =?us-ascii?Q?ZZAxzNDSYX5psMlZuRTjeUA6W4rmGNhMd8qStb7DonwUoxq1FvgCKd+ACpnx?=
 =?us-ascii?Q?Dzhe6LFHv43fxyabg1TxkJYTz42TELn8roQJYCvr6r3fbCRJ2Rw0bPvZ6F8I?=
 =?us-ascii?Q?8xRZ5Ig9nT3zRAItjczZ2+cXPf56udYEGz9QS4WZa55+IQIsUP+RBsKRKCIE?=
 =?us-ascii?Q?xiO3xe9Zt+2GMY8ZYmh17Uu1gpxAdksWuYIKZBLsYpURKrnoVS4UM70Cgp30?=
 =?us-ascii?Q?2eW3+qtH5tVrMhHtmICPF/9s1FYrqhZ/xqhUTBVLEdLybN+essfT4dPYgisQ?=
 =?us-ascii?Q?x5Btl0VSwStKqD5UNnR5EjMCitGp4aXlaSt71pkmkbD0akb/UJmJBf5wjPzJ?=
 =?us-ascii?Q?1qrjoO3dnZMX4Iv492jWcFI6w0/lEs5596y2SIwUm6b7XyeIcg2bMydfSL6l?=
 =?us-ascii?Q?lVna6VsB/gY6vN3fSGI3vhJ+TVYztATFdriwSzKx7h2SbR2dPq2It0n3wpW2?=
 =?us-ascii?Q?M6+mVINUnWqU8Ip5NHhfIj81drO7b9Ia/kNoj5NHvOA5f0IwJ6zAp1bA5yv/?=
 =?us-ascii?Q?G+ir2eU7iUCkebrFUVHZkPjf4AH3omlaWMTOuKM7GAUJohMw9fH9xE7gH/YC?=
 =?us-ascii?Q?aTDp9P+4dhajbt08rtOhNAdnaleLwFRr9qWqb8yepGcxw4FKETlfLSQKGVd7?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f33a5b-60e0-4eb2-ac48-08da5ec7ae7f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:14.7326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SgWCXH63mJIM1x0SOF/r6vh0+22yWdHu26DRF48tMsAy60gTBAZ+2elYknv6WdjLI/OIDTEyNWckYx43fPaOSjzuSiyIRGT50GEl4eqBeTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1934
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFINE_RES_ macros have been created for the commonly used resource types,
but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
to all other resource types.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/linux/ioport.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ec5f71f7135b..b0d09b6f2ecf 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -171,6 +171,11 @@ enum {
 #define DEFINE_RES_MEM(_start, _size)					\
 	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
 
+#define DEFINE_RES_REG_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
+#define DEFINE_RES_REG(_start, _size)					\
+	DEFINE_RES_REG_NAMED((_start), (_size), NULL)
+
 #define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
 	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
 #define DEFINE_RES_IRQ(_irq)						\
-- 
2.25.1

