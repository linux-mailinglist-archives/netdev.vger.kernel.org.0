Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620A74DDD2D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbiCRPoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiCRPoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:44:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 218B02BB7F3
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 08:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647618167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/JGnFIRobCS0r0S48csDK9o+yNqkdjg/7kor2phK+8=;
        b=inCMEidRv0qtP0+NvX/lVdw5bMudEXKLxqzybW0WhTzDx86UYGw5tZF/IPt4jV2QbP2X/T
        bVQPyddSGTiXCzehIha+49ioVCHk2r9DoLud7WJyJImn8oY+/INGz9GrddkrwEoFAb1Vy3
        1T/9TXmNRl7WfqVg2prJZmV4fwMOd2Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-SU_Urm9FN8KT0B_rSXSM0w-1; Fri, 18 Mar 2022 11:42:46 -0400
X-MC-Unique: SU_Urm9FN8KT0B_rSXSM0w-1
Received: by mail-wm1-f71.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so3360315wmj.5
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 08:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=G/JGnFIRobCS0r0S48csDK9o+yNqkdjg/7kor2phK+8=;
        b=wP9Q25zJdhJwiVjdIrTvQBgQJn+UxntxOm80DDGRj4MDp1yTP56ylBy5ouO0GD2qzn
         D4Myved9JVJB1828qKBZWhYpc+P8pu0EJHW4IEHak13kscq2RoN1TM7wQV/kfACPfYRE
         qdTjOYdoUxFyO86EIoUu3dqTbMBGiH8GRNh9MRKEeJpfdp0MX3qNvjwL02Ut8qngvpbv
         6NMKRS58vdRbpjI84byleOBUKeOL/5K9J0WgFj8SSZxSaCGlntnnZyg/mn83jSBD9i3B
         mE8Ctjw2/C9DiRBRiZfmzXl++3TMin7herm090qWytje/l1LBO4YEH+u1paxj08HnThg
         QOJg==
X-Gm-Message-State: AOAM533uoG1VMBk/uF55l+O89FiC9AFZt9pGDEPLZfMA/NRXwqB0TNym
        ZpM1MjCuCBV9L2+kf4uxpPko/XKIuWoG7Awd2cHi+hXeCe4BeX+3TKBcVB+llltu9ite6+qpQSW
        Tds9xde0FVz8U+xYX
X-Received: by 2002:a7b:c057:0:b0:37b:ebad:c9c8 with SMTP id u23-20020a7bc057000000b0037bebadc9c8mr16173384wmc.61.1647618164449;
        Fri, 18 Mar 2022 08:42:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDsjBiuqqhXoWzqCagZHxcuV2UatajrKhiZEIMgp+2GbyM9jttscG0Uxw2+XBszf8ZRcHLzw==
X-Received: by 2002:a7b:c057:0:b0:37b:ebad:c9c8 with SMTP id u23-20020a7bc057000000b0037bebadc9c8mr16173365wmc.61.1647618164126;
        Fri, 18 Mar 2022 08:42:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id g6-20020adfd1e6000000b00203f8effc22sm2242020wrd.63.2022.03.18.08.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 08:42:43 -0700 (PDT)
Message-ID: <13558e3e0ed23097f04bb90b43c261062dca9107.camel@redhat.com>
Subject: Re: [PATCH v2] ipv6: acquire write lock for addr_list in
 dev_forward_change
From:   Paolo Abeni <pabeni@redhat.com>
To:     Niels Dossche <dossche.niels@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 18 Mar 2022 16:42:42 +0100
In-Reply-To: <a24b13ea10ca898bb003300084039b459d553f6d.camel@redhat.com>
References: <20220317155637.29733-1-dossche.niels@gmail.com>
         <7bd311d0846269f331a1d401c493f5511491d0df.camel@redhat.com>
         <a24b13ea10ca898bb003300084039b459d553f6d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-03-18 at 13:48 +0100, Paolo Abeni wrote:
> On Fri, 2022-03-18 at 10:13 +0100, Paolo Abeni wrote:
> > On Thu, 2022-03-17 at 16:56 +0100, Niels Dossche wrote:
> > > No path towards dev_forward_change (common ancestor of paths is in
> > > addrconf_fixup_forwarding) acquires idev->lock for idev->addr_list.
> > > We need to hold the lock during the whole loop in dev_forward_change.
> > > __ipv6_dev_ac_{inc,dec} both acquire the write lock on idev->lock in
> > > their function body. Since addrconf_{join,leave}_anycast call to
> > > __ipv6_dev_ac_inc and __ipv6_dev_ac_dec respectively, we need to move
> > > the responsibility of locking upwards.
> > > 
> > > This patch moves the locking up. For __ipv6_dev_ac_dec, there is one
> > > place where the caller can directly acquire the idev->lock, that is in
> > > ipv6_dev_ac_dec. The other caller is addrconf_leave_anycast, which now
> > > needs to be called under idev->lock, and thus it becomes the
> > > responsibility of the callers of addrconf_leave_anycast to hold that
> > > lock. For __ipv6_dev_ac_inc, there are also 2 callers, one is
> > > ipv6_sock_ac_join, which can acquire the lock during the call to
> > > __ipv6_dev_ac_inc. The other caller is addrconf_join_anycast, which now
> > > needs to be called under idev->lock, and thus it becomes the
> > > responsibility of the callers of addrconf_join_anycast to hold that
> > > lock.
> > > 
> > > Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> > > ---
> > > 
> > > Changes in v2:
> > >  - Move the locking upwards
> > > 
> > >  net/ipv6/addrconf.c | 21 ++++++++++++++++-----
> > >  net/ipv6/anycast.c  | 37 ++++++++++++++++---------------------
> > >  2 files changed, 32 insertions(+), 26 deletions(-)
> > > 
> > > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > > index f908e2fd30b2..69e9f81e2045 100644
> > > --- a/net/ipv6/addrconf.c
> > > +++ b/net/ipv6/addrconf.c
> > > @@ -818,6 +818,7 @@ static void dev_forward_change(struct inet6_dev *idev)
> > >  		}
> > >  	}
> > >  
> > > +	write_lock_bh(&idev->lock);
> > >  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
> > >  		if (ifa->flags&IFA_F_TENTATIVE)
> > >  			continue;
> > > @@ -826,6 +827,7 @@ static void dev_forward_change(struct inet6_dev *idev)
> > >  		else
> > >  			addrconf_leave_anycast(ifa);
> > >  	}
> > > +	write_unlock_bh(&idev->lock);
> > >  	inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
> > >  				     NETCONFA_FORWARDING,
> > >  				     dev->ifindex, &idev->cnf);
> > > @@ -2191,7 +2193,7 @@ void addrconf_leave_solict(struct inet6_dev *idev, const struct in6_addr *addr)
> > >  	__ipv6_dev_mc_dec(idev, &maddr);
> > >  }
> > >  
> > > -/* caller must hold RTNL */
> > > +/* caller must hold RTNL and write lock idev->lock */
> > >  static void addrconf_join_anycast(struct inet6_ifaddr *ifp)
> > >  {
> > >  	struct in6_addr addr;
> > > @@ -2204,7 +2206,7 @@ static void addrconf_join_anycast(struct inet6_ifaddr *ifp)
> > >  	__ipv6_dev_ac_inc(ifp->idev, &addr);
> > >  }
> > >  
> > > -/* caller must hold RTNL */
> > > +/* caller must hold RTNL and write lock idev->lock */
> > >  static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
> > >  {
> > >  	struct in6_addr addr;
> > > @@ -3857,8 +3859,11 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
> > >  			__ipv6_ifa_notify(RTM_DELADDR, ifa);
> > >  			inet6addr_notifier_call_chain(NETDEV_DOWN, ifa);
> > >  		} else {
> > > -			if (idev->cnf.forwarding)
> > > +			if (idev->cnf.forwarding) {
> > > +				write_lock_bh(&idev->lock);
> > >  				addrconf_leave_anycast(ifa);
> > > +				write_unlock_bh(&idev->lock);
> > > +			}
> > >  			addrconf_leave_solict(ifa->idev, &ifa->addr);
> > >  		}
> > >  
> > > @@ -6136,16 +6141,22 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
> > >  				&ifp->addr, ifp->idev->dev->name);
> > >  		}
> > >  
> > > -		if (ifp->idev->cnf.forwarding)
> > > +		if (ifp->idev->cnf.forwarding) {
> > > +			write_lock_bh(&ifp->idev->lock);
> > >  			addrconf_join_anycast(ifp);
> > > +			write_unlock_bh(&ifp->idev->lock);
> > > +		}
> > >  		if (!ipv6_addr_any(&ifp->peer_addr))
> > >  			addrconf_prefix_route(&ifp->peer_addr, 128,
> > >  					      ifp->rt_priority, ifp->idev->dev,
> > >  					      0, 0, GFP_ATOMIC);
> > >  		break;
> > >  	case RTM_DELADDR:
> > > -		if (ifp->idev->cnf.forwarding)
> > > +		if (ifp->idev->cnf.forwarding) {
> > > +			write_lock_bh(&ifp->idev->lock);
> > >  			addrconf_leave_anycast(ifp);
> > > +			write_unlock_bh(&ifp->idev->lock);
> > > +		}
> > >  		addrconf_leave_solict(ifp->idev, &ifp->addr);
> > >  		if (!ipv6_addr_any(&ifp->peer_addr)) {
> > >  			struct fib6_info *rt;
> > > diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
> > > index dacdea7fcb62..f3017ed6f005 100644
> > > --- a/net/ipv6/anycast.c
> > > +++ b/net/ipv6/anycast.c
> > > @@ -136,7 +136,9 @@ int ipv6_sock_ac_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
> > >  			goto error;
> > >  	}
> > >  
> > > +	write_lock_bh(&idev->lock);
> > >  	err = __ipv6_dev_ac_inc(idev, addr);
> > > +	write_unlock_bh(&idev->lock);
> > 
> > I feat this is problematic, due this call chain:
> > 
> >  __ipv6_dev_ac_inc() -> addrconf_join_solict() -> ipv6_dev_mc_inc ->
> > __ipv6_dev_mc_inc -> mutex_lock(&idev->mc_lock);
> > 
> > The latter call requires process context.
> > 
> > One alternarive (likely very hackish way) to solve this could be:
> > - adding another list entry  into struct inet6_dev, rtnl protected.
> 
> Typo above: the new field should be added to 'struct inet6_ifaddr'.
> 
> > - traverse addr_list under idev->lock and add each entry with
> > forwarding on to into a tmp list (e.g. tmp_join) using the field above;
> > add the entries with forwarding off into another tmp list (e.g.
> > tmp_leave), still using the same field.
> 
> Again confusing text above, sorry. As the forwarding flag is per
> device, all the addr entries will land into the same tmp list.
> 
> It's probably better if I sketch up some code...

For the records, I mean something alongside the following - completely
not tested:
---
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 4cfdef6ca4f6..2df3c98b9e55 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -64,6 +64,7 @@ struct inet6_ifaddr {
 
 	struct hlist_node	addr_lst;
 	struct list_head	if_list;
+	struct list_head	if_list_aux;
 
 	struct list_head	tmp_list;
 	struct inet6_ifaddr	*ifpub;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b22504176588..27d1081b693e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -797,6 +797,7 @@ static void dev_forward_change(struct inet6_dev *idev)
 {
 	struct net_device *dev;
 	struct inet6_ifaddr *ifa;
+	LIST_HEAD(tmp);
 
 	if (!idev)
 		return;
@@ -815,9 +816,17 @@ static void dev_forward_change(struct inet6_dev *idev)
 		}
 	}
 
+	rcu_read_lock();
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		if (ifa->flags&IFA_F_TENTATIVE)
 			continue;
+		list_add_tail(&ifa->if_list_aux, &tmp);
+	}
+	rcu_read_unlock();
+
+	while (!list_empty(&tmp)) {
+		ifa = list_first_entry(&tmp, struct inet6_ifaddr, if_list_aux);
+		list_del(&ifa->if_list_aux);
 		if (idev->cnf.forwarding)
 			addrconf_join_anycast(ifa);
 		else

