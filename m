Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A1D52F550
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351325AbiETVsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbiETVsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:48:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81BA8A5029;
        Fri, 20 May 2022 14:48:02 -0700 (PDT)
Date:   Fri, 20 May 2022 23:47:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: [RFC] netfilter: nf_tables: ignore errors on flowtable device hw
 offload setup
Message-ID: <YogMj4PC/+DXYjQX@salvia>
References: <20220510202739.67068-1-nbd@nbd.name>
 <Yn4NnwAkoVryQtCK@salvia>
 <b1fd2a80-f629-48a3-7466-0e04f2c531df@nbd.name>
 <Yn4TmdzQPUQ4TRUr@salvia>
 <88da25b7-0cd0-49df-c09e-8271618ba50f@nbd.name>
 <YoGhjjhsE1PcVeFC@salvia>
 <1c368b57-be21-5c37-ef38-e23fe344b70a@nbd.name>
 <YodIN0jLtAcHUq40@salvia>
 <ede77f8a-73d3-b507-5a7d-e8e3004e930d@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ede77f8a-73d3-b507-5a7d-e8e3004e930d@nbd.name>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 08:07:44PM +0200, Felix Fietkau wrote:
> 
> On 20.05.22 09:50, Pablo Neira Ayuso wrote:
> > I'm sssuming we relax the requirement as I proposed, ie. allow for not
> > allow devices to support for hardware offload, but at least one.
> > 
> > Then, it should be possible to extend the netlink interface to promote
> > a flowtable to support hardware offload, e.g.
> > 
> >   add flowtable inet x y { hook ingress devices = { eth0, eth1 } priority 0; flags offload; }
> > 
> > For an existing flowtable, that will add eth0 and eth1, and it will
> > request to turn hardware offload.
> > 
> > This is not supported, these bits are missing in the netlink interface.
> > 
> > > I still think the best course of action is to silently accept the offload
> > > flag even if none of the devices support hw offload.
> > 
> > Silent means user is asking for something that is actually not
> > supported, there will be no effective way from the control plane to
> > check if what they request is actually being applied.
> > 
> > I'd propose two changes:
> > 
> > - relax the existing requirement, so if one device support hw offload,
> >    then accept the configuration.
> > 
> > - allow to update a flowtable to on/off hardware offload from netlink
> >    interface without needing to reload your whole ruleset.
>
> I still don't see the value in forcing user space to do the
> failure-and-retry dance if none of the devices support hw offload.
> If this is about notifying user space about the hw offload status, I think
> it's much better to simply accept such configurations as-is and extend the
> netlink api to report which of the member devices hw offload was actually
> enabled for.
> This would be much more valuable to users that actually care about the hw
> offload status than knowing if one of the devices in the list has hw offload
> support, and it would simplify the code as well, for kernel and user space
> alike.

I would suggest to extend the API to expose if the device actually
support for the flowtable hardware offload, then after the listing,
the user knows if the feature is available, so they can turn it on.
