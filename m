Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760C98E4A5
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 07:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfHOF5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 01:57:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:34810 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfHOF5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 01:57:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 22:57:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,388,1559545200"; 
   d="scan'208";a="176784513"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga008.fm.intel.com with ESMTP; 14 Aug 2019 22:57:12 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 1/5] x86: tsc: add tsc to art helpers
In-Reply-To: <alpine.DEB.2.21.1907160952040.1767@nanos.tec.linutronix.de>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-2-felipe.balbi@linux.intel.com> <alpine.DEB.2.21.1907160952040.1767@nanos.tec.linutronix.de>
Date:   Thu, 15 Aug 2019 08:57:11 +0300
Message-ID: <87y2zvt1hk.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,


Thomas Gleixner <tglx@linutronix.de> writes:

> Felipe,
>
> On Tue, 16 Jul 2019, Felipe Balbi wrote:
>
> -ENOCHANGELOG
>
> As you said in the cover letter:
>
>>  (3) The change in arch/x86/kernel/tsc.c needs to be reviewed at length
>>      before going in.
>
> So some information what those interfaces are used for and why they are
> needed would be really helpful.

Okay, I have some more details about this. The TGPIO device itself uses
ART since TSC is not directly available to anything other than the
CPU. The 'problem' here is that reading ART incurs extra latency which
we would like to avoid. Therefore, we use TSC and scale it to
nanoseconds which, would be the same as ART to ns.

>> +void get_tsc_ns(struct system_counterval_t *tsc_counterval, u64 *tsc_ns)
>> +{
>> +	u64 tmp, res, rem;
>> +	u64 cycles;
>> +
>> +	tsc_counterval->cycles = clocksource_tsc.read(NULL);
>> +	cycles = tsc_counterval->cycles;
>> +	tsc_counterval->cs = art_related_clocksource;
>> +
>> +	rem = do_div(cycles, tsc_khz);
>> +
>> +	res = cycles * USEC_PER_SEC;
>> +	tmp = rem * USEC_PER_SEC;
>> +
>> +	do_div(tmp, tsc_khz);
>> +	res += tmp;
>> +
>> +	*tsc_ns = res;
>> +}
>> +EXPORT_SYMBOL(get_tsc_ns);
>> +
>> +u64 get_art_ns_now(void)
>> +{
>> +	struct system_counterval_t tsc_cycles;
>> +	u64 tsc_ns;
>> +
>> +	get_tsc_ns(&tsc_cycles, &tsc_ns);
>> +
>> +	return tsc_ns;
>> +}
>> +EXPORT_SYMBOL(get_art_ns_now);
>
> While the changes look innocuous I'm missing the big picture why this needs
> to emulate ART instead of simply using TSC directly.

i don't think we're emulating ART here (other than the name in the
function). We're just reading TSC and converting to nanoseconds, right?

Cheers

-- 
balbi
