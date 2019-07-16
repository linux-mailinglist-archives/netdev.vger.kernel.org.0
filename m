Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70786A35E
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfGPH5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:57:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49515 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbfGPH5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 03:57:51 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hnILA-0001DC-9h; Tue, 16 Jul 2019 09:57:36 +0200
Date:   Tue, 16 Jul 2019 09:57:35 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 1/5] x86: tsc: add tsc to art helpers
In-Reply-To: <20190716072038.8408-2-felipe.balbi@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1907160952040.1767@nanos.tec.linutronix.de>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-2-felipe.balbi@linux.intel.com>
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

On Tue, 16 Jul 2019, Felipe Balbi wrote:

-ENOCHANGELOG

As you said in the cover letter:

>  (3) The change in arch/x86/kernel/tsc.c needs to be reviewed at length
>      before going in.

So some information what those interfaces are used for and why they are
needed would be really helpful.

> +void get_tsc_ns(struct system_counterval_t *tsc_counterval, u64 *tsc_ns)
> +{
> +	u64 tmp, res, rem;
> +	u64 cycles;
> +
> +	tsc_counterval->cycles = clocksource_tsc.read(NULL);
> +	cycles = tsc_counterval->cycles;
> +	tsc_counterval->cs = art_related_clocksource;
> +
> +	rem = do_div(cycles, tsc_khz);
> +
> +	res = cycles * USEC_PER_SEC;
> +	tmp = rem * USEC_PER_SEC;
> +
> +	do_div(tmp, tsc_khz);
> +	res += tmp;
> +
> +	*tsc_ns = res;
> +}
> +EXPORT_SYMBOL(get_tsc_ns);
> +
> +u64 get_art_ns_now(void)
> +{
> +	struct system_counterval_t tsc_cycles;
> +	u64 tsc_ns;
> +
> +	get_tsc_ns(&tsc_cycles, &tsc_ns);
> +
> +	return tsc_ns;
> +}
> +EXPORT_SYMBOL(get_art_ns_now);

While the changes look innocuous I'm missing the big picture why this needs
to emulate ART instead of simply using TSC directly.

Thanks,

	tglx
