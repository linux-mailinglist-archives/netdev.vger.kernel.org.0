Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FED86097F1
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 03:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiJXBr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 21:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJXBr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 21:47:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A436E2E5
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 18:47:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Djpp3x0MijABpklFKWIO4p1eozYv2zlKbx3N3MlZsu5anLX3IQtyYhdwe/RKxfKikizK+BLl59K8Q/XFOIW1slgO1IO+L24kOH9944A+kPYlxpZJ76LOoduNp/YA3RMKA6OxTMnbgYv9l4lkvZzLusb2O7NNV7Zf8W7dOcs0mCmHpgv6rUmU35pBpuSOzEmkTjpcs7+oDqtNnPOf6+r51wLVmzQ4CgqMqldk3U38TutptTZNQPa5bf/inc6k49Nqsb72UZbtu4vl9FMDL+5F47haMwCp8vV2CYeSyGJ9Y3cojBNTnUuLLqs4QZ3gEq3RT7WVWlK2eKZvRanScnFEXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0We9kCggsUZ3We2pBK8lfcT2/GCED/wvASw2+Uy254k=;
 b=F1MXqWZJls8sVqFIqxugU/X1SdZ6qk2vi3HxfzOBOPmIOHqyS2RM9tItMnm904gm4K1DUI0SuTQsSNRPdx29vmhae/dBRDsZWUHUv6U99h115qjx1vbDTB3ev6tffjEWb2wrp8CKRkI6wPAB5EmIwMqX8M25C7AAoyFUNcgkHqdGYSzd+gKdPzYp91bXvcAnE9ySaOjQirFs/vB43cMCfjzufzVc5hgc33aCogBYUikt4VKiMEJH0tMb2Bm50C1IaLEkZKotoJUE8vk2J7R/YXytVCVmoof/rWa2CTkOB8KDDgt1PXEoNh1PLsWUx8H7/yO3QQCAo/eMToejGaBwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0We9kCggsUZ3We2pBK8lfcT2/GCED/wvASw2+Uy254k=;
 b=gLe4Pl5c+csJbAz798jl6KuM5jW8SJqqNDnPIQ0w6iaa/Snn3ASSS2bD6jrbU5GygKnQx/nKm22qXAKcYRlYy39sQmLg9ze7rJqIJbKXO/BQIlfVfaeFqx08QHY3EyjyDYSZHWX+bZg1rOZOZBhZU69hGMVIue9ivQPwchvP3cc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH0PR13MB4939.namprd13.prod.outlook.com (2603:10b6:510:7b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Mon, 24 Oct
 2022 01:47:23 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%8]) with mapi id 15.20.5723.020; Mon, 24 Oct 2022
 01:47:22 +0000
Date:   Mon, 24 Oct 2022 09:47:13 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 2/3] devlink: Add new "max_vf_queue" generic
 device param
Message-ID: <20221024014713.GA20243@nj-rack01-04.nji.corigine.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019140943.18851-3-simon.horman@corigine.com>
 <3c830f86-a814-d564-df7d-670d294b8890@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c830f86-a814-d564-df7d-670d294b8890@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) To
 DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|PH0PR13MB4939:EE_
X-MS-Office365-Filtering-Correlation-Id: 70823e47-8848-445c-408a-08dab561b1e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGxjGZfR2e+BKX9Ybk94wCMgse7g30TyOLLEKrRYdsM2pQJGzfF4kPWyizljp3CuZ0cxtZdLWMYkezH4rCk4GnEz322PL0bV0pfWlR/MbiTr40VATPD5I1YhvO1CMJRlv317LahLVKM3YWvuke6DPnvlQSRXoRTKS9udnBJn71Pg/BOpZ9NxI8BGAXCimviKZfzwsiAyKqGa2FL/vpsoTqKanCpBr0t1MCl2T714cKqO0BTO317/V2mxNaXlmosEp1Wbk4AZpLSTWi1CIK2vNgJpGoYgrtMbzCr1g+2gRoVvu0PJCUQE0Zyfw3wNYBNSr7EFVmaOQEPkHikWfcqZQn+nwoT6Bu6ZPdefebQ9V/dChwhp/rOH6Kun51Co0qMRE48JdvayrY0XnG25+r9hTxkhfpDVGOI+WfZJSPmMFBmEotXpzcwedl/fxAqJRLnT1xdxYA5cWZEpONjLUGGTs+xhQhfo4mTmCTTOYNMgTun+RpyxU6uQum9jtRFqfc696IKMBL+WCtSEbIZ+WXQ5goU90z2x3r28/cABFeaJbkg4Y3OyacUTWhf0L6RZhtZKM2vRG0Bhge3dU+49BmJKlpCKYtq3JDs6ejGKlD56uK4q7EdEO60detL8ke0GwYAKgwe4ZCZ3WH8b/l/IjRuZMjuNstTCrF9selIinawHMl1CW4d3a8FTGXTjj2wIms5fNGGP/c5K3VBVruQxC+dQEh5iav+0r7nTe6R1rEqZIemEE/qf8TdWUvqZBO3kwMaJP6bupUpGheMeX5noC7kLgg93IAP3XDvryQyKjsyJaAc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39840400004)(366004)(451199015)(8676002)(38350700002)(38100700002)(316002)(6916009)(33656002)(54906003)(66946007)(5660300002)(7416002)(44832011)(2906002)(41300700001)(8936002)(66556008)(66476007)(4326008)(6666004)(83380400001)(107886003)(53546011)(52116002)(6506007)(186003)(1076003)(6512007)(26005)(478600001)(6486002)(966005)(86362001)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zWs40dCPj86OfZKq+ON77t19TQs1lObz7ErWRV+yNHhK4xmxSVlncdMT8l1n?=
 =?us-ascii?Q?X4nuVd9UBOf4WIHwzllTFhpInQ0W/dT93kchj/y6vzLsPhaRhPhR0egN57MX?=
 =?us-ascii?Q?ubzp1giyrcH+hV80APMKJPMbyu2Is4DK0lWTuMTf3PUXcnLDx0hwHfAzscpL?=
 =?us-ascii?Q?1crhVPQwnfOiwVKRHLklJrR6SmliN/PVFULuJvJaZsG8gzs4rSL0rPK8RgJZ?=
 =?us-ascii?Q?+YKFoLTwxMpUBiSQeuSYm1niiOgG6huGzBys4ZFeZgsyCMEVYWG0b6MD8Zo4?=
 =?us-ascii?Q?YlyjC+yVoREikoRAbk5v7CED5tbdgFCN6UWhVU5zQSkjUM2xUZKENVZu8qNY?=
 =?us-ascii?Q?5+Rhhj685E3Mn74hpnOjXrz+UtB8nryaOWZ7WmZjLyir2fFgwQp9Aam43pPC?=
 =?us-ascii?Q?7iXw8Hkn66GS51/wXCNOSGBogBOAG/I70DRUDyeAOuRurwAjAQ35iTsTK5G0?=
 =?us-ascii?Q?ppvqjjis0rKrSCnusYDNl/hICG1JCyOHfN6sQUzex+YUprBywL5FsQ64K9re?=
 =?us-ascii?Q?wW5j/fQEV+x4dkpRBIiKeUaf9aW2uQFa4dq6dWuBhH4YPhXsjPBDdroWlsQ3?=
 =?us-ascii?Q?9qLhTQRJXlmbTw6SOTuuc0EY9eRbEyfZLuDx+Zc9UYeVd/Ff033TiIIFW480?=
 =?us-ascii?Q?ke60Fsd5UdaMct7h3+fuvsVQ1jPJWWdIEFyHkkg/LpvTCMiL8gMpSXCCHDAk?=
 =?us-ascii?Q?jjLA71IobEFQs6wW2IUwHudRU2rKjBIGKZWDSWbSqWe9AYkMB8/Lmd4rbb9u?=
 =?us-ascii?Q?TcLIG/AuT1PVGig5uosIuXGNDDVEDNZipGtRpMyECDaCeDH6Kg5PqEwz1ks0?=
 =?us-ascii?Q?/RqlaXOUmPRAAAFFwaq/4rxkBjRaAolrF+2fiL4BYx+iZxl6GgeU4Y0eAsqW?=
 =?us-ascii?Q?QW8htV5lfFqoZ1thI/nDa3BAPE4yQiNbFK8nnD2Lb7pcnva4qw4hLvEb9/0t?=
 =?us-ascii?Q?LTdfL3LSC2+5Wo3Aqs4kad40BSRwhZm9dOgnHA25LORhhFc4H6ct/BNei5RZ?=
 =?us-ascii?Q?Q4UryY2qduPJ82Kn8r5p0RNBVXwlnwt0MwVztuAV3pUtB03OVJABISLAu1h1?=
 =?us-ascii?Q?Jvvoav7QX8NVZ58fQsUA1q1jzyicpHlpWp6nJALnNQqJDKhVcCUHlSkJm3YD?=
 =?us-ascii?Q?gFvYX5knvcTPjDh3Mgvoe9vHv1GpVg7Pa0HsOFHlBSgTLdPXS7t1o9z2cRr9?=
 =?us-ascii?Q?RWbNlKfBTd5gLOxde66sRC8SWOQmPziHsYe15k0BpqH2auYWZ+n01dfcEl9b?=
 =?us-ascii?Q?ZmQae84XkX3+VHUXRFejG3ciQtsZxzGmtvWXVdcTSNgP5CONTTayguLiAJcF?=
 =?us-ascii?Q?QftodWmMdNXEnAGzWKbUXYUTQLkB4e/ce0X8e8Y0v6gkyWco51eojXkfzIJ8?=
 =?us-ascii?Q?3NfLvIEoV/mu0AZKGT8I+SZzEy3cfZ5SgJeKl1Q33sT8uZjVPYqDdpKTEaPG?=
 =?us-ascii?Q?ugyY+GXNBhPhxyapKy5v3FTtQTtCQ3YiBWSD2o1AoPvrZOQTxKHD5JM7FUPl?=
 =?us-ascii?Q?2/bnG6bJEZSGnvMNfIb+DnB5k2yArFGQlJf0KOoq1FVyAHocAzEtaQRwqfir?=
 =?us-ascii?Q?rri11fnU6R3v+8j7t40DeaAVBD4JFvJPM+sa4GNAt/6E3KEqJb8O33TDmLry?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70823e47-8848-445c-408a-08dab561b1e0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 01:47:22.8627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BsFT/3AnAXHJkLLqRQG//lCG7VjplnXkomU72ISAilfIKL4Pj84PC+ltvisDRaLR09YeiET/3yUy8ov/hfFms7kvibDkP77+G2yP6bKokGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4939
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 02:28:24PM +0300, Gal Pressman wrote:
> [Some people who received this message don't often get email from gal@nvidia.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On 19/10/2022 17:09, Simon Horman wrote:
> > From: Peng Zhang <peng.zhang@corigine.com>
> >
> > VF max-queue-number is the MAX num of queues which the VF has.
> >
> > Add new device generic parameter to configure the max-queue-number
> > of the each VF to be generated dynamically.
> >
> > The string format is decided ad vendor specific. The suggested
> > format is ...-V-W-X-Y-Z, the V represents generating V VFs that
> > have 16 queues, the W represents generating W VFs that have 8
> > queues, and so on, the Z represents generating Z VFs that have
> > 1 queue.
> 
> Having a vendor specific string contradicts the point of having a
> generic parameter, why not do it as a vendor param, or generalize the
> string?

As Jakub suggested, we'll try to utilize devlink resource API instead.

> 
> >
> > For example, to configure
> > * 1x VF with 128 queues
> > * 1x VF with 64 queues
> > * 0x VF with 32 queues
> > * 0x VF with 16 queues
> > * 12x VF with 8 queues
> > * 2x VF with 4 queues
> > * 2x VF with 2 queues
> > * 0x VF with 1 queue, execute:
> >
> > $ devlink dev param set pci/0000:01:00.0 \
> >                           name max_vf_queue value \
> >                           "1-1-0-0-12-2-2-0" cmode runtime
> >
> > When created VF number is bigger than that is configured by this
> > parameter, the extra VFs' max-queue-number is decided as vendor
> > specific.
> >
> > If the config doesn't be set, the VFs' max-queue-number is decided
> > as vendor specific.
> >
> > Signed-off-by: Peng Zhang <peng.zhang@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> >
> 
> Does this command have to be run before the VFs are created? What
> happens to existing VFs?

Yes in our current implementation, but it's up to the vendor's
implementation I think.
