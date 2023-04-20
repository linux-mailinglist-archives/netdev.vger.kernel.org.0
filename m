Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701BE6E8B58
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbjDTHZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbjDTHZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:25:28 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2101.outbound.protection.outlook.com [40.107.212.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FA540D3;
        Thu, 20 Apr 2023 00:25:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDnN+6CGsi7XqN79rZxfxxydwVrtBzj9d/Afedt/VoIBfNbkKCbneiRop2I9CHCoQU5+MP9wI5B+Cs7ok76c8XVJ98MndX/aBaTNzlvoMCFW9OxHqu/vEGPRL1Q0qCDanjKou0MCAk+Y/0h6qA/CLzWcwBbimky3oBgvLrkDVIzGZChbxBTbXVvGpXZ+KU/pzZeWaeGm+8DnK+xlmH1nrbkpN06GSTIG+DyY3z6eMG/fnT8VOhJhK28eHb3k1gvR6zYorVX9Tx9NjKFwHQeBsYN2MTHH52c+u/vQdD6ZC3J0SmWRzV8PvutBljNRgBAXYqg51q8h7t7P07iLZFo4xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJncPnZfGx26ibcNgrN6khjFoi0fTewiqwy+Jv8IK/s=;
 b=b6M+wEoY507WmbZpSujqv/Tn5FT89KxVkD48kce3sn+x/SUUBjF6iO4HPJ3I708nqYo9WSVnZCwSNqOXh8BwxTSC805EqP0lc2La+zXMepMQfEKITPG1x5sil1YwcrtZPmvVFEAFpmXlyF89b6D3QbcFWqZtL5dsZxliRBFq8HLruotSamNgKgZn5fI57Q9ZEQFix6A1Z9axvf70pcnM7cOWcIqFzfTFfztbXm4j10CvxHq5afkh6g62wLwH9qm39zSOcUpD5qwR0H2iv/JTOoIbAD4+1DxgvpCsh1deo6h8aCVV/fs3H6hMouSHdcp42iuOUj1HXYGPsTDMK3uQ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJncPnZfGx26ibcNgrN6khjFoi0fTewiqwy+Jv8IK/s=;
 b=kksay2qkcKHJ2uxqJ3zQbcPvgf1+GRWAHR7f9IhG+xocOo/1jRlDASOrOTN/H/QYIdAfXwwX4KGTzg4CtM7HY4C5tO5UodCvZ1/Kqxdx3tPqimFuRAa7oMP9HIn4Hb4UUiU/QsaU/zmgjFMKnd8zmV1kcPsZPITfeT5Si05xVlo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4837.namprd13.prod.outlook.com (2603:10b6:303:d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 07:25:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 07:25:13 +0000
Date:   Thu, 20 Apr 2023 09:25:05 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        'Louis Peens' <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Subject: Re: [PATCH net v2] nfp: correct number of MSI vectors requests
 returned
Message-ID: <ZEDo0RrtX5okUTN2@corigine.com>
References: <20230419081520.17971-1-louis.peens@corigine.com>
 <36322e3475804855a28c7e91a7ccdf3e@AcuMS.aculab.com>
 <20230419183409.1fba81b7@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419183409.1fba81b7@kernel.org>
X-ClientProxiedBy: AS4PR10CA0021.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4837:EE_
X-MS-Office365-Filtering-Correlation-Id: b309917f-7a1d-4c27-0a8b-08db41706114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HK70SOm4/xtwJi5Sk310r86gzfn8VHKnT3WzuRIMss7Mz3kKi6J1vq2ly7IdSxrtYBD3mhWkPFUT1Lth/XWbVOSp5ZJf6CmXHWqszs+3Ivn3rTyF5vXMRD8mri2dIOWZVP9Hi0sAlIzmPTSCCfUDG+2naE5x2ckHV23f8ODObznUlrCSssO8AQ+Jdn5WYjORoF7J93gRd00xRdCs2yZA+Kb9jBCUel1gzur506lvcEgGSjYOjkxyA+Q5eOlLJWnnBjNZCtAYtivGi1KcIgld2P+Towe37uyw9FGf1I70cTnQZA3O2tF7mioFIiv5yce16HO68uW37Mafw86Q1wnZcTM8lOc9X6Dl+MkIbX2B5mVCBzV3RdDUgp2P2tcKO4TCLqjJ51TWIAkvZkfNOoE9+FbvQXpxDHzCW7vWwghYcb6isajTL0hX4/kTT8uX2QgP1eM1Jv9vkZSss1dnX3nciaSWKmkMQId0UH3WpT5l/6zyN5PWWDmez556wFpsSn9TfRXnTM9QTfX2gM0EneV3aFDVzWmcPlRH9m9jq383az5SkHDI1ZNlrgQ1UHVbF9Vl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(136003)(396003)(366004)(376002)(451199021)(38100700002)(36756003)(8936002)(8676002)(5660300002)(4744005)(44832011)(2906002)(86362001)(478600001)(6486002)(6666004)(54906003)(186003)(107886003)(2616005)(6506007)(66946007)(66476007)(6512007)(316002)(6916009)(83380400001)(66556008)(4326008)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i0Y613hSB0y2l9ePfho5UCv2mWuBIJV/t8QreCIZYeUMzb2k6VHql0qXm3d6?=
 =?us-ascii?Q?4zkCozRmG48e+9uRTsIQbzzuK27tiGNOuKxzf0ToljX6U5m6/eRwHPjBM2Dd?=
 =?us-ascii?Q?w0Y64Wrh0BEHbXhlw7le7u8S97hAorFfZ5O0Z0Q2PmZyDHk2lU0fEiDgnAGX?=
 =?us-ascii?Q?7YgSxl9KI3dTmuYsljSXn5WqA+qWj20FU35wDKoPwBgtUAurAovkvoCypR8E?=
 =?us-ascii?Q?47Vuul0rF1v1SUmbIzQeCanx50hTMJ6FCCEtrIzbuDtWL4xc3wthm1gPTPZQ?=
 =?us-ascii?Q?VQ1JgGQHcoOEttPJq66oZYo2CeIAnByc8KDBDx0KR4jmKYyeX7etv1tb/Wpc?=
 =?us-ascii?Q?Ln+vIKwKbFSs/K9Zjgst9TrAZvjR+sXMoDAzV/PsC2pxDf8Yb3WkHAGBLR63?=
 =?us-ascii?Q?+8pf+hogMFMG789+ZrTuiKdlnAbp7Qbe64by5d6m653zBa/Fb+joYntDRy0o?=
 =?us-ascii?Q?2ckxV3CBNqJi1tL8dIHG8WXT5FAF46BALaMSRJMmgc0++tyT7vDviI+us8Mr?=
 =?us-ascii?Q?AzHw6zPCStb9BHjTGZuxBmaeCy5va5KbehJTJBw0d3L/PR8B8EAC21mMmSOd?=
 =?us-ascii?Q?1A4SMOww9hgBir1693DLe89Sl5ScJNYxopFQocl0AUsfKRBrQyaVHQ7ofkfn?=
 =?us-ascii?Q?oFTq4RCB+PSCho8u37nJNGq6zS4ZkGimvMhqQrsRPDYuNGJS5RUrXSkCJAFW?=
 =?us-ascii?Q?rWT/SbALHFCF9eWN6PpF7wCoJVxmc5XfZcGVBxDvTkBPk4lEQGHnbh1uqwkq?=
 =?us-ascii?Q?2DwcbrXkRS4IMaIH8Hh5f57X7vrfXovatpuRrO5D2sTwKYtMP0Qpsz8S38s4?=
 =?us-ascii?Q?MJMl/PQkXsJLIDgFoAZiTRlBMFkTVL2RmII6pFEM84c/JLZicF2s67vM2wIF?=
 =?us-ascii?Q?s7alkRDDlDsOC3vlxLavxonP8CxIg2qOnKY/HbRLQW4Eujzl4GX+qoTssFjs?=
 =?us-ascii?Q?9Pb41pPsNIpMC7lMfhgss+gwsb+stid7uTGh1uVE1lp4pVI4VTGeFbOppKO8?=
 =?us-ascii?Q?zXTHocc0ENA3tBb3ys5PtC+MdacFkv6Qfv8aCCB7XFMo6wj7s45r3jTwYAlR?=
 =?us-ascii?Q?AMDj0wRpAJsNNTx7cYuq5HfB8TQCH17l9MmX5keVWSpr6vbuzajhc2XoPkGh?=
 =?us-ascii?Q?pYQhwbpLrb31Vr5lLMtzp9auC8Te3vGFa1tBK5sNAYg7iPWbVPaptLqzgeAN?=
 =?us-ascii?Q?8JAK5wzIn+ELjeMufTuAAxijYPnEKVqSjxAlLbWrm6arEci4lW4fx3hlNXiM?=
 =?us-ascii?Q?slLZpB6/EdgCKHMZauyVALVEas/7ee/xrpAMxEQOgizv6STu0URa5xs81KX+?=
 =?us-ascii?Q?jqTd3IkYWcX+XtcofiNBlYQXi3R2cnTr0rTNjMTzcWRjgNPqMKPEvOUmFYrQ?=
 =?us-ascii?Q?OociBQ53NOgMuWb+pOGAMmiI5wo1yF2mjh6o1dGbKi5dbgxVpFfVrImpt5Vk?=
 =?us-ascii?Q?NleVmOKGSKCgHnpEMCdKszY5VED56HEOTyp9NJEyXwcHSwh7gIKsO+Bgm9+Q?=
 =?us-ascii?Q?2qjS5NgeNlDfuijzMamlhT/ySmkmpHIfdtqavVKYoVYzwq19kjn1BmMKtvfa?=
 =?us-ascii?Q?aD5VqmiH+5RoIlN6dtJhElV4bCSiwgAtSQ4aeL4ok7C7zqxNvieEGdMAcOLt?=
 =?us-ascii?Q?1oMVipSsA61Yqxb7ZmJImDghF8ee/ZC4pkfYyVwyIqYbs9jYeD2RJOiSSext?=
 =?us-ascii?Q?sOfSpA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b309917f-7a1d-4c27-0a8b-08db41706114
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 07:25:12.8622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PO+2y/A9YsyhHJrvxc9+7f38zyNo5ZAVQbzOanbT3FodHgoKiBmwJ8g3S/UF/UDRM/FHFUOc/SdkMmQFsn1RL+2g/ab41DWHaWgF1GlJH7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4837
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 06:34:09PM -0700, Jakub Kicinski wrote:
> On Wed, 19 Apr 2023 15:37:57 +0000 David Laight wrote:
> > > Before the referenced commit, if fewer interrupts are supported by
> > > hardware than requested, then pci_msix_vec_count() returned the
> > > former. However, after the referenced commit, an error is returned
> > > for this condition. This causes a regression in the NFP driver
> > > preventing probe from completing.  
> > 
> > I believe the relevant change to the msix vector allocation
> > function has been reverted.
> > (Or at least, the over-zealous check of nvec removed.)
> > 
> > So this change to bound the number of interrupts
> > isn't needed.
> 
> Great, thanks, I was about to ask!

Likewise, thanks.
We'll look into this.
