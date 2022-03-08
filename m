Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6098B4D1336
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345304AbiCHJVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242090AbiCHJVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:21:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C82553D1E2
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646731219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BHJNKcefmBPCZQfETqNljYPzoWjRgF0JS6C9KGiRgtk=;
        b=YX5a8O9F0SWzhxi9BQzc40XEBADzOccyVq6zvYQKGFtyOD4i7qunjm2xpsbekuLjt9/qpb
        QzaiWPbsdRCDCR8imcbtK3C5Xt3wkNUo3XbhByGWX3F2O9mQFpsiiOuZB+da4ymxcG7jcb
        wP8hHKK6sLjPTehs/XcEz0riW/RC05U=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-IDUSQjKLMeWBxly4gYDFkQ-1; Tue, 08 Mar 2022 04:20:18 -0500
X-MC-Unique: IDUSQjKLMeWBxly4gYDFkQ-1
Received: by mail-pl1-f199.google.com with SMTP id c10-20020a170902d48a00b00151cf8ca3c7so3611026plg.0
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 01:20:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BHJNKcefmBPCZQfETqNljYPzoWjRgF0JS6C9KGiRgtk=;
        b=ZQpP+0n0O6UPtbYYnQhJiJ6aBWh3mf/dQurRQyotVsM9ez3aOvs3Yh525chUkdZ7UW
         rsnYQh8i09VVYb9mRGKnUTYH/FRIL7d4ULs2ST+oR2XaQXmgnC3dyUecfqcJpBMEeo4U
         auZxCaRv4PVUO1/Uqlpf6hrJ5UVMTJO5Ug/+4w6V1gJtLMk0N7TUJtvn6LDlF4SWDnqr
         u0+6uHYUXurtfhdA5z+oiUb/uhvjg1YhsRsju4LQKmx/IityoMlo8J3WxqhfqA0FDpcM
         z5Tm8xmQomDw+NvdeNhJKyZ62otrNKhMmHe5YfOYgQHiignsFshNJ9HkDsNMaRMTum3P
         LZPQ==
X-Gm-Message-State: AOAM532+1KNo/Qj9wl5Bnlv7oGN1A4rFaQBZkrTyuH2HBkmB+o/BQVxZ
        te+pbCGm80TlUxLQ1ArGVx0xvuvGSWbZ8yW42ArF9fsOc0ZAp0h5QpN7884aLD4pIpzkiswRNjW
        UQIQdVx57fAr8VKaEuKc6PkYIJ19M3O2R
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id r10-20020a17090a560a00b001bc72e73c13mr3561605pjf.246.1646731217685;
        Tue, 08 Mar 2022 01:20:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGBcsxWUY1lv6BGvVcM0BJmAMRFc5RbO84C7BBpZHsPBTdtiEjxgMTPrLlikfMuAeEH1bfUbyx1yR8JsE0/AY=
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id
 r10-20020a17090a560a00b001bc72e73c13mr3561553pjf.246.1646731217191; Tue, 08
 Mar 2022 01:20:17 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-3-benjamin.tissoires@redhat.com> <CAPhsuW5CYF9isR4ffRdm3xA_n_FBoL+AGFkzNn4dn2LgRaQQkg@mail.gmail.com>
 <CAO-hwJKFE4Ps962BBubn8=1K0k9mC2qi8VerFbZo1sqpp6yekg@mail.gmail.com> <CAPhsuW5mZQ-N7RCndxP0RNi669RU5Tbu-Uu0M-KW2-mPYZbbng@mail.gmail.com>
In-Reply-To: <CAPhsuW5mZQ-N7RCndxP0RNi669RU5Tbu-Uu0M-KW2-mPYZbbng@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 8 Mar 2022 10:20:06 +0100
Message-ID: <CAO-hwJ+_aZDdKguze-BC+Ok9=HccAYSUFrNJmQBZfX3oufRGUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/28] bpf: introduce hid program type
To:     Song Liu <song@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 8, 2022 at 1:57 AM Song Liu <song@kernel.org> wrote:
>
> On Mon, Mar 7, 2022 at 10:39 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > On Sat, Mar 5, 2022 at 1:03 AM Song Liu <song@kernel.org> wrote:
> > >
> > > On Fri, Mar 4, 2022 at 9:31 AM Benjamin Tissoires
> > > <benjamin.tissoires@redhat.com> wrote:
> > > >
> > > > HID is a protocol that could benefit from using BPF too.
> > >
> > > [...]
> > >
> > > > +#include <linux/list.h>
> > > > +#include <linux/slab.h>
> > > > +
> > > > +struct bpf_prog;
> > > > +struct bpf_prog_array;
> > > > +struct hid_device;
> > > > +
> > > > +enum bpf_hid_attach_type {
> > > > +       BPF_HID_ATTACH_INVALID = -1,
> > > > +       BPF_HID_ATTACH_DEVICE_EVENT = 0,
> > > > +       MAX_BPF_HID_ATTACH_TYPE
> > >
> > > Is it typical to have different BPF programs for different attach types?
> > > Otherwise, (different types may have similar BPF programs), maybe
> > > we can pass type as an argument to the program (shared among
> > > different types)?
> >
> > Not quite sure I am entirely following you, but I consider the various
> > attach types to be quite different and thus you can not really reuse
> > the same BPF program with 2 different attach types.
> >
> > In my view, we have 4 attach types:
> > - BPF_HID_ATTACH_DEVICE_EVENT: called whenever we receive an IRQ from
> > the given device (so this is net-like event stream)
> > - BPF_HID_ATTACH_RDESC_FIXUP: there can be only one of this type, and
> > this is called to change the device capabilities. So you can not reuse
> > the other programs for this one
> > - BPF_HID_ATTACH_USER_EVENT: called explicitly by the userspace
> > process owning the program. There we can use functions that are
> > sleeping (we are not in IRQ context), so this is also fundamentally
> > different from the 3 others.
> > - BPF_HID_ATTACH_DRIVER_EVENT: whenever the driver gets called into,
> > we get a bpf program run. This can be suspend/resume, or even specific
> > request to the device (change a feature on the device or get its
> > current state). Again, IMO fundamentally different from the others.
> >
> > So I'm open to any suggestions, but if we can keep the userspace API
> > being defined with different SEC in libbpf, that would be the best.
>
> Thanks for this information. Different attach_types sound right for the use
> case.
>
> >
> > >
> > > [...]
> > >
> > > > +struct hid_device;
> > > > +
> > > > +enum hid_bpf_event {
> > > > +       HID_BPF_UNDEF = 0,
> > > > +       HID_BPF_DEVICE_EVENT,           /* when attach type is BPF_HID_DEVICE_EVENT */
> > > > +};
> > > > +
> > > > +struct hid_bpf_ctx {
> > > > +       enum hid_bpf_event type;        /* read-only */
> > > > +       __u16 allocated_size;           /* the allocated size of data below (RO) */
> > >
> > > There is a (6-byte?) hole here.
> > >
> > > > +       struct hid_device *hdev;        /* read-only */
> > > > +
> > > > +       __u16 size;                     /* used size in data (RW) */
> > > > +       __u8 data[];                    /* data buffer (RW) */
> > > > +};
> > >
> > > Do we really need hit_bpf_ctx in uapi? Maybe we can just use it
> > > from vmlinuxh?
> >
> > I had a thought at this context today, and I think I am getting to the
> > limit of what I understand.
> >
> > My first worry is that the way I wrote it there, with a variable data
> > field length is that this is not forward compatible. Unless BTF and
> > CORE are making magic, this will bite me in the long run IMO.
> >
> > But then, you are talking about not using uapi, and I am starting to
> > wonder: am I doing the things correctly?
> >
> > To solve my first issue (and the weird API I had to introduce in the
> > bpf_hid_get/set_data), I came up to the following:
> > instead of exporting the data directly in the context, I could create
> > a helper bpf_hid_get_data_buf(ctx, const uint size) that returns a
> > RET_PTR_TO_ALLOC_MEM_OR_NULL in the same way bpf_ringbuf_reserve()
> > does.
> >
> > This way, I can directly access the fields within the bpf program
> > without having to worry about the size.
> >
> > But now, I am wondering whether the uapi I defined here is correct in
> > the way CORE works.
> >
> > My goal is to have HID-BPF programs to be CORE compatible, and not
> > have to recompile them depending on the underlying kernel.
> >
> > I can not understand right now if I need to add some other BTF helpers
> > in the same way the access to struct xdp_md and struct xdp_buff are
> > converted between one and other, or if defining a forward compatible
> > struct hid_bpf_ctx is enough.
> > As far as I understand, .convert_ctx_access allows to export a stable
> > uapi to the bpf prog users with the verifier doing the conversion
> > between the structs for me. But is this really required for all the
> > BPF programs if we want them to be CORE?
> >
> > Also, I am starting to wonder if I should not hide fields in the
> > context to the users. The .data field could be a pointer and only
> > accessed through the helper I mentioned above. This would be forward
> > compatible, and also allows to use whatever available memory in the
> > kernel to be forwarded to the BPF program. This way I can skip the
> > memcpy part and work directly with the incoming dma data buffer from
> > the IRQ.
> >
> > But is it best practice to do such a thing?
>
> I think .convert_ctx_access is the way to go if we want to access the data
> buffer without memcpy. I am not sure how much work is needed to make
> it compatible with CORE though.
>
> To make sure I understand the case, do we want something like
>
> bpf_prog(struct hid_bpf_ctx *ctx)
> {
>     /* makes sure n < ctx->size */
>     x = ctx->data[n]; /* read data */
>     ctx->data[n] = <something>; /* write data */
>     ctx->size = <something <= n>; /* change data size */
> }
>
> We also need it to be CORE, so that we may modify hid_bpf_ctx by
> inserting more members to it before data.
>
> Is this accurate?
>

Yes, you pretty much summed it all (except maybe that we might want to
have allocated_size in addition to size so we can also grow the value
of .size within the allocated limit).

All in all, what I want for HID bpf programs is to be able to read and
write an array of bytes, and change its size within an allocated
kernel limit.

This will apply to every HID bpf attach type, to the exception of some
BPF_HID_ATTACH_DRIVER_EVENT when we are receiving a suspend/resume
notification. Though in the suspend/resume case we won't have the data
array available, so it won't matter much.

I want the HID bpf programs to be CORE, but if you tell me that it
would matter only if we need to reshuffle hid_bpf_ctx, I would be fine
simply put a comment "new fields must be added at the end" like some
other definitions of contexts are doing.

Besides that, I currently do not want to allow access to the content
of struct hid_device (or any other kernel struct) in HID BPF programs.
That might be of interest at some point for debugging, but with just
the array capability I should be able to achieve all of my use cases.

Cheers,
Benjamin

