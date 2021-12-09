Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C7E46ECD5
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhLIQOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:14:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhLIQOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:14:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639066249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=03wigj9pNJ1HRijvuYCSOkSBUBg4eArvedvK4ATStpc=;
        b=LWR62zDq4Z4HeZn5lv+GkSitFYumSDI6Y/OyB0q8XuUDEttFMCcyzcXA8y4Ikr9leWurzn
        ahfOoNXlpKTqn1DJjfGvoRH5fEurHKd5dCkDUoVbgmGqRX8JrePLJRZ7diHfvqDUYMyr3y
        otNN+MjGqPQgiawPB4Jnbg7jiaz+BFA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-6GV3RX4yP8yH0tgHF5SM1Q-1; Thu, 09 Dec 2021 11:10:48 -0500
X-MC-Unique: 6GV3RX4yP8yH0tgHF5SM1Q-1
Received: by mail-ed1-f70.google.com with SMTP id k7-20020aa7c387000000b003e7ed87fb31so5737090edq.3
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 08:10:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=03wigj9pNJ1HRijvuYCSOkSBUBg4eArvedvK4ATStpc=;
        b=idQzMZv8i2Uqww7TdbcFdjs9fFnGlbKaH9c48VqydghOzYomaPhjgT39yAGqj2Ks6j
         bwz/RZ28Q6i9sqbLbm9cTyXyzC7GtUlJ2MyYySTV66YaImQjtkBdkF/UvFe7BxVw0Vcn
         Ig0jc776fZO4wm8tm33232Qi/hFCAJJTIlFIn7R4stPzxTGBBMCWm39ZhvEFTH/tn9aZ
         9n3ancml1FYpyx3xZnJgSng0Nv3bi++HS7v63NsyF1/0h9rlTwYEzd8XeKzYTYfc2epo
         pgZ9H0e/B+oThKqHaS7ZS06JQn1Z524jPZ8hyXiDasdwexU+WsjrzmNYBk36Tfj8z5jg
         i21w==
X-Gm-Message-State: AOAM5309kK7xfQRYi+yvGMKlPXMAr357WUkxTEIY8zjR5A4CKgutKYCD
        QXL0zwwFNdJ6wtufhqodq9VsZ4S2kHU2LYFk5ogBKL91F8XNm41QrAwDek+VAjaf8zMcYthAaN8
        IOE3jNdCHMDGsg+Py
X-Received: by 2002:a17:907:1b0d:: with SMTP id mp13mr16443069ejc.29.1639066246122;
        Thu, 09 Dec 2021 08:10:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwInNrbAQjjnIncwpxFkzbcQkYtTdKIJGm7y6ekiIxr0NEdGb/FILOR7ty1pt0NJOqEp143Mw==
X-Received: by 2002:a17:907:1b0d:: with SMTP id mp13mr16442946ejc.29.1639066245127;
        Thu, 09 Dec 2021 08:10:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id sd28sm173072ejc.37.2021.12.09.08.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 08:10:44 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2ABAA180471; Thu,  9 Dec 2021 17:10:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: RE: [PATCH bpf-next 6/8] bpf: Add XDP_REDIRECT support to XDP for
 bpf_prog_run()
In-Reply-To: <61b1537634e07_979572086f@john.notmuch>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-7-toke@redhat.com>
 <61b1537634e07_979572086f@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Dec 2021 17:10:44 +0100
Message-ID: <87tufhwygr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This adds support for doing real redirects when an XDP program returns
>> XDP_REDIRECT in bpf_prog_run(). To achieve this, we create a page pool
>> instance while setting up the test run, and feed pages from that into the
>> XDP program. The setup cost of this is amortised over the number of
>> repetitions specified by userspace.
>>=20
>> To support performance testing use case, we further optimise the setup s=
tep
>> so that all pages in the pool are pre-initialised with the packet data, =
and
>> pre-computed context and xdp_frame objects stored at the start of each
>> page. This makes it possible to entirely avoid touching the page content=
 on
>> each XDP program invocation, and enables sending up to 11.5 Mpps/core on=
 my
>> test box.
>>=20
>> Because the data pages are recycled by the page pool, and the test runner
>> doesn't re-initialise them for each run, subsequent invocations of the X=
DP
>> program will see the packet data in the state it was after the last time=
 it
>> ran on that particular page. This means that an XDP program that modifies
>> the packet before redirecting it has to be careful about which assumptio=
ns
>> it makes about the packet content, but that is only an issue for the most
>> naively written programs.
>>=20
>> Previous uses of bpf_prog_run() for XDP returned the modified packet data
>> and return code to userspace, which is a different semantic then this new
>> redirect mode. For this reason, the caller has to set the new
>> BPF_F_TEST_XDP_DO_REDIRECT flag when calling bpf_prog_run() to opt in to
>> the different semantics. Enabling this flag is only allowed if not setti=
ng
>> ctx_out and data_out in the test specification, since it means frames wi=
ll
>> be redirected somewhere else, so they can't be returned.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> [...]
>
>> +static int bpf_test_run_xdp_redirect(struct bpf_test_timer *t,
>> +				     struct bpf_prog *prog, struct xdp_buff *orig_ctx)
>> +{
>> +	void *data, *data_end, *data_meta;
>> +	struct xdp_frame *frm;
>> +	struct xdp_buff *ctx;
>> +	struct page *page;
>> +	int ret, err =3D 0;
>> +
>> +	page =3D page_pool_dev_alloc_pages(t->xdp.pp);
>> +	if (!page)
>> +		return -ENOMEM;
>> +
>> +	ctx =3D ctx_from_page(page);
>> +	data =3D ctx->data;
>> +	data_meta =3D ctx->data_meta;
>> +	data_end =3D ctx->data_end;
>> +
>> +	ret =3D bpf_prog_run_xdp(prog, ctx);
>> +	if (ret =3D=3D XDP_REDIRECT) {
>> +		frm =3D (struct xdp_frame *)(ctx + 1);
>> +		/* if program changed pkt bounds we need to update the xdp_frame */
>
> Because this reuses the frame repeatedly is there any issue with also
> updating the ctx each time? Perhaps if the prog keeps shrinking
> the pkt it might wind up with 0 len pkt? Just wanted to ask.

Sure, it could. But the data buffer comes from userspace anyway, and
there's nothing preventing userspace from passing a 0-length packet
anyway, so I just mentally put this in the "don't do that, then" bucket :)

At least I don't *think* there's actually any problem with this that we
don't have already? A regular XDP program can also shrink an incoming
packet to zero, then redirect it, no?

-Toke

