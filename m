Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D092260F7
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgGTNf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:35:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgGTNf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 09:35:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxVxS-0061nz-Bk; Mon, 20 Jul 2020 15:35:54 +0200
Date:   Mon, 20 Jul 2020 15:35:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com
Subject: Re: [PATCH net-next 0/4] cxgb4: add ethtool self_test support
Message-ID: <20200720133554.GQ1383417@lunn.ch>
References: <20200717134759.8268-1-vishal@chelsio.com>
 <20200717180251.GC1339445@lunn.ch>
 <20200720062837.GA22415@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720062837.GA22415@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 11:58:37AM +0530, Vishal Kulkarni wrote:
> On Friday, July 07/17/20, 2020 at 20:02:51 +0200, Andrew Lunn wrote:
> > On Fri, Jul 17, 2020 at 07:17:55PM +0530, Vishal Kulkarni wrote:
> > > This series of patches add support for below tests.
> > > 1. Adapter status test
> > > 2. Link test
> > > 3. Link speed test
> > > 4. Loopback test
> > 
> > Hi Vishal
> > 
> > The loopback test is pretty usual for an ethtool self test. But the
> > first 3 are rather odd. They don't really seem to be self tests. What
> > reason do you have for adding these? Are you trying to debug a
> > specific problem?
> > 
> > 	 Andrew
> Hi Andrew,
> 
> Our requirement is to add a list of self tests that can summarize if the adapter is functioning
> properly in a single command during system init. The above tests are the most common ones run by
> our on-field diagnostics team. Besides, these tests seem to be the most common among other drivers as well.
> 
> Hence we have added
> 1. Adapter status test: Tests whether the adapter is alive or crashed
> 2. Link test: Adapter PHY is up or not.
> 3. Link speed test: Adapter has negotiated link speed correctly or not.

Hi Vishal

Knowing that the field team does this is useful. But i still don't see
these as self tests.

From the man page:

       -t --test
              Executes adapter selftest on the specified network
	      device. Possible test modes are:

           offline
                  Perform full set of tests, possibly interrupting normal
		  operation during the tests,

           online Perform limited set of tests, not interrupting normal
	   operation,

           external_lb
                  Perform full set of tests, as for offline, and additionally
		  an external-loopback test.


Maybe a crashed adaptor could be considered a self test, but

1) I expect nearly everything else is failing so it is pretty obvious
2) devlink health seems like a better API

The PHY is up or not is only partially to do with self. It has a lot
to do with the link partner and the cable. Plus ip link show will tell
you this.

3) This actually sounds like a bug. Why would it of negotiated a link
speed it cannot support? If you have non-overlapping sets of
advertised link modes, i.e. there is no common mode to select, the
link should remain down, but this is not an error. You can use ethtool
to list both the local and peer advertised modes. You could also
report this via the new link state properties Mellanox just added.

       Andrew
