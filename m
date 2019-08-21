Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760AD96E01
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfHUAET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:04:19 -0400
Received: from lekensteyn.nl ([178.21.112.251]:34193 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfHUAET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 20:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=K3uy9dtKEGKpF75hNPdQJreepvLtuf4viqOfIEdhqEE=;
        b=UAlesXhAJmN/Bm9g4b7rVWmx+HQInzGBH3x+BU7jIMtOjgeaFr2cRIE/4DjjrA5ChVwWKMk4mjoJyKuQRi2Ev7MhcVqHHlJshP44ZINwgtbwllyAxDHDMOPfx/S4dCPYQuZWoxP33OwEo5+Ewi2LgK50aFEu4+k+XFBUfge7XDsAA2kK1GLcKdAPF4oYHZSMzrvpOYRKzV/RBTcq+LR/lgZQH8RjGvVZiJZdhyOMVeDdmDbD5AsUmFC7+8ERasREmztrVH5hiTWgSdIypeUegDGXxi9Ynmk+lo9vKk+O0wrjzmKKIPZGLb8O5UrL/UJ0YUTpEBb5HFTOG/9/jCrM3g==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1i0E6p-0005Jr-0O; Wed, 21 Aug 2019 02:04:15 +0200
Date:   Wed, 21 Aug 2019 01:04:13 +0100
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 3/4] bpf: clarify when bpf_trace_printk discards lines
Message-ID: <20190821000413.GA28011@al>
References: <20190820230900.23445-1-peter@lekensteyn.nl>
 <20190820230900.23445-4-peter@lekensteyn.nl>
 <20190820232221.vzxemergvzy3bg4j@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820232221.vzxemergvzy3bg4j@ast-mbp>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 04:22:23PM -0700, Alexei Starovoitov wrote:
> On Wed, Aug 21, 2019 at 12:08:59AM +0100, Peter Wu wrote:
> > I opened /sys/kernel/tracing/trace once and kept reading from it.
> > bpf_trace_printk somehow did not seem to work, no entries were appended
> > to that trace file. It turns out that tracing is disabled when that file
> > is open. Save the next person some time and document this.
> > 
> > The trace file is described in Documentation/trace/ftrace.rst, however
> > the implication "tracing is disabled" did not immediate translate to
> > "bpf_trace_printk silently discards entries".
> > 
> > Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> > ---
> >  include/uapi/linux/bpf.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 9ca333c3ce91..e4236e357ed9 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -575,6 +575,8 @@ union bpf_attr {
> >   * 		limited to five).
> >   *
> >   * 		Each time the helper is called, it appends a line to the trace.
> > + * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
> > + * 		open, use *\/sys/kernel/debug/tracing/trace_pipe* to avoid this.
> 
> that's not quite correct.
> Having 'trace' file open doesn't discard lines.
> I think this type of comment in uapi header makes more confusion than helps.

Having the 'trace' file open for reading results in discarding lines. It
took me a while to figure that out. At first I was not even sure whether
my eBPF program was executed or not due to lack of entries in the
'trace' file.

I ended up setting a breakpoint and ended up with this call stack:

  - bpf_trace_printk
    - ____bpf_trace_printk
      - __trace_printk
        - trace_vprintk
          - trace_array_vprintk
            - __trace_array_vprintk
              - __trace_array_vprintk
                - __trace_buffer_lock_reserve
                  - ring_buffer_lock_reserve

The function ends up skipping the even because record_disabled == 1:

    if (unlikely(atomic_read(&buffer->record_disabled)))
        goto out;

Why is that? Well, I guessed that ring_buffer_record_disable and
ring_buffer_record_enable would be related. Sure enough, the first one
was hit when the 'trace' file is opened for reading while the latter is
called when the file is closed.

The relevant code from kernel/trace/trace.c (__tracing_open), "snapshot"
is true when "trace" is opened, and "false" when "trace_pipe" is used:

    /* stop the trace while dumping if we are not opening "snapshot" */
    if (!iter->snapshot)
        tracing_stop_tr(tr);

So I think this supports the claim that lines are discarded. Do you
think this is not the case?
-- 
Kind regards,
Peter Wu
https://lekensteyn.nl
