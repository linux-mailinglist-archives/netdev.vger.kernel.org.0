Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BBA6E284B
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDNQ22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDNQ21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:28:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FE07EF8;
        Fri, 14 Apr 2023 09:28:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A225B21A1F;
        Fri, 14 Apr 2023 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681489703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBtDfb7jrlKGDQ2eVProntazDKuZT+KOi2I9EHj7SZo=;
        b=xhUG7FJZpNqXddRbmzJvU5YT702axMW5edjK5s2+awqOAOtiPOjFcajJw/gGfzL+efk9Cc
        5zdTGLjOyUXw2+4Q/Clw1ZlrbuSpjrkMC4Q5G4fTZ8oFagAHnP8ofnjXeQa/qG7ILbRLB3
        frzRUMMFc0UF7TGznTTwQ6J42h8fcJY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681489703;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBtDfb7jrlKGDQ2eVProntazDKuZT+KOi2I9EHj7SZo=;
        b=1W4HBUZZtQ2kqd5S+T/vbB5E5c0bhJOrszNYZrIxVZ4HP/scTFJGVBCvXmUht5X4TkI33g
        gG1qj1B1uT+3IyBg==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 566D82C143;
        Fri, 14 Apr 2023 16:28:23 +0000 (UTC)
Date:   Fri, 14 Apr 2023 18:28:21 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Alexander Lobakin <alobakin@mailbox.org>,
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
Message-ID: <20230414162821.GK63923@kunlun.suse.cz>
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-3-alobakin@pm.me>
 <20230414095457.GG63923@kunlun.suse.cz>
 <9952dc32-f464-c85a-d812-946d6b0ac734@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9952dc32-f464-c85a-d812-946d6b0ac734@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 05:18:27PM +0200, Alexander Lobakin wrote:
> From: Michal Suchánek <msuchanek@suse.de>
> Date: Fri, 14 Apr 2023 11:54:57 +0200
> 
> > Hello,
> 
> Hey-hey,
> 
> > 
> > On Thu, Apr 21, 2022 at 12:38:58AM +0000, Alexander Lobakin wrote:
> >> When building bpftool with !CONFIG_PERF_EVENTS:
> >>
> >> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type 'struct bpf_perf_link'
> >>         perf_link = container_of(link, struct bpf_perf_link, link);
> >>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: note: expanded from macro 'container_of'
> >>                 ((type *)(__mptr - offsetof(type, member)));    \
> >>                                    ^~~~~~~~~~~~~~~~~~~~~~
> >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: note: expanded from macro 'offsetof'
> >>  #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBER)
> >>                                                   ~~~~~~~~~~~^
> >> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct bpf_perf_link'
> >>         struct bpf_perf_link *perf_link;
> >>                ^
> >>
> >> &bpf_perf_link is being defined and used only under the ifdef.
> >> Define struct bpf_perf_link___local with the `preserve_access_index`
> >> attribute inside the pid_iter BPF prog to allow compiling on any
> >> configs. CO-RE will substitute it with the real struct bpf_perf_link
> >> accesses later on.
> >> container_of() is not CO-REd, but it is a noop for
> >> bpf_perf_link <-> bpf_link and the local copy is a full mirror of
> >> the original structure.
> >>
> >> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> > 
> > This does not solve the problem completely. Kernels that don't have
> > CONFIG_PERF_EVENTS in the first place are also missing the enum value
> > BPF_LINK_TYPE_PERF_EVENT which is used as the condition for handling the
> > cookie.
> 
> Sorry, I haven't been working with my home/private stuff for more than a
> year already. I may get back to it some day when I'm tired of Lua (curse
> words, sorry :D), but for now the series is "a bit" abandoned.

This part still appllies and works for me with the caveat that
BPF_LINK_TYPE_PERF_EVENT also needs to be defined.

> I think there was alternative solution proposed there, which promised to
> be more flexible. But IIRC it also doesn't touch the enum (was it added
> recently? Because it was building just fine a year ago on config without
> perf events).

It was added in 5.15. Not sure there is a kernel.org LTS kernel usable
for CO-RE that does not have it, technically 5.4 would work if it was
built monolithic, it does not have module BTF, only kernel IIRC.

Nonetheless, the approach to handling features completely missing in the
running kernel should be figured out one way or another. I would be
surprised if this was the last feature to be added that bpftool needs to
know about.

Thanks

Michal
