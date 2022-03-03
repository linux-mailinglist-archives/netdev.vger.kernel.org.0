Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E014CC8DD
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiCCW2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiCCW2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:28:32 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA2433360;
        Thu,  3 Mar 2022 14:27:46 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id bg10so13718180ejb.4;
        Thu, 03 Mar 2022 14:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lhX6RB0dmLl0zBx/bSbkGbH0bXRDixWhMm0OMYsDjEU=;
        b=nUcta1pBTg1eBDqSeVWWC7RG7LE4QO9NxqSvWSEBN6avbu3LxoVHgonweXNczxA8MY
         +0Xj6fYsk9kHfFFRpreqU9+GJF2viD2HI+ZdY1mhk/jIuewPSKhu1Irnu+7J7LLQXKVg
         Z//I2qjCq4oVYHYpupnAzHWP6Z2BBlhtBVlzl7AwyiHgequ7CP/pVy8emqV4jZhPxD4Z
         GB9VFg9w4zeY/9P30Hjj0LMeUHKGlVp330zGsWsVAI9UCVxnjvJZgcMcAjywIN65TF8n
         nrg2CurmSd4ZdoOTAw4FVnASk1a5QpYDKtbLcXQHWVlEEj82yA5ezQrcCPbZO32CUuYX
         wRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lhX6RB0dmLl0zBx/bSbkGbH0bXRDixWhMm0OMYsDjEU=;
        b=nZj+YcqnE2QDj+XS2WjJ/btzix8HFnf9YoN4ruW7k0uHXP9p4XQmtYUwWwth3HGlTE
         snEYJxk5iDtzbc8m+GUkgmo9Ftptm+i40X5agEij64SErRLagiGtIES+hiN9az8w34XY
         TWOVoS2hHBwzQWMUSpguAd2yzJrt0ve2jycsb8CFmMo0kgD2bYlpP0vlieqj+lzNOXxy
         Yt/mODhU2yAN6k6Su3tfRkoSMgXAqUh7/CwO8sZ3/d+YGWoGczlzTLycWfoiCKfKFUzU
         NRYMm9FKCWaYNtecn9jiVbNdZm0fYd0NQi/5w8iPirmpJtSSOS98cnV+J7NdBi2FIC53
         cxZw==
X-Gm-Message-State: AOAM533HkViY2jPAianlZfom1wNTfg3k9mP4SlfETYtIBLR2u/tSsrGF
        OOi2qbHJi0FbXrvHjIA4SdY=
X-Google-Smtp-Source: ABdhPJwPUPd+eZufSqs2WXGP5Zo2/8iTvzMgr73R155deDRlQqBghh7PIunOorAqMCKxilu/lv6H3g==
X-Received: by 2002:a17:906:a10:b0:6ce:7107:598b with SMTP id w16-20020a1709060a1000b006ce7107598bmr28299009ejf.653.1646346464998;
        Thu, 03 Mar 2022 14:27:44 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id v2-20020a509d02000000b00412d53177a6sm1368434ede.20.2022.03.03.14.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:27:44 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:27:42 +0200
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
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 02/10] net: bridge: mst: Allow changing a
 VLAN's MSTI
Message-ID: <20220303222742.si2gksy3tzagsc7r@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301100321.951175-3-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:03:13AM +0100, Tobias Waldekranz wrote:
> Allow a VLAN to move out of the CST (MSTI 0), to an independent tree.
> 
> The user manages the VID to MSTI mappings via a global VLAN
> setting. The proposed iproute2 interface would be:
> 
>     bridge vlan global set dev br0 vid <VID> msti <MSTI>
> 
> Changing the state in non-zero MSTIs is still not supported, but will
> be addressed in upcoming changes.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

> +static void br_mst_vlan_sync_state(struct net_bridge_vlan *pv, u16 msti)
> +{
> +	struct net_bridge_vlan_group *vg = nbp_vlan_group(pv->port);
> +	struct net_bridge_vlan *v;
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {
> +		/* If this port already has a defined state in this
> +		 * MSTI (through some other VLAN membership), inherit
> +		 * it.
> +		 */
> +		if (v != pv && v->brvlan->msti == msti) {
> +			br_mst_vlan_set_state(pv->port, pv, v->state);
> +			return;
> +		}
> +	}
> +
> +	/* Otherwise, start out in a new MSTI with all ports disabled. */
> +	return br_mst_vlan_set_state(pv->port, pv, BR_STATE_DISABLED);
> +}
> +
> +int br_mst_vlan_set_msti(struct net_bridge_vlan *mv, u16 msti)
> +{
> +	struct net_bridge_vlan_group *vg;
> +	struct net_bridge_vlan *pv;
> +	struct net_bridge_port *p;

No attempt to detect non-changes to the MSTI, and exit early? In a later
patch you will also notify switchdev uselessly because of this.

> +
> +	mv->msti = msti;
> +
> +	list_for_each_entry(p, &mv->br->port_list, list) {
> +		vg = nbp_vlan_group(p);
> +
> +		pv = br_vlan_find(vg, mv->vid);
> +		if (pv)
> +			br_mst_vlan_sync_state(pv, msti);
> +	}
> +
> +	return 0;
> +}
