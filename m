Return-Path: <netdev+bounces-2181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCBE3700A92
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAB801C2126B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1867A54;
	Fri, 12 May 2023 14:44:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A352D813
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:44:04 +0000 (UTC)
Received: from sv3.telemetry-investments.com (gw3a.telemetry-investments.com [38.76.0.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18A9B1FCE
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:44:03 -0700 (PDT)
Received: from ti139.telemetry-investments.com (ti139 [192.168.53.139])
	by sv3.telemetry-investments.com (Postfix) with ESMTP id 96A96107D;
	Fri, 12 May 2023 10:44:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=telemetry-investments.com; s=tele1409; t=1683902641;
	bh=oqxNlAGY2D43Rnm4E6ddndclCw4GiVEBc81cPqMIMEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i/iVHu292njYNs/s7sfNgHF1tpUDqyN52j6aT+vs+PzBAQlLWDuA8SLR+kN5PDndN
	 jeOISK6B7BpwcQhsRO3FpDSwPnjSqjrSNIiNyDmltdmMFxRZVn9AlHpn4uJpxgzWQC
	 7DUWZfqtG3NWFYvfREwxXVY4DEqSNYFgH6VwIBwI=
Received: by ti139.telemetry-investments.com (Postfix, from userid 300)
	id 7315E827; Fri, 12 May 2023 10:44:01 -0400 (EDT)
Date: Fri, 12 May 2023 10:44:01 -0400
From: "Andrew J. Schorr" <aschorr@telemetry-investments.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is
 bond 802.3ad
Message-ID: <20230512144401.GA10864@ti139.telemetry-investments.com>
References: <ZEt3hvyREPVdbesO@Laptop-X1>
 <15524.1682698000@famine>
 <ZFjAPRQNYRgYWsD+@Laptop-X1>
 <84548.1683570736@vermin>
 <ZFtMyi9wssslDuD0@Laptop-X1>
 <20230510165738.GA23309@ti139.telemetry-investments.com>
 <20230510171436.GA27945@ti139.telemetry-investments.com>
 <13565.1683855528@famine>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13565.1683855528@famine>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jay,

On Thu, May 11, 2023 at 06:38:48PM -0700, Jay Vosburgh wrote:
> 	The individual port behavior is part of the LACP standard (IEEE
> 802.1AX, recent editions call this "Solitary"), and is done
> automatically by the kernel.  One of the reasons for it is to permit
> exactly the situation you mention: to enable PXE or "fallback"
> communication to work even if LACP negotiation fails or is not
> configured or implemented at one end.  This is called out explicitly in
> 802.1AX, 6.1.1.j.
> 
> 	The duplex test is only part of the "individual" logic; it comes
> up because LACP negotiation requires the peers to be point-to-point
> links, i.e., full duplex (IEEE 802.1AX-2014, 6.4.8).  That's the norm
> for most everything now, but historically a port in half duplex could be
> on a multiple access topology, e.g., 802.3 CSMA/CD 10BASE2 on a coax
> cable, which is incompatible with LACP aggregation.  This situation
> doesn't come up a lot these days.
> 
> 	The important part of the "individual" logic is whether or not
> the port successfully completes LACP negotiation with a link partner.
> If not, the port is an individual port, which acts essentially like an
> aggregator with just one port in it.  This is separate from
> "is_individual" in the bonding code, and happens in
> ad_port_selection_logic(), after the comment "check if current
> aggregator suits us".  "is_individual" is one element of this test, the
> remaining tests compare the various keys and whether the partner MAC
> address has been populated.

OK. So it sounds like this should just work automatically with no
configuration required to identify which slaves are running in individual
mode. Thanks for clarifying.

> 	As far as documentation goes, the bonding docs[0] describe some
> of the parameters, but doesn't describe the specifics of bonding's
> ability to manage multiple aggregators; I should write that up, since
> this comes up periodically.  The IEEE standard (to which the bonding
> implementation conforms) describes how the whole system works, but
> doesn't really have a simple overview.
> 
> [0] https://www.kernel.org/doc/Documentation/networking/bonding.rst

I noticed the parameters related to this and did do some google searching to
learn about having multiple aggregators, but as you say, it would be
helpful to have a few more clues about how this works in the Bonding Howto,
as well as a mention of this individual port capability.

> 	I'll have to give this some thought.  The best long term
> solution would be to decouple the link monitoring stuff from the mode,
> and thus allow ARP and MII in a wider variety of modes.  I've prototyped
> that out in the past, along with changing the MII monitor to respond to
> carrier state changes in real time instead of polling, and it's fairly
> complicated.
> 
> 	In any event, this does sound like a valid use case for nesting
> the bonds, so simply disabling that facility seems to be off the table.

OK, great. Then I'll stick with this config for now, even though NetworkManager
has some brain damage in this area, since it tries to bring up both bonds
before the MAC addresses have gotten sorted out, which can leave everything
with a random MAC address. I've managed to kludge a solution to this by setting
ONBOOT=no for the active-backup bond, which convinces NetworkManager to start
it a bit later and somehow fixes the race condition.

Regards,
Andy

