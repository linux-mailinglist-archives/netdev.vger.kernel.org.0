Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4862538B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiKKGWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiKKGWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:24 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022018.outbound.protection.outlook.com [52.101.53.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A353663F7;
        Thu, 10 Nov 2022 22:22:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dyd+tNPoq+DsxYcFVp5ChX4QzWVDolygZioLO6CXDK2dYbMz+8yQUA4yGx9gCWfw+0xGLaAoMswyANPP/IEZ27VuIAYKL03WUxvVUoCklDrqSpyDLKCCbO/hO2NdiYONdtH8LqotzfFHxHr4pSwP9mQoR2YKjC2yL3j7U3InVJ/GaOiYhj7VVVOiD3OjfnEvFwZqZWOh/4izx5gEjeSRHlFcSgczBzJEe8A8ttR/movJlSrh787oZFqQrGS4DHKLn1wyivEteYQaDMuRB2qJKvmDQZorPHqZgE3kR62SC5SuUV3ElEh2o50SBxu+tdaJZhtWHrNMDs9MLiIHG6VepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFDQLJOQVpUWkm3kDdRVko3vVZx0WrPkQzObAxlAqGc=;
 b=EUCyzmkL9E0xfHGyVi0or0/DEkE8oYk71P05Ucrudhc0Q+9TEV74UCYg3Z+0uBuoHTQH5AE1wktj/UDh1BYuGaCr4N6YwYMWyn519wgWifvBcJLtePC4EEFQAMGZd37NcaxFvFVsEX2CmjjjvV4/9+0cpKyBaE04zRig1bx9jx7e4AsmgWCQ9MA448+JxBpxQ0yos9MfL/cK8pkxjshAXrd8ftb0DpYxEuDbqbjCcbTBkuWOABOEhNbIpNaBTeBUlLAwSaC81YX/LT7suP4ajlPH14CK9FiPtYyu7ug6oQtaWyloYNwRX0s5Gpjsaeuey3Lo+r6sqo1oWNE0pBmyHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFDQLJOQVpUWkm3kDdRVko3vVZx0WrPkQzObAxlAqGc=;
 b=WJOFgTUjULQoGtmlR+eX3trNyQrZcAhvxAHkfWqwJLrnOoPE91eFL+qWJ2biQQjC8VuPVqqsaFrFOMcOAszvwH04RkzfB8NAFzrAbA8w2QiPsZrczIWpm4G22oKDHUAeVkBg9uhnLHIfVsQQl7MgySuP7alzff46jN8ALRyTYDo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:11 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:11 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Cc:     mikelley@microsoft.com
Subject: [PATCH v2 01/12] x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
Date:   Thu, 10 Nov 2022 22:21:30 -0800
Message-Id: <1668147701-4583-2-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0329.namprd04.prod.outlook.com
 (2603:10b6:303:82::34) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: a8a19a48-a701-49c6-8330-08dac3ad114e
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O942vygdyu6sGmiqdX4F83fJs4RaAhEShbt53qNcCJsXTz3OFg2fPnbVX5TiDnY3m0u9BafDH0T6hQocu45Q2B/HZOoqIGDrGsErYrP30abMnxoyh/zkuOm36fkglhLz0iR6B4M+PJsZ7Ah2Kl24sG1KE+beeW4LQg1IRktiIAPeypNPAhYrlnP22HGr9Hi4PM0JeEsIADtv+OvqEIuLVbAx64m4BY8VcC4PKBIsIgOZyy50+d/CD3ZMADsuKSYgLsjpLpl5hY5P255xx+wsPBzCIyMyQ7QweSSKFvCnITRnI/9viRYrYfDdUNXK95BQmeGzV3Q3c7dwSjbdn6gZMsbThGb1FE+ZDHyOu1zPPqweTCEZ0qUMY23850m+wWpIVfWMOpK+yIYnE/l2C9pJjhz/4cjM90PmFPmS1Lm1An7m9zH3n1eBfPV1FHueMopo2bgE4XiRrpTAXDfIACGlIscBE9rMbf42Lb71kw+l7xJoalmqLuuXXCVUQl9IOQkwm2f/H1zQceys6pSrL91PVhY7OILygrwcfQxKnPFLf0no2pUA8K5tJQUhgCdvWLIWNLxzsKEhR6mDKoIgzxuj6tON4GRNX3iWnbrEdc4dCGsoowpLwFduEknDc6+l7MpyL08muAv0g8Z806J8ekieRwbml2CoKr5My6/WBkdKF71YWzuMJnCCh/IW3Kh5UxWrnOWcsOe4/RcjrHxQltUO43QLaU4b1FqrlBCei6leAj5WwNv/lbQSKbI3lU6zpE616EyzJa7tErLyzF6mSstSnS/HdeGvqxe5E6qARICmb/QljounYUY0Ev8Ln3hPLliLltj3vHTp87G3VV1QEHB/gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(4744005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z4apJ6YhEdSmsnSzYynciuGRev2zgVUIRyNkWEQ9ftfc+t2mqNmuJn7bejzp?=
 =?us-ascii?Q?AQc+wOB1zOHgzOBl6ebOh2DvSkVW77Tz8fD92SfH4pxEDK0X/vMN/ntqGKOV?=
 =?us-ascii?Q?lgMUtGVQUCNg7TEnIFV+ptg9xppcRYIj6BOzWm48qzyjxmiyZRHbDymYmEP1?=
 =?us-ascii?Q?+Qh5sIoV2upL+Fa4TMog82lJEsKHv1cGQ3aE8w8rqzz+1VXUwzvBJwEEWSLp?=
 =?us-ascii?Q?ZFrNGqnpQuQuKDpvzvkwsXWeIUI+4GmJwo4tONGsS0KEd4QbfOhuYG0tblEt?=
 =?us-ascii?Q?OI1CbByTtgmmCF9pHpms3lFzqsq6RnvY6WGVU8CytJR+aJy3qlDFU/JBPxIx?=
 =?us-ascii?Q?IkcziefodgHsmz+gQh+CF2O2ynz1AB2EUd5lgMuo+oP4zlNSpH1+USP3CAjE?=
 =?us-ascii?Q?0CjHHpMty2lRS9LAQSke9feAGBlLHakRVK5KVeUOOJwMb5ZVR8pXSfsDngnx?=
 =?us-ascii?Q?BS9F3IGi7nk2Jt3EHb7N/nmlGxahcaxbZztPQvDk0eCU8LJCWwtrlRBjmKO4?=
 =?us-ascii?Q?nOe18BEu2qTL1Nk1+/hSLnKxitX6otzbSq/icVstTtZebgqL5VHWzoEle2RM?=
 =?us-ascii?Q?Zavp+iPyUDkNDu7LAFL9QoWY8k65Idu2dr0sCMtH+1tbvc7VgIUD0+zcrlTd?=
 =?us-ascii?Q?AssiQhQc+ZtXwdws3PKEb6VCLPqmVWg1CkmhW3zwLx/Nvs5agqfFTwCvBqHx?=
 =?us-ascii?Q?3bN1B9dd0QlbK/pyWs7UUXd8t7eqeD9u/mW9+P6v//Y+kZ69iLb5moxh+RO4?=
 =?us-ascii?Q?WRdGFTJgKFmLGCdwFbzlz2dzP1kSLbxYGiZL9cXrXYZC7J4zGiCQj7Tnqk9H?=
 =?us-ascii?Q?iBHAwqvdV/7WPO8sdjKz1MwJJ12RNMpo3IvordwCs0/8lPYXpoXiKqWd4pBP?=
 =?us-ascii?Q?Iolpi3GxE5f18hD4mwLfJPrMDkTKbLxVDCLM8u1qH+mIx3UqwvZbSdM7aCYP?=
 =?us-ascii?Q?W4SX/ODU67brTa6FNMgM8fnBT779P2jtLXWu80vh5+AsccxEyjKpJ+AkpzIB?=
 =?us-ascii?Q?pMSPJwDhn0AUfjsgvbUp20sbXOxR6Qfh4eadV1LxjcJEwMn7wWnAWCLab2tl?=
 =?us-ascii?Q?lAobQBe+aGy77GgnM2eusNDpVaBqR+3oXs3mYQ0t6SfEEYfNnBvTTim26l5B?=
 =?us-ascii?Q?ZT5g998luPRBSAaAW7mdhayNedhtucuvoQjsTx/HLISmFB7AQP8R4/X8fszR?=
 =?us-ascii?Q?ozRM9F1Fhlbi7y4udR71gq35MvzRavEkOTozQl3UB23bApwUq76rAnvh/Os0?=
 =?us-ascii?Q?L+P3MbeQ2F1w5Be5+9uCmw9XlavBzQ23CgCvfZLPOEVusVvrSy9PXTsa5SnC?=
 =?us-ascii?Q?50zgAtbVMSoGtW1gt2J/GtWZyjwCxZSlM2Qul6cAvU2QnaayEpgicLbRyLBn?=
 =?us-ascii?Q?Re3FB3UD2DCo4peb/G8V7RCo7Em2CpS33TMu2IIUd/CdQADYLiMR9uE3o4U1?=
 =?us-ascii?Q?0QSIZgJMyRHQ+wQJXo0aGhYU+neFvC9X1yQbTUmZ1n2xWsmk1I3/xs5/9UoO?=
 =?us-ascii?Q?bzFsFE+WFkOe2TGyUGAKr4+jjHtsdTD3yWAhVzdfiTlfo8Lk41+6me+SaTNX?=
 =?us-ascii?Q?hvSR+tHHhqVA2v5HhsnVY8DxeZd0AqytV6y87yuX5Wy38ctbGxaHzAyah9MF?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a19a48-a701-49c6-8330-08dac3ad114e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:11.5962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2ylF2QBcPbdSugSRfyLTUi0wX4/iJuZAMpOy54HALKhmqvdVAnb00b+OJpkVTV0UYrbK8t+LwK3kqq+5ep4HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If applying the PHYSICAL_PAGE_MASK to the phys_addr argument causes
upper bits to be masked out, the re-calculation of size to account for
page alignment is incorrect because the same bits are not masked out
in last_addr.

Fix this by masking the page aligned last_addr as well.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/mm/ioremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 78c5bc6..0343de4 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -218,7 +218,7 @@ static void __ioremap_check_mem(resource_size_t addr, unsigned long size,
 	 */
 	offset = phys_addr & ~PAGE_MASK;
 	phys_addr &= PHYSICAL_PAGE_MASK;
-	size = PAGE_ALIGN(last_addr+1) - phys_addr;
+	size = (PAGE_ALIGN(last_addr+1) & PHYSICAL_PAGE_MASK) - phys_addr;
 
 	retval = memtype_reserve(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
-- 
1.8.3.1

