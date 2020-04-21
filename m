Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A212C1B3283
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDUWKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 18:10:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33822 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgDUWKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 18:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587507040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=loEY4ZF+6OH9eK6l+2nyMaeSciC81b/sLFgxrmeT9uo=;
        b=MdW2x5NGZbPUq8t86vBz4F8BHadGM5Igi2ED1AWdmt4TyOr2PAvU9TTZCESdzXUjUMiGAp
        A8obtq3DF27Kgiwaoxlb65VyZ+YsZXGBic8HYpxMEEne+NBTuwL5BDYARB/nhYvZZ7F3H+
        9m67R8Xm6rEi7mgxMxYWPo0d2lNC6Kw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-urQbZWKTPSO4DOqeb1gsPw-1; Tue, 21 Apr 2020 18:10:37 -0400
X-MC-Unique: urQbZWKTPSO4DOqeb1gsPw-1
Received: by mail-ej1-f70.google.com with SMTP id q24so227819ejb.3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 15:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=loEY4ZF+6OH9eK6l+2nyMaeSciC81b/sLFgxrmeT9uo=;
        b=L52vxwraGtse4SlblLzk0Uk9OnrLzczAPGw2WBcecxsQ0LSxa17c+OZYHgFmFQvqj+
         NRSTWghsJpuNIxRhxR6j9x0nAXmfxWIZW8pmbYHJn/0gBuF5jT7m2qHdDyBw4QkFDVTw
         tIeWmnlQVz7YgPMqgy3/ZWuDt8TGfWjQZWs57hG+YBf2B2CGyXFGSxq6Vz/6c2feolIw
         UuoJ8I+P8fLScYvHIeiYMrIN9dug/9YdlIZ1R+N1D9G7VwI5/mtwnSZuICl8jqq+Gz/G
         Fk4WVnhSfo+u0HCvWpeyyUVSl1pVbl92X2xbRZwW56L8RRYLUCJEqOJjPJ+Ez+RRj41/
         Sguw==
X-Gm-Message-State: AGi0PuZuS9HQaHQ31sW4SHB6lueMkCfDeCcoTRXTRnCdN9/kJBCDHJrE
        NuzLqY4rDMYW7BosyuDnllZTNlPOW+tTPFGjuH0dhFedrD2BmrMTJ8wcgvt+5wvUqdhsQhvahUS
        dAR8SpdpivMtU8tljtEX64hcBf2yE41F4
X-Received: by 2002:a17:906:a990:: with SMTP id jr16mr23263454ejb.338.1587507035585;
        Tue, 21 Apr 2020 15:10:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypJREQz/k3X5KXIFvvX35UuJ3qj4AntmPhHFYqs19VtU6vaAuUz9P4L/cV+vUbnqZASaXwPJG2E7X4eUIeqCA0A=
X-Received: by 2002:a17:906:a990:: with SMTP id jr16mr23263438ejb.338.1587507035404;
 Tue, 21 Apr 2020 15:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200421180426.6945-1-jhs@emojatatu.com> <CAPpH65zGO02uQyWQXXq6Yg_zsZcVZg+4-KWfRo_q3iACHr6s_Q@mail.gmail.com>
 <478bfaf8-6418-2d37-cae6-88b113d686b0@mojatatu.com>
In-Reply-To: <478bfaf8-6418-2d37-cae6-88b113d686b0@mojatatu.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Wed, 22 Apr 2020 00:10:23 +0200
Message-ID: <CAPpH65wgkg4g4074pSMhShOuYfTX6ye8bbP3OVnVN6oQ9EwcYg@mail.gmail.com>
Subject: Re: [PATCH iproute2 1/1] bpf: Fix segfault when custom pinning is used
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, daniel@iogearbox.net,
        Jamal Hadi Salim <hadi@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 9:58 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> Hi Andrea,
>
> On 2020-04-21 3:38 p.m., Andrea Claudi wrote:
> [..]
> >
> > Hi Jamal,
> > Are you sure this fixes your issue?
>
> Yes.
>
> > I think asprintf could segfault
> > only if ctx is null, but this case is not addressed in your patch.
>
> The issue is tmp(after it is created by asprintf) gets trampled.
> This:
> ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
> allocates enough space for tmp.
> But then later:
> strcat(tmp, sub);
> strcat(tmp...);
> creates a buffer overrun.
>
> It is easy to overlook things like these when making a large
> semantically-equivalent change - so i would suggest to also
> review the general patch that went from sprintf->asprintf.
>

Oh, now I see. Thanks for pointing it out and making it clear to me.
I agree with you, this needs to be carefully reviewed to ensure we are
not falling into the same error pattern somewhere else.

Acked-by: Andrea Claudi <aclaudi@redhat.com>

> > I remember that Stephen asked me to use asprintf to avoid allocating
> > huge buffers on stack; anyway I've no objection to sprintf, if needed.
>
> Generally that is good practise. And even for this case
> you could probably find a simpler way to solve it with asprintf
> or realloc trickery. I am not sure it is worth the bother - 4K on
> the stack in user space is not a big deal really.

Stephen, what do you think about using sprintf instead of asprintf in
these functions?
When dealing with paths, asprintf can indeed be a bit error-prone. I
can easily imagine this error pattern to happen again in the future.
If you agree, I can send a patch taking care of this.

> cheers,
> jamal
>

Andrea

