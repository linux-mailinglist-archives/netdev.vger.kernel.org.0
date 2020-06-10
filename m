Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834281F5DA6
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 23:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgFJVUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 17:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgFJVUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 17:20:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82AE8206F7;
        Wed, 10 Jun 2020 21:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591824038;
        bh=a+WMnH6/yPbuL8PSANPxjRC1KNz5QB8EwmMTF+RMAx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A16FxRcXHRu1mSq80RT2bJOKiY+VDw/HitLxKkH5R3vkHQbGEoTks3peZyQpfBxD3
         HFAwI3j0E7lFoeFRStK+3Sa6VJPo77489H2zRdwQVXvf3S09UXixncGlUhoKV5DQvz
         q3whNmnsFXTOiYlOP/FHlTxBqBcVS0RgK9oB/srY=
Date:   Wed, 10 Jun 2020 14:20:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     dwilder <dwilder@us.ibm.com>
Cc:     netdev@vger.kernel.org, wilder@us.ibm.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com
Subject: Re: [(RFC) PATCH ] be2net: Allow a VF to use physical link state.
Message-ID: <20200610142036.30c13bb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f2e408a1cd3b3e7327769f1b8d37aa74@linux.vnet.ibm.com>
References: <20200609000059.12924-1-dwilder@us.ibm.com>
        <20200609145839.36f1cbec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f2e408a1cd3b3e7327769f1b8d37aa74@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jun 2020 10:22:22 -0700 dwilder wrote:
> On 2020-06-09 14:58, Jakub Kicinski wrote:
> > On Mon,  8 Jun 2020 17:00:59 -0700 David Wilder wrote:  
> >> Hyper-visors owning a PF are allowed by Emulex specification to 
> >> provide
> >> a VF with separate physical and/or logical link states. However, on
> >> linux, a VF driver must chose one or the other.
> >> 
> >> My scenario is a proprietary driver controlling the PF, be2net is the 
> >> VF.
> >> When I do a physical cable pull test the PF sends a link event
> >> notification to the VF with the "physical" link status but this is
> >> ignored in be2net (see be_async_link_state_process() ).
> >> 
> >> The PF is reporting the adapter type as:
> >> 0xe228   /* Device id for VF in Lancer */
> >> 
> >> I added a module parameter "use_pf_link_state". When set the VF should
> >> ignore logical link state and use the physical link state.
> >> 
> >> However I have an issue making this work.  When the cable is pulled I
> >> see two link statuses reported:
> >> [1706100.767718] be2net 8002:01:00.0 eth1: Link is Down
> >> [1706101.189298] be2net 8002:01:00.0 eth1: Link is Up
> >> 
> >> be_link_status_update() is called twice, the first with the physical 
> >> link
> >> status called from be_async_link_state_process(), and the second with 
> >> the
> >> logical link status from be_get_link_ksettings().
> >> 
> >> I am unsure why be_async_link_state_process() is called from
> >> be_get_link_ksettings(), it results in multiple link state changes
> >> (even in the un-patched case). If I eliminate this call then it works.
> >> But I am un-sure of this change.
> >> 
> >> Signed-off-by: David Wilder <dwilder@us.ibm.com>  
> > 
> > Hm. Just looking at the code in __be_cmd_set_logical_link_config():
> > 
> > 
> > 	if (link_state == IFLA_VF_LINK_STATE_ENABLE ||
> > 	    link_state == IFLA_VF_LINK_STATE_AUTO)
> > 		link_config |= PLINK_ENABLE;
> > 
> > 	if (link_state == IFLA_VF_LINK_STATE_AUTO)
> > 		link_config |= PLINK_TRACK;
> > 
> > Maybe we shouldn't set ENABLE for AUTO?  
> 
> If I am understanding this correctly, this is used by the linux PF 
> driver to configure how link status is delivered to a VF.
> 
> My problem is one of interoperability between the PF (not linux) and the 
> VF is running on linux.

I see.

> The PF driver is implemented to the Emulex/Broadcom spec, which allows a 
> PF driver to be configured such that the VF can be notified of both 
> physical and logical link status, separately.

We'd need a first-class support for this behavior both on PF and VF
sides. A module parameter in one vendor driver to enable support for
this behavior when running with a non-Linux PF driver is unlikely to
succeed.

> > The module parameter is definitely not a good idea, what you're asking
> > for seems to be well within the expectation from the
> > .ndo_set_vf_link_state config, so it seems the driver / firmware is 
> > just
> > not implementing that right.  
> 
> I am attempting to resolve an issue that the linux implementation cant 
> conform to the the Emulex specification due to the implementation on 
> linux.

Sadly I'd think that it's Emulex that needs to conform to Linux APIs,
not the other way around.
