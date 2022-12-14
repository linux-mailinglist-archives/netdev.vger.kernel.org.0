Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F19B64CEE5
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 18:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiLNRe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 12:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLNRe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 12:34:27 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B11E25;
        Wed, 14 Dec 2022 09:34:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niYzYVAX62N/CekmYLaGG7/0yonyPBIxiBjDR1GL4I4/EccwotIllImR3FfUO2QeIJkJGh7/WWErogEcxaHd6g9F4QlkfweczBQoQzgzN6o+rJ8eFiMAK3LLnPkf+T6icFfUK2jTt8wXcERWhG6Fj90oO0UzbPwrYGFeTAhqBn1jXuNpNcRwM+4P/tNOXRIyDzzHcovIm1Z5KZQ7fSu1zzJcTk6Ck7dswGqiW9mBUD1ik0HaemVbWLwBjyy+u65MpXJ9kWqq4a32Z3eUjocYK7xUXTXvMJTWPqitc/k9rn7k+D58v87TdRLDg2l067xI8vurXsgw+D3gxhxOOGBtjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5FkmtlR3EPrYuZXZLi6Pl3AQ/Jtu+febR4ZtM5Li2Y=;
 b=T+kwSUsTFu4sCaQUUrUWDpst38lXO/8qkm80dENJvXF2W2xw9bgv9A99kSdPU0sKrWS7RbBsIhP3/rWkoN7mw/qhxz2pcqQm17ikFASthmpnIZx6ARXwHLzLSBxQM/YRhvLF2TAHX0akff9m/QZYI5gU8JWFbaUFRh4hmINLsel81uiLVMaxUp3z7+GlgOCxc1OBRV4smM3YaB3FD3mi2egVBBYg8jy3FTxitsc2VuKOss7eC9IrQ2rCPn62tLhnIgxEF72tYm3m/0bsAk6IRS90gHsr7qnMMAOxicavzn4/gTFF4Kep+8U+K02Nc3VaVRtGweeF5kiBzPO4jIgcyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5FkmtlR3EPrYuZXZLi6Pl3AQ/Jtu+febR4ZtM5Li2Y=;
 b=qNCCZxnqC45W2i502QWWmfYa0fXnfa2HBYu1LkOzpR1/E219mP3qtdzrhEk5hSWpiOod2KMhFWfB4X1mniy5BG5AHbFUpd3AiTzr4SmOXm4vGK7Q+3LMY6J8dkUqEBSFe+eKhKE9Ca2MWUkBAXQIoc15Mrs5jY3HumLKpZCkHYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8948.eurprd04.prod.outlook.com (2603:10a6:20b:42f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 17:34:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 17:34:22 +0000
Date:   Wed, 14 Dec 2022 19:34:18 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     iommu@lists.linux.dev, Will Deacon <will@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] iommu/arm-smmu: don't unregister on shutdown
Message-ID: <20221214173418.iwovyxlbogkspjxy@skbuf>
References: <20221208165350.3895136-1-vladimir.oltean@nxp.com>
 <d3517811-232c-592d-f973-2870bb5ec3ac@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3517811-232c-592d-f973-2870bb5ec3ac@arm.com>
X-ClientProxiedBy: BE1P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8948:EE_
X-MS-Office365-Filtering-Correlation-Id: 45f01e8e-6f6f-4ed8-76c0-08daddf96fce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 21AlQxuAJyJz8cnY/6OdEbrkksSjUpQAQ4myOupmDA8lH48d/FiIIYKPbL9oemuG40+oQ5roJt07ZPrDYiqIrSPkFXripE8sddjMo4TL6Fqg0TFVxLH2FAF4jQw4a5Y5FUnuoBhud//PPZ2c6/dgL3LDW6PdrYzAYsAkzaisL7jnFKsStNrknJgr131hHcGwEjlcPqUmuWSimeZupcuft/+jycTJWG58v5EFocgEAtQHlDaaowlDX5lBitn+YhxLoTd+kJOAVolygnd5LGvfX9alub0Ll5Xn2iGRE9xPwHKYEv7kx38Sl8Wx7AH7MG2qz7LwVByFI45s/zLt2xHVWnlFoWsVUBDST2zWttxxeGKdwfWsqilDEzDpQFBopzrDIMrM2aEhWiL/UDk49jTP+Xp6k7SVysCsaUVawRYK7G9IoApDY+7tWgkkDgiu7P5gVYL819YyPcscMw/6wWql+RAzBOk/w6oVjvi4kogFtXiG1w6T4/ykRhohRkpRy0hPw5fboMAm1gbRrOwuZsM1HJBA3IFotDdO59giZQdwU3M2lYNRXmgTohzK7MQCV+NhZMpkpbuy6SCRvJBW3XIi3L/vhneXNOw83qv3bpnyT/iMg7ODLqpg7ijTt1zIrRrktNR3Wa/pSb7qlE/tbxtKIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(2906002)(3716004)(5660300002)(8936002)(44832011)(83380400001)(86362001)(1076003)(38100700002)(54906003)(6916009)(186003)(316002)(6512007)(6486002)(9686003)(6666004)(41300700001)(26005)(33716001)(4326008)(66556008)(8676002)(66476007)(478600001)(6506007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZDnMGXzUH4hYdfISdno7627auG7LNCcC8mtj3X41erDj6UDqxvL8sbpUQkq4?=
 =?us-ascii?Q?cvwCZIUhez1Mnd2MoqigOqGxEdfoMTRe7gSHzapoCDbGyK2nGjfWfmejT43e?=
 =?us-ascii?Q?Db80lDmdv7IFdYO+Leat0fABTEhUOG9VInBopO+YJrPwqBRYThIxeBKtMkLx?=
 =?us-ascii?Q?a+s6gXhDN/gUtmpneooD3/NIt2kcZstcn+5RANozqxXl0LDeBYDAv3XtRRWZ?=
 =?us-ascii?Q?M8V22st1Y+qeftwXNRGlpnAkdEMwR1hb00L0mbypWMzyPLMP9fdqHQbqxzg9?=
 =?us-ascii?Q?2JdWA+oWQ33Qh2U0fZFo0uw3gbAbHPJC7UHwRTNG2Mxk7AVJUcDs+/KPQLDS?=
 =?us-ascii?Q?G1CDIg0uiYYoxD5CTzH1dC7YuxSBglhZ/Q/vLl10M57N6gdN3HvatyXt0z4e?=
 =?us-ascii?Q?cOPUDh9zeSeOo+ooICLiUFkfBslIQ0Qov6E4GWhHTaOauD+Oisk2vpX0UpJT?=
 =?us-ascii?Q?aaIVc9pfqxc+zL5XaqfAc84eIX2d6qWTsvDS+K4y8BrFky2BA0ENCq32pG2J?=
 =?us-ascii?Q?+AZe1hBiEZadk3Ot5vV/os8yORMa04p6SbN6/B/mnvAr5GhiZrAQ5wo0N1KO?=
 =?us-ascii?Q?qM34yW+BPemCFRWHwrFxEOaj0W0xtrrXZWou66XV7vcYmyv2MDJLZA3Ir+dw?=
 =?us-ascii?Q?vlYSxYvrFN58lwV/+kUqcYGgDmraMHaIviyNMKWp9MLZy2cgndtpvSk5H1g0?=
 =?us-ascii?Q?d0qg9xWdqOMqtVb6KF/SMuY+YwtVwtk1eCr7tlPJ5WJ/g7mjoRqpgAqi6tpt?=
 =?us-ascii?Q?bISZJty0WT1DP1GhmcVfts1PjJa9m8JLrFUH8ywUOXBP4/ieyDODMeYytMIw?=
 =?us-ascii?Q?rXoXRLB3D3s4TjsBb2zYO9U4gRhQjsaA1KCyMgXJGzNl910uTvQJc+5e/tFG?=
 =?us-ascii?Q?XtmxCxIcDhfy5rdpPMyTiYuch3kws8gMFo9GauCuWu7rCeLtfW+gY6W7mtxv?=
 =?us-ascii?Q?2Fgvm/P7fJZTuPqPPj61lLPb/fjqoChbfnGgtklOFkDfLsTKblQtQjRKk0Au?=
 =?us-ascii?Q?uHVfrajkXBCp6h3gr5m+5Wh5eRZdO0ddiNjBfr9fJt6+JtnZ0OTdmeo2tjO4?=
 =?us-ascii?Q?Nnad4V7hFoTic4gSyox5T73QcjaNIKeME/buwGEsSpokXdGX2AwVFXfzfosM?=
 =?us-ascii?Q?B0d5S/W15tL65fEJN6KLTAwDdkWmBPqQKVJcKrdpufGBzHTA8I4Y/Iop0YqR?=
 =?us-ascii?Q?zOT/VnYw91boKglN/oi1spWqhUnwxyP4tiO4OQvDgQ+y1mWQaQVl+rUe/kSA?=
 =?us-ascii?Q?6KIMWagssfgY3AOEVOOblPDcgxYAg+t+G4fxuoMt/UHiR4DesDFf0/ESGMvH?=
 =?us-ascii?Q?I+1iKIJB4HeVd8mirFxHVfV9zYMi2TXmWv/TMnaVPVgLp5RRZdpUymjgErTy?=
 =?us-ascii?Q?YzOfFF5oc3AH2UIXVwV136h+uSNVExnyW4y3Se67nsfzcEZLiidmkK5PyGMv?=
 =?us-ascii?Q?pEpK8z+TK++dSVyx46P2nEPNh3yqHnnwE3XpRgEFkiGBKjg/YLqSkelJpp6j?=
 =?us-ascii?Q?ulpfqAYK4gJGvP8hDjeLaRaPaz56kWcnWftCMcYoeRis71rIBARy4FQR0Ucu?=
 =?us-ascii?Q?P0007xaJoipBgEGapDIOFBH3nWkPJJ5BNEnChNOlrakQi4C9R6zyAtwm9t+l?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f01e8e-6f6f-4ed8-76c0-08daddf96fce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 17:34:22.2180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6VwnOnw2Ks9weUdWC3+4AmFsYIJF6lz8aZCVAIlC0ALgwl7pIRehj6MMFuI79MjD02Q4Uf9pIvUBivDG1Ry7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8948
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 11:24:32AM +0000, Robin Murphy wrote:
> > Fixes: b06c076ea962 ("Revert "iommu/arm-smmu: Make arm-smmu explicitly non-modular"")
> 
> I think that's semantically correct, but I'm pretty sure at that point it
> would have been benign in practice - the observable splat will be a much
> more recent fallout from me changing the iommu_device_unregister() behaviour
> in 57365a04c921 ("iommu: Move bus setup to IOMMU device registration"). The
> assumption therein is that unregister would only happen on probe failure,
> before the IOMMU instance is in use, or on module unload, which would not be
> allowed while active devices still hold module references. I overlooked that
> the SMMU drivers were doing what they do, sorry about that.

Ok, I'll change the Fixes: tag, I didn't notice that iommu_device_unregister()
changed in behavior only later, I just looked at current trees and tried
to infer what went wrong.

> The change itself looks sensible. The point of this shutdown hook is simply
> not to leave active translations in place that might confuse future software
> after reboot/kexec; any housekeeping in the current kernel state is a waste
> of time anyway. Fancy doing the same for SMMUv3 as well?

I can try, but I won't have hardware to test.

Basically the only thing truly relevant for shutdown from arm_smmu_device_remove()
is arm_smmu_device_disable(), would you agree to a patch which changes
things as below?

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6d5df91c5c46..d4d8bfee9feb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3854,7 +3854,9 @@ static int arm_smmu_device_remove(struct platform_device *pdev)
 
 static void arm_smmu_device_shutdown(struct platform_device *pdev)
 {
-	arm_smmu_device_remove(pdev);
+	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
+
+	arm_smmu_device_disable(smmu);
 }
 
 static const struct of_device_id arm_smmu_of_match[] = {
