Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CA54D44C8
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 11:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiCJKgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 05:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiCJKgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 05:36:14 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B4B3C48A;
        Thu, 10 Mar 2022 02:35:13 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id a8so11053380ejc.8;
        Thu, 10 Mar 2022 02:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bQ6VLPxZA/BQp7aelq0Kynpjtxn593KsL+2rRCzYMD8=;
        b=U0dCQsgQp6TCd8rEA8cYnAwdl6fBTgG5WYSQgBEZDxV9AjrH4GFH4fDELvXQizUgC/
         kXIB633n8vkKo38n8IXo0Q1TjrsG2mKXzOFbuXxEnYqjo6M9G+bAs4QXHt2PX5dsA4Ql
         X4MQ9QK1QXZLtbGVOvNATbNZV535UYZRqmIHyW7xpO68RHpSCo72EH6IVCw8XVtT5e8u
         dP10Ixe8X2j/bxSCjm+QbUQFXvmm1vxihFhtJyZCMKL2Hk2tnI8rkzPy64lb7xQ12cKI
         DDVCiQJ2NdtgYVk2fonBeutA9GRSmSIvZJVL78zXh1lY0URGc2YH5GQkyU/hbhbg4qKE
         TxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bQ6VLPxZA/BQp7aelq0Kynpjtxn593KsL+2rRCzYMD8=;
        b=vqOSfF9SZtU0OIIQC1OaLFO1J1r0wd8kl49GvjxRaNBomCJMz8fd67Dy74nB6jraZI
         zJ1ugU/SLQoGuxNme84ZuuahF83I563l2fmXXM8+jvNTGkOdyjKqH6crFdtcOCK2nVEy
         8KxgBfhZJjqGSRAx/Mrt93y+mpHD7XlN+4xPX86vx0KvCrWSHUWzQxh5dHM4upRI51ko
         GodKodf1W1uOEDgTV8Kca65OW4HGhbUtKhrmXuiHHPA2OOCMsvGhhzK1sGioNsYXMTyX
         PdbnEb82xkJfVXhUWNefFgQJ7CoXePNwavcqp3bzkwUYLRjj9ca3H+MS8+VftaW+7WoS
         akjQ==
X-Gm-Message-State: AOAM530KFpuLQFE8XLQv14GIomdKSeaYpfewBPMugo7RGwnhJzZ8ovBE
        on/U9hh0sURik3l/1PN0IrY=
X-Google-Smtp-Source: ABdhPJxLnqGbZcXUIDJ2roPuIoqLULkfDNTkDYyIquYyFTOLpJOxffqNQdBFwp96nFWSAVNPnQ5mUA==
X-Received: by 2002:a17:906:3803:b0:6cf:56b9:60a9 with SMTP id v3-20020a170906380300b006cf56b960a9mr3492920ejc.716.1646908511660;
        Thu, 10 Mar 2022 02:35:11 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006d229436793sm1639756ejp.223.2022.03.10.02.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 02:35:11 -0800 (PST)
Date:   Thu, 10 Mar 2022 12:35:09 +0200
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
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: Pass MST state changes to
 driver
Message-ID: <20220310103509.g35syl776kyh5j2n@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-8-tobias@waldekranz.com>
 <20220303222055.7a5pr4la3wmuuekc@skbuf>
 <87mthymblh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mthymblh.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 09:54:34AM +0100, Tobias Waldekranz wrote:
> >> +	if (!dsa_port_can_configure_learning(dp) || dp->learning) {
> >> +		switch (state->state) {
> >> +		case BR_STATE_DISABLED:
> >> +		case BR_STATE_BLOCKING:
> >> +		case BR_STATE_LISTENING:
> >> +			/* Ideally we would only fast age entries
> >> +			 * belonging to VLANs controlled by this
> >> +			 * MST.
> >> +			 */
> >> +			dsa_port_fast_age(dp);
> >
> > Does mv88e6xxx support this? If it does, you might just as well
> > introduce another variant of ds->ops->port_fast_age() for an msti.
> 
> You can limit ATU operations to a particular FID. So the way I see it we
> could either have:
> 
> int (*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid)
> 
> + Maybe more generic. You could imagine there being a way to trigger
>   this operation from userspace for example.
> - We would have to keep the VLAN<->MSTI mapping in the DSA layer in
>   order to be able to do the fan-out in dsa_port_set_mst_state.
> 
> or:
> 
> int (*port_msti_fast_age)(struct dsa_switch *ds, int port, u16 msti)
> 
> + Let's the mapping be an internal affair in the driver.
> - Perhaps, less generically useful.
> 
> Which one do you prefer? Or is there a hidden third option? :)

Yes, I was thinking of "port_msti_fast_age". I don't see a cheap way of
keeping VLAN to MSTI associations in the DSA layer. Only if we could
retrieve this mapping from the bridge layer - maybe with something
analogous to br_vlan_get_info(), but br_mst_get_info(), and this gets
passed a VLAN_N_VID sized bitmap, which the bridge populates with ones
and zeroes.

The reason why I asked for this is because I'm not sure of the
implications of flushing the entire FDB of the port for a single MSTP
state change. It would trigger temporary useless flooding in other MSTIs
at the very least. There isn't any backwards compatibility concern to
speak of, so we can at least try from the beginning to limit the
flushing to the required VLANs.

What I didn't think about, and will be a problem, is
dsa_port_notify_bridge_fdb_flush() - we don't know the vid to flush.
The easy way out here would be to export dsa_port_notify_bridge_fdb_flush(),
add a "vid" argument to it, and let drivers call it. Thoughts?

Alternatively, if you think that cross-flushing FDBs of multiple MSTIs
isn't a real problem, I suppose we could keep the "port_fast_age" method.

> > And since it is new code, you could require that drivers _do_ support
> > configuring learning before they could support MSTP. After all, we don't
> > want to keep legacy mechanisms in place forever.
> 
> By "configuring learning", do you mean this new fast-age-per-vid/msti,
> or being able to enable/disable learning per port? If it's the latter,
> I'm not sure I understand how those two are related.

The code from dsa_port_set_state() which you've copied:

	if (!dsa_port_can_configure_learning(dp) ||
	    (do_fast_age && dp->learning)) {

has this explanation:

1. DSA keeps standalone ports in the FORWARDING state.
2. DSA also disables address learning on standalone ports, where this is
   possible (dsa_port_can_configure_learning(dp) == true).
3. When a port joins a bridge, it leaves its FORWARDING state from
   standalone mode and inherits the bridge port's BLOCKING state
4. dsa_port_set_state() treats a port transition from FORWARDING to
   BLOCKING as a transition requiring an FDB flush
5. due to (2), the FDB flush at stage (4) is in fact not needed, because
   the FDB of that port should already be empty. Flushing the FDB may be
   a costly operation for some drivers, so it is avoided if possible.

So this is why the "dsa_port_can_configure_learning()" check is there -
for compatibility with drivers that can't configure learning => they
keep learning enabled also in standalone mode => they need an FDB flush
when a standalone port joins a bridge.

What I'm saying is: for drivers that offload MSTP, let's force them to
get the basics right first (have configurable learning), rather than go
forward forever with a backwards compatibility mode.
