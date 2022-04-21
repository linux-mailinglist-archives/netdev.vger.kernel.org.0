Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44FF509A19
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 10:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386401AbiDUIFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 04:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiDUIFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 04:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72CEB1C920
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650528169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p7er01rcZIWPhWabLFGP6DqeKEF6sxpgGAt7I3QDHYU=;
        b=LGGiNE3IlLNEJdCIaNw1VVgFAQ20nzCzkR5lLAe1hWTI3uRa+e1TFhnLGGUpnSh/TacLfs
        aVqUrzSHrSCtkDnkHZsILv+HTL5cOUtNj0FRwwmDEYcNaGydppiv0CeApVlD6XmTPVAJId
        jn3knIesSRizxdatqIvyth7OgCH0B0Q=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-pXRJIFVOM4KweYPrTFUqMA-1; Thu, 21 Apr 2022 04:02:48 -0400
X-MC-Unique: pXRJIFVOM4KweYPrTFUqMA-1
Received: by mail-qk1-f200.google.com with SMTP id c8-20020a05620a268800b0069c0f1b3206so2832209qkp.18
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=p7er01rcZIWPhWabLFGP6DqeKEF6sxpgGAt7I3QDHYU=;
        b=uKZGnhS3xgXSZclqE4Flb4+YPcDK2+s4vkFsRhsd3Myz2H+yZFjAOthRr+/0jEyCrO
         pWfPKx8nKtDgPa5M9o5gHT9JkwzoHGHJMA3bqkft+SpB3KDUVtf175IDfpH62++UBsJo
         IO3XT3OWstWuC7kjLeLMjYwdzs0I3KUvHtZlzEBiTtNw4QWmTK89U+qvDkKGSqEGqKjd
         kl+Q2jFCXuiQpcU+8YfM2m7rEpQHmmyEC2h2WFiQPJncTLHWTgVylvQkei1ov1AmDG8L
         zzF7FjGOAOyW8HOiMBhGFO2CPhvNwwP4sXAirQg+a53+P8jneDFG53eJulVQkPOYXhU5
         YvOg==
X-Gm-Message-State: AOAM532LKxmSgW9PmRC2GZCBGtruEdhXiDQyDUk4nUV7rhPV2lzQsfbD
        jIETp7LDfaLKxexvP8DYQRaWRiSgLC/SHAi4F1wxWM68izaR4/PIHdCfmQks9NcHQ56WHfANBqO
        OM+NeEjjdg4QJs2cs
X-Received: by 2002:a05:622a:1750:b0:2f1:f7c1:894 with SMTP id l16-20020a05622a175000b002f1f7c10894mr15176825qtk.259.1650528167780;
        Thu, 21 Apr 2022 01:02:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0WIBPn04nK0pxz2TA+z4IAYntqGXRykynS7jdVQ5NR4GVfF/RPYsIsBzqbhXzB1YWmtFl6Q==
X-Received: by 2002:a05:622a:1750:b0:2f1:f7c1:894 with SMTP id l16-20020a05622a175000b002f1f7c10894mr15176809qtk.259.1650528167518;
        Thu, 21 Apr 2022 01:02:47 -0700 (PDT)
Received: from gerbillo.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id m10-20020a05622a054a00b002eb965bbc3esm3155926qtx.93.2022.04.21.01.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 01:02:46 -0700 (PDT)
Message-ID: <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 21 Apr 2022 10:02:43 +0200
In-Reply-To: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-04-17 at 09:04 +0200, Lukas Wunner wrote:
> Jann Horn reports a use-after-free on disconnect of a USB Ethernet
> (ax88179_178a.c).  Oleksij Rempel has witnessed the same issue with a
> different driver (ax88172a.c).
> 
> Jann's report (linked below) explains the root cause in great detail,
> but the gist is that USB Ethernet drivers call linkwatch_fire_event()
> between unregister_netdev() and free_netdev().  The asynchronous work
> linkwatch_event() may thus access the netdev after it's been freed.
> 
> USB Ethernet may not even be the only culprit.  To address the problem
> in the most general way, ignore link events once a netdev's state has
> been set to NETREG_UNREGISTERED.
> 
> That happens in netdev_run_todo() immediately before the call to
> linkwatch_forget_dev().  Note that lweventlist_lock (and its implied
> memory barrier) guarantees that a linkwatch_add_event() running after
> linkwatch_forget_dev() will see the netdev's new state and bail out.
> An unregistered netdev is therefore never added to link_watch_list
> (but may have its __LINK_STATE_LINKWATCH_PENDING bit set, which should
> not matter).  That obviates the need to invoke linkwatch_run_queue() in
> netdev_wait_allrefs(), so drop it.
> 
> In a sense, the present commit is to *no longer* registered netdevs as
> commit b47300168e77 ("net: Do not fire linkwatch events until the device
> is registered.") is to *not yet* registered netdevs.
> 
> Reported-by: Jann Horn <jannh@google.com>
> Link: https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com/
> Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Link: https://lore.kernel.org/netdev/20220315113841.GA22337@pengutronix.de/
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/linux/netdevice.h |  2 --
>  net/core/dev.c            | 17 -----------------
>  net/core/link_watch.c     | 10 ++--------
>  3 files changed, 2 insertions(+), 27 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 59e27a2b7bf0..5d950b45b59d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4805,8 +4805,6 @@ extern const struct kobj_ns_type_operations net_ns_type_operations;
>  
>  const char *netdev_drivername(const struct net_device *dev);
>  
> -void linkwatch_run_queue(void);
> -
>  static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
>  							  netdev_features_t f2)
>  {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8c6c08446556..0ee56965ff76 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10140,23 +10140,6 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
>  			list_for_each_entry(dev, list, todo_list)
>  				call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
>  
> -			__rtnl_unlock();
> -			rcu_barrier();
> -			rtnl_lock();
> -
> -			list_for_each_entry(dev, list, todo_list)
> -				if (test_bit(__LINK_STATE_LINKWATCH_PENDING,
> -					     &dev->state)) {
> -					/* We must not have linkwatch events
> -					 * pending on unregister. If this
> -					 * happens, we simply run the queue
> -					 * unscheduled, resulting in a noop
> -					 * for this device.
> -					 */
> -					linkwatch_run_queue();
> -					break;
> -				}
> -
>  			__rtnl_unlock();
>  
>  			rebroadcast_time = jiffies;
> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
> index 95098d1a49bd..9a0ea7cd68e4 100644
> --- a/net/core/link_watch.c
> +++ b/net/core/link_watch.c
> @@ -107,7 +107,8 @@ static void linkwatch_add_event(struct net_device *dev)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&lweventlist_lock, flags);
> -	if (list_empty(&dev->link_watch_list)) {
> +	if (list_empty(&dev->link_watch_list) &&
> +	    dev->reg_state < NETREG_UNREGISTERED) {
>  		list_add_tail(&dev->link_watch_list, &lweventlist);
>  		dev_hold_track(dev, &dev->linkwatch_dev_tracker, GFP_ATOMIC);
>  	

What about testing dev->reg_state in linkwatch_fire_event() before
setting the __LINK_STATE_LINKWATCH_PENDING bit, so that we don't leave
the device in an unexpected state?

Other than that, it looks good to me, but potentially quite risky. 

Looking at the original report it looks like the issue could be
resolved with a more usb-specific change: e.g. it looks like
usbnet_defer_kevent() is not acquiring a dev reference as it should.

Have you considered that path?

Thanks,

Paolo


