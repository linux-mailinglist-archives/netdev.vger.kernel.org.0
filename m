Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6837A3428A1
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCSWUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhCSWUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:20:45 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97559C06175F;
        Fri, 19 Mar 2021 15:20:45 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k24so4618888pgl.6;
        Fri, 19 Mar 2021 15:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+53pltsYdqXb13I+8/YvTj0AveMqqH3ZdH3ixyZXMcQ=;
        b=PX82dDsEgYqv/9mjfGCtPl4Dy+1GAMZfTPhTvfz8gKLzUDFOnmM9EUDdwsFBHsD4R3
         xQQTmrkcTLdaSWhxyQhgnlDPHRA94pkEbaucnukZUzeNjZq8IqkJOfSpC0GCHN9QmMNU
         7SpuDZ6XApMfuCk7EYy3k0lcmvOiPtor6NZKtT2zBUQa4Tt4R3R1ZRyr5njClLc3xlgZ
         oyt1d1i40W79iLY/BbKsEJv2Axn/SpyK6SXVgPKLtgKSfxfnomqCO2rWWY3HKKk8aZ0L
         WEwmQC1p4+MrtG2aq9L+JfnvoUywpL8wJKZA5uTaA2/dfFPPrD51TSKto9HjaqJQgxDe
         4kTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+53pltsYdqXb13I+8/YvTj0AveMqqH3ZdH3ixyZXMcQ=;
        b=X8oZzZ9LuxKTmomqdzcYFi9Q6IANPIuUH7Zc10/JlMyU1b9jbiApFUcmjfMSZN/4hp
         AwiFWIYI6H5uAHhEJdNWIIXW9735srZqIcLprbLrJFtMWZORxCnlPvMjYDODTT83k6CM
         eUn8B1QayUBkfA84ReAmJU17IXeQHJlRnDiYRBDXc7M8OyE/Obtag6HZdYTEIQwrNCZx
         eaaF3lFI6fC443VHY3VmRzNTjl/98cNr2clCDT8O4LUWIe1xzNCWpKGxlOLdy7kKCaSX
         FXphmKj7SLUzruHtsib4gWbvOouImNQH8ehVqJwL7biLR3faT6s08xaOjsQpUV/cJyUW
         KJ8w==
X-Gm-Message-State: AOAM533L5XLfJASpGXyVCwseMInB5sTGtuMGxfjaGWsy0NEuCT8Hb9T0
        sW1TLYpUZUqo/a9eXhpSqdc=
X-Google-Smtp-Source: ABdhPJzS+CbzQjEjaZLgh0V+I2I78c6+s1TQKvT5iohM+jjq1W9LEqGoA3sMCL4o/MN/FRJVC9Gfig==
X-Received: by 2002:a65:62d9:: with SMTP id m25mr5376109pgv.6.1616192445005;
        Fri, 19 Mar 2021 15:20:45 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p5sm6398093pfq.56.2021.03.19.15.20.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:20:44 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 08/16] net: dsa: replay port and
 host-joined mdb entries when joining the bridge
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eb155de5-73b7-1c27-20e9-0177dedfd985@gmail.com>
Date:   Fri, 19 Mar 2021 15:20:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-9-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> I have udhcpcd in my system and this is configured to bring interfaces
> up as soon as they are created.
> 
> I create a bridge as follows:
> 
> ip link add br0 type bridge
> 
> As soon as I create the bridge and udhcpcd brings it up, I have some
> other crap (avahi)

How dare you ;)

 that starts sending some random IPv6 packets to
> advertise some local services, and from there, the br0 bridge joins the
> following IPv6 groups:
> 
> 33:33:ff:6d:c1:9c vid 0
> 33:33:00:00:00:6a vid 0
> 33:33:00:00:00:fb vid 0
> 
> br_dev_xmit
> -> br_multicast_rcv
>    -> br_ip6_multicast_add_group
>       -> __br_multicast_add_group
>          -> br_multicast_host_join
>             -> br_mdb_notify
> 
> This is all fine, but inside br_mdb_notify we have br_mdb_switchdev_host
> hooked up, and switchdev will attempt to offload the host joined groups
> to an empty list of ports. Of course nobody offloads them.
> 
> Then when we add a port to br0:
> 
> ip link set swp0 master br0
> 
> the bridge doesn't replay the host-joined MDB entries from br_add_if,
> and eventually the host joined addresses expire, and a switchdev
> notification for deleting it is emitted, but surprise, the original
> addition was already completely missed.
> 
> The strategy to address this problem is to replay the MDB entries (both
> the port ones and the host joined ones) when the new port joins the
> bridge, similar to what vxlan_fdb_replay does (in that case, its FDB can
> be populated and only then attached to a bridge that you offload).
> However there are 2 possibilities: the addresses can be 'pushed' by the
> bridge into the port, or the port can 'pull' them from the bridge.
> 
> Considering that in the general case, the new port can be really late to
> the party, and there may have been many other switchdev ports that
> already received the initial notification, we would like to avoid
> delivering duplicate events to them, since they might misbehave. And
> currently, the bridge calls the entire switchdev notifier chain, whereas
> for replaying it should just call the notifier block of the new guy.
> But the bridge doesn't know what is the new guy's notifier block, it
> just knows where the switchdev notifier chain is. So for simplification,
> we make this a driver-initiated pull for now, and the notifier block is
> passed as an argument.
> 
> To emulate the calling context for mdb objects (deferred and put on the
> blocking notifier chain), we must iterate under RCU protection through
> the bridge's mdb entries, queue them, and only call them once we're out
> of the RCU read-side critical section.
> 
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h |  9 +++++
>  net/bridge/br_mdb.c       | 84 +++++++++++++++++++++++++++++++++++++++
>  net/dsa/dsa_priv.h        |  2 +
>  net/dsa/port.c            |  6 +++
>  net/dsa/slave.c           |  2 +-
>  5 files changed, 102 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index ebd16495459c..4c25dafb013d 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -69,6 +69,8 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto);
>  bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
>  bool br_multicast_enabled(const struct net_device *dev);
>  bool br_multicast_router(const struct net_device *dev);
> +int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb, struct netlink_ext_ack *extack);
>  #else
>  static inline int br_multicast_list_adjacent(struct net_device *dev,
>  					     struct list_head *br_ip_list)
> @@ -93,6 +95,13 @@ static inline bool br_multicast_router(const struct net_device *dev)
>  {
>  	return false;
>  }
> +static inline int br_mdb_replay(struct net_device *br_dev,
> +				struct net_device *dev,
> +				struct notifier_block *nb,
> +				struct netlink_ext_ack *extack)
> +{
> +	return -EINVAL;

Should we return -EOPNOTUSPP such that this is not made fatal for DSA if
someone compiles its kernel with CONFIG_BRIDGE_IGMP_SNOOPING disabled?

> +}
>  #endif
>  
>  #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 8846c5bcd075..23973186094c 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -506,6 +506,90 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
>  	kfree(priv);
>  }
>  
> +static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
> +			     struct net_bridge_mdb_entry *mp, int obj_id,
> +			     struct net_device *orig_dev,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct switchdev_notifier_port_obj_info obj_info = {
> +		.info = {
> +			.dev = dev,
> +			.extack = extack,
> +		},
> +	};
> +	struct switchdev_obj_port_mdb mdb = {
> +		.obj = {
> +			.orig_dev = orig_dev,
> +			.id = obj_id,
> +		},
> +		.vid = mp->addr.vid,
> +	};
> +	int err;
> +
> +	if (mp->addr.proto == htons(ETH_P_IP))
> +		ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
> +#if IS_ENABLED(CONFIG_IPV6)
> +	else if (mp->addr.proto == htons(ETH_P_IPV6))
> +		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
> +#endif
> +	else
> +		ether_addr_copy(mdb.addr, mp->addr.dst.mac_addr);

How you would feel about re-using br_mdb_switchdev_host_port() here and
pass a 'type' value that is neither RTM_NEWDB nor RTM_DELDB just so you
don't have to duplicate that code here and we ensure it is in sync?
-- 
Florian
