Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F966E1FF4
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjDNJzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDNJzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:55:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94A43C33;
        Fri, 14 Apr 2023 02:54:59 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 984731FD95;
        Fri, 14 Apr 2023 09:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681466098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JneUppOda+5TGdxaMKXFrkRT/M0RbNosDbdjrmg3y6k=;
        b=eoAS1KDc4SAzQxjPHa49axCInW8IYd7O23TIPd4pc4RtFzpXMnPNvJuuh4r8HAN2in8lnb
        sM/fnESaVmSw9iLUm3YlEHd37s6sPk1uDXk/YScAO02FhmppXPGQyPOLtKAT5DYjazK5y8
        s0q1QxXYzigtfGSPzu1yV8/MxXm+c3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681466098;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JneUppOda+5TGdxaMKXFrkRT/M0RbNosDbdjrmg3y6k=;
        b=T/MqJAD2yZlYNLf1ybBOCRHZrfmQwdHuODNnW6DOSFgHnLD9yHU8HdY3Fjes0PO1zVgAXB
        A1BgrUiyUa2zRbAQ==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4EF8B2C143;
        Fri, 14 Apr 2023 09:54:58 +0000 (UTC)
Date:   Fri, 14 Apr 2023 11:54:57 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20230414095457.GG63923@kunlun.suse.cz>
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-3-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421003152.339542-3-alobakin@pm.me>
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

Hello,

On Thu, Apr 21, 2022 at 12:38:58AM +0000, Alexander Lobakin wrote:
> When building bpftool with !CONFIG_PERF_EVENTS:
> 
> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type 'struct bpf_perf_link'
>         perf_link = container_of(link, struct bpf_perf_link, link);
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: note: expanded from macro 'container_of'
>                 ((type *)(__mptr - offsetof(type, member)));    \
>                                    ^~~~~~~~~~~~~~~~~~~~~~
> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: note: expanded from macro 'offsetof'
>  #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBER)
>                                                   ~~~~~~~~~~~^
> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct bpf_perf_link'
>         struct bpf_perf_link *perf_link;
>                ^
> 
> &bpf_perf_link is being defined and used only under the ifdef.
> Define struct bpf_perf_link___local with the `preserve_access_index`
> attribute inside the pid_iter BPF prog to allow compiling on any
> configs. CO-RE will substitute it with the real struct bpf_perf_link
> accesses later on.
> container_of() is not CO-REd, but it is a noop for
> bpf_perf_link <-> bpf_link and the local copy is a full mirror of
> the original structure.
> 
> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")

This does not solve the problem completely. Kernels that don't have
CONFIG_PERF_EVENTS in the first place are also missing the enum value
BPF_LINK_TYPE_PERF_EVENT which is used as the condition for handling the
cookie.

Thanks

Michal
