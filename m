Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2881D5AD0B
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfF2TUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:20:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39404 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfF2TUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:20:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A46314C73B0F;
        Sat, 29 Jun 2019 12:20:23 -0700 (PDT)
Date:   Sat, 29 Jun 2019 12:20:22 -0700 (PDT)
Message-Id: <20190629.122022.1773703044487782799.davem@davemloft.net>
To:     gpiccoli@canonical.com
Cc:     GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        skalluru@marvell.com, aelior@marvell.com,
        jay.vosburgh@canonical.com
Subject: Re: [PATCH V4] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627163133.5990-1-gpiccoli@canonical.com>
References: <20190627163133.5990-1-gpiccoli@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 12:20:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Date: Thu, 27 Jun 2019 13:31:33 -0300

> Currently bnx2x ptp worker tries to read a register with timestamp
> information in case of TX packet timestamping and in case it fails,
> the routine reschedules itself indefinitely. This was reported as a
> kworker always at 100% of CPU usage, which was narrowed down to be
> bnx2x ptp_task.
> 
> By following the ioctl handler, we could narrow down the problem to
> an NTP tool (chrony) requesting HW timestamping from bnx2x NIC with
> RX filter zeroed; this isn't reproducible for example with ptp4l
> (from linuxptp) since this tool requests a supported RX filter.
> It seems NIC FW timestamp mechanism cannot work well with
> RX_FILTER_NONE - driver's PTP filter init routine skips a register
> write to the adapter if there's not a supported filter request.
> 
> This patch addresses the problem of bnx2x ptp thread's everlasting
> reschedule by retrying the register read 10 times; between the read
> attempts the thread sleeps for an increasing amount of time starting
> in 1ms to give FW some time to perform the timestamping. If it still
> fails after all retries, we bail out in order to prevent an unbound
> resource consumption from bnx2x.
> 
> The patch also adds an ethtool statistic for accounting the skipped
> TX timestamp packets and it reduces the priority of timestamping
> error messages to prevent log flooding. The code was tested using
> both linuxptp and chrony.
> 
> Reported-and-tested-by: Przemyslaw Hausman <przemyslaw.hausman@canonical.com>
> Suggested-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

Applied and queued up for -stable.
