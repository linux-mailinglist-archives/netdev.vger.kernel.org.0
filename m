Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6CD5975C4
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbiHQSfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiHQSfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:35:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F0B9C1D0;
        Wed, 17 Aug 2022 11:35:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oONsT-0001oq-Rk; Wed, 17 Aug 2022 20:34:53 +0200
Date:   Wed, 17 Aug 2022 20:34:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Florian Westphal <fw@strlen.de>,
        Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
Message-ID: <20220817183453.GA24008@breakpoint.cc>
References: <cover.1660592020.git.dxu@dxuuu.xyz>
 <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
 <871qth87r1.fsf@toke.dk>
 <20220815224011.GA9821@breakpoint.cc>
 <5c7ac2ab-942f-4ee7-8a9c-39948a40681c@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c7ac2ab-942f-4ee7-8a9c-39948a40681c@www.fastmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> wrote:
> On Mon, Aug 15, 2022, at 4:40 PM, Florian Westphal wrote:
> > Toke Høiland-Jørgensen <toke@kernel.org> wrote:
> >> > Support direct writes to nf_conn:mark from TC and XDP prog types. This
> >> > is useful when applications want to store per-connection metadata. This
> >> > is also particularly useful for applications that run both bpf and
> >> > iptables/nftables because the latter can trivially access this metadata.
> >> >
> >> > One example use case would be if a bpf prog is responsible for advanced
> >> > packet classification and iptables/nftables is later used for routing
> >> > due to pre-existing/legacy code.
> >> >
> >> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> >> 
> >> Didn't we agree the last time around that all field access should be
> >> using helper kfuncs instead of allowing direct writes to struct nf_conn?
> >
> > I don't see why ct->mark needs special handling.
> >
> > It might be possible we need to change accesses on nf/tc side to use
> > READ/WRITE_ONCE though.
> 
> I reviewed some of the LKMM literature and I would concur that
> READ/WRITE_ONCE() is necessary. Especially after this patchset.
> 
> However, it's unclear to me if this is a latent issue. IOW: is reading
> ct->mark protected by a lock? I only briefly looked but it doesn't
> seem like it.

No, its not protected by a lock.  READ/WRITE_ONCE is unrelated to your
patchset, this is a pre-existing "bug".
