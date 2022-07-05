Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904475679C6
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiGEVzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGEVz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:55:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA650CF4;
        Tue,  5 Jul 2022 14:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657058125; x=1688594125;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VEi1co6rpJ5a8g+H6DoDMEmae0EzGQxH1pWxICwqPSw=;
  b=lK/83tdY7T60esk/NSehauzkXwSau40XcaMkT4Dhe+49hUy3RYn/7VCd
   B+ZPh750cTdAczK58FOyt7tofuMlkN/6EOhMs2ul3ssakVfNSX/Rl4ZXO
   9b5xGQL8pqZh/FQOkQXw3zf2tNAuOO9140ghzGF9TavcPNl0+9DHCvR6+
   ZqPzARvll+/rkOiiFHyODj5lQ2PsLgzJ84ywD+el+fS4Eu0jbg4xuKg06
   Lf2bdMk/5utm6WnnsWy1Lm5po54MYxLAoxohDw38w8RbDSNR1LWCP6tAS
   f4weprB97ovxEtEIdOfTt6jDsQDENI2gJllPl7t1IC28NCGWIMTjv8QLH
   w==;
X-IronPort-AV: E=Sophos;i="5.92,248,1650956400"; 
   d="scan'208";a="166504484"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jul 2022 14:55:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Jul 2022 14:55:20 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Jul 2022 14:55:20 -0700
Date:   Tue, 5 Jul 2022 23:59:18 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/7] net: lan966x: Split
 lan966x_fdb_event_work
Message-ID: <20220705215918.uwcp4yco5fn3fdex@soft-dev3-1.localhost>
References: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
 <20220701205227.1337160-3-horatiu.vultur@microchip.com>
 <20220702140834.gyqmtmaru6ecdamb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220702140834.gyqmtmaru6ecdamb@skbuf>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/02/2022 14:08, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, Jul 01, 2022 at 10:52:22PM +0200, Horatiu Vultur wrote:
> > Split the function lan966x_fdb_event_work. One case for when the
> > orig_dev is a bridge and one case when orig_dev is lan966x port.
> > This is preparation for lag support. There is no functional change.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> 
> > -static void lan966x_fdb_event_work(struct work_struct *work)
> > +void lan966x_fdb_flush_workqueue(struct lan966x *lan966x)
> > +{
> > +     flush_workqueue(lan966x->fdb_work);
> > +}
> > +
> 
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > index df2bee678559..d9fc6a9a3da1 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > @@ -320,9 +320,10 @@ static int lan966x_port_prechangeupper(struct net_device *dev,
> >  {
> >       struct lan966x_port *port = netdev_priv(dev);
> >
> > -     if (netif_is_bridge_master(info->upper_dev) && !info->linking)
> > -             switchdev_bridge_port_unoffload(port->dev, port,
> > -                                             NULL, NULL);
> > +     if (netif_is_bridge_master(info->upper_dev) && !info->linking) {
> > +             switchdev_bridge_port_unoffload(port->dev, port, NULL, NULL);
> > +             lan966x_fdb_flush_workqueue(port->lan966x);
> > +     }
> 
> Very curious as to why you decided to stuff this change in here.
> There was no functional change in v2, now there is. And it's a change
> you might need to come back to later (probably sooner than you'd like),
> since the flushing of the workqueue is susceptible to causing deadlocks
> if done improperly - let's see how you blame a commit that was only
> supposed to move code, in that case ;)

There is a functional change here and I forgot to change the commit
message for this.
> 
> The deadlock that I'm talking about comes from the fact that
> lan966x_port_prechangeupper() runs with rtnl_lock() held. So the code of
> the flushed workqueue item must not hold rtnl_lock(), or any other lock
> that is blocked by the rtnl_lock(). Otherwise, the flushing will wait
> for a workqueue item to complete, that in turn waits to acquire the
> rtnl_lock, which is held by the thread waiting the workqueue to complete.
> 
> Analyzing your code, lan966x_mac_notifiers() takes rtnl_lock().
> That is taken from threaded interrupt context - lan966x_mac_irq_process(),
> but is a sub-lock of spin_lock(&lan966x->mac_lock).
> 
> There are 2 problems with that already: rtnl_lock() is a mutex => can
> sleep, but &lan966x->mac_lock is a spin lock => is atomic. You can't
> take rtnl_lock() from atomic context. Lockdep and/or CONFIG_DEBUG_ATOMIC_SLEEP
> will tell you so much.
> 
> The second problem is the lock ordering inversion that this causes.
> There exists a threaded IRQ which takes the locks in the order mac_lock
> -> rtnl_lock, and there exists this new fdb_flush_workqueue which takes
> the locks in the order rtnl_lock -> mac_lock. If they run at the same
> time, kaboom. Again, lockdep will tell you as much.
> 
> I'm sorry, but you need to solve the existing locking problems with the
> code first.

As I see it, there 2 'different problems' which both have the same root
cause, the usage of the lan966x->mac_lock:
1. One is with lan966x_mac_notifiers and lan966x_mac_irq_process, which
is an issue on net. And this needs a separate patch.
2. Second is introduced by flushing the workqueue.

I am pretty sure I have run with CONFIG_DEBUG_ATOMIC_SLEEP but I
couldn't see any errors/warnings.

So let me start by fixing first issue on net.

> 
> >
> >       return NOTIFY_DONE;
> >  }
> > --
> > 2.33.0
> >

-- 
/Horatiu
