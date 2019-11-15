Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF63FD6EB
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfKOH1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:27:40 -0500
Received: from www62.your-server.de ([213.133.104.62]:33546 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfKOH1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:27:40 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVW14-0004dT-NR; Fri, 15 Nov 2019 08:27:38 +0100
Date:   Fri, 15 Nov 2019 08:27:38 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH rfc bpf-next 7/8] bpf, x86: emit patchable direct jump as
 tail call
Message-ID: <20191115072738.GB3957@pc-9.home>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <78a8cbc4887d00b3dc4705347f05572630650cbf.1573779287.git.daniel@iogearbox.net>
 <20191115032345.loei6qqgyo4tdbuq@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115032345.loei6qqgyo4tdbuq@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 07:23:46PM -0800, Alexei Starovoitov wrote:
> On Fri, Nov 15, 2019 at 02:04:01AM +0100, Daniel Borkmann wrote:
> > for later modifications. In ii) fixup_bpf_tail_call_direct() walks
> > over the progs poke_tab, locks the tail call maps poke_mutex to
> > prevent from parallel updates and patches in the right locations via
> ...
> > @@ -1610,6 +1671,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >  		prog->bpf_func = (void *)image;
> >  		prog->jited = 1;
> >  		prog->jited_len = proglen;
> > +		fixup_bpf_tail_call_direct(prog);
> 
> Why not to move fixup_bpf_tail_call_direct() just before
> bpf_jit_binary_lock_ro() and use simple memcpy instead of text_poke ?

Thinking about it, I'll move it right into the branch before we lock ...

  if (!prog->is_func || extra_pass) {
    bpf_tail_call_fixup_direct(prog);
    bpf_jit_binary_lock_ro(header);
  } else { [...]

... and I'll add a __bpf_arch_text_poke() handler which passes in the
a plain memcpy() callback instead of text_poke_bp(), so it keeps reusing
most of the logic/checks from __bpf_arch_text_poke() which we also have
at a later point once the program is live.

> imo this logic in patch 7:
> case BPF_JMP | BPF_TAIL_CALL:
> +   if (imm32)
> +            emit_bpf_tail_call_direct(&bpf_prog->aux->poke_tab[imm32 - 1],
> would have been easier to understand if patch 7 and 8 were swapped.

Makes sense, it's totally fine to swap them, so I'll go do that. Thanks
for the feedback!

Cheers,
Daniel
