Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B9B59783E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbiHQUrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiHQUrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:47:15 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2428BA74F4
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 13:47:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtPxRcYaJxZzKcoKCEohp/eVgllHIlWYwyK9ap8+854b/MvRSAV4L4zvnfubH1K3663kGZd5uzi09YUc4UPUmqQya6eGbsAs+QB0qdYLL5+cQ9b4AJvOV1mmi56tXUPFIDYe9Ur5yVg6zY5vBAYzo/PCeIsxAmShwxo8kPDwyaWrx6ccTr/IwsSaP7JgoysiquSZPZsZS7PWa5BBPHVHl2avKRgq+vAV0uXXgBpHrM0uHy485eGDh5rkW/1RTlpHtCNKjHWpTSOXU5X27Ndr5tLlRy2FP0RZ8+WCu7vgTLaEv4hha2QA5mrWwJKgve80Szr+X3ySFZz65bGxLDG8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aeFv1lRZ+i8KOE8vBLXSTDbrrjNswwp4mNExkaAUWHc=;
 b=aXCxM/wJYq+6N6LUJAAMw5OkOSB4D2Ixh5l4Av2qrA6RLC3A1mUV3ruckq/6iHyFZPVzIbXht6ribGpDzjuJ9/AoXj2qbqFfvtsESKpuzNu9VyTCdPz1+nL0uOo00mrMYUCPkWNH67gBjQwvWHJm1zggNBJiQAZkwye2oJvwTBkdNX5L1qpHeYwzQdc13f8loTDMGqrdmZ/aLrACdmOhzeL7XAtUndTo9j+pFtMaHyNDEE1MhMzLIJVc3XKz9dadpJH84PB+vLXZ1sD9K+WM9C5atJ3bWk3d77Obv6Sw2QE9z9WM/laKM3OR2f2+SLkn1lkDXbfX5VgnBOawovD7nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeFv1lRZ+i8KOE8vBLXSTDbrrjNswwp4mNExkaAUWHc=;
 b=phhf4MVkGy8ysWGCU5wM23jLnxDluVkzG7f46TMwc7KJhlQf2wSSzvtSVvyrtdvLMcy1eWyuxpOZuxKvTlVtXfekA8A6mRtEd6tUE4Z37qVBr5Z2r/6rvohalwyENdkxDPMtzggd5bXecD0CT/VWAsBModYhkJ3m1vXbTNPA2JA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB2572.namprd10.prod.outlook.com
 (2603:10b6:5:b3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 20:47:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 20:47:12 +0000
Date:   Wed, 17 Aug 2022 13:47:07 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net 6/8] net: mscc: ocelot: make struct
 ocelot_stat_layout array indexable
Message-ID: <Yv1Tyy7mmHW1ltCP@colin-ia-desktop>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-7-vladimir.oltean@nxp.com>
 <YvyO1kjPKPQM0Zw8@euler>
 <20220817110644.bhvzl7fslq2l6g23@skbuf>
 <20220817130531.5zludhgmobkdjc32@skbuf>
 <Yv0FwVuroXgUsWNo@colin-ia-desktop>
 <20220817174226.ih5aikph6qyc2xtz@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817174226.ih5aikph6qyc2xtz@skbuf>
X-ClientProxiedBy: BYAPR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:a03:114::36) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77e89a65-065a-446b-f67d-08da8091a8b6
X-MS-TrafficTypeDiagnostic: DM6PR10MB2572:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8TQbxwpBZZxeGfnSMWED06v32ggOBLsnJRARcrbrGeG8DhR/LWVvQYj+VC15P+gJZgzGI5wG5nYusJ4WR6WHDNkqj+Tvt8onzd/iUjAqgmArXq/PfGXxxhGFIJIy4xqfh7XQqx/HXZVIgbcl41fsbnjR5x0eLOGO8z6z1/TrxiWQ1UiaGK9Pn0QjWVpU/LV37Rf48sp59YNtGLbwpBUIEEJ5BJyST0WOKOjTzyipzcqK2BO9CP0K3BgrQMFZMtmOnKGb3/AbGvUyKYH/CFDEVYcGyDS0RFXp5aHSlFGtDjHIGd/WeHek+udHDc3yAqCxnciLl/vFWGNDHOiZLow4nJZd55tSh1yOp2KWDnq5zD18paH2fQte9xvmORHwiY8Y5pVsPExEuLEt0/tTfz9aHyI0VlkYdv5/DHJd24Toro/6W3Q/jtlF+Bp1OkZPm67srn4w0J8SAbL8osRIUh+APHn5EWU+1lIkgxOXUt34U0FjkyOUZ/wD6KALZvy9TwUKFG6VX2oJpcBvDtPDw1ueyDd9dnJeBEsR5uOCG7hXY75L7uRbrKa9dIOyf9BQu5ksUQUHFGVx7GLr1Az794FgdTtOkkhvwvt+DgqHDXHr126gF3ykAkClzfgiGUj/h7MnA86RdlZhDdr1eBIZwLiUgqwwDMzJVMcArD8xy+frSHJeMNGn0AMEUq3Hi3f77F5v28APlRgcNQMjvvOvH2oAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(366004)(396003)(136003)(39830400003)(376002)(33716001)(478600001)(6486002)(66946007)(66476007)(66556008)(8676002)(4326008)(6512007)(9686003)(44832011)(26005)(7416002)(5660300002)(2906002)(6506007)(41300700001)(6666004)(86362001)(38100700002)(8936002)(316002)(186003)(83380400001)(6916009)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fPHPe5z2EyZtfS7XJ/5s22Bf2KxXOK6yxRxARDXcqcRbQoavxAbvHXpbhYtw?=
 =?us-ascii?Q?C76IYbZnWk59RVEZlHpDGvufFq3qKI0pu0FXArV7ujErYn0h72vYTrjrFwPp?=
 =?us-ascii?Q?3BI4DZ7ZgmpWL3enTPi5BqYOARXnUDiRDfmNosl3sfp5RLjPoQIQ7nBA9IgO?=
 =?us-ascii?Q?2tyCGnOTpW6fl/OnctGaSXfWIdISCS6xp9s9s1mt3qbBoYKUw66JmfZSgCL0?=
 =?us-ascii?Q?rMa/DjS8A/yIsl/LXKm5XbVZCOKyqDQiM3TBwpiFtn0q4dLhn29WVdgUejgU?=
 =?us-ascii?Q?Zdo0vYHCV6Dmqyz/AttYJBd00ZCocKqNRt4o3Aic/mtV/obNk3IXIGbwAODl?=
 =?us-ascii?Q?6UpUsxC27yp729tuc1v1muAh0iaX7aqBgsxkM2AS5Wp7e1boU1jJnePSC4Rd?=
 =?us-ascii?Q?jQQLG0xFnbqzb9qcKhU5BmUXfY/VYIA36jPAUZARNH4vreH/9Mxtgk+hih4z?=
 =?us-ascii?Q?qaX2WC63a7MOsxkp/IKraWqPige17NJqONWL8z1oKr2ZDvggQPiSn8hu75Rx?=
 =?us-ascii?Q?nQQmR4ItSmMYP6pg2lR6qAjqik5JwR77xE0jmBCX4Y64PNqBvwF+t6H5ObKP?=
 =?us-ascii?Q?z3ruR/oXSvDkZGqa8OtIfkd0utpppw1gTq0H3woXrpJtR80f8jn5HPUddavB?=
 =?us-ascii?Q?pX8u9tOXIOalvUx3tIoN9/JAqGYwcMBokMve+Wj9i2eocv6L0YV94Tab2Egy?=
 =?us-ascii?Q?FZ3+cRHujJB4vxwCZyJe2PpeBaEDhIMfzER6cMbC8wgZ4aXB4NEJVcgf5H5W?=
 =?us-ascii?Q?DFZWCP9iIEx/ezGNG7RMIEa8qZVmORbbIq3m+BjH4cv9C6XvWDvf2gj7LZPc?=
 =?us-ascii?Q?cqZzUESOo0+CHNvQfjoWrPuc3qxnA4TcPp4h0+B/VJ+Any6PmZm08LcBYiKI?=
 =?us-ascii?Q?1rIIjWdkXBXyQaBne68g4DNr92qKbS8i2Ul8bmhPYeQKGy+t6+z+XCslWYyG?=
 =?us-ascii?Q?cXOA8dCVtEadad5o3RxiwOvmASXryMeIuUQm7PLoPwZ43d5Ix3fxesKb53Ad?=
 =?us-ascii?Q?hXDw9qroEIIKZhW5oNqPwaEExk3ihVSVzihKYR7MVpLIF8v46SxIFRdj31qt?=
 =?us-ascii?Q?Sy2iMiPV0qvvuXakK6DB2cpXERzsBLATE1hObQjXfNqohpTgqreGM0p+sJKR?=
 =?us-ascii?Q?ZYv862kNd2YohFUknT++xCpF0uCNqLgMrrarGOcOQdCiKRWJtQ4HCZxs3SAe?=
 =?us-ascii?Q?CrZQ75SAcoBf2+BXGoERBJk3g49IMmEQt7NgxnygNGNU2m3Lq7cKANMP9Y2w?=
 =?us-ascii?Q?jCAcWKOzXymHqV5aLcTqfD6iP02d6OUQ1JCGMmctJPpS4o4Fd/IoXaVS0vAw?=
 =?us-ascii?Q?oSK1noiYG7Vr491U8FIiMxoUBenr79jRTXKqL4N/jIDJoqPDgM+bqkMgRN+F?=
 =?us-ascii?Q?Yj7V3p9TUXs4n5gYJJNYM583rdeiDCKwyznyaCIPQMfkmPm4TRD8LwQa27eG?=
 =?us-ascii?Q?f2BM2nQcmkgRohBMlri0YFUc0Gi+guuKgocqkeUrreVZWtDvjo2fJdtJgQN0?=
 =?us-ascii?Q?y76ygaGqHaMGWcb9/H8evTSWhuAcSFyq9kWPcm4489UMAtovNM3vzHGDaB7j?=
 =?us-ascii?Q?GMzU2KeqXy99xklmpzRcsZxqYF44svDeBT74zxtIvVJXf+YVhumFmmq5jiqI?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e89a65-065a-446b-f67d-08da8091a8b6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 20:47:11.9741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pPWgq+hnI8VKT9LselxLMGB2cfujde+hQJj6XV96cSe9aQsBMIPB3wkDwZZNlj9A9CBZHq2f5kY/yJLozn72Bj/Xi5QHv3RcvZ4OKNLRViU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2572
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 05:42:27PM +0000, Vladimir Oltean wrote:
> On Wed, Aug 17, 2022 at 08:14:09AM -0700, Colin Foster wrote:
> > On Wed, Aug 17, 2022 at 01:05:32PM +0000, Vladimir Oltean wrote:
> > > On Wed, Aug 17, 2022 at 02:06:44PM +0300, Vladimir Oltean wrote:
> > > > I think in practice this means that ocelot_prepare_stats_regions() would
> > > > need to be modified to first sort the ocelot_stat_layout array by "reg"
> > > > value (to keep bulking efficient), and then, I think I'd have to keep to
> > > > introduce another array of u32 *ocelot->stat_indices (to keep specific
> > > > indexing possible). Then I'd have to go through one extra layer of
> > > > indirection; RX_OCTETS would be available at
> > > > 
> > > > ocelot->stats[port * OCELOT_NUM_STATS + ocelot->stat_indices[OCELOT_STAT_RX_OCTETS]].
> > > > 
> > > > (I can wrap this behind a helper, of course)
> > > > 
> > > > This is a bit complicated, but I'm not aware of something simpler that
> > > > would do what you want and what I want. What are your thoughts?
> > > 
> > > Or simpler, we can keep enum ocelot_stat sorted in ascending order of
> > > the associated SYS_COUNT_* register addresses. That should be very much
> > > possible, we just need to add a comment to watch out for that. Between
> > > switch revisions, the counter relative ordering won't differ. It's just
> > > that RX and TX counters have a larger space between each other.
> > 
> > That's what I thought was done... enum order == register order. But
> > that's a subtle, currently undocumented "feature" of my implementation
> > of the bulk reads. Also, it now relies on the fact that register order
> > is the same between hardware products - that's the new requirement that
> > I'm addressing.
> > 
> > I agree it would be nice to not require specific ordering, either in the
> > display order of `ethtool -S` or the definition order of enum
> > ocelot_stat. That's telling me that at some point someone (likely me?)
> > should probably write a sorting routine to guarantee optimized reads,
> > regardless of how they're defined or if there are common / unique
> > register sets.
> > 
> > The good thing about the current implementation is that the worst case
> > scenario is it will just fall back to the original behavior. That was
> > intentional.
> 
> How about we add this extra check?
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
> index d39908c1c6c9..85259de86ec2 100644
> --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> @@ -385,7 +385,7 @@ EXPORT_SYMBOL(ocelot_port_get_stats64);
>  static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
>  {
>  	struct ocelot_stats_region *region = NULL;
> -	unsigned int last;
> +	unsigned int last = 0;
>  	int i;
>  
>  	INIT_LIST_HEAD(&ocelot->stats_regions);
> @@ -402,6 +402,12 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
>  			if (!region)
>  				return -ENOMEM;
>  
> +			/* enum ocelot_stat must be kept sorted in the same
> +			 * order as ocelot->stats_layout[i].reg in order to
> +			 * have efficient bulking.
> +			 */
> +			WARN_ON(last >= ocelot->stats_layout[i].reg);
> +
>  			region->base = ocelot->stats_layout[i].reg;
>  			region->count = 1;
>  			list_add_tail(&region->node, &ocelot->stats_regions);
> 
> If not, help me understand the concern better.

You get my concern. That's a good comment / addition. Gaps are welcome
in the register layout, but moving backwards will ensure (in the current
implementation) inefficiencies.

> 
> > Tangentially related: I'm having a heck of a time getting the QSGMII
> > connection to the VSC8514 working correctly. I plan to write a tool to
> > print out human-readable register names. Am I right to assume this is
> > the job of a userspace application, translating the output of
> > /sys/kernel/debug/regmap/ reads to their datasheet-friendly names, and
> > not something that belongs in some sort of sysfs interface? I took a
> > peek at mv88e6xxx_dump but it didn't seem to be what I was looking for.
> 
> Why is the mv88e6xxx_dump kind of program (using devlink regions) not
> what you're looking for?

I suspect the issue I'm seeing is that there's something wrong with the
HSIO registers that control the QSGMII interface between the 7512 and
the 8514. Possibly something with PLL configuration / calibration? I
don't really know yet, and bouncing between the source
(ocelot_vsc7514.c, {felix,ocelot-ext}.c, phy-ocelot-serdes.c), the
reference design software, and the datasheet is slowing me down quite a
bit. Unless I am mistaken, it feels like the problems I'm chasing down
are at the register <> datasheet interface and not something exposed
through any existing interfaces.

I plan to get some internal support on that front that can hopefully
point me in the right direction, or find what I have set up incorrectly.
Otherwise it probably doesn't even make sense to send out anything for
review until the MFD set gets accepted. Though maybe I'm wrong there.

I'd also like to try to keep my patch version count down to one nibble
next time, so I'm planning on keeping ports 0-3 and ports 4-7+ in
separate patch sets :D

> 
> There's also ethtool --register-dump which some DSA drivers have support
> for (again, mv88e6xxx), but I think that's mainly per port.
> 
> I tried to add support for devlink regions to dump the PGIDs, but doing
> this from the common ocelot switch lib is a PITA, because in the devlink
> callbacks, we need to access the struct ocelot *ocelot from the
> struct devlink *devlink. But DSA keeps the devlink pointer one way, and
> the ocelot switchdev driver another. To know how to retrieve the ocelot
> pointer from the devlink pointer, you'd need to know where to search for it.
> 
> So I'm thinking, if we add devlink regions to ocelot, it would be just
> for DSA for now.
