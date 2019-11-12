Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88CB3F86A0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 03:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKLCG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 21:06:56 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45311 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfKLCGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 21:06:55 -0500
Received: by mail-qv1-f68.google.com with SMTP id g12so5752923qvy.12;
        Mon, 11 Nov 2019 18:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qmX9tbmCcACs0MUuLr+va8i7kPdPL9DOvcjAQxjCogg=;
        b=JtvaEoHRO0vtxqm5a6CaPMw9hM3d8Dv/GuXf+HvIQpGazTf76o+vpkKrXBX+FQm57Y
         5C2HvN99tTqaHamyAvQfA++flVAsRjjABDTXxAOenMQCcdurs0DmlRYB6SQCIwMZHADC
         PT+qOsQ9lykqf3QUMD4NuD4RdOC8n0QEigL4NYb5i6p0quE7qMLFnjCtKquVhMGR8+pC
         HfZQL9agLOkC0fkkpPPm8G9T0R78UJ7OUngSzZAYiXRRhxkRAQapzqCsZC5IO4sriXlB
         yAyrRRn5UZX8r6CdTAGWyqT60YfDAaHuS5Hoaq2lCfaGScFFz00kfe8J5RZKpxB2txjn
         kkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qmX9tbmCcACs0MUuLr+va8i7kPdPL9DOvcjAQxjCogg=;
        b=QO9fF5Ll35ULswfpj3ERG2ss7COyJD6JTX7hRGw7yN5P1Bna6QRSUKJPu6wY7mSMsD
         /CW8cTjWIqphwPHPpGZpHxpUwMN7J2/xZ0+Llz9N3xmSiMvvv5tNzg4ZcGIjnmqUyC4C
         kRinxxp1UlW0TAgSlF4zRrNni7As/T5ga+47Bs5tmX+Tij5hpyUGNmBcJIy/rolhRnH5
         Bp+unDA51rQu6HTEUS4aP379/HsdsCfqtIU+0xQpJVCD9UPVCTNoN3dTr0+vZdTErMea
         mHd5WQA10RUynXK+rQT5tdaYbZdE5M9pL/3nMpCRJOFgi+qzzCFXL7CEM9tKm38jrAH8
         YzGQ==
X-Gm-Message-State: APjAAAUpjn60MB3cRNeyOssDFc70jiqgc8Ga2B7iOiHBwsytHvS7Xzxy
        j9DyFIHRpAl/WIxCTuSUa9PwHtfJU9CrQ5wSo0Y=
X-Google-Smtp-Source: APXvYqwir0yn0DtTe6HVqGkzse6A2SkCl51E92x71ap/O9SJe9PjWhHSwQQjbhSgjtYpq02Vzosa3Cmuo/tLyIbCdgg=
X-Received: by 2002:a0c:eb47:: with SMTP id c7mr27430835qvq.163.1573524412885;
 Mon, 11 Nov 2019 18:06:52 -0800 (PST)
MIME-Version: 1.0
References: <20191109080633.2855561-1-andriin@fb.com> <20191109080633.2855561-2-andriin@fb.com>
 <20191111103743.1c3a38a3@cakuba>
In-Reply-To: <20191111103743.1c3a38a3@cakuba>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Nov 2019 18:06:42 -0800
Message-ID: <CAEf4Bzay-sCd5+5Y1+toJuEd6vNh+R7pkosYA7V7wDqTdoDxdw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 10:37 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Sat, 9 Nov 2019 00:06:30 -0800, Andrii Nakryiko wrote:
> > With BPF_F_MMAPABLE array allocating data in separate chunk of memory,
> > array_map_gen_lookup has to accomodate these changes. For non-memory-mapped
> > there are no changes and no extra instructions. For BPF_F_MMAPABLE case,
> > pointer to where array data is stored has to be dereferenced first.
> >
> > Generated code for non-memory-mapped array:
> >
> > ; p = bpf_map_lookup_elem(&data_map, &zero);
> >   22: (18) r1 = map[id:19]
> >   24: (07) r1 += 408                  /* array->inline_data offset */
> >   25: (61) r0 = *(u32 *)(r2 +0)
> >   26: (35) if r0 >= 0x3 goto pc+3
> >   27: (67) r0 <<= 3
> >   28: (0f) r0 += r1
> >   29: (05) goto pc+1
> >   30: (b7) r0 = 0
> >
> > Generated code for memory-mapped array:
> >
> > ; p = bpf_map_lookup_elem(&data_map, &zero);
> >   22: (18) r1 = map[id:27]
> >   24: (07) r1 += 400                  /* array->data offset */
> >   25: (79) r1 = *(u64 *)(r1 +0)               /* extra dereference */
> >   26: (61) r0 = *(u32 *)(r2 +0)
> >   27: (35) if r0 >= 0x3 goto pc+3
> >   28: (67) r0 <<= 3
> >   29: (0f) r0 += r1
> >   30: (05) goto pc+1
> >   31: (b7) r0 = 0
>
> Would it not be possible to overallocate the memory and align the start
> of the bpf_map in case of BPF_F_MMAPABLE so that no extra dereference
> is needed?

So let's say if sizeof(struct bpf_array) is 300, then I'd have to either:

- somehow make sure that I allocate 4k (for data) + 300 (for struct
bpf_array) in such a way that those 4k of data are 4k-aligned. Is
there any way to do that?
- assuming there isn't, then another way would be to allocate entire
4k page for struct bpf_array itself, but put it at the end of that
page, so that 4k of data is 4k-aligned. While wasteful, the bigger
problem is that pointer to bpf_array is not a pointer to allocated
memory anymore, so we'd need to remember that and adjust address
before calling vfree().

Were you suggesting #2 as a solution? Or am I missing some other way to do this?
