Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB76B5058
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 19:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjCJSq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 13:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjCJSqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 13:46:47 -0500
X-Greylist: delayed 530 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Mar 2023 10:46:37 PST
Received: from srv4.3e8.eu (srv4.3e8.eu [IPv6:2001:67c:12a0:200::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADFA11F695
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 10:46:37 -0800 (PST)
Received: from [IPV6:2003:c6:cf02:2a0:7386:7d2e:443a:1890] (p200300c6cf0202a073867d2e443a1890.dip0.t-ipconnect.de [IPv6:2003:c6:cf02:2a0:7386:7d2e:443a:1890])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by srv4.3e8.eu (Postfix) with ESMTPSA id 1529A40B99;
        Fri, 10 Mar 2023 19:37:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=3e8.eu; s=mail20211217;
        t=1678473459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Vux3fToYGGKu6hwZ2kMDklmk3KXrmteEeKXCmqxNfc=;
        b=LAZfBQ/VD6OckDDd79YLZhul5Gd56HRoHG6VybkyQ9ZN9CjPflvyaR/6vQ40IiVM+fuJDh
        S5Q9ulNYh51UkIuavtHdOo/5yGD0AqrTOndpsac3tLDmBy7RqVJ4WHg711m2vgVYDP0Z42
        4JYtaRONWd5K6hDY9drizcrumPooSSa07JCPEsyfINwHjBSZGYPefAyGbCmhrlYl8PSc2n
        PzDJ5vwY+qMMPvkKtO6jn2KSELkViagzSNI3O1x18Fb12h3ZSRd6tBy23DhiiUMXEDqg/J
        dNnoFWnsHnXNDx1vbKzAR6gmz25I6wNWf/BvX3Rkx2CUzBZnlrY1OYEnCBW7fg==
Message-ID: <db38eb8f-9109-b142-6ef4-91df1c1c9de3@3e8.eu>
Date:   Fri, 10 Mar 2023 19:37:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
To:     Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     openwrt-devel@lists.openwrt.org,
        Sander Vanheule <sander@svanheule.net>,
        erkin.bozoglu@xeront.com
References: <20230303214846.410414-1-jan@3e8.eu>
 <dd0c8abb-ebb7-8ea5-12ed-e88b5e310a28@arinc9.com>
 <20230306134636.p2ufzoqk6kf3hu3y@skbuf>
Content-Language: en-US
From:   Jan Hoffmann <jan@3e8.eu>
Subject: Re: [PATCH 0/6] realtek: fix management of mdb entries
In-Reply-To: <20230306134636.p2ufzoqk6kf3hu3y@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Thank you for having a look at this!

On 06.03.2023 14:46, Vladimir Oltean wrote:
> On Sat, Mar 04, 2023 at 01:52:32PM +0300, Arınç ÜNAL wrote:
>> On 4.03.2023 00:48, Jan Hoffmann wrote:
>>> This series fixes multiple issues related to the L2 table and multicast
>>> table. That includes an issue that causes corruption of the port mask
>>> for unknown multicast forwarding, which can occur even when multicast
>>> snooping is disabled.
>>>
>>> With these patches, multicast snooping should be mostly working.
>>> However, one important missing piece is forwarding of all multicast
>>> traffic to multicast router ports (as specified in section 2.1.2-1 of
>>> RFC4541). As far as I can see, this is a general issue that affects all
>>> DSA switches, and cannot be fixed without changes to the DSA subsystem.
>>
>> Do you plan to discuss this on the netdev mailing list with Vladimir?
>>
>> Arınç
> 
> I searched for the patches and found them at
> https://patchwork.ozlabs.org/project/openwrt/cover/20230303214846.410414-1-jan@3e8.eu/
> 
> I guess that what should be discussed is the topic of switch ports
> attached to multicast routers, yes?
> 
> DSA does not (and has never) listen(ed) to the switchdev notifications
> emitted for bridge ports regarding multicast routers (SWITCHDEV_ATTR_ID_PORT_MROUTER).
> It has only listened for a while to the switchdev notifications for the
> bridge itself as a multicast router (SWITCHDEV_ATTR_ID_BRIDGE_MROUTER),
> and even that was done for a fairly strange reason and eventually got
> reverted for breaking something - see commits 08cc83cc7fd8 and c73c57081b3d.
> 
> I personally don't have use cases for IP multicast routing / snooping,
> so I would need some guidance regarding what is needed for things to
> work smoothly. Also, to make sure that they keep working in the future,
> one of the tests from tools/testing/selftests/net/forwarding/ which
> exercises flooding towards multicast ports (if it exists) should be
> symlinked to tools/testing/selftests/drivers/net/dsa/ and adapted until
> it works. That's a pretty good way to get maintainers' attention on a
> feature that they don't normally test.
> 
> It's not the first time I'm reading RFC4541, but due to a lack of any
> practical applications surrounding me (and therefore also partial lack
> of understanding), I keep forgetting what it says :)
> 
> Section 2.1.1.  IGMP Forwarding Rules (for the control path) says
> 
>     1) A snooping switch should forward IGMP Membership Reports only to
>        those ports where multicast routers are attached.
> 
> how? I guess IGMP/MLD packets should reach the CPU via packet traps
> (which cause skb->offload_fwd_mark to be unset), and from there, the
> bridge software data path identifies the mrouter ports and forwards
> control packets only there? What happens if the particular switch
> hardware doesn't support IGMP/MLD packet identification and trapping?

I wasn't really thinking about this potential issue, as that already 
works for switches that trap IGMP/MLD reports to the CPU. But multicast 
snooping is definitely going to be broken for DSA drivers that implement 
the MDB methods but don't trap IGMP/MLD to the CPU port.

> Should the driver install a normal multicast forwarding rule for
> all 224.0.0.X traffic (translated to MAC), and patch the tagging
> protocol driver to set skb->offload_fwd_mark = 0 based on
> eth_hdr(skb)->h_dest?
Doing something like that should work for IGMPv3/MLDv2, as reports have 
the fixed destination addresses 224.0.0.22 and ff02:16. However, for 
these protocol versions, it should also be okay to flood reports, 
because clients don't do report suppression in that case.

For IGMPv1/IGMPv2/MLDv1, this approach isn't practical, as reports are 
sent to the group address itself, i.e. are not limited to 224.0.0.X. 
Detecting them requires looking further into the packets (there are a 
few details on this in section 3 "IPv6 Considerations" of RFC4515).

So, I don't think there really is a good way to do multicast snooping on 
hardware that doesn't support detecting and trapping IGMP/MLD reports 
specifically. Of course, trapping all multicast to the CPU (as you 
suggested below) should always be an option, but the additional CPU load 
might be an issue.

Another possibility would be to just not support multicast snooping on 
such devices and always flood multicast (i.e. how a driver without 
port_mdb_add/port_mdb_del works right now). However, that opens the 
question about what should happen when multicast snooping is enabled on 
a bridge (which is the default), but the DSA switch does not support it. 
I guess a clean solution would be to just not allow this in the first 
place. If this is allowed, then making sure that any multicast 
originating from the CPU is flooded to all switch ports should also 
avoid breaking multicast (but having a bridge that performs multicast 
snooping only partially, i.e. for the non-offloaded ports, is probably a 
confusing design).

> Then for the data path we have:
> 
> 2.1.2.  Data Forwarding Rules
> 
>     1) Packets with a destination IP address outside 224.0.0.X which are
>        not IGMP should be forwarded according to group-based port
>        membership tables and must also be forwarded on router ports.
> 
>        This is the main IGMP snooping functionality for the data path.
>        One approach that an implementation could take would be to
>        maintain separate membership and multicast router tables in
>        software and then "merge" these tables into a forwarding cache.
> 
> For my clarity, this means that *all* IP multicast packets must be
> forwarded to the multicast router ports, be their addresses known
> (bridge mdb entries exist for them) or unknown (flooded)?

Yes, that is how I understand this section as well.

> What does the software bridge implementation do? Does it perform this
> "merging" of tables for us? (for known MDB entries, does it also notify
> them through switchdev on the mrouter ports?) Looking superficially at
> the first-order callers of br_mdb_notify(), I don't get the impression
> that the bridge has this logic?

Unfortunately, the software bridge implementation doesn't do this kind 
of merging ahead of time, otherwise there wouldn't be any need to handle 
this in DSA. It only takes place in br_multicast_flood, the function 
that does the actual forwarding of registered multicast:

https://elixir.bootlin.com/linux/v6.2.3/source/net/bridge/br_forward.c#L277

> Or am I completely off with my reading of RFC4541?
> 
> It's not obvious to me, after looking at the few implementations of
> SWITCHDEV_ATTR_ID_PORT_MROUTER handlers in drivers, that this merging of
> forwarding tables would be done anywhere within sight.

It looks to me like all three switchdev drivers with handlers for 
SWITCHDEV_ATTR_ID_PORT_MROUTER actually add the mrouter ports to mdb 
entries:

https://elixir.bootlin.com/linux/v6.2.3/source/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c#L1022

https://elixir.bootlin.com/linux/v6.2.3/source/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c#L2163

https://elixir.bootlin.com/linux/v6.2.3/source/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c#L105

> If someone could explain to me what are the expectations (we don't seem
> to have a lot of good documentation) and how do the existing drivers work,
> we can start discussing more concretely how the layering and API within
> DSA should look like.

I experimented a bit with the rtl83xx switch driver in OpenWrt by 
passing through the switchdev events to the DSA driver:
https://github.com/janh/openwrt/commit/80b677fe04292570d7e304e184fd7d4ac8397a4f

The disadvantage with this approach is that the DSA driver has to do the 
"merging" of mrouter ports and mdb entries. As a port can be a group 
member and multicast router port at the same time, this means the driver 
now has to keep track of all mdb entries, to be able to properly handle 
when a port leaves a group or stops being a multicast router.

If the DSA subsystem could handle the "merging" instead and also call 
port_mdb_add/port_mdb_del as appropriate for multicast router ports, the 
individual drivers wouldn't have to deal with this particular issue at all.

> As a way to fix a bug quickly and get correct behavior, I guess there's
> also the option of stopping to process multicast packets in hardware,
> and configure the switch to always send any multicast to the CPU port
> only. As long as the tagger knows to leave skb->offload_fwd_mark unset,
> the bridge driver should know how to deal with those packets in
> software, and forward them only to whom is interested. But the drawback
> is that there is no forwarding acceleration involved. Maybe DSA should
> have done that from the get go for drivers which didn't care about
> multicast in particular, instead of ending up with this current situation
> which appears to be slightly chaotic.

Thanks,
Jan
