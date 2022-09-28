Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED09C5ED969
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiI1Js3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiI1JsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:48:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF1F95E73
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664358484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JojnlB8YwuHw3WaiLCvm1GIVn0nTelV1daLnuoHKCyY=;
        b=Mx9c2nlzEWKowpdjGkgKUuswZUVPNhkUzv24ZHLxQ2p9vsTKkGkm9ikJp3AJAVbmN7ZTW6
        tJalnRoy+ZLJqyvWxl8U4ny4VdX3ySt3v0TsV6Hh7AppX+YXjR0xMLwXcJiLrKGjDB+4FY
        2FdEmvvJqi3WsmV/lBeRycmADlOyrP4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-519-OHLjMDyNOTuxUOcMFmX-jA-1; Wed, 28 Sep 2022 05:48:03 -0400
X-MC-Unique: OHLjMDyNOTuxUOcMFmX-jA-1
Received: by mail-wm1-f70.google.com with SMTP id fc12-20020a05600c524c00b003b5054c70d3so6871507wmb.5
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JojnlB8YwuHw3WaiLCvm1GIVn0nTelV1daLnuoHKCyY=;
        b=Rc0JYeZnEV/n7BsQ7GD2cQANrn1BKYfX5Niv6K+nZndTKK/98/O7jV9voHSVhVbnfR
         PyoqWo8ZcY1+3biP9IxmDsPbzUd3kDOtcPlMB2HJYPzKFbrCSAFsjr3o5V5J6DISMa20
         xN8iFRg4yioj/YRoyYDNwKEc+nODrlnS+uIOJQfUrOP7RtT+Q4CysJNB2CEl3YcZLrZe
         v5HoGLs8/z+L3yxz4ogJthn4Y6RXzIMNEG+U1J6zf1TLmpy3uhnxZnhj7X0Gv946zpj2
         +eb05LYbr1y3hhd7Iov2wCxzyzs/Dw3AEfxv51FPHHHsPCZ/+Zyd7y31lo8ZEjfSU7WG
         40tw==
X-Gm-Message-State: ACrzQf13o3EyUwQ0Xt5eJqIVxBXgu1sGhISB+nlT0WOFK2AkRaFLgdWs
        0qweMiTS0XJ2gapQojswosMbWAIuBEV7uRJnF1+7YDNRgmkVc6eo3qxr14GcvKioc7kkSVKp7Qq
        MtyHnTQ7GXK1PA/7T
X-Received: by 2002:a5d:654e:0:b0:22c:b7aa:e4fa with SMTP id z14-20020a5d654e000000b0022cb7aae4famr5493513wrv.101.1664358481173;
        Wed, 28 Sep 2022 02:48:01 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5sV63veDAO9nIrevgWqqTNG1gLAz5ICNKaSovdrzGA8b0QKqCCuHPjuiJYaitrH+OgoUhZaw==
X-Received: by 2002:a5d:654e:0:b0:22c:b7aa:e4fa with SMTP id z14-20020a5d654e000000b0022cb7aae4famr5493498wrv.101.1664358480987;
        Wed, 28 Sep 2022 02:48:00 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id m35-20020a05600c3b2300b003b47b913901sm5989314wms.1.2022.09.28.02.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 02:48:00 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:47:57 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <20220928094757.GA3081@localhost.localdomain>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
 <20220927072130.6d5204a3@kernel.org>
 <YzOz9ePdsIMGg0s+@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzOz9ePdsIMGg0s+@Laptop-X1>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 10:39:49AM +0800, Hangbin Liu wrote:
> On Tue, Sep 27, 2022 at 07:21:30AM -0700, Jakub Kicinski wrote:
> > On Tue, 27 Sep 2022 12:13:03 +0800 Hangbin Liu wrote:
> > > @@ -3382,6 +3401,12 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
> > >  		if (err)
> > >  			goto out_unregister;
> > >  	}
> > > +
> > > +	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
> > > +				      0, pid, nlh->nlmsg_seq);
> > > +	if (nskb)
> > > +		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
> > > +
> > >  out:
> > >  	if (link_net)
> > >  		put_net(link_net);
> > 
> > I'm surprised you're adding new notifications. Does the kernel not
> > already notify about new links? I thought rtnl_newlink_create() ->
> > rtnl_configure_link() -> __dev_notify_flags() sends a notification,
> > already.
> 
> I think __dev_notify_flags() only sends notification when dev flag changed.
> On the other hand, the notification is sent via multicast, while this patch
> is intend to unicast the notification to the user space.

In rntl_configure_link(), dev->rtnl_link_state is RTNL_LINK_INITIALIZING
on device cretation, so __dev_notify_flags() is called with gchanges=~0
and notification should be always sent. It's just a matter of passing the
portid and the nlmsghdr down the call chain to make rtnl_notify() send
the unicast message together with the multicast ones.

Now for device modification, I'm not sure there's a use case for
unicast notifications. The caller already knows which values it asked
to modify, so ECHO doesn't bring much value compared to a simple ACK.

> Thanks
> Hangbin
> 

