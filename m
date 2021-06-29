Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5753B6BA6
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhF2AV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:21:58 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:35691 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhF2AV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 20:21:57 -0400
Received: (qmail 35703 invoked by uid 89); 29 Jun 2021 00:19:29 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 29 Jun 2021 00:19:29 -0000
Date:   Mon, 28 Jun 2021 17:19:28 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628233056.GA766@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 04:30:56PM -0700, Richard Cochran wrote:
> On Mon, Jun 28, 2021 at 11:46:11AM -0700, Jonathan Lemon wrote:
> > This event differs from CLOCK_EXTTS in two ways:
> > 
> >  1) The caller provides the sec/nsec fields directly, instead of
> >     needing to convert them from the timestamp field.
> 
> And that is useful?  how?

The devices I have provide the sec/nsec values directly from the
FPGA/hardware.  (IIRC, there is another in-tree driver that does
the same thing).  Right now, these values must be coerced into a
timestap, and then re-converted back to a sec/nsec value, which
seems a bit pointless.

> >  2) A 32 bit data field is attached to the event, which is returned
> >     to userspace, which allows returning timestamped data information.
> >     This may be used for things like returning the phase difference
> >     between two time sources.
> 
> What two time sources?
> 
> What problem are you trying to solve?
> 
> As it stands, without any kind of rational at all, this patch gets a NAK.

I have two use cases:

1) The external PPS source from the FPGA returns a counter
   corresponding to the pulse events which is used to insure
   a pulse isn't lost.   This is a marginal case, since the 
   counter can be reverse engineered from the timestamp.

2) The OpenCompute timecard has an on-board rubidium atomic
   clock, and also a GPS receiver.  The atomic clock needs 
   to be steered slightly to keep thse in phase.

   The PPS from the clock and GPS are measured and the 
   phase difference/error is reported every second.  This
   difference is then used to steer the clock, so it can 
   reliably take over in case of GPS loss.

   So, I need a PPS (with timestamp), along with the phase
   difference (data).

This fits in nicely with the extts event model.  I really
don't want to have to re-invent another ptp_chardev device
that does the same thing - nor recreate a extended PTP.
-- 
Jonathan
