Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BEA3E43A4
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbhHIKK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:10:56 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34761 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233565AbhHIKKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:10:55 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 179AALEM020477;
        Mon, 9 Aug 2021 12:10:21 +0200
Date:   Mon, 9 Aug 2021 12:10:21 +0200
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
Message-ID: <20210809101021.GA20448@1wt.eu>
References: <020577f3-763d-48fd-73ce-db38c3c7fdf9@redhat.com>
 <22626.1628376134@famine>
 <d2dfeba3-6cd6-1760-0abb-6005659ac125@redhat.com>
 <20210808044912.GA10092@1wt.eu>
 <79019b7e-1c2e-7186-4908-cf085b33fb59@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79019b7e-1c2e-7186-4908-cf085b33fb59@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

On Sun, Aug 08, 2021 at 09:31:39PM -0400, Jonathan Toppins wrote:
> I am likely very wrong but the lack of a recalculation of the bond carrier
> state after a lower notifies of an up/down event seemed incorrect. Maybe a
> place to start?

Thanks for the test, it could have been a good candidate but it does
not work :-)

That's what I have after the following sequence:

  - link is up
  - suspend-to-ram
  - unplug the cable
  - resume

  $ ip -br li
  eth0             DOWN           e8:6a:64:5d:19:ed <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> 
  eth0.2@eth0      UP             e8:6a:64:5d:19:ed <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> 
  bond0            UP             e8:6a:64:5d:19:ed <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> 

My bond interface uses eth0 and eth0.2 in active-backup scenario allowing
me to instantly switch between tagged/untagged network depending on the
port I'm connecting to.

I just figured the problem. It's not the bonding driver which is causing
this issue, the issue is with the VLAN interface which incorrectly shows
up while it ought not to, as can be seen above, and the bond naturally
selected it:

  Primary Slave: eth0 (primary_reselect always)
  Currently Active Slave: eth0.2
  MII Status: up
  MII Polling Interval (ms): 200
  Up Delay (ms): 0
  Down Delay (ms): 0
  Peer Notification Delay (ms): 0

So the bond driver works well, I'll have to dig into the 802.1q code
and/or see how the no-carrier state is propagated upstream. So you were
not very wrong at all and put me on the right track :-)

Cheers,
Willy
