Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F1D4D1382
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbiCHJiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345416AbiCHJhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:37:53 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CDD4133F;
        Tue,  8 Mar 2022 01:36:57 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y12so10086144edt.9;
        Tue, 08 Mar 2022 01:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bgdd+pjLL0TTcBJjFC3vOow5yyBynWCNc6WQ1UzDQec=;
        b=KT5ZbFULzk0OtslSNELNJPT7ht5LcwpTo5BKOrqu5BfRswSKbI+W3BFkDw9/QPP8oJ
         6tGX7NvfD8u9k8QzPKraK11DMhM4lbLIA/kLfr+gW5seyb/L6XteR7DEEQ19ujJLPswZ
         xkO1ZkisPSo42TnGGbhFyScKxZpjxX0cIojNlnR7e8l8KUQ2pDstyKiRpYp2/2DbVR8+
         AIiQCvrZ9gJrLJDmEqN70oypgHXk+ebFnDKuiD2DMTODgID3jl/1PKSkK2QvMQXRD1Lh
         4D5u71BzwowqPshByVebiyUGlp/PHrbpXJlEiI2Aig3Jgy89SW1AqhFKtfXOfSryRnW5
         iRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bgdd+pjLL0TTcBJjFC3vOow5yyBynWCNc6WQ1UzDQec=;
        b=tohAaXbeKwV/W4jC5h576hbh1uh3YFnbLAARGpXHtUMP7H5FfKB826qhKGZkcAqUoe
         TNSvyBQl7SRiJKNCLkAphWxcRJ5QScl6DAEv9LJad2pywwFqoKH1YPWSwsZio7ujYWye
         md53lZ1Ft2ErqoktxA/vEDu85jqILQaAUmmMCaQyt6hQP877awHR5naxDEWJAeympvaW
         ytxyjG1lxyPIite27Wg7Mhmnk+eHvNz8N0wm8gKSlGsJb6HpR+c3i8dlxmMzHwxZpGpu
         Wxs/Jz7uvI2kD7oKvkA/l5agsprhIvkG+UXDZLfBkpEp6mTFylPLTHnpZ4vAB2XNI8CR
         oVDg==
X-Gm-Message-State: AOAM5319QONKAmJIA8xi3/qvBojzTueiduv1SJjnykE3lB9BpIvIPmfN
        N8Grm2o4Bmp+LrDzJa/RMOI=
X-Google-Smtp-Source: ABdhPJwzc7K8I4JiQtHr3iuqywav9ykbuFEW5na4v1EDJadtUDRA3akr63KyVSVTBODc0BO6qCkHyw==
X-Received: by 2002:a05:6402:7cb:b0:415:f059:c817 with SMTP id u11-20020a05640207cb00b00415f059c817mr15221506edy.364.1646732215476;
        Tue, 08 Mar 2022 01:36:55 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id et3-20020a170907294300b006d6534ef273sm5526725ejc.156.2022.03.08.01.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 01:36:55 -0800 (PST)
Date:   Tue, 8 Mar 2022 11:36:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_dsa: Fix tx from VLAN uppers on
 non-filtering bridges
Message-ID: <20220308093653.c2enspat5mvah4n3@skbuf>
References: <20220307110548.812455-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307110548.812455-1-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 12:05:48PM +0100, Tobias Waldekranz wrote:
> In this situation (VLAN filtering disabled on br0):
> 
>     br0.10
>      /
>    br0
>    / \
> swp0 swp1
> 
> When a frame is transmitted from the VLAN upper, the bridge will send
> it down to one of the switch ports with forward offloading
> enabled. This will cause tag_dsa to generate a FORWARD tag. Before
> this change, that tag would have it's VID set to 10, even though VID
> 10 is not loaded in the VTU.
> 
> Before the blamed commit, the frame would trigger a VTU miss and be
> forwarded according to the PVT configuration. Now that all fabric
> ports are in 802.1Q secure mode, the frame is dropped instead.
> 
> Therefore, restrict the condition under which we rewrite an 802.1Q tag
> to a DSA tag. On standalone port's, reuse is always safe since we will
> always generate FROM_CPU tags in that case. For bridged ports though,
> we must ensure that VLAN filtering is enabled, which in turn
> guarantees that the VID in question is loaded into the VTU.
> 
> Fixes: d352b20f4174 ("net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/tag_dsa.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index c8b4bbd46191..e4b6e3f2a3db 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -127,6 +127,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  				   u8 extra)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct net_device *br_dev;
>  	u8 tag_dev, tag_port;
>  	enum dsa_cmd cmd;
>  	u8 *dsa_header;
> @@ -149,7 +150,16 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  		tag_port = dp->index;
>  	}
>  
> -	if (skb->protocol == htons(ETH_P_8021Q)) {
> +	br_dev = dsa_port_bridge_dev_get(dp);
> +
> +	/* If frame is already 802.1Q tagged, we can convert it to a DSA
> +	 * tag (avoiding a memmove), but only if the port is standalone
> +	 * (in which case we always send FROM_CPU) or if the port's
> +	 * bridge has VLAN filtering enabled (in which case the CPU port
> +	 * will be a member of the VLAN).
> +	 */
> +	if (skb->protocol == htons(ETH_P_8021Q) &&
> +	    (!br_dev || br_vlan_enabled(br_dev))) {

Conservative patch. If !br_dev, we could/should inject using
MV88E6XXX_VID_STANDALONE. But since we use FROM_CPU, the classified VLAN
probably does not make a difference that I can see, so there is no
reason to change this now (and certainly not in the same patch).

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  		if (extra) {
>  			skb_push(skb, extra);
>  			dsa_alloc_etype_header(skb, extra);
> @@ -166,10 +176,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  			dsa_header[2] &= ~0x10;
>  		}
>  	} else {
> -		struct net_device *br = dsa_port_bridge_dev_get(dp);
>  		u16 vid;
>  
> -		vid = br ? MV88E6XXX_VID_BRIDGED : MV88E6XXX_VID_STANDALONE;
> +		vid = br_dev ? MV88E6XXX_VID_BRIDGED : MV88E6XXX_VID_STANDALONE;
>  
>  		skb_push(skb, DSA_HLEN + extra);
>  		dsa_alloc_etype_header(skb, DSA_HLEN + extra);
> -- 
> 2.25.1
> 

