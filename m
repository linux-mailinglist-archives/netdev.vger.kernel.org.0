Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279986DC289
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 04:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjDJCIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 22:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjDJCIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 22:08:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8EB30E7
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 19:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05EC061720
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 02:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B2EC433EF;
        Mon, 10 Apr 2023 02:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681092482;
        bh=ewjOFZ1AC1XnkCM/seZdlOVIeezdzGy6zefW/U7nb7A=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uQN3kf6da+CtYL1XBXY8p7Mx7zX6RPCDe/1YcGvACQqKxMoHIXb5vkzy25MT4ryzc
         iGg3nuoUL6GxRwnbsi2MeC91/09RLp8G/WduPAl9qTFetyd6oyuKikRRFtaD6HdiGQ
         nMHrAbOqeL2TeZReWKbg2MC68uTyc67zBD/LJJ279VGH1ZGwT7u00iQlai2q0PFVbU
         bBjUdeuZ4PEvTcIQlTGqjQMPnHDVPU0sP5Dw9MrD/KV7Mc/sQnUlr8jEDeTpCPNf7o
         NOXRYcmfv0IAGOqZM9t3WHRXUoRaPJ6gkQ4JYeAUP7xAk6ZsWKBY9ci5LL1MUTeyAt
         O5vk3BkhJ5gIQ==
Message-ID: <febbbc75-2cf5-1cf9-8ed9-6a42ff295ab9@kernel.org>
Date:   Sun, 9 Apr 2023 20:08:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [RFC PATCH net] net: ipv4/ipv6 addrconf: call
 igmp{,6}_group_dropped() while dev is still up
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20230406233058.780721-1-vladimir.oltean@nxp.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230406233058.780721-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc Ido in case such a change has implications to mlxsw ]

On 4/6/23 5:30 PM, Vladimir Oltean wrote:
> ipv4 devinet calls ip_mc_down(), and ipv6 calls addrconf_ifdown(), and
> both of these eventually result in calls to dev_mc_del(), either through
> igmp_group_dropped() or igmp6_group_dropped().
> 
> The problem is that dev_mc_del() does call __dev_set_rx_mode(), but this
> will not propagate all the way to the ndo_set_rx_mode() of the device,
> because of this check:
> 
> 	/* dev_open will call this function so the list will stay sane. */
> 	if (!(dev->flags&IFF_UP))
> 		return;
> 
> and the NETDEV_DOWN notifier is emitted while the interface is already
> down. OTOH we have NETDEV_GOING_DOWN which is emitted a bit earlier -
> see:
> 
> dev_close_many()
> -> __dev_close_many()
>    -> call_netdevice_notifiers(NETDEV_GOING_DOWN, dev);
>    -> dev->flags &= ~IFF_UP;
> -> call_netdevice_notifiers(NETDEV_DOWN, dev);
> 
> Normally this oversight is easy to miss, because the addresses aren't
> lost, just not synced to the device until the next up event.
> 
> DSA does some processing in its dsa_slave_set_rx_mode(), and assumes
> that all addresses that were synced are also unsynced by the time the
> device is unregistered. Due to that assumption not being satisfied,
> the WARN_ON(!list_empty(&dp->mdbs)); from dsa_switch_release_ports()
> triggers, and we leak memory corresponding to the multicast addresses
> that were never synced.
> 
> Minimal reproducer:
> ip link set swp0 up
> ip link set swp0 down
> echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
> 
> The proposal is to respond to that slightly earlier notifier with the
> IGMP address deletion, so that the ndo_set_rx_mode() of the device does
> actually get called. I am not familiar with the details of these layers,
> but it appeared to me that NETDEV_DOWN needed to be replaced everywhere
> with NETDEV_GOING_DOWN, so I blindly did that and it worked.
> 
> Fixes: 5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Obviously DSA is not the only affected driver, but the extent to which
> other drivers are impacted is not obvious to me. At least in DSA, there
> is a WARN_ON() and a memory leak, so this is why I chose that Fixes tag.
> 
>  net/ipv4/devinet.c  |  7 ++++---
>  net/ipv6/addrconf.c | 12 ++++++------
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 5deac0517ef7..95690d16d651 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -392,7 +392,8 @@ static void __inet_del_ifa(struct in_device *in_dev,
>  
>  				rtmsg_ifa(RTM_DELADDR, ifa, nlh, portid);
>  				blocking_notifier_call_chain(&inetaddr_chain,
> -						NETDEV_DOWN, ifa);
> +							     NETDEV_GOING_DOWN,
> +							     ifa);
>  				inet_free_ifa(ifa);
>  			} else {
>  				promote = ifa;
> @@ -429,7 +430,7 @@ static void __inet_del_ifa(struct in_device *in_dev,
>  	   So that, this order is correct.
>  	 */
>  	rtmsg_ifa(RTM_DELADDR, ifa1, nlh, portid);
> -	blocking_notifier_call_chain(&inetaddr_chain, NETDEV_DOWN, ifa1);
> +	blocking_notifier_call_chain(&inetaddr_chain, NETDEV_GOING_DOWN, ifa1);
>  
>  	if (promote) {
>  		struct in_ifaddr *next_sec;
> @@ -1588,7 +1589,7 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
>  		/* Send gratuitous ARP to notify of link change */
>  		inetdev_send_gratuitous_arp(dev, in_dev);
>  		break;
> -	case NETDEV_DOWN:
> +	case NETDEV_GOING_DOWN:
>  		ip_mc_down(in_dev);
>  		break;
>  	case NETDEV_PRE_TYPE_CHANGE:
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 3797917237d0..9e484f829f1c 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -1307,7 +1307,7 @@ static void ipv6_del_addr(struct inet6_ifaddr *ifp)
>  
>  	ipv6_ifa_notify(RTM_DELADDR, ifp);
>  
> -	inet6addr_notifier_call_chain(NETDEV_DOWN, ifp);
> +	inet6addr_notifier_call_chain(NETDEV_GOING_DOWN, ifp);
>  
>  	if (action != CLEANUP_PREFIX_RT_NOP) {
>  		cleanup_prefix_route(ifp, expires,
> @@ -3670,12 +3670,12 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
>  		}
>  		break;
>  
> -	case NETDEV_DOWN:
> +	case NETDEV_GOING_DOWN:
>  	case NETDEV_UNREGISTER:
>  		/*
>  		 *	Remove all addresses from this interface.
>  		 */
> -		addrconf_ifdown(dev, event != NETDEV_DOWN);
> +		addrconf_ifdown(dev, event != NETDEV_GOING_DOWN);
>  		break;
>  
>  	case NETDEV_CHANGENAME:
> @@ -3741,7 +3741,7 @@ static bool addr_is_local(const struct in6_addr *addr)
>  
>  static int addrconf_ifdown(struct net_device *dev, bool unregister)
>  {
> -	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_DOWN;
> +	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_GOING_DOWN;
>  	struct net *net = dev_net(dev);
>  	struct inet6_dev *idev;
>  	struct inet6_ifaddr *ifa;
> @@ -3877,7 +3877,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>  
>  		if (state != INET6_IFADDR_STATE_DEAD) {
>  			__ipv6_ifa_notify(RTM_DELADDR, ifa);
> -			inet6addr_notifier_call_chain(NETDEV_DOWN, ifa);
> +			inet6addr_notifier_call_chain(NETDEV_GOING_DOWN, ifa);
>  		} else {
>  			if (idev->cnf.forwarding)
>  				addrconf_leave_anycast(ifa);
> @@ -6252,7 +6252,7 @@ static void dev_disable_change(struct inet6_dev *idev)
>  
>  	netdev_notifier_info_init(&info, idev->dev);
>  	if (idev->cnf.disable_ipv6)
> -		addrconf_notify(NULL, NETDEV_DOWN, &info);
> +		addrconf_notify(NULL, NETDEV_GOING_DOWN, &info);
>  	else
>  		addrconf_notify(NULL, NETDEV_UP, &info);
>  }

