Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251D14D5506
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344150AbiCJXJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiCJXJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:09:34 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7CC119F33;
        Thu, 10 Mar 2022 15:08:32 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qa43so15291259ejc.12;
        Thu, 10 Mar 2022 15:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HCHrcR4YJ2xtc4FY2BMgDcY7SCm93U/C5P25h42SrIY=;
        b=jMK7IMUs01zOlEllHurQiT1N5EPE1wNmEvxRQWfhXOx6gNoKLQNEXN2h1NrD+wszIC
         eyOfzZRXEy0kAWYzim/STmfiBrYySHORmABBbw4Lkb1s1p4q9m665GjjEh1YJkF9N1xz
         FTbBMcW5Zig5d/UOZIPy/tMxJfHz8OQMTF4KkQNMhRqvL0ePvKga7n4aGIUp2XbyXMfv
         hCPghJNtUQeDO5S11TO8nuerlPKjcnuXx01QfG8bfUkPztWENQo1yZtC69H5HkUfW1Xc
         qAwau6WUxk2Mu8IkhAdtfKQ/TKcm96WMK3t8Vt73ldjFpRo2jLbTiYT9xnWr3xH+joen
         Xl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HCHrcR4YJ2xtc4FY2BMgDcY7SCm93U/C5P25h42SrIY=;
        b=VEjTQhfItqWSl4t0sbKz7MbF9+irr/UsWZ2VkxnSfFzTDvPAyi5N90na/7ifDOWnVj
         jRtiszGLXcHk5XdUecxYaqiMd/CI1wDN2ic1y78cuDJP+WHyMhTkFhkBTFGOZ5zPXUIC
         ZZOAZHAk4T5tWTtJHMLGDqh9u80W+0HgdGO6Xqj8jomDBCHZCzdrtB+VPdbfdPZYYdGy
         QA3bPoTyQ5jDSOKxGsIcTQRk1+clvsGeiZ2cF+K3RZAJLWy+KmcOpFGj9TYS+kJCwhb2
         QpxGKL24uuzREsvDvqjUpdYHel2cQVB0BSJQS/wmkv2IA82OLDyVOtbKsIkyjsULxMop
         Y3dg==
X-Gm-Message-State: AOAM533r/lINN9YwRFW167Llt5bpB0+Xg9olrrzKa2sIvwGOHjf4VPUD
        djM8fsPd10n9nMLxmzk0TY8=
X-Google-Smtp-Source: ABdhPJw2ZHY1DrWCR9/CFH2RhvFid+fzatFjBzbAFNDCr9M96G4DwCMOxZL3FOZZ/3xaKCBGvYm1cw==
X-Received: by 2002:a17:906:7944:b0:6da:b834:2f3e with SMTP id l4-20020a170906794400b006dab8342f3emr6312071ejo.353.1646953710562;
        Thu, 10 Mar 2022 15:08:30 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id b24-20020a170906491800b006db31196e2bsm2271649ejq.218.2022.03.10.15.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 15:08:30 -0800 (PST)
Date:   Fri, 11 Mar 2022 01:08:28 +0200
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
Message-ID: <20220310230828.fvx24zhoyue5mkb7@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-8-tobias@waldekranz.com>
 <20220303222055.7a5pr4la3wmuuekc@skbuf>
 <87mthymblh.fsf@waldekranz.com>
 <20220310103509.g35syl776kyh5j2n@skbuf>
 <87h785n67k.fsf@waldekranz.com>
 <20220310161857.33owtynhm3pdyxiy@skbuf>
 <87bkydmnmy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkydmnmy.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 11:46:45PM +0100, Tobias Waldekranz wrote:
> On Thu, Mar 10, 2022 at 18:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Thu, Mar 10, 2022 at 05:05:35PM +0100, Tobias Waldekranz wrote:
> >> On Thu, Mar 10, 2022 at 12:35, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > On Thu, Mar 10, 2022 at 09:54:34AM +0100, Tobias Waldekranz wrote:
> >> >> >> +	if (!dsa_port_can_configure_learning(dp) || dp->learning) {
> >> >> >> +		switch (state->state) {
> >> >> >> +		case BR_STATE_DISABLED:
> >> >> >> +		case BR_STATE_BLOCKING:
> >> >> >> +		case BR_STATE_LISTENING:
> >> >> >> +			/* Ideally we would only fast age entries
> >> >> >> +			 * belonging to VLANs controlled by this
> >> >> >> +			 * MST.
> >> >> >> +			 */
> >> >> >> +			dsa_port_fast_age(dp);
> >> >> >
> >> >> > Does mv88e6xxx support this? If it does, you might just as well
> >> >> > introduce another variant of ds->ops->port_fast_age() for an msti.
> >> >> 
> >> >> You can limit ATU operations to a particular FID. So the way I see it we
> >> >> could either have:
> >> >> 
> >> >> int (*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid)
> >> >> 
> >> >> + Maybe more generic. You could imagine there being a way to trigger
> >> >>   this operation from userspace for example.
> >> >> - We would have to keep the VLAN<->MSTI mapping in the DSA layer in
> >> >>   order to be able to do the fan-out in dsa_port_set_mst_state.
> >> >> 
> >> >> or:
> >> >> 
> >> >> int (*port_msti_fast_age)(struct dsa_switch *ds, int port, u16 msti)
> >> >> 
> >> >> + Let's the mapping be an internal affair in the driver.
> >> >> - Perhaps, less generically useful.
> >> >> 
> >> >> Which one do you prefer? Or is there a hidden third option? :)
> >> >
> >> > Yes, I was thinking of "port_msti_fast_age". I don't see a cheap way of
> >> > keeping VLAN to MSTI associations in the DSA layer. Only if we could
> >> > retrieve this mapping from the bridge layer - maybe with something
> >> > analogous to br_vlan_get_info(), but br_mst_get_info(), and this gets
> >> > passed a VLAN_N_VID sized bitmap, which the bridge populates with ones
> >> > and zeroes.
> >> 
> >> That can easily be done. Given that, should we go for port_vlan_fast_age
> >> instead? port_msti_fast_age feels like an awkward interface, since I
> >> don't think there is any hardware out there that can actually perform
> >> that operation without internally fanning it out over all affected VIDs
> >> (or FIDs in the case of mv88e6xxx).
> >
> > Yup, yup. My previous email was all over the place with regard to the
> > available options, because I wrote it in multiple phases so it wasn't
> > chronologically ordered top-to-bottom. But port_vlan_fast_age() makes
> > the most sense if you can implement br_mst_get_info(). Same goes for
> > dsa_port_notify_bridge_fdb_flush().
> >
> >> > The reason why I asked for this is because I'm not sure of the
> >> > implications of flushing the entire FDB of the port for a single MSTP
> >> > state change. It would trigger temporary useless flooding in other MSTIs
> >> > at the very least. There isn't any backwards compatibility concern to
> >> > speak of, so we can at least try from the beginning to limit the
> >> > flushing to the required VLANs.
> >> 
> >> Aside from the performance implications of flows being temporarily
> >> flooded I don't think there are any.
> >> 
> >> I suppose if you've disabled flooding of unknown unicast on that port,
> >> you would loose the flow until you see some return traffic (or when one
> >> side gives up and ARPs). While somewhat esoteric, it would be nice to
> >> handle this case if the hardware supports it.
> >
> > If by "handle this case" you mean "flush only the affected VLANs", then
> > yes, I fully agree.
> >
> >> > What I didn't think about, and will be a problem, is
> >> > dsa_port_notify_bridge_fdb_flush() - we don't know the vid to flush.
> >> > The easy way out here would be to export dsa_port_notify_bridge_fdb_flush(),
> >> > add a "vid" argument to it, and let drivers call it. Thoughts?
> >> 
> >> To me, this seems to be another argument in favor of
> >> port_vlan_fast_age. That way you would know the VIDs being flushed at
> >> the DSA layer, and driver writers needn't concern themselves with having
> >> to remember to generate the proper notifications back to the bridge.
> >
> > See above.
> >
> >> > Alternatively, if you think that cross-flushing FDBs of multiple MSTIs
> >> > isn't a real problem, I suppose we could keep the "port_fast_age" method.
> >> 
> >> What about falling back to it if the driver doesn't support per-VLAN
> >> flushing? Flushing all entries will work in most cases, at the cost of
> >> some temporary flooding. Seems more useful than refusing the offload
> >> completely.
> >
> > So here's what I don't understand. Do you expect a driver other than
> > mv88e6xxx to do something remotely reasonable under a bridge with MSTP
> > enabled? The idea being to handle gracefully the case where a port is
> > BLOCKING in an MSTI but FORWARDING in another. Because if not, let's
> > just outright not offload that kind of bridge, and only concern
> > ourselves with what MST-capable drivers can do.
> 
> I think you're right. I was trying to make it easier for other driver
> writers, but it will just be more confusing and error prone.
> 
> Alright, so v3 will have something like this:
> 
> bool dsa_port_can_offload_mst(struct dsa_port *dp)
> {
> 	return ds->ops->vlan_msti_set &&
> 		ds->ops->port_mst_state_set &&
> 		ds->ops->port_vlan_fast_age &&
> 		dsa_port_can_configure_learning(dp);
> }
> 
> If this returns false, we have two options:
> 
> 1. Return -EOPNOTSUPP, which the bridge will be unable to discriminate
>    from a non-switchdev port saying "I have no idea what you're talking
>    about". I.e. the bridge will happily apply the config, but the
>    hardware won't match. I don't like this, but it lines up with most
>    other stuff.
> 
> 2. Return a hard error, e.g. -EINVAL/-ENOSYS. This will keep the bridge
>    in sync with the hardware and also gives some feedback to the
>    user. This seems like the better approach to me, but it is a new kind
>    of paradigm.
> 
> What do you think?

Wait, what? It matters a lot where you place the call to
dsa_port_can_offload_mst(), too. You don't have to propagate a hard
error code, either, at least if you make dsa_port_bridge_join() return
-EOPNOTSUPP prior to calling switchdev_bridge_port_offload(), no?
DSA transforms this error code into 0, and dsa_port_offloads_bridge*()
starts returning false, which makes us ignore all MSTP related switchdev
notifiers.
The important part will be to make sure that MSTP is enabled for this
bridge from the get-go (that being the only case in which we can offload
an MSTP aware bridge), and refusing to offload dynamic changes to its
MSTP state. I didn't re-check now, but I think I remember there being
limitations even in the software bridge related to dynamic MSTP mode
changes anyway - there had to not be any port VLANs, which IIUC means
that you actually need to _delete_ the port PVIDs which are automatically
created before you could change the MSTP mode.

This is the model, what's wrong with it? I said "don't offload the
bridge", not "don't offload specific MSTP operations".

> > I'm shadowing you with a prototype (and untested so far) MSTP
> > implementation for the ocelot/felix drivers, and those switches can
> > flush the MAC table per VLAN too. So I don't see an immediate need to
> > have a fallback implementation if you'll also provide it for mv88e6xxx.
> > Let's treat that only if the need arises.
> 
> Cool. Agreed, v3 will implement .port_vlan_fast_age for mv88e6xxx.
