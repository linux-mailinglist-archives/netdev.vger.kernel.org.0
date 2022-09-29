Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EC75EF796
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiI2Ocv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiI2Ocu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:32:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BF71BBEC6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664461968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OIys9OiwpkBVR/3lqiM0UfVKwYvI8yX2Jajhm9lq+5U=;
        b=T6JoQMGH401CT8n2zIJl+VtfxpaVsa/tfwdiGLOZdKe9dy+jHrthTVmNxXamdoGuftpfEC
        ZPlv/Suwqj5dJABGy4wm/wUZ5gcdQHiAQqEu7NwaodQdpUXVQAtRLdSWwW9HhATs2cksHl
        t501msCB7KtLESbrP7uCnMOzM6u7ERE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-618-r1rzeZO2NauVeSfe8jUJfw-1; Thu, 29 Sep 2022 10:32:47 -0400
X-MC-Unique: r1rzeZO2NauVeSfe8jUJfw-1
Received: by mail-wr1-f71.google.com with SMTP id k30-20020adfb35e000000b0022cc5ecd872so609935wrd.8
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=OIys9OiwpkBVR/3lqiM0UfVKwYvI8yX2Jajhm9lq+5U=;
        b=AtobvSOfXNVqElbOJEX4V7Mu6PoxzAOvdhirQ66eDTeO7vO6D9QGEJsn/ULqTTDcQp
         /wBISEilWZkf3/iWIi2GCkGPQ3deRpT2upxqUIwLDw2HD6iPpi5AWxUPpU19PRg/N1YP
         QPXJWrAsq9RR6rMY2Wp1U1vtQDCUqfZ2nJKGTUZRekDeThft7ega2V3XlmHlK+ObdukL
         xNe5ly8AhCtqexcJMMspXvhmckS6ukp5d6zjEiQqnWnjujjejeXGJWErb+axJ2FEtI9V
         sALlawojTYPoQrJpTwJTaZSxCBTzFuZH69OUHeIp+R/XNRC1wVsJObYlUlLQs0Ps8WxB
         kI6g==
X-Gm-Message-State: ACrzQf3FCMrzQwGDAbwNI7BnBOnRBeUIkIZqRKZZZP0V3Ks2NFwBVxK7
        OMCF44X/1oxNQ7lYyU7wZYGKAQu45MoQqK3iWLFI2amq9F9B4eUoWf9hNkrkY6mlyeBpo0N2ics
        WljKMsm8IwharuTqi
X-Received: by 2002:a05:6000:1e0d:b0:22c:aa08:5272 with SMTP id bj13-20020a0560001e0d00b0022caa085272mr2772576wrb.296.1664461966310;
        Thu, 29 Sep 2022 07:32:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4biZVGcv7QRvOkIW7N9Y4DmDxwHBvSbcNS6kH5PRYA9JL+u6YFkPVq0nDLneQveQQWbF0rQg==
X-Received: by 2002:a05:6000:1e0d:b0:22c:aa08:5272 with SMTP id bj13-20020a0560001e0d00b0022caa085272mr2772551wrb.296.1664461966040;
        Thu, 29 Sep 2022 07:32:46 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id bu24-20020a056000079800b00226dedf1ab7sm7173487wrb.76.2022.09.29.07.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 07:32:45 -0700 (PDT)
Date:   Thu, 29 Sep 2022 16:32:42 +0200
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
Message-ID: <20220929143242.GB6761@localhost.localdomain>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
 <20220927072130.6d5204a3@kernel.org>
 <YzOz9ePdsIMGg0s+@Laptop-X1>
 <20220928094757.GA3081@localhost.localdomain>
 <YzUMrAgm5eieW1hS@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzUMrAgm5eieW1hS@Laptop-X1>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 11:10:36AM +0800, Hangbin Liu wrote:
> On Wed, Sep 28, 2022 at 11:47:57AM +0200, Guillaume Nault wrote:
> > On Wed, Sep 28, 2022 at 10:39:49AM +0800, Hangbin Liu wrote:
> > > On Tue, Sep 27, 2022 at 07:21:30AM -0700, Jakub Kicinski wrote:
> > > > On Tue, 27 Sep 2022 12:13:03 +0800 Hangbin Liu wrote:
> > > > > @@ -3382,6 +3401,12 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
> > > > >  		if (err)
> > > > >  			goto out_unregister;
> > > > >  	}
> > > > > +
> > > > > +	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
> > > > > +				      0, pid, nlh->nlmsg_seq);
> > > > > +	if (nskb)
> > > > > +		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
> > > > > +
> > > > >  out:
> > > > >  	if (link_net)
> > > > >  		put_net(link_net);
> > > > 
> > > > I'm surprised you're adding new notifications. Does the kernel not
> > > > already notify about new links? I thought rtnl_newlink_create() ->
> > > > rtnl_configure_link() -> __dev_notify_flags() sends a notification,
> > > > already.
> > > 
> > > I think __dev_notify_flags() only sends notification when dev flag changed.
> > > On the other hand, the notification is sent via multicast, while this patch
> > > is intend to unicast the notification to the user space.
> > 
> > In rntl_configure_link(), dev->rtnl_link_state is RTNL_LINK_INITIALIZING
> > on device cretation, so __dev_notify_flags() is called with gchanges=~0
> > and notification should be always sent. It's just a matter of passing the
> > portid and the nlmsghdr down the call chain to make rtnl_notify() send
> > the unicast message together with the multicast ones.
> 
> To update __dev_notify_flags() with nlmsghdr, we also need to update
> rtnl_configure_link(), which is called by some drivers.

There's just a handful of virtual net devices that call
rtnl_configure_link(). It should be easy to modify its prototype
and adjust these external callers.

> > Now for device modification, I'm not sure there's a use case for
> > unicast notifications. The caller already knows which values it asked
> > to modify, so ECHO doesn't bring much value compared to a simple ACK.
> 
> And the __dev_notify_flags() is only used when the dev flag changed.
> 
> It looks no much change if we call it when create new link:
> rtnl_newlink_create() -> rtnl_configure_link() -> __dev_notify_flags()
> 
> But when set link, it is only called when flag changed
> do_setlink() -> dev_change_flags() -> __dev_notify_flags().
> 
> Unless you want to omit the ECHO message when setting link.

For SET operations, we may send one, many or even zero notifications.
I agree with Jackub that we shouldn't add specific notifications just
for NLM_F_ECHO. That means, either we echo all the existing
notifications (or none if the device hasn't been modified), or we
leave NLM_F_ECHO unimplemented for SET operations.

As I said in my previous reply, I can't see any use case for ECHO on
SET operations, so I don't mind if we skip it.

> At latest, when call rtnl_delete_link(), there is no way to call
> __dev_notify_flags(). So we still need to use the current way.

Not everything has to be done with __dev_notify_flags(). For DEL
operations notifications are sent in netdev_unregister_many().
Given the overwhelming number of callers, modifying its prototype isn't
going to be practical, but you can use a wrapper.

Something like (very rough idea):

-void unregister_netdevice_many(struct list_head *head)
+void unregister_netdevice_many_notify(struct list_head *head, u32 portid,
+                                      const struct nlmsghdr *nlh)
 {
[...]
                 if (!dev->rtnl_link_ops ||
                     dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
-                        skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-                                                     GFP_KERNEL, NULL, 0);
+                        skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, portid,
+                                                     nlh->nlmsg_seq, dev, ~0U,
+                                                     0, GFP_KERNEL, NULL, 0);
 
[...]
                if (skb)
-                        rtmsg_ifinfo_send(skb, dev, GFP_KERNEL);
+                        rtmsg_ifinfo_send(skb, portid, dev, nlh, GFP_KERNEL);
 
[...]
 }
 
+void unregister_netdevice_many(struct list_head *head)
+{
+        unregister_netdevice_many_notify(head, 0, NULL);
+}

> As a summarize, we need to change a lot of code if we use __dev_notify_flags()
> to notify user, while we can only use it in one place. This looks not worth.
> 
> WDYT?

Using __dev_notify_flags() is only for NEW operations. SET and DEL have
to be handled differently.

To summarise, the objective is to reuse the existing notifications.
In practice that means just doing the required plumbing to pass the
correct parameters to the existing nlmsg_notify() calls (and ensure we
set the correct portid and sequence number in the netlink message
header).

> Thanks
> Hangbin
> 

