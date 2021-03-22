Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0CB3449F3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhCVP5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhCVP4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:56:46 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15156C061574;
        Mon, 22 Mar 2021 08:56:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id jy13so22112395ejc.2;
        Mon, 22 Mar 2021 08:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nU06B+K6T+Upob5Kdb5rTc9RgsFNU7KJnzTdD6AF+fg=;
        b=YADj7C54tW1tz6xywI30a4JmkrlaPDKD7i2/Vi+nGqwNlxf03MmlpoCBCRxwor8wiN
         HfPGEhm3TlWa4T/qA/B2ww0WRKBXxy72FnJpDx6fL4sn8TeT6AMpOuUBQ5HwaoFzHuuw
         8ROl7me0x9iJTcmaajqGRClI+mErJ5g08+thTjAjAYisLUnSs2/+MIeuy/tTcwkifyNl
         raKuLosefeaTlYlQlH1aaUGX9dWy3ry4R7iLHabxhUOjm8oXsUqf+uKabSUMNblB7VWB
         XP/ReAJla7WRqg61KmZk9UqwkIJo5tlUbIl+a6nVzQVs4QG86tv3XBG4lq+vhEdkGgGU
         1Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nU06B+K6T+Upob5Kdb5rTc9RgsFNU7KJnzTdD6AF+fg=;
        b=ajKik6PA0nPv6l3wx+nXM2bBRJ//qwIjKMSe3ThW4w7fiylaIgQuuzkwzmFosoUZLO
         lR/RtKzWwoSlyQGdK7uxyH07d74aB5xpGdSCsWbXKEYcekUbVqrIYGQfYpFeAvtc2eCw
         g0vYt1sux0nJSshC6s1MUQkL3C95GXjuT9a0Hw9AD3pQVnrRTB/Y4KbSnsHxzuK0wiQD
         C/SOV2xwIN6OH6CoOMMS/JM06DSTyQgz/y8UBSVJ1gpK384o20gyv+LabBcjMTEDcQ7G
         ONZVt9OQRudaXgCLqZ3FmwTy6XQwoxTrscGWmuP2oxIEDmTw66mt8p4//FkumRhUXZ1t
         YMFg==
X-Gm-Message-State: AOAM530LBHjC3rvfSAC2qKcmohsuW7iwFMWZqg80UZRCEDfcwx756EAv
        Pat5DoZshPRw1mwytFGY2fM=
X-Google-Smtp-Source: ABdhPJwvu1gQ5YN30uSe36M8oNANjCpB+Qu7H4hxPQO16nOVxyqFlKXCldeIm3f8/ohcxiPgRS1DOQ==
X-Received: by 2002:a17:906:1986:: with SMTP id g6mr400468ejd.533.1616428604678;
        Mon, 22 Mar 2021 08:56:44 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f3sm9915373ejd.42.2021.03.22.08.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 08:56:44 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 08/16] net: dsa: replay port and
 host-joined mdb entries when joining the bridge
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
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
 <eb155de5-73b7-1c27-20e9-0177dedfd985@gmail.com>
 <20210320095311.noojqngoyobuntej@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <602ff919-61ce-2e8e-55f1-5a1bf21e90a1@gmail.com>
Date:   Mon, 22 Mar 2021 08:56:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210320095311.noojqngoyobuntej@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/2021 2:53 AM, Vladimir Oltean wrote:
> On Fri, Mar 19, 2021 at 03:20:38PM -0700, Florian Fainelli wrote:
>>
>>
>> On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>
>>> I have udhcpcd in my system and this is configured to bring interfaces
>>> up as soon as they are created.
>>>
>>> I create a bridge as follows:
>>>
>>> ip link add br0 type bridge
>>>
>>> As soon as I create the bridge and udhcpcd brings it up, I have some
>>> other crap (avahi)
>>
>> How dare you ;)
> 
> Well, it comes preinstalled on my system, I don't need it, and it has
> caused me nothing but trouble. So I think it has earned its title :D
> 
>>> that starts sending some random IPv6 packets to
>>> advertise some local services, and from there, the br0 bridge joins the
>>> following IPv6 groups:
>>>
>>> 33:33:ff:6d:c1:9c vid 0
>>> 33:33:00:00:00:6a vid 0
>>> 33:33:00:00:00:fb vid 0
>>>
>>> br_dev_xmit
>>> -> br_multicast_rcv
>>>    -> br_ip6_multicast_add_group
>>>       -> __br_multicast_add_group
>>>          -> br_multicast_host_join
>>>             -> br_mdb_notify
>>>
>>> This is all fine, but inside br_mdb_notify we have br_mdb_switchdev_host
>>> hooked up, and switchdev will attempt to offload the host joined groups
>>> to an empty list of ports. Of course nobody offloads them.
>>>
>>> Then when we add a port to br0:
>>>
>>> ip link set swp0 master br0
>>>
>>> the bridge doesn't replay the host-joined MDB entries from br_add_if,
>>> and eventually the host joined addresses expire, and a switchdev
>>> notification for deleting it is emitted, but surprise, the original
>>> addition was already completely missed.
>>>
>>> The strategy to address this problem is to replay the MDB entries (both
>>> the port ones and the host joined ones) when the new port joins the
>>> bridge, similar to what vxlan_fdb_replay does (in that case, its FDB can
>>> be populated and only then attached to a bridge that you offload).
>>> However there are 2 possibilities: the addresses can be 'pushed' by the
>>> bridge into the port, or the port can 'pull' them from the bridge.
>>>
>>> Considering that in the general case, the new port can be really late to
>>> the party, and there may have been many other switchdev ports that
>>> already received the initial notification, we would like to avoid
>>> delivering duplicate events to them, since they might misbehave. And
>>> currently, the bridge calls the entire switchdev notifier chain, whereas
>>> for replaying it should just call the notifier block of the new guy.
>>> But the bridge doesn't know what is the new guy's notifier block, it
>>> just knows where the switchdev notifier chain is. So for simplification,
>>> we make this a driver-initiated pull for now, and the notifier block is
>>> passed as an argument.
>>>
>>> To emulate the calling context for mdb objects (deferred and put on the
>>> blocking notifier chain), we must iterate under RCU protection through
>>> the bridge's mdb entries, queue them, and only call them once we're out
>>> of the RCU read-side critical section.
>>>
>>> Suggested-by: Ido Schimmel <idosch@idosch.org>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>>  include/linux/if_bridge.h |  9 +++++
>>>  net/bridge/br_mdb.c       | 84 +++++++++++++++++++++++++++++++++++++++
>>>  net/dsa/dsa_priv.h        |  2 +
>>>  net/dsa/port.c            |  6 +++
>>>  net/dsa/slave.c           |  2 +-
>>>  5 files changed, 102 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
>>> index ebd16495459c..4c25dafb013d 100644
>>> --- a/include/linux/if_bridge.h
>>> +++ b/include/linux/if_bridge.h
>>> @@ -69,6 +69,8 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto);
>>>  bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
>>>  bool br_multicast_enabled(const struct net_device *dev);
>>>  bool br_multicast_router(const struct net_device *dev);
>>> +int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
>>> +		  struct notifier_block *nb, struct netlink_ext_ack *extack);
>>>  #else
>>>  static inline int br_multicast_list_adjacent(struct net_device *dev,
>>>  					     struct list_head *br_ip_list)
>>> @@ -93,6 +95,13 @@ static inline bool br_multicast_router(const struct net_device *dev)
>>>  {
>>>  	return false;
>>>  }
>>> +static inline int br_mdb_replay(struct net_device *br_dev,
>>> +				struct net_device *dev,
>>> +				struct notifier_block *nb,
>>> +				struct netlink_ext_ack *extack)
>>> +{
>>> +	return -EINVAL;
>>
>> Should we return -EOPNOTUSPP such that this is not made fatal for DSA if
>> someone compiles its kernel with CONFIG_BRIDGE_IGMP_SNOOPING disabled?
> 
> Sure, I'll change the return values of the shims everywhere.
> 
>>> +}
>>>  #endif
>>>
>>>  #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
>>> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
>>> index 8846c5bcd075..23973186094c 100644
>>> --- a/net/bridge/br_mdb.c
>>> +++ b/net/bridge/br_mdb.c
>>> @@ -506,6 +506,90 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
>>>  	kfree(priv);
>>>  }
>>>
>>> +static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
>>> +			     struct net_bridge_mdb_entry *mp, int obj_id,
>>> +			     struct net_device *orig_dev,
>>> +			     struct netlink_ext_ack *extack)
>>> +{
>>> +	struct switchdev_notifier_port_obj_info obj_info = {
>>> +		.info = {
>>> +			.dev = dev,
>>> +			.extack = extack,
>>> +		},
>>> +	};
>>> +	struct switchdev_obj_port_mdb mdb = {
>>> +		.obj = {
>>> +			.orig_dev = orig_dev,
>>> +			.id = obj_id,
>>> +		},
>>> +		.vid = mp->addr.vid,
>>> +	};
>>> +	int err;
>>> +
>>> +	if (mp->addr.proto == htons(ETH_P_IP))
>>> +		ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	else if (mp->addr.proto == htons(ETH_P_IPV6))
>>> +		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
>>> +#endif
>>> +	else
>>> +		ether_addr_copy(mdb.addr, mp->addr.dst.mac_addr);
>>
>> How you would feel about re-using br_mdb_switchdev_host_port() here and
>> pass a 'type' value that is neither RTM_NEWDB nor RTM_DELDB just so you
>> don't have to duplicate that code here and we ensure it is in sync?
> 
> The trouble is that br_mdb_switchdev_host calls switchdev_port_obj_add,
> and I think the agreement was that replayed events should be a silent,
> one-to-one conversation via a direct call to the notifier block of the
> interested driver, as opposed to a call to the entire notifier chain
> which would make everybody else in the system see duplicates. This is
> the reason why I duplicated mostly everything.

It's not a whole lot of notification but if you passed a type argument
that is neither of the two supported value (say -1),
br_mdb_switchdev_host_port() would end its execution there, and that
would avoid the duplication altogether. I am not stuck on that idea and
can hardly think for now of why this function would change, or why the
switchdev_obj_port_mdb would change, too.
-- 
Florian
