Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693F03509E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfFDUHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:07:11 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34999 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFDUHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:07:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id p26so2256500edr.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RgNKKPgJAzFI9IGcn1+oxkExAoJ366kiYnXg2DryRNg=;
        b=f0bY1C2/8Ae3IKlP7pYSZjb4brQCi5T0lwPR4BUlCHuJCK6KpAvzUEXKV77pB+1mtY
         jwdVNxBITQV9MW94CD++H28L9gG70NgdXAzb9+ks2+T5IHwj5es35UzxgUrgl0w06TK1
         mUkn3izDIeVQojZMu72JrT+iTFoZRIM4vWj8j8yyK4nWD6Fi1zxAPb+z0ZznTZrCM65W
         GnNBHcA651N391YEbIlg05TcSL5XAFowbcmOxc5UcwteNcrDkTq/bD9S5a90TeWI4Ju+
         rAqrlhdnyP0kcKZCydhConfqQog3SyQDtRWWJYLqW2KqMQ1bsoybN8oVpmCoNjTukT7A
         fnPA==
X-Gm-Message-State: APjAAAVkKn6fIZi1YayDVDJuX/vUkQtC8MBkYOMZXFk2nG8ZMI48XGmF
        2SfgqBZ0UBxmy2Uk2gtvhVQ63Q==
X-Google-Smtp-Source: APXvYqx4ihvXRmQBjfPCldAZ0iCFJ73qKKZrehn/IC/LFthgYUgBY0TuxpRsOtbcdye7Yb0ZP5uOrQ==
X-Received: by 2002:aa7:c391:: with SMTP id k17mr38675620edq.166.1559678827264;
        Tue, 04 Jun 2019 13:07:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id c10sm1195997edk.80.2019.06.04.13.07.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 13:07:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D55A4181CC1; Tue,  4 Jun 2019 22:07:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an xskmap
In-Reply-To: <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com>
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com> <20190603163852.2535150-2-jonathan.lemon@gmail.com> <20190604184306.362d9d8e@carbon> <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Jun 2019 22:07:05 +0200
Message-ID: <874l55f72u.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Lemon <jonathan.lemon@gmail.com> writes:

> On 4 Jun 2019, at 9:43, Jesper Dangaard Brouer wrote:
>
>> On Mon, 3 Jun 2019 09:38:51 -0700
>> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>>
>>> Currently, the AF_XDP code uses a separate map in order to
>>> determine if an xsk is bound to a queue.  Instead of doing this,
>>> have bpf_map_lookup_elem() return the queue_id, as a way of
>>> indicating that there is a valid entry at the map index.
>>
>> Just a reminder, that once we choose a return value, there the
>> queue_id, then it basically becomes UAPI, and we cannot change it.
>
> Yes - Alexei initially wanted to return the sk_cookie instead, but
> that's 64 bits and opens up a whole other can of worms.
>
>
>> Can we somehow use BTF to allow us to extend this later?
>>
>> I was also going to point out that, you cannot return a direct pointer
>> to queue_id, as BPF-prog side can modify this... but Daniel already
>> pointed this out.
>
> So, I see three solutions here (for this and Toke's patchset also,
> which is encountering the same problem).
>
> 1) add a scratch register (Toke's approach)
> 2) add a PTR_TO_<type>, which has the access checked.  This is the most
>    flexible approach, but does seem a bit overkill at the moment.
> 3) add another helper function, say, bpf_map_elem_present() which just
>    returns a boolean value indicating whether there is a valid map entry
>    or not.
>
> I was starting to do 2), but wanted to get some more feedback first.

I think I prefer 2) over 3); since we have a verifier that can actually
enforce something like read-only behaviour, actually having access to
the value will probably be useful to someone.

I can obviously live with 1) as well, of course (since I already did
that; though I just now realise that I forgot to make the scratch space
per-CPU)... :)

-Toke
