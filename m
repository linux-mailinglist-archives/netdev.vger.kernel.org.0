Return-Path: <netdev+bounces-1539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E24AD6FE32C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 115831C20DE6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271DE174C3;
	Wed, 10 May 2023 17:23:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA8B14A81
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 17:23:12 +0000 (UTC)
X-Greylist: delayed 499 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 May 2023 10:23:09 PDT
Received: from sv3.telemetry-investments.com (gw3a.telemetry-investments.com [38.76.0.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 874D1526A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:23:09 -0700 (PDT)
Received: from ti139.telemetry-investments.com (ti139 [192.168.53.139])
	by sv3.telemetry-investments.com (Postfix) with ESMTP id 4CF5D232;
	Wed, 10 May 2023 13:14:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=telemetry-investments.com; s=tele1409; t=1683738876;
	bh=rLJ4nRNfhLZ4riTAGObiAYB+AUBDD6Qf4iKgn+q/Qww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=6tpaWEpAFJ107gB4d+iis75c4JpbJI0fD8nH+mkHPbJq0AfPk9XZas+M0uC0KgGW7
	 jt0hBEs7ky06haIzLQ80LoDNIoXy5L8JsyRCGFaIvurKokj+yXk3CvxPFrnVKTAdm1
	 XX3QDgeAuGaMrNv6OpX7iZUBto/pWCkOn4fR/I4I=
Received: by ti139.telemetry-investments.com (Postfix, from userid 300)
	id 44C68885; Wed, 10 May 2023 13:14:36 -0400 (EDT)
Date: Wed, 10 May 2023 13:14:36 -0400
From: "Andrew J. Schorr" <aschorr@telemetry-investments.com>
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is
 bond 802.3ad
Message-ID: <20230510171436.GA27945@ti139.telemetry-investments.com>
References: <ZEt3hvyREPVdbesO@Laptop-X1>
 <15524.1682698000@famine>
 <ZFjAPRQNYRgYWsD+@Laptop-X1>
 <84548.1683570736@vermin>
 <ZFtMyi9wssslDuD0@Laptop-X1>
 <20230510165738.GA23309@ti139.telemetry-investments.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510165738.GA23309@ti139.telemetry-investments.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sorry -- resending from a different email address to fix a problem
with gmail rejecting it.

On Wed, May 10, 2023 at 12:57:38PM -0400, Andrew J. Schorr wrote:
> Hi Hangbin & Jay,
> 
> On Wed, May 10, 2023 at 03:50:34PM +0800, Hangbin Liu wrote:
> > On Mon, May 08, 2023 at 11:32:16AM -0700, Jay Vosburgh wrote:
> > > 	That case should work fine without the active-backup.  LACP has
> > > a concept of an "individual" port, which (in this context) would be the
> > > "normal NIC," presuming that that means its link peer isn't running
> > > LACP.
> > > 
> > > 	If all of the ports (N that are LACP to a single switch, plus 1
> > > that's the non-LACP "normal NIC") were attached to a single bond, it
> > > would create one aggregator with the LACP enabled ports, and then a
> > > separate aggregator for the indvidual port that's not.  The aggregator
> > > selection logic prefers the LACP enabled aggregator over the individual
> > > port aggregator.  The precise criteria is in the commentary within
> > > ad_agg_selection_test().
> > > 
> > 
> > cc Andrew, He add active-backup bond over LACP bond because he want to
> > use arp_ip_target to ensure that the target network is reachable...
> 
> That's correct. I prefer the ARP monitoring to ensure that the needed
> connectivity is actually there instead of relying on MII monitoring.
> 
> I also confess that I was unaware of the possibility of using an individual
> port inside an 802.3ad bond without having to stick that individual port into a
> port-channel group with LACP enabled. I want to avoid enabling LACP on that
> link because I'd like to be able to PXE boot over it, not to mention the switch
> configuration hassle.  Is that individual port configuration without LACP
> detected automatically by the kernel, or do I need to configure something to do
> that? I see the logic in drivers/net/bonding/bond_3ad.c to set is_individual,
> but it appears to depend on whether duplex is enabled. At that point, I got
> lost, since I see duplex mentioned only in ad_user_port_key, and that seems to
> be a property of the bond master, not the slaves. Is there any documentation of
> how this configuration works?
> 
> But in any case, I still prefer active-backup on top of 802.3ad so that I can
> have the ARP monitoring.
> 
> If it's too much trouble to get the top-level bond to report duplex/speed
> correctly when the underlying bond speed changes, then I think it would
> be an improvement to set duplex/speed to N/A (or -1) for a bond of
> bonds configuration instead of potentially having incorrect information.
> I imagine such a fix might be much easier than updating dynamically
> when the lower-level 802.3ad bond changes speed.
> 
> Best regards,
> Andy

