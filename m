Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C16B1FC219
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFPXEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:03:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3D4C061573;
        Tue, 16 Jun 2020 16:03:59 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h185so172226pfg.2;
        Tue, 16 Jun 2020 16:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=djKkgCDygGC6EG1pSvAXkAIjP6AEGcA/Dqqhpxx/0Hw=;
        b=AAiXxmie88JoN3z4aQITsbDwu6bNgDAPVulr5eZ0ZPaYjTOUgSUbBxmqmfp6txORBV
         AaOvavIGZJogT/0pck9+fMN2bG22Pomz8rTy2uS9n6pWG9ky3ZJTbNc+/k8YtPsCJMWi
         /lLpI28/5p5bFH3osbS1CnNvcRKEsVB9jUTAaaTl7D7wiy7uDLNBp0caQq9nl2EvCSn+
         Yz6Xy+8Gp0xMjLIqb4+42Bav2SsG3BBER6vqqrWHZjGAmj+0//eZOZQK4U8RSvbQW2QH
         Gl0WD4TdeWtY5a/usfaEIQvSNyvsqbnpInq/go1Y4Sc8s6JzlcU8nC3qiD27C7jPm4zv
         kCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=djKkgCDygGC6EG1pSvAXkAIjP6AEGcA/Dqqhpxx/0Hw=;
        b=hHqYfLuxESJhegms36GWTGl4GnIpEG4azL6HghvVrx3xHhJ380lQ+GaMcUdOsfFkpZ
         JG0Hq6d6XIdlNh6GeVfZZE5I4V3ohLverw/xI725rYFUOazGGkbew7W+btfuayfe/vLR
         XhwUlf0O4MK9trcWnNzOTmL6cBR9kqBAIPEMabxBEWbRKtgz7NLZGwbstlGp6jY3ie9x
         kg5XG4dv2Wuc9cI6TRCIO/ELvWK/v1BgwC/+Vvx8ufWWs41/3Xmfl0G7dE9OeHkVo0wQ
         VlMdPzYqcBMZayF9RQbL2XgnH9lxAbUnK5t0dtLUL1abr/LrmlqjYz1bC9RJ7c1JG2pc
         1JkQ==
X-Gm-Message-State: AOAM531Bs31S/G2kyaxi38Apo7zyhuDVArS9fdHdQgUArcCfPKS5T1En
        lr1Vx46XKVSxxncr0gBpvvE=
X-Google-Smtp-Source: ABdhPJzJH3NBLo2f2197/oHkCkL6bb7p1hd+CMj2l7QilYGW6fYn2SRyhluFaffT/3iApQbuV6T6tw==
X-Received: by 2002:a63:3546:: with SMTP id c67mr3714546pga.379.1592348638751;
        Tue, 16 Jun 2020 16:03:58 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5d74])
        by smtp.gmail.com with ESMTPSA id mp15sm3380312pjb.45.2020.06.16.16.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 16:03:57 -0700 (PDT)
Date:   Tue, 16 Jun 2020 16:03:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH bpf v3 1/2] bpf: don't return EINVAL from
 {get,set}sockopt when optlen > PAGE_SIZE
Message-ID: <20200616230355.hzipb7hly3fo5moc@ast-mbp.dhcp.thefacebook.com>
References: <20200608182748.6998-1-sdf@google.com>
 <20200613003356.sqp6zn3lnh4qeqyl@ast-mbp.dhcp.thefacebook.com>
 <CAKH8qBuJpks_ny-8MDzzZ5axobn=35P3krVbyz2mtBBtR8Uv+A@mail.gmail.com>
 <20200613035038.qmoxtf5mn3g3aiqe@ast-mbp>
 <CAKH8qBvUv_OwjFA70JQfL-rET662okH87QYyeivbybCPwCEJEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBvUv_OwjFA70JQfL-rET662okH87QYyeivbybCPwCEJEQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 09:41:38AM -0700, Stanislav Fomichev wrote:
> On Fri, Jun 12, 2020 at 8:50 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> [ .. ]
> > > > It's probably ok, but makes me uneasy about verifier consequences.
> > > > ctx->optval is PTR_TO_PACKET and it's a valid pointer from verifier pov.
> > > > Do we have cases already where PTR_TO_PACKET == PTR_TO_PACKET_END ?
> > > > I don't think we have such tests. I guess bpf prog won't be able to read
> > > > anything and nothing will crash, but having PTR_TO_PACKET that is
> > > > actually NULL would be an odd special case to keep in mind for everyone
> > > > who will work on the verifier from now on.
> > > >
> > > > Also consider bpf prog that simply reads something small like 4 bytes.
> > > > IP_FREEBIND sockopt (like your selftest in the patch 2) will have
> > > > those 4 bytes, so it's natural for the prog to assume that it can read it.
> > > > It will have
> > > > p = ctx->optval;
> > > > if (p + 4 > ctx->optval_end)
> > > >  /* goto out and don't bother logging, since that never happens */
> > > > *(u32*)p;
> > > >
> > > > but 'clever' user space would pass long optlen and prog suddenly
> > > > 'not seeing' the sockopt. It didn't crash, but debugging would be
> > > > surprising.
> > > >
> > > > I feel it's better to copy the first 4k and let the program see it.
> > > Agreed with the IP_FREEBIND example wrt observability, however it's
> > > not clear what to do with the cropped buffer if the bpf program
> > > modifies it.
> > >
> > > Consider that huge iptables setsockopts where the usespace passes
> > > PAGE_SIZE*10 optlen with real data and bpf prog sees only part of it.
> > > Now, if the bpf program modifies the buffer (say, flips some byte), we
> > > are back to square one. We either have to silently discard that buffer
> > > or reallocate/merge. My reasoning with data == NULL, is that at least
> > > there is a clear signal that the program can't access the data (and
> > > can look at optlen to see if the original buffer is indeed non-zero
> > > and maybe deny such requests?).
> > > At this point I'm really starting to think that maybe we should just
> > > vmalloc everything that is >PAGE_SIZE and add a sysclt to limit an
> > > upper bound :-/
> > > I'll try to think about this a bit more over the weekend.
> >
> > Yeah. Tough choices.
> > We can also detect in the verifier whether program accessed ctx->optval
> > and skip alloc/copy if program didn't touch it, but I suspect in most
> > case the program would want to read it.
> > I think vmallocing what optlen said is DoS-able. It's better to
> > stick with single page.
> > Let's keep brainstorming.
> Btw, can we use sleepable bpf for that? As in, do whatever I suggested
> in these patches (don't expose optval>PAGE_SIZE via context), but add
> a new helper where you can say 'copy x bytes from y offset of the
> original optval' (the helper will do sleepable copy_form_user).
> That way we have a clean signal to the BPF that the value is too big
> (optval==optval_end==NULL) and the user can fallback to the helper to
> inspect the value. We can also provide another helper to export new
> value for this case.

sleepable will be read-only and with toctou.
I guess this patch is the least evil then ?
But I'm confused with the test in patch 2.
Why does it do 'if (optval > optval_end)' ?
How is that possible when patch 1 makes them equal.
may be another idea:
allocate 4k, copy first 4k into it, but keep ctx.optlen as original.
if bpf prog reads optval and finds it ok in setsockopt,
it can set ctx.optlen = 0
which would mean run the rest of setsockopt handling with original
'__user *optval' and ignore the buffer that was passed to bpf prog.
In case of ctx.optlen < 4k the behavior won't change from bpf prog
and from kernel pov.
When ctx.optlen > 4k and prog didn't adjust it
__cgroup_bpf_run_filter_setsockopt will do ret = -EFAULT;
and reject sockopt.
So bpf prog would be force to do something with large optvals.
yet it will be able to examine first 4k bytes of it.
It's a bit of change in behavior, but I don't think bpf prog is
doing ctx.optlen = 0, since that's more or less the same as
doing ctx.optlen = -2.
or may be use some other indicator ?
And do something similar with getsockopt.
