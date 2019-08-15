Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2068EDFD
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732892AbfHOOQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:16:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39873 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732829AbfHOOQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:16:31 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos.glx-home)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hyGY3-0006TL-He; Thu, 15 Aug 2019 16:16:15 +0200
Date:   Thu, 15 Aug 2019 16:16:09 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 1/5] x86: tsc: add tsc to art helpers
In-Reply-To: <87y2zvt1hk.fsf@gmail.com>
Message-ID: <alpine.DEB.2.21.1908151458560.1923@nanos.tec.linutronix.de>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-2-felipe.balbi@linux.intel.com> <alpine.DEB.2.21.1907160952040.1767@nanos.tec.linutronix.de> <87y2zvt1hk.fsf@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felipe,

On Thu, 15 Aug 2019, Felipe Balbi wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> > On Tue, 16 Jul 2019, Felipe Balbi wrote:
> >
> > So some information what those interfaces are used for and why they are
> > needed would be really helpful.
> 
> Okay, I have some more details about this. The TGPIO device itself uses
> ART since TSC is not directly available to anything other than the
> CPU. The 'problem' here is that reading ART incurs extra latency which
> we would like to avoid. Therefore, we use TSC and scale it to
> nanoseconds which, would be the same as ART to ns.

Fine. But that's not really correct:

      TSC = art_to_tsc_offset + ART * scale;
 
> >> +void get_tsc_ns(struct system_counterval_t *tsc_counterval, u64 *tsc_ns)

Why is this not returning the result instead of having that pointer
indirection?

> >> +{
> >> +	u64 tmp, res, rem;
> >> +	u64 cycles;
> >> +
> >> +	tsc_counterval->cycles = clocksource_tsc.read(NULL);
> >> +	cycles = tsc_counterval->cycles;
> >> +	tsc_counterval->cs = art_related_clocksource;

So this does more than returning the TSC time converted to nanoseconds. The
function name should reflect this. Plus both functions want kernel-doc
explaining what they do.

> >> +	rem = do_div(cycles, tsc_khz);
> >> +
> >> +	res = cycles * USEC_PER_SEC;
> >> +	tmp = rem * USEC_PER_SEC;
> >> +
> >> +	do_div(tmp, tsc_khz);
> >> +	res += tmp;
> >> +
> >> +	*tsc_ns = res;
> >> +}
> >> +EXPORT_SYMBOL(get_tsc_ns);
> >> +
> >> +u64 get_art_ns_now(void)
> >> +{
> >> +	struct system_counterval_t tsc_cycles;
> >> +	u64 tsc_ns;
> >> +
> >> +	get_tsc_ns(&tsc_cycles, &tsc_ns);
> >> +
> >> +	return tsc_ns;
> >> +}
> >> +EXPORT_SYMBOL(get_art_ns_now);
> >
> > While the changes look innocuous I'm missing the big picture why this needs
> > to emulate ART instead of simply using TSC directly.
> 
> i don't think we're emulating ART here (other than the name in the
> function). We're just reading TSC and converting to nanoseconds, right?

Well, the function name says clearly: get_art_ns_now(). But you are not
using ART, you use the TSC and derive the ART value from it (incorrectly).

Thanks,

	tglx

