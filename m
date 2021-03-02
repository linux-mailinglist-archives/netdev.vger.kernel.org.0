Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9367832A36B
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382170AbhCBI4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:56:37 -0500
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:14416
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1837221AbhCBHkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 02:40:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbdxY+4jocAy/jCHbZFmM60m0i5xtlJjIFbciR7Z1mFoOTiA8bG89AjGu1XYsBCYYdqPXhz6osjdFqa+XiIlvytLsgQxmqVpD8HAkZ2DLgATgOmGWAS9lYpRh/8tvlFN7fPfKHS7B3MPVN73ZDcouC5nPYvFdJr2Xp0LWjpAhrQZRQ8VbJRB+vXu38zLylJzX0Ke/nsKSJ+08yok/ekJJyIMclAJKySi8ljX2iCz+dbosTIh7fXZIRPe2IXqYh8CWLL1YOSwXx35J+G1hhYalNr9JsDqqt60vmen4uAkfm6rsK5MOKx8qcd+ntK2jMZXZBPDW4Jiv8+KETM72v7ylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilG9FI3hAhS+931MzlWsGukeFWJ3fzcmjnDxT+k9kdw=;
 b=c7WYJaW0+guJSj0jagXZ9zWzGeDtzFriGpRRQYze4g0k240zTQ3PK8YI08v6qnj/3Y1dHwEgDQCInKIcHWMJpc3aUA0iTzm/NidLyjlD0OdjXC1jGE4tGHDwQxSRq0XlQYVAu+BwqN/qQ4xJzNQqUvESVwvWGN6l4FvFSV939hQbbbg6mH4wJlZxA0pIQBqC/st93wpRPM6AAjn1fhGvN0q+Rop2RP9iFkWu2Qo8irYo8S+L6jEFHFaEUES9NW0eJSl2bqyHXg8dScezr09q59+Ldy3Q8r1cxtuItfwkdtLnYyhq7pitMuUY6dzdF/h4e21d6d7fAfkNGUBE+2GF/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilG9FI3hAhS+931MzlWsGukeFWJ3fzcmjnDxT+k9kdw=;
 b=iUhezgDfKQmJeVYGmoPHA1iIU7jXQAMrnd2cbg/oQEHCuxooCll5s0JI6Ih0hh+aSSwprPreYTRPumUl2KG70D4srqcPbmrPP3f/d8aRt1eFXvbuIlrgnatRnbNBJ2HO1H0FOPdnl2NsUUyRf/isHAV76ophsDDkt1Mgd3scVHA=
Authentication-Results: codewreck.org; dkim=none (message not signed)
 header.d=none;codewreck.org; dmarc=none action=none
 header.from=synaptics.com;
Received: from BN3PR03MB2307.namprd03.prod.outlook.com
 (2a01:111:e400:7bb1::16) by BN7PR03MB3601.namprd03.prod.outlook.com
 (2603:10b6:406:c7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 2 Mar
 2021 07:39:55 +0000
Received: from BN3PR03MB2307.namprd03.prod.outlook.com
 ([fe80::246d:2f3d:93bf:ee56]) by BN3PR03MB2307.namprd03.prod.outlook.com
 ([fe80::246d:2f3d:93bf:ee56%4]) with mapi id 15.20.3890.030; Tue, 2 Mar 2021
 07:39:55 +0000
Date:   Tue, 2 Mar 2021 15:39:40 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: free what was emitted when read count is 0
Message-ID: <20210302153940.64332d11@xhacker.debian>
In-Reply-To: <YD3BMLuZXIcETtzp@codewreck.org>
References: <20210301103336.2e29da13@xhacker.debian>
        <YDxWrB8AoxJOmScE@odin>
        <20210301110157.19d9ad4e@xhacker.debian>
        <YD3BMLuZXIcETtzp@codewreck.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BY3PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::14) To BN3PR03MB2307.namprd03.prod.outlook.com
 (2a01:111:e400:7bb1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BY3PR03CA0009.namprd03.prod.outlook.com (2603:10b6:a03:39a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 07:39:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaf0b43b-c23e-4a46-bbe6-08d8dd4e5f8c
X-MS-TrafficTypeDiagnostic: BN7PR03MB3601:
X-Microsoft-Antispam-PRVS: <BN7PR03MB3601819280186BDFAC2958D1ED999@BN7PR03MB3601.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OvR/iLBLeKjhRz7X40I1/qFuey/xcyvZTUV0G8p3/8yPVrjL3bwi39yuePaBQRjTBkB9uzbNvCXzNEFSD+7nem+kwpo+ivQ/EKgPhZ66JavV5hOk2jFs5Ae4k+VhTmbsXTgdXUzFVpNAsKNvtTDmHgSOCvccE+2b1zO3baTC8Luwe6reC/51DNujm836DQwqJxXvUfcyaZUWWaIe1mS6mZz5pebVibcshjWt8YoXJWroNUPaiECdD4U9S5WhZza0NCCnx4PYSQTYqhs7Et9moJ/OvaxH3xbFVXoKMD7Zb72FeMwqq/kpNEnH6PgVLps+BR4FzXNt8xE0TjeVXRYPWhNYbbzdUP3n941KG185p4H5J+LtRhCOmux98BvnKTPGmf2IWl/adohgqOrxAp2/ijAlNteizNayNgBW/0LQtedomPnOpkA1RdNM6A7GCwU1sYhUnRZP2EEwDD+Agh69UzsJBR2+5SMFeuwhQzBhmee/AOLDk7RYva6Aue+5Pqv4oW/FMxeaEJkFfegyJ6TrnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN3PR03MB2307.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(6506007)(6666004)(26005)(2906002)(7696005)(86362001)(316002)(83380400001)(478600001)(52116002)(1076003)(186003)(66476007)(54906003)(956004)(16526019)(66556008)(9686003)(5660300002)(8936002)(6916009)(55016002)(4326008)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ixJxUHH7TfgDKBFTlGclfKRo4GVlrtwUD7TtWVHLv8pBUd4PNuESx/Jt66DH?=
 =?us-ascii?Q?gMWS36VMyGFHIBT+7i0xCE2ac2+Pfk/A4z3MMXxQc19ol/BXgeua0WmewEaC?=
 =?us-ascii?Q?+GCak7dkU4TDvXOCwmRAgFaGaFd3O2Q8kNoGcE6ez5UTIgBZu0UJaM/arc8b?=
 =?us-ascii?Q?n+QbDtNxTpCXPM7L+Ub0UakaRxj1Bn7uR05Ana6VQHi+8YawiBibFOYJWysG?=
 =?us-ascii?Q?PN/TjObhu3y1VkiEy0dktPdNHxMfKDliWlbWK7BUw+6rE5fs3C1jdHc66ayr?=
 =?us-ascii?Q?t8MKNoEN+zgtftQJZTsZL8nbHwYtLYsSx0sLFIsj21is2WrMrTkmnn7nFgFT?=
 =?us-ascii?Q?YgqpnsOPkbDsBMqbB34Je3e9whj7Br7WR1SCYfs+B8TZVAUTLwJWUtTjAkA0?=
 =?us-ascii?Q?kNQki3xuCdisH3O0NF3mrFd+d3hV0Zox6Dfg+UuYcmY68imb0xcsdKSWrJ0T?=
 =?us-ascii?Q?DdRLvGpYVm9RN+QTbu2JqBjF7Rzq0Y5de65kmbckoRtIUf/ghzqLh0WzejZ2?=
 =?us-ascii?Q?gFvwtMZHQK8HRVrw3nxzzDSSspVJjLirYr+Gf1SK3WfkAZXGoLO/nvhG7lQx?=
 =?us-ascii?Q?PTXxXLKjQ9Uqsrc+D8nI0g/w1eoTSkDpjTrqrZ6t7XIW3+rtaklpTERSo0eh?=
 =?us-ascii?Q?TiqM3cfLAlrsKYwq1+GoZ8aVIcCcMABuYoUBz2mKNCiOBgk87fFoSix5klJf?=
 =?us-ascii?Q?5vjyGSKt1RNH0azpUtpOzfwzKk+PnAALkuzxprYSGFWMLPX67OLOAlw/t3EG?=
 =?us-ascii?Q?AHITtpqEqOzR98p262iyz3owt+ZK6lON8WjPig/A7Q6B7N7lm7gjyYWkWjlU?=
 =?us-ascii?Q?3BqkLUPANC5Go2u5BrovEPh5QJUfNNMePTVlthLjqOQ09QlQrthm0Vxb3O/S?=
 =?us-ascii?Q?Pkj/7Q8gziS8DYTk/AtG/GnYyq2DEtdqafpDsRL9oGlNTeq88iXpDrw/+DdT?=
 =?us-ascii?Q?YAN1M9LDBhPeGjJBuxyoc3bQqPSkww314FTBeF52ffgIIXgrHh34Kyna2FMK?=
 =?us-ascii?Q?I01k9/UItmDiga37WEplSsO7JibOttSOq2y1oZlc0UUnj7SRUss43NAe3eEN?=
 =?us-ascii?Q?UEaZrOU694IcfUjPIEuQUfdtO+1J9UrMki04V14uEhooCGFof3J9kqF4WX2f?=
 =?us-ascii?Q?0Q6WGvdysEzqQDZPBhv/C7xD8bVh6/Ml0ajMP7WuAcMO3MHlMG/FPMzAIlaD?=
 =?us-ascii?Q?TOi7lMy7JKdDKU8pFmIqk0g2bxBf569tKdVkLrl8ExkRGM7HSg+9EcrPUgC4?=
 =?us-ascii?Q?94z6G7ywWkMBD67GWe6tTxfD5muGGgzpzf0HmMjcds5I6wj39OnFanFeX9D2?=
 =?us-ascii?Q?Bn/eMvrYpGRuKWARTiU/DOsk?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf0b43b-c23e-4a46-bbe6-08d8dd4e5f8c
X-MS-Exchange-CrossTenant-AuthSource: BN3PR03MB2307.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 07:39:55.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2BDsZ7dbMnETflLP+Bju3WsSx/gn8WhsFj2IM86CZxW6dXGOd9cZyua3QammAJ8Uj7NTp8Wt6pUFaSzS4M/cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3601
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 13:38:08 +0900 Dominique Martinet wrote:

> 
> 
> Jisheng Zhang wrote on Mon, Mar 01, 2021 at 11:01:57AM +0800:
> > Per my understanding of iov_iter, we need to call iov_iter_advance()
> > even when the read out count is 0. I believe we can see this common style
> > in other fs.  
> 
> I'm not sure where you see this style, but I don't see exceptions for
> 0-sized read not advancing the iov in general, and I guess this makes
> sense.

for example, function dio_refill_pages() in fs/direct-io.c, and below code piece
from net/core/datagram.c:

                copied = iov_iter_get_pages(from, pages, length,
                                            MAX_SKB_FRAGS - frag, &start);
                if (copied < 0)
                        return -EFAULT;

                iov_iter_advance(from, copied);

As can be seen, for "copied >=0" case, we call iov_iter_advance()

> 
> 
> Rather than make an exception for 0, how about just removing the if as
> follow ?

IMHO, we may need to keep the "if" in current logic. When count
reaches zero, we need to break the "while(iov_iter_count(to))" loop, so removing
the "if" modifying the logic.

> 
> I've checked that the non_zc case (copy_to_iter with 0 size) also works
> to the same effect, so I'm not sure why the check got added in the
> first place... But then again this is old code so maybe the semantics
> changed since 2015.
> 
> 
> ----
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 4f62f299da0c..0a0039255c5b 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -1623,11 +1623,6 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
>         }
> 
>         p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
> -       if (!count) {
> -               p9_tag_remove(clnt, req);
> -               return 0;
> -       }
> -
>         if (non_zc) {
>                 int n = copy_to_iter(dataptr, count, to);
> 
> 
> ----
> 
> If you're ok with that, would you mind resending that way?
> 
> I'd also want the commit message to be reworded a bit, at least the
> first line (summary) doesn't make sense right now: I have no idea
> what you mean by "free what was emitted".
> Just "9p: advance iov on empty read" or something similar would do.

Thanks for the suggestion. I will send a v2 to update the commit msg but
keep the patch as is if you agree with above keeping "if" logic.
> 
> 
> > > cat version? coreutils' doesn't seem to do that on their git)  
> >
> > busybox cat  
> 
> Ok, could reproduce with busybox cat, thanks.
> As expected I can't reproduce with older kernels so will run a bisect
> for the sake of it as time allows
> 

Thanks
