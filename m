Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8622667C8D3
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbjAZKmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbjAZKmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:42:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF745688C;
        Thu, 26 Jan 2023 02:42:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F8FE617A3;
        Thu, 26 Jan 2023 10:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24A1C433D2;
        Thu, 26 Jan 2023 10:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674729732;
        bh=xW9HRR8a9oajieaxS1LWPtit9dg4vphLwBMUXfq8ERQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rV0Chr7piTtIcyMjMupZz/Sa/O2hbYSFnkfEMLSGpfXRWjQRUUsKAagGwfHGUu8m2
         2f7YsnHwth8dfOpc49W4iHIPfnf/nRNEZBDvkLcTlwhfqwVOKcb9nLuEBXEXYAmAy5
         ncBs/YZL/b9VDJTreShkTQtmF1LIurRaaxQDdmcWbPHB2+Lxu3RbchfURLdN6cnROr
         LqYu7yzvmuwKSQrq+jO5pwxelcSRU3q1ZHZrBVIcri6OFQHkLn+dWNngVEtJ/Elfzg
         R6WHtJ9NGq08qVxOD5TUxaXC2gIfLY9LJmkAYADp9ROB/Xs9XVLunX7h34jWts+GJW
         ORXa5mJ7q3GOg==
Date:   Thu, 26 Jan 2023 12:42:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next v1 01/10] xfrm: extend add policy callback to
 set failure reason
Message-ID: <Y9JZAEa6HkLMfs2P@unreal>
References: <cover.1674560845.git.leon@kernel.org>
 <c182cae29914fa19ce970859e74234d3de506853.1674560845.git.leon@kernel.org>
 <20230125110226.66dc7eeb@kernel.org>
 <Y9Irgrgf3uxOjwUm@unreal>
 <75f6e5d0e42a8b9895c1b2330c373da9ed7f41db.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75f6e5d0e42a8b9895c1b2330c373da9ed7f41db.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 10:45:50AM +0100, Paolo Abeni wrote:
> On Thu, 2023-01-26 at 09:28 +0200, Leon Romanovsky wrote:
> > On Wed, Jan 25, 2023 at 11:02:26AM -0800, Jakub Kicinski wrote:
> > > On Tue, 24 Jan 2023 13:54:57 +0200 Leon Romanovsky wrote:
> > > > -	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp);
> > > > +	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
> > > >  	if (err) {
> > > >  		xdo->dev = NULL;
> > > >  		xdo->real_dev = NULL;
> > > >  		xdo->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
> > > >  		xdo->dir = 0;
> > > >  		netdev_put(dev, &xdo->dev_tracker);
> > > > -		NL_SET_ERR_MSG(extack, "Device failed to offload this policy");
> > > 
> > > In a handful of places we do:
> > > 
> > > if (!extack->msg)
> > > 	NL_SET_ERR_MSG(extack, "Device failed to offload this policy");
> > > 
> > > in case the device did not provide the extack.
> > > Dunno if it's worth doing here.
> > 
> > Honestly, I followed devlink.c which didn't do that, but looked again
> > and found that devlink can potentially overwrite messages :)
> > 
> > For example in this case:
> >     997         err = ops->port_fn_state_get(port, &state, &opstate, extack);
> >     998         if (err) {
> >     999                 if (err == -EOPNOTSUPP)
> >    1000                         return 0;
> >    1001                 return err;
> >    1002         }
> >    1003         if (!devlink_port_fn_state_valid(state)) {
> >    1004                 WARN_ON_ONCE(1);
> >    1005                 NL_SET_ERR_MSG_MOD(extack, "Invalid state read from driver");
> >    1006                 return -EINVAL;
> >    1007         }
> > 
> > 
> > So what do you think about the following change, so we can leave
> > NL_SET_ERR_MSG_MOD() in devlink and xfrm intact? 
> > 
> > diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> > index 38f6334f408c..d6f3a958e30b 100644
> > --- a/include/linux/netlink.h
> > +++ b/include/linux/netlink.h
> > @@ -101,7 +101,7 @@ struct netlink_ext_ack {
> >                                                         \
> >         do_trace_netlink_extack(__msg);                 \
> >                                                         \
> > -       if (__extack)                                   \
> > +       if (__extack && !__extack->msg)                 \
> >                 __extack->_msg = __msg;                 \
> >  } while (0)
> > 
> > @@ -111,7 +111,7 @@ struct netlink_ext_ack {
> >  #define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {                         \
> >         struct netlink_ext_ack *__extack = (extack);                           \
> >                                                                                \
> > -       if (!__extack)                                                         \
> > +       if (!__extack || __extack->msg)                                        \
> >                 break;                                                         \
> >         if (snprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,               \
> >                      "%s" fmt "%s", "", ##args, "") >=                         \
> > 
> 
> I think it makes sense. With the above patch 3/10 should be updated to
> preserve the 'catch-all' error message, I guess.

Great, thanks

> 
> Let's see what Jakub thinks ;)
> 
> Cheers,
> 
> Paolo
> 
