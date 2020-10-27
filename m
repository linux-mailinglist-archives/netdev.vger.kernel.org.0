Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C564429B17C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 15:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759993AbgJ0Oat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:30:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902001AbgJ0O3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXPys-003opd-A3; Tue, 27 Oct 2020 15:29:46 +0100
Date:   Tue, 27 Oct 2020 15:29:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027142946.GE878328@lunn.ch>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027122720.6jm4vuivi7tozzdq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027122720.6jm4vuivi7tozzdq@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > (mv88e6xxx) What is the policy regarding the use of DSA vs. EDSA?  It
> > seems like all chips capable of doing EDSA are using that, except for
> > the Peridot.
> 
> I have no documentation whatsoever for mv88e6xxx, but just wondering,
> what is the benefit brought by EDSA here vs DSA? Does DSA have the
> same restriction when the ports are in a LAG?

Hi Vladimir

One advantage of EDSA is that it uses a well known Ether Type. It was
easy for me to add support to tcpdump to spot this Ether type, decode
the EDSA header, and pass the rest of the frame on for further
processing as normal.

With DSA, you cannot look at the packet and know it is DSA, and then
correctly decode it. So tcpdump just show the packet as undecodable.

Florian fixed this basic problem a while ago, since not being able to
decode packets is a problem for all tagger except EDSA. So now there
is extra meta information inserted into the pcap file, which gives
tcpdump the hint it needs to do the extra decoding of the tagger
header. But before that was added, it was much easier to debug EDSA vs
DSA because of tcpdump decoding.

	Andrew
