Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F41344DCB
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhCVRxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhCVRxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:53:01 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DCCC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:53:01 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id u4so22181152ljo.6
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=S9XrB/yPOTg7SO0eO+VfVbndkc5Zws2e27nb6nPllIY=;
        b=CwHAg96sLJ7agndoZENvfhlwxGPITsoGw/1kXKz8cpTXoLvGkGvmA1/0cqutJ3fa1Y
         MZhVRXFj01nK5i2D2052kwhED0og3gcCuWgT5JtaQFRWEG1ORC5NO0UZhXb1QP3c9iNs
         jGMLWADQWcQbOTdQG3PJlQVkT8L0QRPwfYgUN5NRT5naTO5dMIdxVgSSpGFdTzYivZVX
         j9a2T2MJfHTqmgxQsVgVOLRyh4NrmQslOpdqIflSMi34hqNygHYuOijs5UX7CvJtMPFx
         2TJbAxFWmZupSh/ZcRNdv95f70+kgiaIpT8BGKDHnSRzgToCOKoFkfJxfG7wGC3Ba/ic
         9o5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=S9XrB/yPOTg7SO0eO+VfVbndkc5Zws2e27nb6nPllIY=;
        b=UlSMwVbPaFp72rY3QE+AFiTxTvf7VdzaA/uYngU97g2x8AetSV6Wpkmkda31UdWx3z
         UVyX+LDSJVbS4haSplFf4mjruU5kZtq9kWNzOW/jt1jk67rAqBXCAieaZFdrvU78AxQE
         T94G/WAfMAYMaFJcQapXi5d1UqS1XfGRPDRRVGdyYzcoYFg3HRvG2OMRCtr0FzHiGChk
         Ezgp92gWbMwPLXRpIpbbmMsC/vF1OuA2CDUZhrcYVNfgD+6+uU6OHlgS68kw2vmDU55u
         PkQCnkRcciuNJb5ZuwKcgXpSoDYadz3nj0zc8cTdWYzdCrTzRbS+uyQ1k1m5n4j43KcP
         86GA==
X-Gm-Message-State: AOAM5310M7sNfOdw2a10CXUQPKzHY/Bp/MBm31+R+Gf0elcB0hIfFhM/
        Wv5BI3bjfRr13Msj2gUamuUrsw==
X-Google-Smtp-Source: ABdhPJxlqRpLrbMQRvnVPOOp8SW6kwmPkck8xjLxtWQZvsh0Jwm05F+id9yNHWh7UghT5pGKwV/SJg==
X-Received: by 2002:a2e:910a:: with SMTP id m10mr409383ljg.421.1616435579888;
        Mon, 22 Mar 2021 10:52:59 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j1sm1634686lfb.85.2021.03.22.10.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:52:59 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 1/3] net: dsa: only unset VLAN filtering when last port leaves last VLAN-aware bridge
In-Reply-To: <20210320225928.2481575-2-olteanv@gmail.com>
References: <20210320225928.2481575-1-olteanv@gmail.com> <20210320225928.2481575-2-olteanv@gmail.com>
Date:   Mon, 22 Mar 2021 18:52:58 +0100
Message-ID: <87lfafm5xh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 00:59, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> DSA is aware of switches with global VLAN filtering since the blamed
> commit, but it makes a bad decision when multiple bridges are spanning
> the same switch:
>
> ip link add br0 type bridge vlan_filtering 1
> ip link add br1 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br0
> ip link set swp4 master br1
> ip link set swp5 master br1
> ip link set swp5 nomaster
> ip link set swp4 nomaster
> [138665.939930] sja1105 spi0.1: port 3: dsa_core: VLAN filtering is a global setting
> [138665.947514] DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE
>
> When all ports leave br1, DSA blindly attempts to disable VLAN filtering
> on the switch, ignoring the fact that br0 still exists and is VLAN-aware
> too. It fails while doing that.
>
> This patch checks whether any port exists at all and is under a
> VLAN-aware bridge.
>
> Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  net/dsa/switch.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 4b5da89dc27a..32963276452f 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -107,7 +107,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
>  	bool unset_vlan_filtering = br_vlan_enabled(info->br);
>  	struct dsa_switch_tree *dst = ds->dst;
>  	struct netlink_ext_ack extack = {0};
> -	int err, i;
> +	int err, port;
>  
>  	if (dst->index == info->tree_index && ds->index == info->sw_index &&
>  	    ds->ops->port_bridge_join)
> @@ -124,13 +124,16 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
>  	 * it. That is a good thing, because that lets us handle it and also
>  	 * handle the case where the switch's vlan_filtering setting is global
>  	 * (not per port). When that happens, the correct moment to trigger the
> -	 * vlan_filtering callback is only when the last port left this bridge.
> +	 * vlan_filtering callback is only when the last port leaves the last
> +	 * VLAN-aware bridge.
>  	 */
>  	if (unset_vlan_filtering && ds->vlan_filtering_is_global) {
> -		for (i = 0; i < ds->num_ports; i++) {
> -			if (i == info->port)
> -				continue;
> -			if (dsa_to_port(ds, i)->bridge_dev == info->br) {
> +		for (port = 0; port < ds->num_ports; port++) {
> +			struct net_device *bridge_dev;
> +
> +			bridge_dev = dsa_to_port(ds, port)->bridge_dev;
> +
> +			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
>  				unset_vlan_filtering = false;
>  				break;
>  			}
> -- 
> 2.25.1

Is it the case that all devices in which VLAN filtering is a global
setting are also single-chip? To my _D_SA eyes, it feels like we should
have to iterate over all ports in the tree, not just the switch.
