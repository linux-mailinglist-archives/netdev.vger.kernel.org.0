Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275CC663E7B
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbjAJKpv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Jan 2023 05:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238059AbjAJKpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:45:45 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B60DE92
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:45:45 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-yku-WrMtP0uD7s8VMIN2pA-1; Tue, 10 Jan 2023 05:45:38 -0500
X-MC-Unique: yku-WrMtP0uD7s8VMIN2pA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 402B585CBE8;
        Tue, 10 Jan 2023 10:45:38 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E7DA22166B26;
        Tue, 10 Jan 2023 10:45:36 +0000 (UTC)
Date:   Tue, 10 Jan 2023 11:44:13 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     ehakim@nvidia.com, netdev@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v7 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y71BfSFAtZJoker5@hog>
References: <20230109085557.10633-1-ehakim@nvidia.com>
 <20230109085557.10633-2-ehakim@nvidia.com>
 <Y7wvWOZYL1t7duV/@hog>
 <167334021775.17820.2386827809582589477@kwain.local>
MIME-Version: 1.0
In-Reply-To: <167334021775.17820.2386827809582589477@kwain.local>
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

2023-01-10, 09:43:37 +0100, Antoine Tenart wrote:
> Quoting Sabrina Dubroca (2023-01-09 16:14:32)
> > 2023-01-09, 10:55:56 +0200, ehakim@nvidia.com wrote:
> > > @@ -3840,6 +3835,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
> > >       if (ret)
> > >               goto cleanup;
> > >  
> > > +     if (data[IFLA_MACSEC_OFFLOAD]) {
> > > +             ret = macsec_update_offload(dev, nla_get_u8(data[IFLA_MACSEC_OFFLOAD]));
> > > +             if (ret)
> > > +                     goto cleanup;
> > > +     }
> > > +
> > >       /* If h/w offloading is available, propagate to the device */
> > >       if (macsec_is_offloaded(macsec)) {
> > >               const struct macsec_ops *ops;
> > 
> > There's a missing rollback of the offloading status in the (probably
> > quite unlikely) case that mdo_upd_secy fails, no? We can't fail
> > macsec_get_ops because macsec_update_offload would have failed
> > already, but I guess the driver could fail in mdo_upd_secy, and then
> > "goto cleanup" doesn't restore the offloading state.  Sorry I didn't
> > notice this earlier.
> > 
> > In case the IFLA_MACSEC_OFFLOAD attribute is provided and we're
> > enabling offload, we also end up calling the driver's mdo_add_secy,
> > and then immediately afterwards mdo_upd_secy, which probably doesn't
> > make much sense.
> > 
> > Maybe we could turn that into:
> > 
> >     if (data[IFLA_MACSEC_OFFLOAD]) {
> 
> If data[IFLA_MACSEC_OFFLOAD] is provided but doesn't change the
> offloading state, then macsec_update_offload will return early and
> mdo_upd_secy won't be called.

Ouch, thanks for catching this.

> 
> >         ... macsec_update_offload
> >     } else if (macsec_is_offloaded(macsec)) {
> >         /* If h/w offloading is available, propagate to the device */
> >         ... mdo_upd_secy
> >     }
> > 
> > Antoine, does that look reasonable to you?
> 
> But yes I agree we can improve the logic. Maybe something like:
> 
>   prev_offload = macsec->offload;
>   offload = data[IFLA_MACSEC_OFFLOAD];

That needs to be under if (data[IFLA_MACSEC_OFFLOAD]) and then the
rest gets a bit messy.

> 
>   if (prev_offload != offload) {
>       macsec_update_offload(...)
>   } else if (macsec_is_offloaded(macsec)) {
>       ...
>       prev_offload can be used to restore the offloading state on
>       failure here.
>   }

We also have a prev != new test at the start of macsec_update_offload,
the duplication is a bit ugly. We could move it out and then only call
macsec_update_offload when there is a change to do, both from
macsec_changelink and macsec_upd_offload.

Since we don't need to restore in the second branch, and we can only
fetch IFLA_MACSEC_OFFLOAD when it's present, maybe:

    change = false;
    if (data[IFLA_MACSEC_OFFLOAD]) {
        offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
        if (macsec->offload != offload) {
            change = true;
            macsec_update_offload ...cleanup
        }
    }
    
    if (!change && macsec_is_offloaded(macsec)) {
        ...
    }

Or let macsec_update_offload do the macsec->offload != offload test
and pass &change so that changelink can know what to do next.

-- 
Sabrina

