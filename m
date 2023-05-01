Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AAB6F3190
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 15:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjEANdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 09:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjEANdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 09:33:43 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C473AE7;
        Mon,  1 May 2023 06:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=W30vo2a/DaYLsV5lycHCuXpr30UwYmCUDX3N1I7uon8=; b=TS8XUHk3rkjgEf4iri4hxXGrPC
        QkpPYFLBcUQvbpSnnhSyiJO5i1zqj6be6eWgSLd0kwkb/lYWXrByuishyPDj+L+g9YQAS4Tzi8cm0
        eWXJuKzkiI40LyQFldDJ8s+YX7IfjhRarcJd6vM+C/5uQ3inQVqT2E2c3+QcNtogOSrEkzlAisK21
        T7e2L3dwuys862rPOydg8GnGIGiutNSFWz62K+22v8IaB6fBPxY2m9tkK2oI04mS++DJFJtS1gt3K
        P6Hkw3DlHR7Sd8QTNKcV7mkx1KszLms1fQ6HcWUFqBx2L9mwD6h5OEjIoTNGB/aYfmDdaB3bRBeo2
        IVDmdxWg==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1ptTer-00006E-LD; Mon, 01 May 2023 15:33:37 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ptTeq-000WZm-Vn; Mon, 01 May 2023 15:33:37 +0200
Subject: Re: [PATCH v2 net] bonding: add xdp_features support
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, alardam@gmail.com, memxor@gmail.com,
        sdf@google.com, brouer@redhat.com, toke@redhat.com,
        Jussi Maki <joamaki@gmail.com>
References: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1260d53a-1a05-9615-5a39-4c38171285fd@iogearbox.net>
Date:   Mon, 1 May 2023 15:33:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26893/Mon May  1 09:22:05 2023)
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/23 12:02 PM, Lorenzo Bianconi wrote:
> Introduce xdp_features support for bonding driver according to the slave
> devices attached to the master one. xdp_features is required whenever we
> want to xdp_redirect traffic into a bond device and then into selected
> slaves attached to it.
> 
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Please also keep Jussi in Cc for bonding + XDP reviews [added here].

> ---
> Change since v1:
> - remove bpf self-test patch from the series

Given you targeted net tree, was this patch run against BPF CI locally from
your side to avoid breakage again?

Thanks,
Daniel

> ---
>   drivers/net/bonding/bond_main.c    | 48 ++++++++++++++++++++++++++++++
>   drivers/net/bonding/bond_options.c |  2 ++
>   include/net/bonding.h              |  1 +
>   3 files changed, 51 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 710548dbd0c1..c98121b426a4 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1789,6 +1789,45 @@ static void bond_ether_setup(struct net_device *bond_dev)
>   	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>   }
>   
> +void bond_xdp_set_features(struct net_device *bond_dev)
> +{
> +	struct bonding *bond = netdev_priv(bond_dev);
> +	xdp_features_t val = NETDEV_XDP_ACT_MASK;
> +	struct list_head *iter;
> +	struct slave *slave;
> +
> +	ASSERT_RTNL();
> +
> +	if (!bond_xdp_check(bond)) {
> +		xdp_clear_features_flag(bond_dev);
> +		return;
> +	}
> +
> +	bond_for_each_slave(bond, slave, iter) {
> +		struct net_device *dev = slave->dev;
> +
> +		if (!(dev->xdp_features & NETDEV_XDP_ACT_BASIC)) {
> +			xdp_clear_features_flag(bond_dev);
> +			return;
> +		}
> +
> +		if (!(dev->xdp_features & NETDEV_XDP_ACT_REDIRECT))
> +			val &= ~NETDEV_XDP_ACT_REDIRECT;
> +		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
> +			val &= ~NETDEV_XDP_ACT_NDO_XMIT;
> +		if (!(dev->xdp_features & NETDEV_XDP_ACT_XSK_ZEROCOPY))
> +			val &= ~NETDEV_XDP_ACT_XSK_ZEROCOPY;
> +		if (!(dev->xdp_features & NETDEV_XDP_ACT_HW_OFFLOAD))
> +			val &= ~NETDEV_XDP_ACT_HW_OFFLOAD;
> +		if (!(dev->xdp_features & NETDEV_XDP_ACT_RX_SG))
> +			val &= ~NETDEV_XDP_ACT_RX_SG;
> +		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG))
> +			val &= ~NETDEV_XDP_ACT_NDO_XMIT_SG;
> +	}
> +
> +	xdp_set_features_flag(bond_dev, val);
> +}
> +
>   /* enslave device <slave> to bond device <master> */
>   int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>   		 struct netlink_ext_ack *extack)
> @@ -2236,6 +2275,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>   			bpf_prog_inc(bond->xdp_prog);
>   	}
>   
> +	bond_xdp_set_features(bond_dev);
> +
>   	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s link\n",
>   		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
>   		   new_slave->link != BOND_LINK_DOWN ? "an up" : "a down");
> @@ -2483,6 +2524,7 @@ static int __bond_release_one(struct net_device *bond_dev,
>   	if (!netif_is_bond_master(slave_dev))
>   		slave_dev->priv_flags &= ~IFF_BONDING;
>   
> +	bond_xdp_set_features(bond_dev);
>   	kobject_put(&slave->kobj);
>   
>   	return 0;
> @@ -3930,6 +3972,9 @@ static int bond_slave_netdev_event(unsigned long event,
>   		/* Propagate to master device */
>   		call_netdevice_notifiers(event, slave->bond->dev);
>   		break;
> +	case NETDEV_XDP_FEAT_CHANGE:
> +		bond_xdp_set_features(bond_dev);
> +		break;
>   	default:
>   		break;
>   	}
> @@ -5874,6 +5919,9 @@ void bond_setup(struct net_device *bond_dev)
>   	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
>   		bond_dev->features |= BOND_XFRM_FEATURES;
>   #endif /* CONFIG_XFRM_OFFLOAD */
> +
> +	if (bond_xdp_check(bond))
> +		bond_dev->xdp_features = NETDEV_XDP_ACT_MASK;
>   }
>   
>   /* Destroy a bonding device.
> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
> index f71d5517f829..0498fc6731f8 100644
> --- a/drivers/net/bonding/bond_options.c
> +++ b/drivers/net/bonding/bond_options.c
> @@ -877,6 +877,8 @@ static int bond_option_mode_set(struct bonding *bond,
>   			netdev_update_features(bond->dev);
>   	}
>   
> +	bond_xdp_set_features(bond->dev);
> +
>   	return 0;
>   }
>   
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index c3843239517d..a60a24923b55 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -659,6 +659,7 @@ void bond_destroy_sysfs(struct bond_net *net);
>   void bond_prepare_sysfs_group(struct bonding *bond);
>   int bond_sysfs_slave_add(struct slave *slave);
>   void bond_sysfs_slave_del(struct slave *slave);
> +void bond_xdp_set_features(struct net_device *bond_dev);
>   int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>   		 struct netlink_ext_ack *extack);
>   int bond_release(struct net_device *bond_dev, struct net_device *slave_dev);
> 

