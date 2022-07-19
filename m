Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3E457A865
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbiGSUkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237206AbiGSUkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:40:19 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305EF1F2DE
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:40:18 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bu1so23309901wrb.9
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JdPg8PwLJ4scewlXe1S2XGQEoVuVmzE9bCFnDeQCIK4=;
        b=bB6eKvcGtQyvp2gkywdhf4t0OsWG55pK+5M8CtEyHuw+pGlJ7pl2SwrrYx8wcu/kTi
         7u5f/k2qeZqS7yIuedGDANVzsTFYA+8CodeUT/Pz9CP9aPTzvoDXTwwkx2f0h64pM0rh
         u/ULiNpLNydBY4gFACcOkfv1O9WshTY/TX2raBSNPWYewHgWKFryZcGyq+MdswITWS+T
         KoflBhNUiVrsRsDnhBQ/FxP/jNUKy7N1gIQAuYJPuJWX/h3xCFjSJeUOIdgD86szQmyA
         KlcixorJDp3cRjPsJ4NJknHni1+UyVeL3+QjxMnfnXwAuEfDOAPg1FNBqFXM1LM0IjjZ
         tFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JdPg8PwLJ4scewlXe1S2XGQEoVuVmzE9bCFnDeQCIK4=;
        b=OmLtLI4LFNlpCxje9+Z0kcpuGav5VUtrsCCEz+wz7C+uxvmmFX/BRejqyhR9VqAr8t
         u+QNeDKaEwS6VOAr35/2KTnoH6BpfHnUTr5Ht+xxhLEKlYdv6/tGFYn8CUGf2z0mFB4X
         b4Rk5RyS7ttNFGI54iwzesL82MLKO2VIVMdKNr3cFoU/xaqkXK+PIxYS11yvd29qefe4
         r6VZXCbeGp+JFN9W4V5VrtC0cBTcirnimg+b4i1AqrNiq7lTBu9/HAQc7V57hP8qtks1
         uSjKCOSTcGxlrJePHxK8A3YRGidloDpp5VaNRVuNVfHakCVzstsyqsij4EzGC06pp/n6
         YKOQ==
X-Gm-Message-State: AJIora/IXFNG6c2d+v9KvpjZ1Cpf4hRkUE3XFRVEnZqU28WzMhGqzylI
        LI5t+y+gYusNfj0WGb39gh0O
X-Google-Smtp-Source: AGRyM1t03bw69c3/iCuX0kmyzrNE0mXK3hOrX/Id1fT8sX4jqzu5kbOOuRkhzgxy0K7oW/sJqSqUhw==
X-Received: by 2002:adf:e310:0:b0:21e:3e46:81f8 with SMTP id b16-20020adfe310000000b0021e3e4681f8mr3192688wrj.188.1658263216722;
        Tue, 19 Jul 2022 13:40:16 -0700 (PDT)
Received: from Mem (2a01cb089094b7009c79f2cfd97c0e48.ipv6.abo.wanadoo.fr. [2a01:cb08:9094:b700:9c79:f2cf:d97c:e48])
        by smtp.gmail.com with ESMTPSA id d10-20020adfa34a000000b00210bac248c8sm14769266wrb.11.2022.07.19.13.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 13:40:15 -0700 (PDT)
Date:   Tue, 19 Jul 2022 22:40:13 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf v2 0/5] bpf: Allow any source IP in
 bpf_skb_set_tunnel_key
Message-ID: <20220719204013.GA90459@Mem>
References: <cover.1658159533.git.paul@isovalent.com>
 <75d3ee98-a73c-16c5-2bb3-f61180115b29@blackwall.org>
 <CAADnVQLV-Tkyo+jJtLB6MYr7kR8k4Q9_T0La7MPEUXzcRE7EZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLV-Tkyo+jJtLB6MYr7kR8k4Q9_T0La7MPEUXzcRE7EZg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 10:44:52AM -0700, Alexei Starovoitov wrote:
> On Mon, Jul 18, 2022 at 11:58 PM Nikolay Aleksandrov
> <razor@blackwall.org> wrote:
> >
> > On 18/07/2022 18:53, Paul Chaignon wrote:
> > > Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> > > added support for getting and setting the outer source IP of encapsulated
> > > packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> > > allows BPF programs to set any IP address as the source, including for
> > > example the IP address of a container running on the same host.
> > >
> > > In that last case, however, the encapsulated packets are dropped when
> > > looking up the route because the source IP address isn't assigned to any
> > > interface on the host. To avoid this, we need to set the
> > > FLOWI_FLAG_ANYSRC flag.
> > >
> > > Changes in v2:
> > >   - Removed changes to IPv6 code paths as they are unnecessary.
> > >
> > > Paul Chaignon (5):
> > >   ip_tunnels: Add new flow flags field to ip_tunnel_key
> > >   vxlan: Use ip_tunnel_key flow flags in route lookups
> > >   geneve: Use ip_tunnel_key flow flags in route lookups
> > >   bpf: Set flow flag to allow any source IP in bpf_tunnel_key
> > >   selftests/bpf: Don't assign outer source IP to host
> > >
> > >  drivers/net/geneve.c                                 |  1 +
> > >  drivers/net/vxlan/vxlan_core.c                       | 11 +++++++----
> > >  include/net/ip_tunnels.h                             |  1 +
> > >  net/core/filter.c                                    |  1 +
> > >  tools/testing/selftests/bpf/prog_tests/test_tunnel.c |  1 -
> > >  5 files changed, 10 insertions(+), 5 deletions(-)
> > >
> >
> > Looks good, for the set:
> > Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
> 
> vxlan_test is failing.
> See BPF CI link in patchwork.

I've seen that today and was able to reproduce. It's most likely because
the reply packet is dropped by the stack given the destination address
is not local. The easiest way to update the test is probably to rewrite
the destination address with another BPF program on ingress. Anyway,
thanks for the heads up!

I'm also trying to figure out how I got a passing test before, but most
likely explanation is that my test changes were overwritten because of
the workflow bug [1]

1 - https://github.com/kernel-patches/vmtest/pull/95

> 
> Also it's too late for 'bpf' tree. Pls tag bpf-next on respin.

Will do.
