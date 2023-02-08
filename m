Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4223368E9C1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 09:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjBHIVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 03:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjBHIU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 03:20:59 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2139.outbound.protection.outlook.com [40.107.223.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5781342BF6;
        Wed,  8 Feb 2023 00:20:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmujxqIMN/Bu83ky2GIJ0Q4uPGd+ZF3kS3U7cvtdr78gDx8s5Gh3Xpy3g4O4YSY2tUk2VbTkmVxWOaMPvx0FGr9ZGr9oUK6ZvKDgYmXY9YSZy+en8a+1uetWYdBewzwGosuvjvDbqaOuCTpRqvpE0/Fqc+SCB2h8T4B59c4nxkpa3v54KySfg4f7xgtl6BeNxNetyJKD4/V5tGysixBXwLFmkWeBf5dXPu5mojKECPTpVMGDPjp1UsjmDSmlQJ9q1nz0j50ZvVBzqu10PnIoy2J3/O3o9jFFeq1DP6DONUDvIJR8i9Q6WfSoOWwCI5OvQL45s8oOYO+eKWiDAWGSVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rQJA0xKafLvXsC0xxfrHT2wDQY4O9a3vhebuQwGPj8=;
 b=Cuafbe8T2rBiPcmtdAPf1jTlG7LhLpMnAz3ixZm6Y++JU5oTH9RYkWd4MhjUX4P+RFQZs8V5ShV8l1p2wMDeBOgIg4jepnWM6MMbPNjtjn3VtnZCmNbKiQHtfO4UKbZIv3hnu76SGnaoefsCK5iFRip3cf47acGmQfBE42epEIJ/C/1/8syq4VuKgHm1BHqEvZvP0Xl1nJz/g1Kx9hsrZOfxRSE1+Q871b+tICejiWitM7Plzw26emfHyx2Ntt2KsCInkowAT/t4lGTnSjTLThwD6/Oxprs464pFEdlEimvZpzbTADUn54dI7FNMsPY03Om/7j6xibg188AdwnXXGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rQJA0xKafLvXsC0xxfrHT2wDQY4O9a3vhebuQwGPj8=;
 b=C5qJkkwPaRYde+a8odingInxipacD0c6mc8D7KH/WJ/AMGwqjgh786vmbQTaQzlKdJRgC4EbL3PFOtXWO4y8SI8uoQNJW8XxfLAv71Me9YPD9Re2cCuaXYBZ1FZQVfBI+incaD0Ae7t3WFMSC+jzbvpWa+D2J34mmp3ba2Uze54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4936.namprd13.prod.outlook.com (2603:10b6:303:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 08:20:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 08:20:46 +0000
Date:   Wed, 8 Feb 2023 09:20:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        helgaas@kernel.org
Subject: Re: [PATCH] PCI: Add ACS quirk for Wangxun NICs
Message-ID: <Y+NbV5rKVV3zBx7A@corigine.com>
References: <20230207102419.44326-1-mengyuanlou@net-swift.com>
 <Y+KMhg145coygAdY@corigine.com>
 <5E1719B4-C7B4-49F7-9883-AF92A6685C03@net-swift.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5E1719B4-C7B4-49F7-9883-AF92A6685C03@net-swift.com>
X-ClientProxiedBy: AM0PR06CA0090.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f78e17-208e-4f16-f55b-08db09ad607e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VUlDlWrDlHvPHP+QCq4EODjt6EgpaLgRwyrExJZw6IA+clfqFbh9PTHLWDl3FNc+4srJqXU46bxS0RjLzG2LjTjnPVLuUcqkRKZKgmihcNooO/KFZFo7/whZ0oS3r3uN+LoAhZ4FzoezENARcQ9rI9ANzZFOhxj4uO/rqC3UFsAQBJ5O6+z/8OCey/LnupdhdDTJNzSDg5LXXRy/yaimPmO9VTr0IKjvo5S5JqGe8kHs/W/l6jBNJzlKU/CxIir7o5wDiCl+kH3g2IoONu9wK/dmLg5cMLegQUSKXOX3ZqpsPnmQjp/FIKa6IVIeKVW5qurSGsTQsz/Gzwed7Yybv0y62RIFF+0TubZ2jg5utEspUDIURVDSlhYF2q3MbO5of0/Gr78AWIi2L2IA4VMXTpcTR8ci84qhAE/Tp2XRqT2fONHeG1ULE1v+RqNkJCsKO67zuLPz3dmFAwFaEXTDJlg18BPZmnxdeiv4doOqQ33MeFFMTkD4LvFxPDKQ2Xi8D8on52kQT2NE4lnJzeNupQuieYeZNo4H98grc3OSQAC4RXXK6fC0H77O/PkzCP1lp70Wm6LkbQLBL67rLIiVOr/+QHU/kjoNts9Rawooi1ZfJ+5zQgDRgzUuELG4EfOU4yhsCWu1I6W8Xa9XlnF49Af+VavCSOpT+SVYaV4GzgFyg/VnbgUjPwZ6jqGTK04f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(376002)(366004)(396003)(136003)(451199018)(83380400001)(38100700002)(316002)(478600001)(6506007)(4326008)(36756003)(2906002)(6512007)(86362001)(2616005)(186003)(8676002)(44832011)(5660300002)(6666004)(8936002)(66946007)(66556008)(66476007)(6916009)(6486002)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEJJREVvN3RCMG12TXlIWlpnWGZ3K2lrdjh5cDh1dE1nZ1Y0d0s0QmpZZS9W?=
 =?utf-8?B?VUZhbFdVd0t1SXVsckg3TG8zTlIvU3NIVWRJWmFlUXNVaGdWbURqTW52UWp5?=
 =?utf-8?B?T3BhTTlwQUg4Z0ZGdDhOTEtPQWEwM2pidUhQbkdlemVneVFFRC9aT2VoeWhU?=
 =?utf-8?B?ZXorc1dKc1BQMjVPcTlTRlhudW11dWdib3BLUEJESDNaTGsrcXdYRU5CMG96?=
 =?utf-8?B?VjEybFdvNG5BK0EwTW93TTVqc0ZHZ3Z1Y2VVSmdhS0xMak1ubkVHQlY1Mk80?=
 =?utf-8?B?SHFlczU5VVluak5ZaDlsQ3FQK2VsRG1jak9hUE1jMkZieUdDM1pJK2lOMWRK?=
 =?utf-8?B?cDhWdVNTUytlNEZCYS8rQXRYazRZOXJSWW5RaXltRGpUTml0UU5NZU5xODNa?=
 =?utf-8?B?Q3RtczZ3VTR5R1VNd2R4UXJqUVY3VTU4aUpYdDh1WVRqd0NjSGx4N1drUEMy?=
 =?utf-8?B?Y0NXRmlKaXl1c0ZOK0ttRlN5cFF4Z0dYU20zL2tlK0ZMdWxFeHJVMUVCV3Y1?=
 =?utf-8?B?cFc3WkcveXdHak9uOEx3TWgwaFRoLzJVamo2SUx4cERkZEdza0QvcFgxaGpI?=
 =?utf-8?B?KytVc0tXZGFFQU1mTWt3bUpwR25MVHRNL2pmVDZyaXpWTmp4OVp0REc1VE0v?=
 =?utf-8?B?eEU0ZnFzWjBkbm41bnhMNjFaN2JXSE5PQTkzRmNIandqQnJ2ak83R0gxb25H?=
 =?utf-8?B?anVjTWh6anVxSTBTdjlLYzBaVHYreG1zVFFJVjFxbWNQc00wK1NDdk9jZGVW?=
 =?utf-8?B?Qk9DeXVnR3hPSVh4RGp6RkVLaElZcEU0V214M21veW9rYnVZNzZ3NUVDZnpU?=
 =?utf-8?B?L2U0WS80Z2FaYURpZURmLzRqd2daNWc1WXFmV1d4ZWM1Umhvd2FaNmtGVzhI?=
 =?utf-8?B?Y05IOUdpVGxGQU80MStHakJJTVJoaTFFQ3VIeU8xSTVRcFJsd3ptNDQ5WEV1?=
 =?utf-8?B?QjRJR3p2VFdXQ1M2TjRvWCtpWDRJKzh2TGlzNVpndVExYThEZW9GbjlTYzZX?=
 =?utf-8?B?WURZOWRNYXFCaXdJWW9LamZOZUowODFwam9VRkVKdzlocVVqQThucHJ0QlR2?=
 =?utf-8?B?UkJKdk1KSGFUNUhiM1BENGNTdmxMdlFFcDBpTXBNdjU5dkVjY09aRTl6YlZV?=
 =?utf-8?B?Z3VhT1dSSm5RaHBIa2dGSERuZnh4Y1l4ZVBweGJ4VGlZYnlhNlNrS1dSWERQ?=
 =?utf-8?B?RkYxVzAvcVJValBVZXVKWlplV1FlR0l4K0M5b1MrUkRPeHM1UW1Rbk9Ydmtu?=
 =?utf-8?B?V2VMYkJLV09QcTh3WEoybWZncFBncmhYZXJvdFdYZU8xWVhraFVQZXFURElY?=
 =?utf-8?B?Y0JSUUlNZS9uWXV0SGdsQVQ2Z3BkTW15TitGSitnV1FNMWJGR1VlQXd2b2Jz?=
 =?utf-8?B?NEJHNlBFUXFUN05yZDhQZi8yaTVlZUNTSDZmOVduaS9KK01tQ0hRc3d0Z3hr?=
 =?utf-8?B?RkVCZkhtdHhrRGdBY01LN3k2NnNrQm5aM0pZaGlGY3htTEwxMTJiZ0xQK0ZP?=
 =?utf-8?B?VVg5aTNEajN6d2J4V0JzUGZQTlU5c0VWRzN3Y0N6djgzKy9aZ2doRE5qVUVt?=
 =?utf-8?B?dlRLbHU5SWcyNTBaZWdIOTJZQ2YxcmI1R3E0SlZMdzFqVTVqOHhDN0o2NGxa?=
 =?utf-8?B?L3QwTmJSVjdMR0dJMVZwK2w4dmFFMFRCWFF5ZHg5THUzMld4SnpiWGNWZmdl?=
 =?utf-8?B?bWROU0tmSHJXOTVocExGS3l4elJrWHMvUlEyNzZTNWt5eVZVdUtZbUtXTHJ4?=
 =?utf-8?B?bkxHZlZVUTZSYU5tVUREVGtBQ3dhc2Z6VThhZlo4TEs0bkNBVm14dHhFU0Vl?=
 =?utf-8?B?YWcvSC9KQ2Raa0xuNmc2OGdlK2Q0TlRjY2k0R211dUsvTk8vS1hpMHl5YmpU?=
 =?utf-8?B?dEdOSmJOY09IRnRiUHZZcFZIQzREMmFCbWZrenhzb1ovRWJnUkhBSklpalFq?=
 =?utf-8?B?SGFnbSt4WDRVaWFBTmdud1oxUHFLQlJnaGsxUEVnd21EVmp6emF4Q2Y0RDVo?=
 =?utf-8?B?NWZFTTlFMWJ3K2pQTDg3bmZWditmTUJyMzU1VVg4Tkh1THVGVG91eVBWUkJr?=
 =?utf-8?B?b292dzMrMHZ3WUFBam52T0lweHF2Z01IcGFhMkV1Yi9PdnA3NDc4SUZxMFMw?=
 =?utf-8?B?cXQzclVtcTU5ellKcTAzb3FXWlBTSytEckZkaUc4ZGFyRHM1VHVsZTl4a2Vt?=
 =?utf-8?B?MVVtdWFIR0VWTjRZNmpIUENvVGxDcG9wM1kvTjh4eXM5dktpdEhYVXgrenFX?=
 =?utf-8?B?SURZT2kxR0FUZkt6Wm1Hb05QaDBRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f78e17-208e-4f16-f55b-08db09ad607e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 08:20:45.8169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9zSbrzCrBIH+7quuITdv5cv1lD94RXPlGHM142tquv6UCxdzUwnX0ThZ9xqVX54t7yn0+cw7Sk0h2cVX39Idlj//OaYdWlJyQ/0cFSXWIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4936
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 10:16:13AM +0800, mengyuanlou@net-swift.com wrote:
> 
> 
> > 2023年2月8日 01:38，Simon Horman <simon.horman@corigine.com> 写道：
> > 
> > On Tue, Feb 07, 2023 at 06:24:19PM +0800, Mengyuan Lou wrote:
> >> Wangxun has verified there is no peer-to-peer between functions for the
> >> below selection of SFxxx, RP1000 and RP2000 NICS.
> >> They may be multi-function device, but the hardware does not advertise
> >> ACS capability.
> >> 
> >> Add an ACS quirk for these devices so the functions can be in
> >> independent IOMMU groups.
> >> 
> >> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> > 
> > ...
> > 
> >> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> >> index b362d90eb9b0..bc8f484cdcf3 100644
> >> --- a/include/linux/pci_ids.h
> >> +++ b/include/linux/pci_ids.h
> >> @@ -3012,6 +3012,8 @@
> >> #define PCI_DEVICE_ID_INTEL_VMD_9A0B 0x9a0b
> >> #define PCI_DEVICE_ID_INTEL_S21152BB 0xb152
> >> 
> >> +#define PCI_VENDOR_ID_WANGXUN 0x8088
> >> +
> > 
> > nit: this is already present in drivers/net/ethernet/wangxun/libwx/wx_type.h
> >     perhaps it can be removed from there as a follow-up ?
> It will be removed in a later patch.

Perfect, thanks.

> >> #define PCI_VENDOR_ID_SCALEMP 0x8686
> >> #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL 0x1010
