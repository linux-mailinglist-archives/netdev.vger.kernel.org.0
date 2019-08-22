Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F065698A29
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 06:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfHVEGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 00:06:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfHVEGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 00:06:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 640F6152474BD;
        Wed, 21 Aug 2019 21:06:22 -0700 (PDT)
Date:   Wed, 21 Aug 2019 21:06:21 -0700 (PDT)
Message-Id: <20190821.210621.1830113293142016068.davem@davemloft.net>
To:     julietk@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/2] net/ibmvnic: unlock rtnl_lock in reset so
 linkwatch_event can run
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820213120.19880-1-julietk@linux.vnet.ibm.com>
References: <20190820213120.19880-1-julietk@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 21:06:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliet Kim <julietk@linux.vnet.ibm.com>
Date: Tue, 20 Aug 2019 17:31:19 -0400

> Commit a5681e20b541 ("net/ibmnvic: Fix deadlock problem in reset") 
> made the change to hold the RTNL lock during a reset to avoid deadlock 
> but linkwatch_event is fired during the reset and needs the RTNL lock.  
> That keeps linkwatch_event process from proceeding until the reset 
> is complete. The reset process cannot tolerate the linkwatch_event 
> processing after reset completes, so release the RTNL lock during the 
> process to allow a chance for linkwatch_event to run during reset. 
> This does not guarantee that the linkwatch_event will be processed as 
> soon as link state changes, but is an improvement over the current code
> where linkwatch_event processing is always delayed, which prevents 
> transmissions on the device from being deactivated leading transmit 
> watchdog timer to time-out. 
> 
> Release the RTNL lock before link state change and re-acquire after 
> the link state change to allow linkwatch_event to grab the RTNL lock 
> and run during the reset.
> 
> Fixes: a5681e20b541 ("net/ibmnvic: Fix deadlock problem in reset")
> Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>

Conditional locking, especialy such extensive use of conditional
locking as is being done here, is strongly discouraged and is always
indicative of bad design.

Please try to rework this change such that the code paths that want
to lock things a certain way are %100 segregated functionally into
different code paths and functions.

Or feel free to find a cleaner way to fix this.
