Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3130E6B8840
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 03:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjCNCSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 22:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCNCS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 22:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E867A867EA
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 19:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678760259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kjDBKn3JRqkY0p0pjARPVgay/DHvOTqKhwEPJ+QVeOo=;
        b=hZCNIUU/8ownmGrffUQKqE6iWLFp0ItA/BfdNlo1LPhC0074s6BBYYFx7GAs6IdmPNi1/x
        ZSrz2B4FDaVrXAvWAUjFMfxCWp3DQugpQwoLJ5y79HFto7ESwLpYBLpjS9xPnKnl5xm5SB
        88dEFT5l2pA4fuqTuSwUAOhDcPpdh0Y=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-SlpWIPuXPx-dTmuU7y8TKA-1; Mon, 13 Mar 2023 22:17:36 -0400
X-MC-Unique: SlpWIPuXPx-dTmuU7y8TKA-1
Received: by mail-pl1-f197.google.com with SMTP id k3-20020a170902ce0300b0019ca6e66303so8037422plg.18
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 19:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678760255;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjDBKn3JRqkY0p0pjARPVgay/DHvOTqKhwEPJ+QVeOo=;
        b=wKZeZGUOxItRhJzYtpw5gWLf1Ghi0oXjjRIlbnlXW56RdeqRABET4gYCRui3m/VTB8
         QpkxjeJ4rpAmmCBGMMJHMIscDUUW1Rpd+i+DeTJCO4UqL+9RJ2f0suMmvTBQ8zmbs0K1
         609bluJFRQC24rE74LUPHx+gkfyJlgNM0UYVb5Evl235doFhefil6iX0BNU6YJYQr56U
         mHZuY7ZWbQtX73LEr4pYF1okEFH9qHg5FlQvzFjT0S1dUcdY1KVJke3OwIdIyojDXYEA
         K9ckcevdnUi+BfQDqEv+gWaBK184qOdcYGc3mByAYNoMxrLYMhb+Sp3oLL2Xf2gCmhKu
         kxxQ==
X-Gm-Message-State: AO0yUKWvQ+bsOIivWSYbllAe9AGwSLwM13qBlFKisiNQSed9QL7Vr44f
        aP8fFi3DeArPE61M7mMrbIUYoiGteoMJ0/8A9DuSOML4lqdNRbGO5ihDjb9dl9mNDa0OpjQ/wDN
        EFuyOT3R2oSDnWkTg
X-Received: by 2002:a05:6a20:441a:b0:d4:beda:7a48 with SMTP id ce26-20020a056a20441a00b000d4beda7a48mr3832184pzb.0.1678760254828;
        Mon, 13 Mar 2023 19:17:34 -0700 (PDT)
X-Google-Smtp-Source: AK7set8q4ME6Is/JGWOqkwsBMZfnQ4pXV7orpmx5CXs5A6gnHJnjA9PePz6FyeYe7nmefAykDEHZfg==
X-Received: by 2002:a05:6a20:441a:b0:d4:beda:7a48 with SMTP id ce26-20020a056a20441a00b000d4beda7a48mr3832168pzb.0.1678760254444;
        Mon, 13 Mar 2023 19:17:34 -0700 (PDT)
Received: from kernel-devel ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id z16-20020a631910000000b0050336b0b08csm381497pgl.19.2023.03.13.19.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 19:17:34 -0700 (PDT)
Date:   Tue, 14 Mar 2023 11:17:29 +0900
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     j.vosburgh@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
Subject: Re: [PATCH net] bonding: Fix warning in default_device_exit_batch()
Message-ID: <ZA/ZOTGGADHe8TL7@kernel-devel>
References: <20230312152158.995043-1-syoshida@redhat.com>
 <d7a740f1-99e9-6947-06ef-3139198730f7@blackwall.org>
 <ZA7uTL2/IkBEIRD7@kernel-devel>
 <45fc873b-9b71-adf2-8f2f-17134344e490@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45fc873b-9b71-adf2-8f2f-17134344e490@blackwall.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

On Mon, Mar 13, 2023 at 12:52:44PM +0200, Nikolay Aleksandrov wrote:
> On 13/03/2023 11:35, Shigeru Yoshida wrote:
> > Hi Nik,
> > 
> > On Sun, Mar 12, 2023 at 10:58:18PM +0200, Nikolay Aleksandrov wrote:
> >> On 12/03/2023 17:21, Shigeru Yoshida wrote:
> >>> syzbot reported warning in default_device_exit_batch() like below [1]:
> >>>
> >>> WARNING: CPU: 1 PID: 56 at net/core/dev.c:10867 unregister_netdevice_many_notify+0x14cf/0x19f0 net/core/dev.c:10867
> >>> ...
> >>> Call Trace:
> >>>  <TASK>
> >>>  unregister_netdevice_many net/core/dev.c:10897 [inline]
> >>>  default_device_exit_batch+0x451/0x5b0 net/core/dev.c:11350
> >>>  ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
> >>>  cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613
> >>>  process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
> >>>  worker_thread+0x669/0x1090 kernel/workqueue.c:2537
> >>>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
> >>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> >>>  </TASK>
> >>>
> >>> For bond devices which also has a master device, IFF_SLAVE flag is
> >>> cleared at err_undo_flags label in bond_enslave() if it is not
> >>> ARPHRD_ETHER type.  In this case, __bond_release_one() is not called
> >>> when bond_netdev_event() received NETDEV_UNREGISTER event.  This
> >>> causes the above warning.
> >>>
> >>> This patch fixes this issue by setting IFF_SLAVE flag at
> >>> err_undo_flags label in bond_enslave() if the bond device has a master
> >>> device.
> >>>
> >>
> >> The proper way is to check if the bond device had the IFF_SLAVE flag before the
> >> ether_setup() call which clears it, and restore it after.
> >>
> >>> Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
> >>> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> >>> Link: https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef [1]
> >>> Reported-by: syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
> >>> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> >>> ---
> >>>  drivers/net/bonding/bond_main.c | 2 ++
> >>>  include/net/bonding.h           | 5 +++++
> >>>  2 files changed, 7 insertions(+)
> >>>
> >>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >>> index 00646aa315c3..1a8b59e1468d 100644
> >>> --- a/drivers/net/bonding/bond_main.c
> >>> +++ b/drivers/net/bonding/bond_main.c
> >>> @@ -2291,6 +2291,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> >>>  			dev_close(bond_dev);
> >>>  			ether_setup(bond_dev);
> >>>  			bond_dev->flags |= IFF_MASTER;
> >>> +			if (bond_has_master(bond))
> >>> +				bond_dev->flags |= IFF_SLAVE;
> >>>  			bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
> >>>  		}
> >>>  	}
> >>> diff --git a/include/net/bonding.h b/include/net/bonding.h
> >>> index ea36ab7f9e72..ed0b49501fad 100644
> >>> --- a/include/net/bonding.h
> >>> +++ b/include/net/bonding.h
> >>> @@ -57,6 +57,11 @@
> >>>  
> >>>  #define bond_has_slaves(bond) !list_empty(bond_slave_list(bond))
> >>>  
> >>> +/* master list primitives */
> >>> +#define bond_master_list(bond) (&(bond)->dev->adj_list.upper)
> >>> +
> >>> +#define bond_has_master(bond) !list_empty(bond_master_list(bond))
> >>> +
> >>
> >> This is not the proper way to check for a master device.
> >>
> >>>  /* IMPORTANT: bond_first/last_slave can return NULL in case of an empty list */
> >>>  #define bond_first_slave(bond) \
> >>>  	(bond_has_slaves(bond) ? \
> >>
> >> The device flags are wrong because of ether_setup() which clears IFF_SLAVE, we should
> >> just check if it was present before and restore it after the ether_setup() call.
> > 
> > Thank you so much for your comment!  I understand your point, and
> > agree that your approach must resolve the issue.
> > 
> > BTW, do you mean there is a case where a device has IFF_SLAVE flag but
> > the upper list is empty?  I thought a device with IFF_SLAVE flag has a
> > master device in the upper list (that is why I took the above way.)
> > 
> 
> Hi Shigeru,
> No, that's not what I meant. It's the opposite actually, you may have an upper list
> but you don't have a "master" device or slave flag set. Yes, you can say that if
> a device has IFF_SLAVE set, then it must have a master upper device but that's not
> what you're checking for, you've reversed that logic to check for an upper device instead
> and assume there's a IFF_SLAVE flag set (which may not be true).
> For an upper device to be considered a "master" device, it must have the master bool set to
> true in its netdev_adjacent structure. We already have helpers to check for master devices
> and to retrieve them, e.g. check netdev_master_upper_dev_get* in net/core/dev.c
> 
> The most robust way to fix it is to check if the flag was there prior to the ether_setup() call
> and restore it after, also to leave a nice comment about all of this. :)

Thanks for kindly explanation.  I've now understand why my fix is not
sufficient to check a master device.  And, yes, the most robust and
simple way to fix the issue is to check the flag before it is cleared.

Thanks you~
Shigeru

> 
> > Thanks,
> > Shigeru
> > 
> 
> Cheers,
>  Nik
> 

