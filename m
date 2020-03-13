Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405811846DE
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 13:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgCMM23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 08:28:29 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:57483 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMM22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 08:28:28 -0400
X-Originating-IP: 81.149.34.29
Received: from localhost (host81-149-34-29.in-addr.btopenworld.com [81.149.34.29])
        (Authenticated sender: josh@joshtriplett.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 7EE4EFF803;
        Fri, 13 Mar 2020 12:28:25 +0000 (UTC)
Date:   Fri, 13 Mar 2020 12:28:24 +0000
From:   Josh Triplett <josh@joshtriplett.org>
To:     "Jubran, Samih" <sameehj@amazon.com>
Cc:     "Machulsky, Zorik" <zorik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] ena: Speed up initialization 90x by reducing poll
 delays
Message-ID: <20200313122824.GA1389@localhost>
References: <eb427583ff2444dcae18e1e37fb27918@EX13D11EUB003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb427583ff2444dcae18e1e37fb27918@EX13D11EUB003.ant.amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 01:24:17PM +0000, Jubran, Samih wrote:
> Hi Josh,
> 
> Thanks for taking the time to write this patch. I have faced a bug while testing it that I haven't pinpointed yet the root cause of the issue, but it seems to me like a race in the netlink infrastructure.
> 
> Here is the bug scenario:
> 1. created ac  c5.24xlarge instance in AWS in v_virginia region using the default amazon Linux 2 AMI 
> 2. apply your patch won top of net-next v5.2 and install the kernel (currently I'm able to boot net-next v5.2 only, higher versions of net-next suffer from errors during boot time)
> 3. run "rmmod ena && insmod ena.ko" twice
> 
> Result:
> The interface is not in up state
> 
> Expected result:
> The interface should be in up state
> 
> What I know so far:
> * ena_probe() seems to finish with no errors whatsoever
> * adding prints / delays to ena_probe() causes the bug to vanish or less likely to occur depending on the amount of delays I add
> * ena_up() is not called at all when the bug occurs, so it's something to do with netlink not invoking dev_open()
> 
> Did you face such issues? Do you have any idea what might be causing this?

I haven't observed anything like this. I didn't test with Amazon Linux
2, though.

To rule out some possibilities, could you try disabling *all* userspace
networking bits, so that userspace does nothing with a newly discovered
interface, and then testing again? (The interface wouldn't be "up" in
that case, but it should still have a link detected.)

If that works, then I wonder if the userspace used in Amazon Linux 2
might have some kind of race where it's still using the previous
incarnation of the device when you rmmod and insmod? Perhaps the
previous delays made it difficult or impossible to trigger that race?

- Josh Triplett
