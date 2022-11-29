Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B912E63C220
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiK2OOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbiK2ONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:36 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D36761515;
        Tue, 29 Nov 2022 06:13:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocNBFibuPqQ7Becsg2eHRGRlAVOmd8tewV4nakibqZqwr9a3DC6pc2+MHj+oPGjmRtFMx37QF4RebyHLiBHKCzHgA8H5T7euXZx8j1tWIGXdxyqtnC1VGfOFIq2vhHXqSbkgqPZkALAoVyQcTOfYfYg1z5RJH7z9YNJ1zKV7jvLVF82TpxPk/48qq4+FdEVyWlgFAqA7gmxlzvPHF/e/ZccSXi6ozfmvyKXSfnc0WfS3wv3r9A7jCcTTfMPVNkim2g3K+YJruhecEsIbuQ6KgI6WmNRktEjD/zkCIvcv8dm8cge1K37IU6fdD/mJxLvqgrUspniQcS6V/B5T11BrhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezo51H+43DPp5KVZCqsH636wQ5JiPwfxPsHF2yGFLV4=;
 b=nFQpNJCqXT7nVc0NE/HgoNsUZ/d7nsR0NkxZbArLJ6w1SSzLzBQ6xOUFhY1tr28c69Tka+l1C0QeaMHwFZVKa/qLpsd59GLZQCdr80kASFktSrOABhxSIBTiqofg6Fo6OH6m9nus7ExHIxigEpEGLjNQ4CMKoH1BHz2kUQdbRneOq9WD7oVX/OA4xx83pyW4JyRMiGEw/Ow7L4Zh/hKNDDz8r6aWVuC2nJ4zoO29guwYpM+HXfgP77ILWFFPmuaKK/EcTD8AVuXr5xnkatquHzcbPPUBtj38UXiSO6vJn34JT5bqG44uLB/89sBKIcT0dL1lidDIzn/wMlwy5ugKhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezo51H+43DPp5KVZCqsH636wQ5JiPwfxPsHF2yGFLV4=;
 b=MsFZtCr3zqL8E+3nWv24/CkrzjNBVH1fs6ZLwIej5PYK4aCWucK8YxD7JFfNFBk3q9DM9jtxizZGSc4HM2qDqIY9ajlCp5h0fK/qeY5CzZJd5KK6B5BQzDCCcqMzwB0dQD/Vv10OqsMg4uPl2tIM2XNYEaQlymc4xtEZ2R4MXlg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/12] net: dpaa2-switch replace direct MAC access with dpaa2_switch_port_has_mac()
Date:   Tue, 29 Nov 2022 16:12:17 +0200
Message-Id: <20221129141221.872653-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d3d619-4334-4802-05fa-08dad213c5e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c409kLmaYJs4VG0tkaBPTF8Yv+8YFMqCbrVkyh5jus7m0h0zudVu4+5RYS26mHQZiXBHWnde/cV8g0EALbYoKcOn3nMvO9sX74IRO/Y3AOf6UBhM0c6yrdOeO9NDApEo3nsZWJGrx9XLAz5UpRGNmh9KTzs6OcZVL7QAL+elhoIRHcTyYEZ6PEsClJQ/sRJGGezzWCDgQICFUTwc7P8Y2GycY9M4ORJz/1+0BaHhlS5Du8PY8TEBsGGM+B40d0sBHRYJL+LYUcycYc5oR7PfZQLuC7s48ntPi5YjHe5wFm9j0uS+cL1TwcTe1yvE9ajVKYRsc7XJzzQ+l2hJS0f/4I6E2gzaC/ucU2RuCigyjxBHf7zAQ9giBEVc3m2JLL+QAQnrSRnC/dFHQCAIDRYJ29f66ZZMSHXdr9iSC8Y7LJHopIxKZqcAsYJo/YlaWGGsxytcyRe1QIor5EWHk8y9baWv2J0gbG3ciwXFIitVd4TnHaEL+pDMx1bcR5B9mZHsmZn0Wzj8w/P/qVBHFMul4v84/0SAfo2kuzFniugrd6OfYoO4oJpS8BlSCpcGx6aXMLq5aPfMqdsoW4XLAy1FI2JNlx66LEHbOLRYMwQVhOXtOBJcSlxuzj3QlmtMFcZGvssDbzUr3wZiGsY74kcIEyFaSa1hGRq2W0K/liWhipIErAO3AeyNoHwUdSS3g5e8Y9VVf7fgvITV/nQz/pGNTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(4744005)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lYtgopuQn7z3Ghx8IgyblV2MfJJWahx80eehdqjGPqPLXYNq8xOyRVyO+ZDY?=
 =?us-ascii?Q?o+S3W4XHE7DINSkaZ+ztFdXoeju/YsjW2/UGcwD9BqRo14/Fmc6P7uOYxXmw?=
 =?us-ascii?Q?sd3diICHbm/m60qs2emgCI+xmAUWgPd5OQTA3byP4qtTtXFuvvWPoQf4/4lN?=
 =?us-ascii?Q?S/z5jOozajbN6hfzr4dxMdX5Zbze9+EQYAIvwWlG709CgUTUY1T2Kb7IJDit?=
 =?us-ascii?Q?MyA77QSgDhNyAKg6u5c8gJQjTDl86hIUTC/f69qCXCxY7MkYCWXoghHf8SGe?=
 =?us-ascii?Q?SVVxqfCgYRGSYj0PNpZ7EFFM+ucVSx/l/6uhJCfisS3SWuumNn1kBiy+ThfO?=
 =?us-ascii?Q?fbSxSXTLzBv10BksbySVzhWM35aaCLeLUnwnC6u0uh0kOqK22A2XFf29JW3f?=
 =?us-ascii?Q?rkh3Y5SXSWw+POQ3sXuGunUtriUxBFVuyvXmwtPZV39NKF1M7IHntceJaY77?=
 =?us-ascii?Q?lv0pOJHdzLQIOSEX5uajjTcVfTAKtAfmjZY/cJuFu3frz0Q8Difix4GVuE3D?=
 =?us-ascii?Q?UeDdTroPEypFYswi4Jc5F8b15HR2V5ZoRP6lCKMuHgcIy8iYh7IrHTBD52QE?=
 =?us-ascii?Q?4Sj4jJDBFBiUNVSqTeIymz7NFStaBAxDgJygHfarJwh+gy+mlUdnYoDfY3ft?=
 =?us-ascii?Q?KabQ94kHXmuxUDcOvNVNb88jcl0KJ/ILhytJjko77tPkH6XEtiN1O0RoDPCY?=
 =?us-ascii?Q?M/7P1w+Hj1HvlqXMk7m6AZEFEkZxxZ5jqI2o5ZjqfvkQOQ+nm926X+c0I0u3?=
 =?us-ascii?Q?vF7Yg6KW/lq+mflKdHuuE6OmV8EqbKzYQv33rzp7+LDFANDbHzEWvfXrUylO?=
 =?us-ascii?Q?cC0J0tIY8hBEbrmd2qGmPlcCMUih3kYCs00qt4l7XFrnZxqc3nsk5X3EsPQc?=
 =?us-ascii?Q?1YwAShNIU147P3H12Z+C9fJTNLnAzQ3k6L2fjIGlD2wG/m9u1ppLY3T1Pp/N?=
 =?us-ascii?Q?camDNtacpMjPz4We8vhlJ49hPdHWfBNHJDn07A9NZMBGkrkb4GHWysXYtKQ8?=
 =?us-ascii?Q?b2NwmFj567sO+gjdOCH2wv4iai3kw0e5r74hH9nSnXEX6T5ecCBEQGU3byXt?=
 =?us-ascii?Q?bQhnzg8FgZkyzULK0KTpou6Nc/X2TLT64/RBzhaK25quui3UT5r6vUcEIWRV?=
 =?us-ascii?Q?DpeuduE+nal+XbDlR+kFyv29baVEsdhVwiepyATyGzblVJTNBGe1qxvsJg6C?=
 =?us-ascii?Q?6GDBIZa/YHQ86Bvwb8doBN9gWWqtUpQFw7nL2UKJJOSS99uRaA8LYIFqTD8B?=
 =?us-ascii?Q?EMkfpBbqkQK/Zf7Csi4/Mu82bMCEotrW3zuEKMVa+HJ8XTYLbKtfPGPGQVCG?=
 =?us-ascii?Q?c793i8vvG1E+q5gEqwaP1wabIN9yDCpPL2RXwBBkgFe5YQXdB5sc9m7TQGO8?=
 =?us-ascii?Q?qgWa3twLFVf6RBv6pPROXp30Ve+hXPJjCVNuvlesIgR/oObn/D6y1LVBK0Wg?=
 =?us-ascii?Q?OnKbmGm6GzVuW13B61pmGmkSMXdgPgZ0OKzQfUdbXxLGZjQh0+UFnA+P+N+6?=
 =?us-ascii?Q?DBCFFTJlP6ggMkaiRwHFKiWO3FueC94mxHOTw249bli90LGtQ5b603PFQZYT?=
 =?us-ascii?Q?nUN8//hOIJwqJORyepz2Tqu7WiOfOh4hMpb6v+cPFf6NVcRUwXHVucuVbeHn?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d3d619-4334-4802-05fa-08dad213c5e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:39.4972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XeEUHtdCE8AKZylsWn25gKNcn7HsNCXb0IwvmfWQ+trx6wI+qwZl7UPfnwzK67dtkENH3P0H9OQTcgLFUIByvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper function will gain a lockdep annotation in a future patch.
Make sure to benefit from it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 40ee57ef55be..76a4b09e2854 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -189,7 +189,7 @@ static void dpaa2_switch_ethtool_get_stats(struct net_device *netdev,
 				   dpaa2_switch_ethtool_counters[i].name, err);
 	}
 
-	if (port_priv->mac)
+	if (dpaa2_switch_port_has_mac(port_priv))
 		dpaa2_mac_get_ethtool_stats(port_priv->mac, data + i);
 }
 
-- 
2.34.1

