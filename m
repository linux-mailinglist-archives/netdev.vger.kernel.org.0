Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC2A4DBBE2
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 01:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352965AbiCQAoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 20:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240096AbiCQAoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 20:44:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB4A14099;
        Wed, 16 Mar 2022 17:43:30 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bi12so7623690ejb.3;
        Wed, 16 Mar 2022 17:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=epMYlP8SwfuajkjtWjH/vdDgnJLu6cKl9OWtKi8Kk94=;
        b=Qoted9Hr0eGzmpkCHTYGlB9GWjkE+TWEPm1lkAgM0fg8igtm6f9hjxNnovjmkFDYYg
         fP51yRAboD900JOQlGUtnah7kk9DgdBI1gKsMEvsfFBu1PiRII59tOUASjKEtfHIfNmC
         GsiLQm5utgUqyqnGBl1HB6D0OkGAvSG7ZrNk3W97LO5I3x2ccRdjBagVxbvf2OCfQ947
         xaLp9TCsmOUGYcs0VB4Ir6NJtEalPEjjJLI6I+FhUnxeAvq/yIbmlz3200tabpvIudC9
         QjbAmRccewrzOEva+71WXoyon9TiNTIRW0BwFSy/cCxAGZJ4A7rpsk3NVjQ+l4s+dB1B
         d9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=epMYlP8SwfuajkjtWjH/vdDgnJLu6cKl9OWtKi8Kk94=;
        b=sn8629avyo+sBnXz+FwKNU64fEg7jWSsMoxH6NI7hJ4yQAs46OJItZYaYIHjsB4GmO
         hhpNm8Jy+GKm4TWYb6sEAN8ig40eCAJEWfd3HWvE9FM71FkbV1lHhDyKSPZ9pTnVALOY
         fXVM8AXjHbuJyaskdJQAS8YGYe678GnVTiHFt7Z4TC6/D3ntpTvFEnEQAwkCgYvfDXMj
         g73hrxA5j+I+DQvt9fxw66wLRHt3XrS58jHp50yhnySEyVhCXwlB52IeG/1Pc+uJmv9v
         1cO1f6IwlE36CGlLRtAf1o1jyvGsgytFGrhro+zky9xjAjmorRzcmYArpl6jY7YXJnDR
         9KOw==
X-Gm-Message-State: AOAM532nBbdi17VgeXxNhJvZP6U/Ex6dYUjVa8qile3CBHQzpOCVNQnH
        n5D1l+zK2LNSlEadPc7QKuA=
X-Google-Smtp-Source: ABdhPJwyCt6QsreK6fVWbPz1fnNbV7bg5/AUmfMUCyxa4Mm6zX3eCKFmwX4vrCGRDX68jIsiXer0YA==
X-Received: by 2002:a17:907:7b87:b0:6db:ee39:b55c with SMTP id ne7-20020a1709077b8700b006dbee39b55cmr2218734ejc.98.1647477808962;
        Wed, 16 Mar 2022 17:43:28 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id js24-20020a170906ca9800b006c8aeca8fe8sm1594948ejb.58.2022.03.16.17.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 17:43:28 -0700 (PDT)
Date:   Thu, 17 Mar 2022 02:43:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v5 net-next 07/15] net: bridge: mst: Add helper to map an
 MSTI to a VID set
Message-ID: <20220317004326.ebsc5xjug76qqen3@skbuf>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-8-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316150857.2442916-8-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 04:08:49PM +0100, Tobias Waldekranz wrote:
> br_mst_get_info answers the question: "On this bridge, which VIDs are
> mapped to the given MSTI?"
> 
> This is useful in switchdev drivers, which might have to fan-out
> operations, relating to an MSTI, per VLAN.
> 
> An example: When a port's MST state changes from forwarding to
> blocking, a driver may choose to flush the dynamic FDB entries on that
> port to get faster reconvergence of the network, but this should only
> be done in the VLANs that are managed by the MSTI in question.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  include/linux/if_bridge.h |  7 +++++++
>  net/bridge/br_mst.c       | 26 ++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 3aae023a9353..1cf0cc46d90d 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -119,6 +119,7 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  		     struct bridge_vlan_info *p_vinfo);
>  int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  			 struct bridge_vlan_info *p_vinfo);
> +int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
>  #else
>  static inline bool br_vlan_enabled(const struct net_device *dev)
>  {
> @@ -151,6 +152,12 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  {
>  	return -EINVAL;
>  }
> +
> +static inline int br_mst_get_info(const struct net_device *dev, u16 msti,
> +				  unsigned long *vids)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #if IS_ENABLED(CONFIG_BRIDGE)
> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
> index 00935a19afcc..00b36e629224 100644
> --- a/net/bridge/br_mst.c
> +++ b/net/bridge/br_mst.c
> @@ -13,6 +13,32 @@
>  
>  DEFINE_STATIC_KEY_FALSE(br_mst_used);
>  
> +int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
> +{
> +	const struct net_bridge_vlan_group *vg;
> +	const struct net_bridge_vlan *v;
> +	const struct net_bridge *br;
> +
> +	ASSERT_RTNL();
> +
> +	if (!netif_is_bridge_master(dev))
> +		return -EINVAL;
> +
> +	br = netdev_priv(dev);
> +	if (!br_opt_get(br, BROPT_MST_ENABLED))
> +		return -EINVAL;
> +
> +	vg = br_vlan_group(br);
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {
> +		if (v->msti == msti)
> +			__set_bit(v->vid, vids);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(br_mst_get_info);
> +
>  static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
>  				  u8 state)
>  {
> -- 
> 2.25.1
> 

