Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B01715BACF
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 09:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgBMIdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 03:33:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:39770 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgBMIdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 03:33:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5767EAB92;
        Thu, 13 Feb 2020 08:33:34 +0000 (UTC)
Date:   Thu, 13 Feb 2020 09:33:33 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: Question about kthread_mod_delayed_work() allowed context
Message-ID: <20200213083333.jglatxs5j76z2634@pathway.suse.cz>
References: <cfa886ad-e3b7-c0d2-3ff8-58d94170eab5@ti.com>
 <20200212154116.hh2vdyi7e2xflxr5@pathway.suse.cz>
 <59802c56-1013-3042-167d-89f288f51b58@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59802c56-1013-3042-167d-89f288f51b58@ti.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2020-02-12 21:17:53, Grygorii Strashko wrote:
> 
> 
> On 12/02/2020 17:41, Petr Mladek wrote:
> > On Tue 2020-02-11 12:23:59, Grygorii Strashko wrote:
> > > Hi All,
> > > 
> > > I'd like to ask question about allowed calling context for kthread_mod_delayed_work().
> > > 
> > > The comment to kthread_mod_delayed_work() says:
> > > 
> > >   * This function is safe to call from any context including IRQ handler.
> > >   * See __kthread_cancel_work() and kthread_delayed_work_timer_fn()
> > >   * for details.
> > >   */
> > > 
> > > But it has del_timer_sync() inside which seems can't be called from hard_irq context:
> > > kthread_mod_delayed_work()
> > >    |-__kthread_cancel_work()
> > >       |- del_timer_sync()
> > > 	|- WARN_ON(in_irq() && !(timer->flags & TIMER_IRQSAFE));
> > 
> > It is safe because kthread_delayed_work_timer_fn() is IRQ safe.
> > Note that it uses raw_spin_lock_irqsave(). It is the reason why
> > the timer could have set TIMER_IRQSAFE flag, see
> > KTHREAD_DELAYED_WORK_INIT().
> > 
> > In more details. The timer is either canceled before the callback
> > is called. Or it waits for the callback but the callback is safe
> > because it can't sleep.
> 
> I think, my issue (warning) could be related to the fact that kthread_init_delayed_work()
> is used, which seems doesn't set TIMER_IRQSAFE flag.

Great catch!

It is a bug. Would you like to send the fix for
kthread_init_delayed_work() or would you prefer me doing so?

Best Regards,
Petr
