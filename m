Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EE1229F67
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbgGVSmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:42:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:45234 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgGVSmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 14:42:49 -0400
IronPort-SDR: +ZXtsriim91GOb4Ts/3GcZfmw9iKpAOu2F/vv7mbApBXG0wzgC0T/gai6ZS98KCAzSC2clQmug
 0FGGDfgaCEzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="148349929"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="148349929"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 11:42:48 -0700
IronPort-SDR: 7QZpM5HXBtVjIU2NpMlIANIw2vJK9LhotX8Cr4jumreACtwCbILgu6DHaYQHuAlh3+zvJrLwr7
 R6j9AbQsZMoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="302043853"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga002.jf.intel.com with ESMTP; 22 Jul 2020 11:42:46 -0700
Date:   Wed, 22 Jul 2020 20:37:49 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Subject: Re: [PATCH v2 bpf-next 2/6] bpf: propagate poke descriptors to
 subprograms
Message-ID: <20200722183749.GB8874@ranger.igk.intel.com>
References: <20200721115321.3099-1-maciej.fijalkowski@intel.com>
 <20200721115321.3099-3-maciej.fijalkowski@intel.com>
 <29a3dcfc-9d85-c113-19d2-e33f80ce5430@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29a3dcfc-9d85-c113-19d2-e33f80ce5430@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 04:40:42PM +0200, Daniel Borkmann wrote:
> On 7/21/20 1:53 PM, Maciej Fijalkowski wrote:
> > Previously, there was no need for poke descriptors being present in
> > subprogram's bpf_prog_aux struct since tailcalls were simply not allowed
> > in them. Each subprog is JITed independently so in order to enable
> > JITing such subprograms, simply copy poke descriptors from main program
> > to subprogram's poke tab.
> > 
> > Add also subprog's aux struct to the BPF map poke_progs list by calling
> > on it map_poke_track().
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   kernel/bpf/verifier.c | 20 ++++++++++++++++++++
> >   1 file changed, 20 insertions(+)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 3c1efc9d08fd..3428edf85220 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9936,6 +9936,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
> >   		goto out_undo_insn;
> >   	for (i = 0; i < env->subprog_cnt; i++) {
> > +		struct bpf_map *map_ptr;
> > +		int j;
> > +
> >   		subprog_start = subprog_end;
> >   		subprog_end = env->subprog_info[i + 1].start;
> > @@ -9960,6 +9963,23 @@ static int jit_subprogs(struct bpf_verifier_env *env)
> >   		func[i]->aux->btf = prog->aux->btf;
> >   		func[i]->aux->func_info = prog->aux->func_info;
> > +		for (j = 0; j < prog->aux->size_poke_tab; j++) {
> > +			int ret;
> > +
> > +			ret = bpf_jit_add_poke_descriptor(func[i],
> > +							  &prog->aux->poke_tab[j]);
> > +			if (ret < 0) {
> > +				verbose(env, "adding tail call poke descriptor failed\n");
> > +				goto out_free;
> > +			}
> > +			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
> > +			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
> > +			if (ret < 0) {
> > +				verbose(env, "tracking tail call prog failed\n");
> > +				goto out_free;
> > +			}
> 
> Hmm, I don't think this is correct/complete. If some of these have been registered or
> if later on the JIT'ing fails but the subprog is already exposed to the prog array then
> it's /public/ at this point, so a later bpf_jit_free() in out_free will rip them mem
> while doing live patching on prog updates leading to UAF.

Ugh. So if we would precede the out_free label with map_poke_untrack() on error
path - would that be sufficient?

> 
> > +		}
> > +
> >   		/* Use bpf_prog_F_tag to indicate functions in stack traces.
> >   		 * Long term would need debug info to populate names
> >   		 */
> > 
> 
