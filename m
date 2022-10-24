Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95D560BEF4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJXXtV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Oct 2022 19:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiJXXsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:48:45 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C133833503C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 15:06:37 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-ZCiO6XYeNbG-reXi1wsRZw-1; Mon, 24 Oct 2022 18:05:37 -0400
X-MC-Unique: ZCiO6XYeNbG-reXi1wsRZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 808B43814583;
        Mon, 24 Oct 2022 22:05:36 +0000 (UTC)
Received: from hog (unknown [10.39.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59F6B2166B35;
        Mon, 24 Oct 2022 22:05:35 +0000 (UTC)
Date:   Tue, 25 Oct 2022 00:05:02 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y1cMDkGJSlG5SS1B@hog>
References: <cover.1665416630.git.sd@queasysnail.net>
 <Y0j+E+n/RggT05km@unreal>
 <Y0kTMXzY3l4ncegR@hog>
 <Y0lCHaGTQjsNvzVN@unreal>
 <166575623691.3451.2587099917911763555@kwain>
 <Y05HeGnTKBY0RVI4@unreal>
 <Y1FTFOsZxELhvWT4@hog>
 <Y1Ty2LlrdrhVvLYA@unreal>
 <Y1ZLvNE3W9Ph+qqJ@hog>
 <Y1ZQLtjs18YOvRXF@unreal>
MIME-Version: 1.0
In-Reply-To: <Y1ZQLtjs18YOvRXF@unreal>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

2022-10-24, 11:43:26 +0300, Leon Romanovsky wrote:
> On Mon, Oct 24, 2022 at 10:24:28AM +0200, Sabrina Dubroca wrote:
> > 2022-10-23, 10:52:56 +0300, Leon Romanovsky wrote:
> > > On Thu, Oct 20, 2022 at 03:54:28PM +0200, Sabrina Dubroca wrote:
> > > > 2022-10-18, 09:28:08 +0300, Leon Romanovsky wrote:
> > > > > On Fri, Oct 14, 2022 at 04:03:56PM +0200, Antoine Tenart wrote:
> > > > > > Quoting Leon Romanovsky (2022-10-14 13:03:57)
> > > > > > > On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> > > > > > > > 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > > > > > > > > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> > > 
> > > <...>
> > > 
> > > > > > - With the revert: IPsec and MACsec can be offloaded to the lower dev.
> > > > > >   Some features might not propagate to the MACsec dev, which won't allow
> > > > > >   some performance optimizations in the MACsec data path.
> > > > > 
> > > > > My concern is related to this sentence: "it's not possible to offload macsec
> > > > > to lower devices that also support ipsec offload", because our devices support
> > > > > both macsec and IPsec offloads at the same time.
> > > > > 
> > > > > I don't want to see anything (even in commit messages) that assumes that IPsec
> > > > > offload doesn't exist.
> > > > 
> > > > I don't understand what you're saying here. Patch #1 from this series
> > > > is exactly about the macsec device acknowledging that ipsec offload
> > > > exists. The rest of the patches is strictly macsec stuff and says
> > > > nothing about ipsec. Can you point out where, in this series, I'm
> > > > claiming that ipsec offload doesn't exist?
> > > 
> > > All this conversation is about one sentence, which I cited above - "it's not possible
> > > to offload macsec to lower devices that also support ipsec offload". From the comments,
> > > I think that you wanted to say "macsec offload is not working due to performance
> > > optimization, where IPsec offload feature flag was exposed from lower device." Did I get
> > > it correctly, now?
> > 
> > Yes. "In the current state" (that I wrote in front of the sentence you
> > quoted) refers to the changes introduced by commit c850240b6c41. The
> > details are present in the commit message for patch 1.
> > 
> > Do you object to the revert, if I rephrase the justification, and then
> > re-add the features that make sense in net-next?
> 
> I don't have any objections.

Would this be ok for the cover letter?

    ----
    The first patch is a revert of commit c850240b6c41 ("net: macsec:
    report real_dev features when HW offloading is enabled"). That
    commit tried to improve the performance of macsec offload by
    taking advantage of some of the NIC's features, but in doing so,
    broke macsec offload when the lower device supports both macsec
    and ipsec offload, as the ipsec offload feature flags were copied
    from the real device. Since the macsec device doesn't provide
    xdo_* ops, the XFRM core rejects the registration of the new
    macsec device in xfrm_api_check.

    I'm working on re-adding those feature flags when offload is
    available, but I haven't fully solved that yet. I think it would
    be safer to do that second part in net-next considering how
    complex feature interactions tend to be.
    ----

Do you want something added to the commit message of the revert as
well?

Thanks.

-- 
Sabrina

