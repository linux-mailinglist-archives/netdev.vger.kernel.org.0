Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0771465BF3A
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 12:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjACLqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 06:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbjACLpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 06:45:54 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE659A441;
        Tue,  3 Jan 2023 03:45:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pCfjg-0003WK-LK; Tue, 03 Jan 2023 12:45:40 +0100
Date:   Tue, 3 Jan 2023 12:45:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Quentin Deslandes <qde@naccy.de>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Kernel Team <kernel-team@meta.com>
Subject: Re: [PATCH bpf-next v3 00/16] bpfilter
Message-ID: <20230103114540.GB13151@breakpoint.cc>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Deslandes <qde@naccy.de> wrote:
> The patchset is based on the patches from David S. Miller [1],
> Daniel Borkmann [2], and Dmitrii Banshchikov [3].
> 
> Note: I've partially sent this patchset earlier due to a
> mistake on my side, sorry for then noise.
> 
> The main goal of the patchset is to prepare bpfilter for
> iptables' configuration blob parsing and code generation.
> 
> The patchset introduces data structures and code for matches,
> targets, rules and tables. Beside that the code generation
> is introduced.
> 
> The first version of the code generation supports only "inline"
> mode - all chains and their rules emit instructions in linear
> approach.
> 
> Things that are not implemented yet:
>   1) The process of switching from the previous BPF programs to the
>      new set isn't atomic.

You can't make this atomic from userspace perspective, the
get/setsockopt API of iptables uses a read-modify-write model.

Tentatively I'd try to extend libnftnl and generate bpf code there,
since its used by both iptables(-nft) and nftables we'd automatically
get support for both.

I was planning to look into "attach bpf progs to raw netfilter hooks"
in Q1 2023, once the initial nf-bpf-codegen is merged.
