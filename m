Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDD53E38B3
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 06:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhHHEtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 00:49:46 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34744 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHHEto (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 00:49:44 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 1784nCFK010240;
        Sun, 8 Aug 2021 06:49:12 +0200
Date:   Sun, 8 Aug 2021 06:49:12 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: bonding: link state question
Message-ID: <20210808044912.GA10092@1wt.eu>
References: <020577f3-763d-48fd-73ce-db38c3c7fdf9@redhat.com>
 <22626.1628376134@famine>
 <d2dfeba3-6cd6-1760-0abb-6005659ac125@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2dfeba3-6cd6-1760-0abb-6005659ac125@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 08:09:31PM -0400, Jonathan Toppins wrote:
> setting miimon = 100 does appear to fix it.
> 
> It is interesting that there is no link monitor on by default. For example
> when I enslave enp0s31f6 to a new bond with miimon == 0, enp0s31f6 starts
> admin down and will never de-assert NO-CARRIER the bond always results in an
> operstate of up. It seems like miimon = 100 should be the default since some
> modes cannot use arpmon.

Historically when miimon was implemented, not all NICs nor drivers had
support for link state checking at all! In addition, there are certain
deployments where you could rely on many devices by having a bond device
on top of a vlan or similar device, and where monitoring could cost a
lot of resources and you'd prefer to rely on external monitoring to set
all of them up or down at once.

I do think however that there remains a case with a missing state
transition in the driver: on my laptop I have a bond interface attached
to eth0, and I noticed that if I suspend the laptop with the link up,
when I wake it up with no interface connected, the bond will not turn
down, regardless of miimon. I have not looked closer yet, but I
suspect that we're relying too much on a state change between previous
and current and that one historically impossible transition does not
exist there and/or used to work because it was handled as part of
another change. I'll eventually have a look.

Willy
