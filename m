Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43801606246
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJTNzQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Oct 2022 09:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJTNzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:55:12 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EA3844C9
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 06:55:05 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-6TJWXZgnMo6WwPDmHBxJ2w-1; Thu, 20 Oct 2022 09:54:59 -0400
X-MC-Unique: 6TJWXZgnMo6WwPDmHBxJ2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB29E185A7A3;
        Thu, 20 Oct 2022 13:54:58 +0000 (UTC)
Received: from hog (unknown [10.39.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A12CA40C83DA;
        Thu, 20 Oct 2022 13:54:57 +0000 (UTC)
Date:   Thu, 20 Oct 2022 15:54:28 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y1FTFOsZxELhvWT4@hog>
References: <cover.1665416630.git.sd@queasysnail.net>
 <Y0j+E+n/RggT05km@unreal>
 <Y0kTMXzY3l4ncegR@hog>
 <Y0lCHaGTQjsNvzVN@unreal>
 <166575623691.3451.2587099917911763555@kwain>
 <Y05HeGnTKBY0RVI4@unreal>
MIME-Version: 1.0
In-Reply-To: <Y05HeGnTKBY0RVI4@unreal>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-10-18, 09:28:08 +0300, Leon Romanovsky wrote:
> On Fri, Oct 14, 2022 at 04:03:56PM +0200, Antoine Tenart wrote:
> > Quoting Leon Romanovsky (2022-10-14 13:03:57)
> > > On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> > > > 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > > > > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> > > > > > I'm working on a dummy offload for macsec on netdevsim. It just has a
> > > > > > small SecY and RXSC table so I can trigger failures easily on the
> > > > > > ndo_* side. It has exposed a couple of issues.
> > > > > > 
> > > > > > The first patch will cause some performance degradation, but in the
> > > > > > current state it's not possible to offload macsec to lower devices
> > > > > > that also support ipsec offload. 
> > > > > 
> > > > > Please don't, IPsec offload is available and undergoing review.
> > > > > https://lore.kernel.org/netdev/cover.1662295929.git.leonro@nvidia.com/
> > > > > 
> > > > > This is whole series (XFRM + driver) for IPsec full offload.
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
> > > 
> > > > That patchset is also doing nothing to address the issue I'm refering
> > > > to here, where xfrm_api_check rejects the macsec device because it has
> > > > the NETIF_F_HW_ESP flag (passed from the lower device) and no xfrmdev_ops.
> > > 
> > > Of course, why do you think that IPsec series should address MACsec bugs?
> > 
> > I was looking at this and the series LGTM. I don't get the above
> > concern, can you clarify?
> > 
> > If a lower device has both IPsec & MACsec offload capabilities:
> > 
> > - Without the revert: IPsec can be offloaded to the lower dev, MACsec
> >   can't. That's a bug.
> 
> And how does it possible that mlx5 macsec offload work?

Well, I don't know. AFAICT, xfrm_api_check will be called for every
new net_device created in the system, so a new macsec device with
NETIF_F_HW_ESP will be rejected. Am I missing something?

I don't have access to mlx5 NICs with macsec offload so I can't check
how that would work. My guess is that for some reason, the mlx5 driver
didn't expose the NETIF_F_HW_ESP feature (CONFIG_MLX5_EN_IPSEC=n?).
The only other possibility I see is CONFIG_XFRM=n.

> 
> > 
> > - With the revert: IPsec and MACsec can be offloaded to the lower dev.
> >   Some features might not propagate to the MACsec dev, which won't allow
> >   some performance optimizations in the MACsec data path.
> 
> My concern is related to this sentence: "it's not possible to offload macsec
> to lower devices that also support ipsec offload", because our devices support
> both macsec and IPsec offloads at the same time.
> 
> I don't want to see anything (even in commit messages) that assumes that IPsec
> offload doesn't exist.

I don't understand what you're saying here. Patch #1 from this series
is exactly about the macsec device acknowledging that ipsec offload
exists. The rest of the patches is strictly macsec stuff and says
nothing about ipsec. Can you point out where, in this series, I'm
claiming that ipsec offload doesn't exist?

-- 
Sabrina

