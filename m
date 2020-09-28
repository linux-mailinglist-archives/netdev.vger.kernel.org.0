Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0999827B86D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgI1Xpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgI1Xpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:45:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F5723A04;
        Mon, 28 Sep 2020 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601332206;
        bh=mY8I/nt8kjpDPPFP0yWECX4ENjt7ImZ4oPKksLTXQDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YtjAb7g7kAvNBT3WjrIANyKfk7QfgH4tmBwXbPHHsE5JH0c65r9H1WQGJl4Gp6iTJ
         r+HObB4S5Clnffe9uKVgZpWTAdObzgTWKLT1z36fKBJMZxv/SJbRMK9MmeLMh3GNq5
         OfdTgwXbk88J3UmuLmLWlZiu4bRiTnUlai/9hWrE=
Date:   Mon, 28 Sep 2020 15:30:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Sven Auhagen <sven.auhagen@voleatech.de>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: Re: [net-next 01/15] igb: add XDP support
Message-ID: <20200928153003.077836c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200928175908.318502-2-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
        <20200928175908.318502-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 10:58:54 -0700 Tony Nguyen wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Add XDP support to the IGB driver.
> The implementation follows the IXGBE XDP implementation
> closely and I used the following patches as basis:
> 
> 1. commit 924708081629 ("ixgbe: add XDP support for pass and drop actions")
> 2. commit 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
> 3. commit ed93a3987128 ("ixgbe: tweak page counting for XDP_REDIRECT")
> 
> Due to the hardware constraints of the devices using the
> IGB driver we must share the TX queues with XDP which
> means locking the TX queue for XDP.
> 
> I ran tests on an older device to get better numbers.
> Test machine:
> 
> Intel(R) Atom(TM) CPU C2338 @ 1.74GHz (2 Cores)
> 2x Intel I211
> 
> Routing Original Driver Network Stack: 382 Kpps
> 
> Routing XDP Redirect (xdp_fwd_kern): 1.48 Mpps
> XDP Drop: 1.48 Mpps
> 
> Using XDP we can achieve line rate forwarding even on
> an older Intel Atom CPU.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Also some new sparse warnings added here:

drivers/net/ethernet/intel/igb/igb_main.c:6282:23: warning: incorrect type in assignment (different base types)
drivers/net/ethernet/intel/igb/igb_main.c:6282:23:    expected unsigned int [usertype] olinfo_status
drivers/net/ethernet/intel/igb/igb_main.c:6282:23:    got restricted __le32 [usertype]
drivers/net/ethernet/intel/igb/igb_main.c:6287:37: warning: incorrect type in assignment (different base types)
drivers/net/ethernet/intel/igb/igb_main.c:6287:37:    expected restricted __le32 [usertype] olinfo_status
drivers/net/ethernet/intel/igb/igb_main.c:6287:37:    got unsigned int [assigned] [usertype] olinfo_status
