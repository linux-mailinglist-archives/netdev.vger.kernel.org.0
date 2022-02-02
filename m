Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286164A692C
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243271AbiBBAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:25:04 -0500
Received: from mail-dm3nam07on2064.outbound.protection.outlook.com ([40.107.95.64]:51909
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230330AbiBBAZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 19:25:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOPiKfFov6cbs9MnAA2LVKLvejFCE13eOR/t+A6Kl3xvaZ3MLOutaXTWk5jnsvbgVxiL8V443uzPKf8V+PXTBLorg7R3MMwk3n48W1sl56ZM+gmuUxZxpXpEec3ksiNZ2r2mWOOZ8NCtIkSLLbXw2iiRLM8giCxsNzozonwfyoSxVRGBE+W750o73F4ZipLKsaUxKGIF65FPriDkTeJM5eBVF24JW20TrmDFqLVfYUS7YINhLTiEw8qCtUxb+KRzWsv/eiHMb2HWDT52UY2mCxIs1ev8S+ZqL4qbl0i1/xsxLat0vrkWeIezFzJiMvxKCZCN5vaDiOg/y/wGSpFEiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FpMuvoRPvLMOr9isIkbupHiJ5gEWQT0W6qSch19W8T0=;
 b=nBsrfUaWl8Mc6ERCCnTJ/ceE0SYzCjX+bQak7RmWbryqIC5WxIJ8p7g4O3g4h0jUike094+WA5vYH6OyXLoUA+2UzX+swUxJkBKfNyOdl/MUlt8koulEmCHr3iiSVCvVcbvApF558f6gKtPbMw5dCImbUYry5WspGN/41/Ymh2qi4VZUxXLbKTHH0z2BeAGYnefO3vIf0boxaOHkP/aBoZiz7cAAJGNIawZELN/OmhPnWtWBcNcVt4w/2XlWaTIM4n9ucPC4AN7EPA8fLs0KS/5KQsiQMvbtTFeFYHeJl3aObF9kDo0vuhpObyz12d501xDu54CNpkUlVZ8Mwjw+Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpMuvoRPvLMOr9isIkbupHiJ5gEWQT0W6qSch19W8T0=;
 b=Qz2rYybdHluuutEeRvTKBnsLRQbU+fdNOr/DyONMKpDYcB7ok3EbQyCM8qYVEshhI7PgsMQCgldKk5IlNMhdshaynKhtaznVz/SZJJOREdQC4X+uEmW2HBQKjfv1jD0OI4hK9y6qxYliqLi/7mZloFbk/T/3KlRnWf3PXmohmXhjRjSYkjZ8cgExXXexviX3v02jc86V+pWfxCk3HJkSBZOOpos4cVaMUCqQzCwuR6e41dKWD4Tw5rs0GV9m34j7cfTM7uge+FOgDVzkgUzO3nEjRpIHgaLT5LU31DZgd54t2NsnAUsbiIlvIUNoKqjF+FIrz57kgctFv0k77jyO6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1927.namprd12.prod.outlook.com (2603:10b6:903:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Wed, 2 Feb
 2022 00:25:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Wed, 2 Feb 2022
 00:25:00 +0000
Date:   Tue, 1 Feb 2022 20:24:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220202002459.GP1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
 <20220131164318.3da9eae5.alex.williamson@redhat.com>
 <20220201003124.GZ1786498@nvidia.com>
 <20220201100408.4a68df09.alex.williamson@redhat.com>
 <20220201183620.GL1786498@nvidia.com>
 <20220201144916.14f75ca5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201144916.14f75ca5.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0419.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9da6d5aa-b02f-4f96-c91d-08d9e5e272fc
X-MS-TrafficTypeDiagnostic: CY4PR12MB1927:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB192756B3A0B2F573048929EFC2279@CY4PR12MB1927.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qx8PgZ6O5d6vgrqMf5LSaozhfRcZLhZHId5mlXhk/sZKI2b1LFlqsUlDgU6kI1EiOiFwWMldmKflKUE2Evo3yQzO7VyfRFNScYtW8kMDFIhybZuDYYPftjZqokiLMQ832TTAldyRxetOIT2OVtSjClRNWuO6hzLV8jbZMxiiOO4oykxRTk9vjABTAqi0UKVP2BX4M8SVq2DrpbvWNkIaSbDaQJrNFYjkJZ7l2Mm4M28JJfYENm2R4wAooKYxWWXsCp6K6wU+gjVMSxARCAArSXaVHvf2LtKQlVEu5TypUPLpAPSXRaVeYliR3HbB+dKX2UzxGqvwcjYWCh9PpppjHtZEB1xNBqeopah7ZDoSkgLJIlvqwi7f2c7BxR03gPHCBBQnFQ86jKkBsF4wyGMwEZlep0pcm9BOyZnuZAj2RkVO0SqH0uQnwYSJ6T7iO4RlkeFIjl3VHScplA7Ex2sAOG2YdlHvTcCaAyJNHC8XU1J4WPOSoC4EvOSL6I80Py6kolMCSPpaqT1HKgqRHq+HXccQk2cE++6QxJopqIpoL1hsGoM/FOgliPj6/c4H4RJx7MdDAmn4/ugX6a63l6Qhov0l351sjS5MJT/EhPNNLobH9z1XC+5oSkWRDFDVOGDVs0vxSrVgyPb/vUkEFij+/Y4ztYiULqz3Ahqe2Zn4sjfKx+OqgDgZM6WQllPIUWzFvcA9rJPp5wkVAaRsalstw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(186003)(38100700002)(6916009)(508600001)(6486002)(316002)(2906002)(26005)(83380400001)(36756003)(107886003)(1076003)(5660300002)(66946007)(4326008)(33656002)(66476007)(8676002)(8936002)(6506007)(6512007)(66556008)(86362001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PAOwD69bpbzQy/q2nXKbnjlfxYimPI2kUgQGJbWzwUahRtbSL3MnI34xm//2?=
 =?us-ascii?Q?5jGibhCVWxgcMup6oXcohYX0tzJdxvXpcRRpjOc3NgyzXNCoQkF98f+ZTKHD?=
 =?us-ascii?Q?6ntQyInnnaTnUAsmrYypuA0rk6z+XWO9S09Ef/MRmcejHsqT+wjvxj0RgswS?=
 =?us-ascii?Q?KWOpt66sNRdCkSxgx0lnFXqoOTaP0XL8q4ebCCSpPCoWOVAak36JI5RoEhXu?=
 =?us-ascii?Q?djOcJulDRF9VrlfFjvG+TNeDW/4mc0s8iywp8PRdRpjIIW8Tl2X8l+X4YQG2?=
 =?us-ascii?Q?QolL2BNM6GBhtRsTksr8nHfVTRI2xa8iYTvgvlnGIme20yTxkHEjd712iaAg?=
 =?us-ascii?Q?82Nro/2zNYfJJrfhrpKGeahEcRvXVTQM275ZqaxcK6oCDTFbecfreoa/lB3z?=
 =?us-ascii?Q?biOyBINOyv6acdh43MC23UtAv9n6749N61DS4wYtarC7F5DZ0Clva7RAACyu?=
 =?us-ascii?Q?OrNW6Tym2Kh+uVEvaf+Tmk17Es0YWOIsx+zYCRVn+86KqeJAeWn1XBVXeilo?=
 =?us-ascii?Q?prrk0Fyf/0y4n9MBW1ULzpJbGNflls6YM9cmxtUEBMBW/ulCLYGcOgEvTO9p?=
 =?us-ascii?Q?9OOw6jQKn8wYGmPImkm1uUOxDvyuDlhmE3Uw0v+Z7Uyah+M5i4ILefGjmPjT?=
 =?us-ascii?Q?OMYVwG0JQqPVcuChMXJjNcaNdTlb7CJGDLG7SoswDeOYg2ySWa80Y0ijc+lz?=
 =?us-ascii?Q?PVAc5epO11jrZkOV/TKJRzS7DVS4YpeBMxWRDQckMxXdupFOnXMwTSUaH6sL?=
 =?us-ascii?Q?SDU8C/cdWk0eF9K84gPqwPa0rvAlap7B50gSnjhT7T1xoN3V2Q7y0vBbSPj5?=
 =?us-ascii?Q?VYaBTSkEBWC2WE0PIlDF6RFQg+3cw4xCYEgHnbfnxY8sqlRKL+lvdAmu50ol?=
 =?us-ascii?Q?aryEMjzNcEbcMxk1iehYu2FCAIYYAlbjHThr1pVGz4Wa2M/VHJCFfJfBQGp3?=
 =?us-ascii?Q?IX4oSOc1artEH2DC5diccZsV7k9JgN3+kzTPsJt9nJjKNm9uYZ9MSEA+RB/P?=
 =?us-ascii?Q?3EVnt/gR6+lL2yUpQKEsROzobqaklsSacbX4Uz3AxLYzjVOAT/ObTOOwzmwv?=
 =?us-ascii?Q?j4SG5wi3XdtBct/DIOqe0ZU9n/gnSXsNVxt+V4DU55UDvqT9nGnhBCMf3Cw9?=
 =?us-ascii?Q?qfSgAqh6PXHtKwY1LaNG57gA/CtOfiBPUx8moENdnpNPWCY1NhhNbY3YckRJ?=
 =?us-ascii?Q?WCzxRKv8QSZlpJO5v2lpe4ckK0OuBFGlu6HO4hQQz25A+oPJyJcWOo3+LA2X?=
 =?us-ascii?Q?tUve7Jlf+IOsBltn0rRdLth6RfKr8KFjmtj6AxKJfXQtGYhfSAUr+Agkr5xM?=
 =?us-ascii?Q?aQyYoJJwN8cbV5AFN0W1weWO2PoYGcW8G1V9DCgBozQRI8vMuZjZAB/rAzXf?=
 =?us-ascii?Q?3slPYog7Kpr6KOt0eLeqbJU+nNI74puuW3PuByYI+KyywBI5r86B6j3Ew42B?=
 =?us-ascii?Q?tlV/A0bmtXxqmZuHaAKcMelhuO63ufhMUclhrs4MrURSiy4HBk223r8t9Cm3?=
 =?us-ascii?Q?O8oIXYC8lLqchGIjOFzRibw6yE/AfMjRvcJG7Ws2nqH3en7x6H7I2t2KScHb?=
 =?us-ascii?Q?raIvMQNWGSyNgr6guzA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da6d5aa-b02f-4f96-c91d-08d9e5e272fc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 00:25:00.5424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTBSZCE0ljeQs4NRxsqtePFKv6N4vqM8HIm7LUB2EO2NguvOq7BSLpelvEhpzYg3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1927
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 02:49:16PM -0700, Alex Williamson wrote:
> On Tue, 1 Feb 2022 14:36:20 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Feb 01, 2022 at 10:04:08AM -0700, Alex Williamson wrote:
> > 
> > > Ok, let me parrot back to see if I understand.  -ENOTTY will be
> > > returned if the ioctl doesn't exist, in which case device_state is
> > > untouched and cannot be trusted.  At the same time, we expect the user
> > > to use the feature ioctl to make sure the ioctl exists, so it would
> > > seem that we've reclaimed that errno if we believe the user should
> > > follow the protocol.  
> > 
> > I don't follow - the documentation says what the code does, if you get
> > ENOTTY returned then you don't get the device_state too. Saying the
> > user shouldn't have called it in the first place is completely
> > correct, but doesn't change the device_state output.
> 
> The documentation says "...the device state output is not reliable", and
> I have to question whether this qualifies as a well specified,
> interoperable spec with such language.  We're essentially asking users
> to keep track that certain errnos result in certain fields of the
> structure _maybe_ being invalid.

So you are asking to remove "is not reliable" and just phrase is as:

"device_state is updated to the current value when -1 is returned,
except when these XXX errnos are returned?

(actually userspace can tell directly without checking the errno - as
if -1 is returned the device_state cannot be the requested target
state anyhow)

> Now you're making me wonder how much I care to invest in semantic
> arguments over extended errnos :-\

Well, I know I don't :) We don't have consistency in the kernel and
userspace is hard pressed to make any sense of it most of the time,
IMHO. It just doesn't practically matter..

> > We don't know the device_state in the core code because it can only be
> > read under locking that is controlled by the driver. I hope when we
> > get another driver merged that we can hoist the locking, but right now
> > I'm not really sure - it is a complicated lock.
> 
> The device cannot self transition to a new state, so if the core were
> to serialize this ioctl then the device_state provided by the driver is
> valid, regardless of its internal locking.

It is allowed to transition to RUNNING due to reset events it captures
and since we capture the reset through the PCI hook, not from VFIO,
the core code doesn't synchronize well. See patch 14

> Whether this ioctl should be serialized anyway is probably another good
> topic to breach.  Should a user be able to have concurrent ioctls
> setting conflicting states?

The driver is required to serialize, the core code doesn't touch any
global state and doesn't need serializing.

> I'd suggest that ioctl return structure is only valid at all on
> success and we add a GET interface to return the current device

We can do this too, but it is a bunch of code to achieve this and I
don't have any use case to read back the device_state beyond debugging
and debugging is fine with this. IMHO

> It's entirely possible that I'm overly averse to ioctl proliferation,
> but for every new ioctl we need to take a critical look at the proposed
> API, use case, applicability, and extensibility.  

This is all basicly the same no matter where it is put, the feature
multiplexer is just an ioctl in some semi-standard format, but the
vfio pattern of argsz/flags is also a standard format that is
basically the same thing.

We still need to think about extensibility, alignment, etc..

The problem I usually see with ioctls is not proliferation, but ending
up with too many choices and a big ?? when it comes to adding
something new.

Clear rules where things should go and why is the best, it matters
less what the rules actually are IMHO.

> > I don't want to touch capabilities, but we can try to use feature for
> > set state. Please confirm this is what you want.
> 
> It's a team sport, but to me it seems like it fits well both in my
> mental model of interacting with a device feature, without
> significantly altering the uAPI you're defining anyway.

Well, my advice is that ioctls are fine, and a bit easier all around.
eg strace and syzkaller are a bit easier if everything neatly maps
into one struct per ioctl - their generator tools are optimized for
this common case.

Simple multiplexors are next-best-fine, but there should be a clear
idea when to use the multiplexer, or not.

Things like the cap chains enter a whole world of adventure for
strace/syzkaller :)

> > You'll want the same for the PRE_COPY related information too?
> 
> I hadn't gotten there yet.  It seems like a discontinuity to me that
> we're handing out new FDs for data transfer sessions, but then we
> require the user to come back to the device to query about the data its
> reading through that other FD.  

An earlier draft of this put it on the data FD, but v6 made it fully
optional with no functional impact on the data FD. The values decrease
as the data FD progresses and increases as the VM dirties data - ie it
is 50/50 data_fd/device behavior.

It doesn't matter which way, but it feels quite weird to have the main
state function is a FEATURE and the precopy query is an ioctl.

> Should that be an ioctl on the data stream FD itself?  

I can be. Implementation wise it is about a wash.

> Is there a use case for also having it on the STOP_COPY FD?

I didn't think of one worthwhile enough to mandate implementing it in
every driver.

> > If we are into these very minor nitpicks does this mean you are OK
> > with all the big topics now?
> 
> I'm not hating it, but I'd like to see buy-in from others who have a
> vested interest in supporting migration.  I don't see Intel or Huawei
> on the Cc list and the original collaborators of the v1 interface
> from

That is an oversight, I'll ping them. I think people have been staying
away until the dust settles.

> NVIDIA have been silent through this redesign.

We've reviewed this internally with them. They reserve judgement on
the data transfer performance until they work on it, but functionally
it has all the necessary semantics.

They have the same P2P issue mlx5 does, and are happy with the
solution under the same general provisions as already discussed for
the Huawei device - RUNNING_P2P is sustainable only while the device
is not touched - ie the VCPU is halted.

The f_ops implemenation we used for mlx5 is basic, the full
performance version would want to use the read/write_iter() fop with
async completions to support the modern zero-copy iouring based data
motion in userspace. This is all part of the standard FD abstraction
and why it is appealing to use it.

Thanks,
Jason
