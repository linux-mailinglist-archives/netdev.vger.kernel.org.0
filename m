Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6A5479F2F
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhLSEvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 23:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbhLSEvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 23:51:08 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23FDC061574;
        Sat, 18 Dec 2021 20:51:07 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id m24so5344630pls.10;
        Sat, 18 Dec 2021 20:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PVLOSEk62POTNKznm9WavggBFRCbVhfNidk+UUQ9Crw=;
        b=KYmulpukQftZPIpsPFdiI1ieqnWKsWuOabFDzZWZ7YoROQL0XVZeAU3v+QzCREAqOu
         DJbi+/KfIB//EseOmhbbwZdD1/xDJgNHJyqCVJeCFHrNbPNPFMgjsvSK2tFQcP5aqX+w
         7F6O5m6/g5/35Ck/y1UFUpUIgJQQ220OnveTtUmfIyLMIv8VI7UenjwlvX2FlqeELh2X
         AR6cPTYC5i2Ekepe1/ZrYN2vcBakh7j3Vdq+FxpxkmjT0ZTGTakgz/4AfntcHU6sz5T7
         4BacDU634KZu/4bqoE3eJw74S4UKFVOQkq3hzO2kiXuET6nog7WgD0pGHLnKcM932w06
         Uryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVLOSEk62POTNKznm9WavggBFRCbVhfNidk+UUQ9Crw=;
        b=XBTFwtiJ1sj8XVz/Wwxb1P87QHL2/K7lE2EaTt3ADJHfIVsl40MLZHwSVfqGZbT+BU
         DHghJe6NXh5dYmMsXURFCqN9KQTJRLhC1/jLMrW+sbhhOTep8d/Ic116K4VmsYI6wdOg
         pSGKIwXZJyr+HDWBBWzD85kaFTyb1xMAAW+LVOHQzuaiM5q4yNpfFjCQasUBMdURIHk7
         EsWXynCuJu6tkkZ2MGaF+WugV/r2ZS8K1u8a+aY9b3ecqCzDZ4GrhiGZ5MH15EaWwLj4
         JBlI70wXLA8DFeOY0CPLyYD2uxD9u4RpPM2dAPNA3/M90dnR6puOb3YOxkNKeSvn6xfI
         oSXA==
X-Gm-Message-State: AOAM531D/ivhgss9AFNygJ4/cyY2jRh+j7Z6Ndj51UwrKO3sST2qn2Co
        f3Dlx4XRqW/YIehTmzbKyHVY2/rkG6qHbAvAZvI=
X-Google-Smtp-Source: ABdhPJxui2CAZ6/tvQ1M4zt2D+xxoLRPJRB72oPe6WMSFxo9gIfu50rKVVcUjRrDNTflp3RimmJfmfP6TgTjg7VuCAI=
X-Received: by 2002:a17:90b:3b46:: with SMTP id ot6mr850541pjb.62.1639889467355;
 Sat, 18 Dec 2021 20:51:07 -0800 (PST)
MIME-Version: 1.0
References: <20211217015031.1278167-1-memxor@gmail.com> <20211217015031.1278167-6-memxor@gmail.com>
 <20211219022248.6hqp64a4nbhyyxeh@ast-mbp> <20211219030128.2s23lzhup6et4rsu@apollo.legion>
 <CAADnVQLz_JK6=6V=iVpT2BQKcKCSvOmJy6-KbTdMnbxBKu0EAg@mail.gmail.com> <20211219043837.27p3zvtdpozs7ep4@apollo.legion>
In-Reply-To: <20211219043837.27p3zvtdpozs7ep4@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 18 Dec 2021 20:50:56 -0800
Message-ID: <CAADnVQLKnG4yrDKEn5mBN8NSuD59ZdFQ0NvGq4U=V815b4Kftg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 05/10] bpf: Add reference tracking support to kfunc
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 8:38 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sun, Dec 19, 2021 at 09:24:37AM IST, Alexei Starovoitov wrote:
> > On Sat, Dec 18, 2021 at 7:01 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Sun, Dec 19, 2021 at 07:52:48AM IST, Alexei Starovoitov wrote:
> > > > On Fri, Dec 17, 2021 at 07:20:26AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > >
> > > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > > index 965fffaf0308..015cb633838b 100644
> > > > > --- a/include/linux/bpf.h
> > > > > +++ b/include/linux/bpf.h
> > > > > @@ -521,6 +521,9 @@ struct bpf_verifier_ops {
> > > > >                              enum bpf_access_type atype,
> > > > >                              u32 *next_btf_id);
> > > > >     bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
> > > > > +   bool (*is_acquire_kfunc)(u32 kfunc_btf_id, struct module *owner);
> > > > > +   bool (*is_release_kfunc)(u32 kfunc_btf_id, struct module *owner);
> > > > > +   bool (*is_kfunc_ret_type_null)(u32 kfunc_btf_id, struct module *owner);
> > > >
> > > > Same feedback as before...
> > > >
> > > > Those callbacks are not necessary.
> > > > The existing check_kfunc_call() is just as inconvenient.
> > > > When module's BTF comes in could you add it to mod's info instead of
> > > > introducing callbacks for every kind of data the module has.
> > > > Those callbacks don't server any purpose other than passing the particular
> > > > data set back. The verifier side should access those data sets directly.
> > >
> > > Ok, interesting idea. So these then go into the ".modinfo" section?
> >
> > It doesn't need to be a special section.
> > The btf_module_notify() parses BTF.
> > At the same time it can add a kfunc whitelist to "struct module".
> > The btf_ids[ACQUIRE/RELEASE][] arrays will be a part of
> > the "struct module" too.
> > If we can do a btf name convention then this job can be
> > performed generically by btf_module_notify().
> > Otherwise __init of the module can populate arrays in "struct module".
> >
>
> Nice idea, I think this is better than what I am doing (it also prevents
> constant researching into the list).
>
> But IIUC I think this btf_ids array needs to go into struct btf instead,
> since if module is compiled as built-in, we will not have any struct module for
> it.
>
> Then we can concatenate all sets of same type (check/acquire/release etc.) and
> sort them to directly search using a single btf_id_set_contains call, the code
> becomes same for btf_vmlinux or module btf. struct module is not needed anymore.
>
> WDYT?

You mean that btf_parse_module() will do this?
That would work for vmlinux's BTF too then?
Makes sense to me!
