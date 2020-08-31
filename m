Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15602257FAA
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 19:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgHaRfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 13:35:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:47928 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbgHaRfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 13:35:17 -0400
IronPort-SDR: QTwHxIgJ6BCmOagd6yRfqx884YIjgSBf3PLAFOJmhljjJyYiE7ZrKwY//lhXZicF59HqbNEcT4
 QAfQIWuSvFdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="241842693"
X-IronPort-AV: E=Sophos;i="5.76,376,1592895600"; 
   d="scan'208";a="241842693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 10:35:15 -0700
IronPort-SDR: cGVVcZvPecMsySxe4p+Aa46cW0pDw/6y+yCX4Qy4RfoOvq9vnu3LkaXOZowiA3OO7ZO7katJnK
 jpC/HjekF1Yg==
X-IronPort-AV: E=Sophos;i="5.76,376,1592895600"; 
   d="scan'208";a="340726410"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.252.138.103])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 10:35:14 -0700
Date:   Mon, 31 Aug 2020 10:35:12 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] VRRP not working on i40e X722 S2600WFT
Message-ID: <20200831103512.00001fab@intel.com>
In-Reply-To: <20200828155616.3sd2ivrml2gpcvod@csclub.uwaterloo.ca>
References: <20200827183039.hrfnb63cxq3pmv4z@csclub.uwaterloo.ca>
        <20200828155616.3sd2ivrml2gpcvod@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lennart Sorensen wrote:

> On Thu, Aug 27, 2020 at 02:30:39PM -0400, Lennart Sorensen wrote:
> > I have hit a new problem with the X722 chipset (Intel R1304WFT server).
> > VRRP simply does not work.
> > 
> > When keepalived registers a vmac interface, and starts transmitting
> > multicast packets with the vrp message, it never receives those packets
> > from the peers, so all nodes think they are the master.  tcpdump shows
> > transmits, but no receives.  If I stop keepalived, which deletes the
> > vmac interface, then I start to receive the multicast packets from the
> > other nodes.  Even in promisc mode, tcpdump can't see those packets.
> > 
> > So it seems the hardware is dropping all packets with a source mac that
> > matches the source mac of the vmac interface, even when the destination
> > is a multicast address that was subcribed to.  This is clearly not
> > proper behaviour.

Thanks for the report Lennart, I understand your frustration, as this
should probably work without user configuration.

However, please give this command a try:
ethtool --set-priv-flags ethX disable-source-pruning on


> > I tried a stock 5.8 kernel to check if a driver update helped, and updated
> > the nvm firware to the latest 4.10 (which appears to be over a year old),
> > and nothing changes the behaviour at all.
> > 
> > Seems other people have hit this problem too:
> > http://mails.dpdk.org/archives/users/2018-May/003128.html
> > 
> > Unless someone has a way to fix this, we will have to change away from
> > this hardware very quickly.  The IPsec NAT RSS defect we could tolerate
> > although didn't like, while this is just unworkable.
> > 
> > Quite frustrated by this.  Intel network hardware was always great,
> > how did the X722 make it out in this state.
> 
> Another case with the same problem on an X710:
> 
> https://www.talkend.net/post/13256.html

I don't know how to reply to this other thread, but it is about DPDK,
which would require a code change or further investigation to issue the
right command to the hardware to disable source pruning.

