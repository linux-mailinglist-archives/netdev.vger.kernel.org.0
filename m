Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CED6EA505
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDUHjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDUHjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:39:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919F393C2;
        Fri, 21 Apr 2023 00:39:07 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D6E4F1FDDB;
        Fri, 21 Apr 2023 07:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1682062745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SW/BafQPTgaGXLW01L/Le1hsXVIB2LKcUVfRqpb3Xc8=;
        b=jH+MV53ySUGWpcyc017NVY4EGdbvHoiylIZ7T0UG/mJR/Zqxq+VAJ+/S4xhM7JVmGz65iv
        sM/cdTfzCW32JwMzoYOTAJk6xMH7bF1tNFEkXGaur5gLiLvfjZVtnUlIoG58rVDMUton5e
        9NKjlyAEBFLeZZhImeHfSjCld7/q3e8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1682062745;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SW/BafQPTgaGXLW01L/Le1hsXVIB2LKcUVfRqpb3Xc8=;
        b=NKeSGXGa/D7a0vlQYkmKcFNoeEedpJvnDVX8ZuXIJGAVLRCRTaUfm1HrloDhRwfrnftOos
        3iAcpTphvwv8X2Dw==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4FBEC2C141;
        Fri, 21 Apr 2023 07:39:05 +0000 (UTC)
Date:   Fri, 21 Apr 2023 09:39:04 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 bpf 02/11] bpftool: define a local bpf_perf_link to
 fix accessing its fields
Message-ID: <20230421073904.GJ15906@kitsune.suse.cz>
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-3-alobakin@pm.me>
 <20230414095457.GG63923@kunlun.suse.cz>
 <9952dc32-f464-c85a-d812-946d6b0ac734@intel.com>
 <20230414162821.GK63923@kunlun.suse.cz>
 <CAEf4BzYx=dSXp-TkpjzyhSP+9WY71uR4Xq4Um5YzerbfOtJOfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYx=dSXp-TkpjzyhSP+9WY71uR4Xq4Um5YzerbfOtJOfA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 04:07:38PM -0700, Andrii Nakryiko wrote:
> On Fri, Apr 14, 2023 at 9:28 AM Michal Suchánek <msuchanek@suse.de> wrote:
> >
> > On Fri, Apr 14, 2023 at 05:18:27PM +0200, Alexander Lobakin wrote:
> > > From: Michal Suchánek <msuchanek@suse.de>
> > > Date: Fri, 14 Apr 2023 11:54:57 +0200
> > >
> > > > Hello,
> > >
> > > Hey-hey,
> > >
> > > >
> > > > On Thu, Apr 21, 2022 at 12:38:58AM +0000, Alexander Lobakin wrote:
> > > >> When building bpftool with !CONFIG_PERF_EVENTS:
> > > >>
> > > >> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type 'struct bpf_perf_link'
> > > >>         perf_link = container_of(link, struct bpf_perf_link, link);
> > > >>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: note: expanded from macro 'container_of'
> > > >>                 ((type *)(__mptr - offsetof(type, member)));    \
> > > >>                                    ^~~~~~~~~~~~~~~~~~~~~~
> > > >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: note: expanded from macro 'offsetof'
> > > >>  #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBER)
> > > >>                                                   ~~~~~~~~~~~^
> > > >> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct bpf_perf_link'
> > > >>         struct bpf_perf_link *perf_link;
> > > >>                ^
> > > >>
> > > >> &bpf_perf_link is being defined and used only under the ifdef.
> > > >> Define struct bpf_perf_link___local with the `preserve_access_index`
> > > >> attribute inside the pid_iter BPF prog to allow compiling on any
> > > >> configs. CO-RE will substitute it with the real struct bpf_perf_link
> > > >> accesses later on.
> > > >> container_of() is not CO-REd, but it is a noop for
> > > >> bpf_perf_link <-> bpf_link and the local copy is a full mirror of
> > > >> the original structure.
> > > >>
> > > >> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> > > >
> > > > This does not solve the problem completely. Kernels that don't have
> > > > CONFIG_PERF_EVENTS in the first place are also missing the enum value
> > > > BPF_LINK_TYPE_PERF_EVENT which is used as the condition for handling the
> > > > cookie.
> > >
> > > Sorry, I haven't been working with my home/private stuff for more than a
> > > year already. I may get back to it some day when I'm tired of Lua (curse
> > > words, sorry :D), but for now the series is "a bit" abandoned.
> >
> > This part still appllies and works for me with the caveat that
> > BPF_LINK_TYPE_PERF_EVENT also needs to be defined.
> >
> > > I think there was alternative solution proposed there, which promised to
> > > be more flexible. But IIRC it also doesn't touch the enum (was it added
> > > recently? Because it was building just fine a year ago on config without
> > > perf events).
> >
> > It was added in 5.15. Not sure there is a kernel.org LTS kernel usable
> > for CO-RE that does not have it, technically 5.4 would work if it was
> > built monolithic, it does not have module BTF, only kernel IIRC.
> >
> > Nonetheless, the approach to handling features completely missing in the
> > running kernel should be figured out one way or another. I would be
> > surprised if this was the last feature to be added that bpftool needs to
> > know about.
> 
> Are we talking about bpftool built from kernel sources or from Github?
> Kernel source version should have access to latest UAPI headers and so
> BPF_LINK_TYPE_PERF_EVENT should be available. Github version, if it
> doesn't do that already, can use UAPI headers distributed (and used
> for building) with libbpf through submodule.

It does have a copy of the uapi headers but apparently does not use
them. Using them directly might cause conflict with vmlinux.h, though.

Thanks

Michal
