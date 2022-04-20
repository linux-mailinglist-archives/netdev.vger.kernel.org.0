Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3A50826F
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 09:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376292AbiDTHpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 03:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241235AbiDTHpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 03:45:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2109.outbound.protection.outlook.com [40.107.220.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54F03B027;
        Wed, 20 Apr 2022 00:42:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+6Qsl+kW/CQopP9wEewdPNoQFDv6LiQbu7QQFFf4CrBUAaU97HAftB73LNEV0SxTFXB1oET9CgU1y6Mz4glP73B+4Mo1S8Ea5T1lUpZHD29pfGRSpITT4tvIpi3s3KSzXN2RISVxoEHTlWMo66kSKV//ghz7ZVkue7PINqNu9R3oMUHd92l8k2mBjLyTxvU6Qnlf/EuxP8/dwW1pILcTklkpe+jotByuLmXrtLYLXlLywwIbOPRD9S4Zxe6wlVTKAQwMnC91NTjN6E0PVAudLDqi93r9SOTzXLE/AH5Gtdjh5ODKMx2QoZYAyuWVeXSGdoOYVhOSvhBuL/R8ZXGAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCozZzejFPhQmuXHuDCO7m5sCqSouCTwQ9geU26eS4c=;
 b=bRqeKG5Mp/ZvPpIs/o/UZGf5NoU2LRPdEJL5aDqilU5syjmOfF+PGbp918IVhlahlon5y5sHF1DZQeDgY/gUiXZ+jUvBy9JbXFBqFJTQ+OoNC87u2Vw4JmX4XJx/ymvhWCf5dTDDKJhhlQK+N7UqjtsQehhmwbi4226+uYjSJFDviicJ2oyq6g/k048V/lwQTPhPwwAcQF0rg3nGP1f9kouvN3ANy8onE22GuDdMa+Vzvn8h4JZLnAQwugGCiQnXDWujZm3NGelj/rmxdXFNSyyAcu4GxX4qQjT2UwmeEiHSSV+XR1BN74FTEFU0UsTRYFpZs+60h2aN1RBZMKVA9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCozZzejFPhQmuXHuDCO7m5sCqSouCTwQ9geU26eS4c=;
 b=RlPlEqjIdSponJNLeEaN6UwFFa3E/6eDx9vRyugtB8YeUjJ32sMItaKYHhMWvYhY4+toxdn0Eb2OwqSqXej88iZzQT+5rjHVgVJHE1kgoHUmNodv+A49H+5ziokT3S6xgbiKdoksafpVShvID/YWEWcxnuqXnmDJSupg0Boy8cg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by MW5PR13MB5486.namprd13.prod.outlook.com (2603:10b6:303:195::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.10; Wed, 20 Apr
 2022 07:42:17 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::5cb2:d978:65bc:9137]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::5cb2:d978:65bc:9137%5]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 07:42:17 +0000
Date:   Wed, 20 Apr 2022 15:42:11 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next] PCI: add Corigine vendor ID into pci_ids.h
Message-ID: <20220420074211.GA27487@nj-rack01-04.nji.corigine.com>
References: <1650362568-11119-1-git-send-email-yinjun.zhang@corigine.com>
 <Yl8w5XK54fB/rx9c@lunn.ch>
 <20220420015952.GB4636@nj-rack01-04.nji.corigine.com>
 <Yl+kUqyMUTIadDMz@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl+kUqyMUTIadDMz@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: HKAPR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:203:d0::23) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 582cf8c8-2be5-485e-a955-08da22a14af9
X-MS-TrafficTypeDiagnostic: MW5PR13MB5486:EE_
X-Microsoft-Antispam-PRVS: <MW5PR13MB5486214E1511DE9824A9FACDFCF59@MW5PR13MB5486.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rd+S9dJabiQggIcSrvnnHQufSJPojn8V2kAs10GleII9mcs32uwqdne1JTlod71W94thIVI8zWvJRUHYvn1htOsXFa1rECGlUoQk81HMNBuAsGhq2X6CQJTbqzfa8WzYSO8sRj6SGFiXfCVItKqUm8VCD5Endc9sMTTnN1VecHFx5wUfM29p8JV1wpS7aUGTxy5S+T3xbRYc6kCcGnThSQozyCJLhssnc6o0mGR6mGJnFAx2qB2Sglo2uTz9cUTSLDksNkcAOwrZU5i8j3Ej82Yh2Y6xOX/yFsDBycpIGnWMydYCuSXrJe5CqFcU4z0KV0ZPPJ1S4LVVnL91+XMlSWhSRIT3weOxc72T9uH9a5NZHvjO0hDicBJbJvQGoiFE64iXUCne7heZUNqTNCTnRQLrY60BZ1s+rAd2DYBwfpzE5fT/bDcJN0eJ2jp6dYyTuZWzvoDp8CCUgOkyxGv1g7I9FGMKsSQNuOrCj363aNwfaLArGUvYNQvAaDGrKKUsIAaAUjcWQyVl6inttYLL9ASklfsF3qNRayOUBzDeCiwREsEKU354HiKC30VpJvrarI020GQ/LgfzYLB7knsFV9FJfOMQ1MIGfpM6pVGvgHj6X1ZRysZHPTxn64KYyYbJ9jDj1vTdhJLDqmXDZ+B9i826b6geR7+AoaZwhxRbTWMhW4RcQPdJfPfOdvYSC5uEQUGh/z4nwnoD+JNeXHVg3H39JrKp6bI9kwJlK6vuBXslOmZfM3QSMRRBLRMHHaNc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(346002)(136003)(376002)(366004)(396003)(508600001)(5660300002)(54906003)(83380400001)(316002)(2906002)(33656002)(86362001)(8936002)(52116002)(8676002)(1076003)(6506007)(6666004)(44832011)(186003)(6486002)(107886003)(66476007)(6512007)(66946007)(26005)(66556008)(38100700002)(6916009)(38350700002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?va7CzD1hDG102vSyo/OH4PxEGRKIDOdMTU4YrBno3YyakpGUj/CbSUQLl4Rv?=
 =?us-ascii?Q?WObu2B1VjmvVAfBRm/2zgrmf/FEpY8wc0PeFJcGyiiO+1SRppF7NE9hM9Sbs?=
 =?us-ascii?Q?KdXg42T2bChC6XmUcyUngUoqKWuq54xPUONOSrHw5XCOw0A4HBzJg89qTe6s?=
 =?us-ascii?Q?PJkksB0C7lH+dR3DsFADq6Lnf09pe+o9zo+GVKMow5BLMUglutOIOx2TkeSR?=
 =?us-ascii?Q?BEknvoAsCpu3xcj9L28zmw15EEDoCpuC8Kw6Lt74ujccp0s4RthCyXCYL8RU?=
 =?us-ascii?Q?mtN7HzPxuLsv088HXhQSrW+MQM9Na8ZSxIRfyfuYVXrL9WHuw2P1xlMqSCCX?=
 =?us-ascii?Q?sKoexLR/MDzDKxnAWSJu2jErYkcY0abZluEjsuoyKMrpQgnuH+x+MWbU3/Sr?=
 =?us-ascii?Q?6ab1GTEnz4xCTc1A8dPJBuzWCww9+2nYypuSh3zpd4RU55tCBK11p14S4PC2?=
 =?us-ascii?Q?q4KpM9pN5hAfCGhz8LdhlMAOV8HlkJ8sriJXmDjIZ1PCaX3WMJZVt5xwXseo?=
 =?us-ascii?Q?cUidI74qfKmPReThckt1FucN0wKHexaUoRp9pofjpXZJR/iaterOeadwn5tw?=
 =?us-ascii?Q?yvp70s83eDEozgMZqROH3wkeyk7U5Fx+CjNiHdREepTUCNK/9pFiJBBxvQfm?=
 =?us-ascii?Q?uM7EnyiFHk0PZGZmXQS86aKgwvNCHPLaX6xoSYHmYTgkcY2iCV9s6r5YtvIH?=
 =?us-ascii?Q?l4xcdVsGE98J4RGkwqExCxvC3tVPBKzXrlNaLr4dSNtn4QagCopPvUiXok3D?=
 =?us-ascii?Q?/Sfj4PfSIHLmyUCmXRQCucP/A1UJsvL0S1G+9wp9Dy2ANnOHsw7LIcjlPPsJ?=
 =?us-ascii?Q?Fsyv7x/rII8kirLXzi95nw1LMFjuFQ66VqaNR8KY9UmMTE4O0ffGUkeInlBP?=
 =?us-ascii?Q?IBU2rVfuPzKtX/3NC/HwE1ITteTfLuevqfXDiepXDPBoELnPfohSqFxXhuwu?=
 =?us-ascii?Q?aPLku4ii8Fwy2nYd95Os/wtGVs7IvAIKiBuMXxSScHsg3SL2ymJW1Ofclwur?=
 =?us-ascii?Q?PAgguDQvaaeMd0GFiyNkdPV2HNp8BTwKFZQ0wZowLzk0iS7VYvwZSFrZf8n/?=
 =?us-ascii?Q?kQz6fs5NF8/Ubvu3fM3bMVLlTjYGVNWtonFFiF+9MmJRCe+4orZ17hlOR21l?=
 =?us-ascii?Q?EUe2Kr5L/Td569O8BgHwdInfaNm2ZwrPOpOjQmmTwShjv1KfAjIEQah14NKY?=
 =?us-ascii?Q?fLZukgDHBP8MxLSXf6LO7ZAsZe020kgOI10pN9AlJUqL1O0ABzwLaw96azdC?=
 =?us-ascii?Q?OFbcGcxdU6CcOvs98JVI07j1Y/9yjvzL3wTdN0w0DeEDxfFfjNta/iPxCuca?=
 =?us-ascii?Q?PoNAx3iKxVuYmKUfucH/riCK4qgrCG664jRSPZsP5E6OSbVYKkmCnmp1gBYe?=
 =?us-ascii?Q?EDiU0Mir5dHJcc2ADlIDWHb7AWfVw3XYm9svzBJFLgy9virnS6/3UjvlMNUo?=
 =?us-ascii?Q?49BMcLKBsZPganYT6Ml/pVBkpUgHGM3M9rfWZ+/qGmqvxqBj024cVg46XhBC?=
 =?us-ascii?Q?CTMvgNLZIblOtZYoEduSxgMpqpGSaSEXXZzh35X9RqN6p/ALplx0wpM/ER2B?=
 =?us-ascii?Q?Jifblr5bWtLt+RnwM9UsWMGyJkqA4kapZCHXjYNbeOHZXIHtynN/sp9vHn4e?=
 =?us-ascii?Q?SeFl5u3fn901Ijp5vbt+NXLrvNXIrsVFHLNjYkMGa8VKI/xPpbmz/Zj68+k8?=
 =?us-ascii?Q?bCGH9wn8uDost8bxcs8xT3OzYyqecYO5jxuhq010dY96inxDAG1w6SknpKib?=
 =?us-ascii?Q?UNTDxW+kPPFRROKU95rynythle+xAzo=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 582cf8c8-2be5-485e-a955-08da22a14af9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 07:42:17.2895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5s2wWJVLTXCeL+tZ3ymPBPeLw77c3O97ecy3TM9XUKIHernPsX8hZUcY2tL3eJq3iTFHDB3w2D12zHnzfvU4rjCNyo351y49okzmJoxyWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5486
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 09:12:34AM +0300, Leon Romanovsky wrote:
> On Wed, Apr 20, 2022 at 09:59:52AM +0800, Yinjun Zhang wrote:
> > On Wed, Apr 20, 2022 at 12:00:05AM +0200, Andrew Lunn wrote:
> > > On Tue, Apr 19, 2022 at 06:02:48PM +0800, Yinjun Zhang wrote:
> > > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > > Cc: linux-pci@vger.kernel.org
> > > > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > > > ---
> > > >  include/linux/pci_ids.h | 2 ++
> > > 
> > > The very top of this file says:
> > > 
> > >  *      Do not add new entries to this file unless the definitions
> > >  *      are shared between multiple drivers.
> > > 
> > > Please add to the commit messages the two or more drivers which share
> > > this definition.
> > 
> > It will be used by ethernet and infiniband driver as we can see now,
> > I'll update the commit message if you think it's a good practice.
> 
> Are you going to submit completely separated infiniband driver that has
> PCI logic in drivers/infiniband without connection todrivers/net/ethernet ...?
> 
> If yes, it is very uncommon in infiniband world.

No, we'll follow the convention, the connection with driver/net/ethernet
is necessary. We've discussed internally that direct ref to VID/DID is not
a good way.

I'll move the VID macro into driver header files for now.
Also thanks for pointing this out, Andrew. 

Cc: Bjorn Helgaas

> 
> I would like to see this PCI patch submitted when it is actually used.
> 
> Thanks
> 
> > 
> > > 
> > > Thanks
> > > 
> > >      Andrew
