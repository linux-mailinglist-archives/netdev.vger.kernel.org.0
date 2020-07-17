Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3463E223115
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 04:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGQCQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 22:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgGQCQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 22:16:29 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD55C061755;
        Thu, 16 Jul 2020 19:16:28 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k27so5926315pgm.2;
        Thu, 16 Jul 2020 19:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fYbHCA6JKXOLMV26BdBnZoN0CKEQZpewpdHTporIVVw=;
        b=JDdFi0O2kQ8AlqcGuC6UzWqeBLFls6ROgdqX9PkWWvjoSHDFWyC3y+5yOj/Xr26QsJ
         fPx0Ur5PpyhqngM0YerGLJHHH9b1aiJYM2heVZr6LxoQ1HxwIS7P4CmxIkt2x5hOAJy8
         Vb7BoDE0odnMM4P//2Zshbbfjzxqszp/ve23k476sTGCI7UCCTY8cIIxiqtujyersMkQ
         FZm4FWkTJcHroD7FQLxeaZ82JkBIhWVFIWsmtFPWKUWkF6q7Ne/U88Zxv7uRyuwhJS4D
         4CFpSFjEY7B9Sq12AMkq8rngukyUxmmUiWl7V61/l9eMbFQ7a1E2OU1/NbgfJEciKe23
         BBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fYbHCA6JKXOLMV26BdBnZoN0CKEQZpewpdHTporIVVw=;
        b=ba2X6+xDXxr+TyncyOtGNEF6AzNEFVKrD+LBmwyDQc11pWHu8CERNO1KtQXVROrBnU
         WsY98IX0QS391GjKoevA5+SLmmFupBnAsuNBtVPzxP06jG+kIEEYfmJS6sU0o+RvSwB4
         z8ZRs+NqWzTKngU/hoE/NAbhs3e0w+BmC3JlmzqCgIWuV+mNGbspDhIZgldb+k+XMA1O
         sgyISOnVKsvOqwe6IYsQJR2kMRySpMyLTOaULFHKtd5oNx1z4UCk81D3qMJXDrQvA/i4
         6hwTMgQkjf9lmFjIRw34BoWwYcrLjzZdynQ0YvidzsWAmmEWaDvI1hv/lLLqSUxgmcPf
         v+pg==
X-Gm-Message-State: AOAM530zh0S0Bw8GhnNaNDHsaglx2qo+UQJ2WNzaSCtQ1CJwmQl3JrwC
        3isSWiuXhIg7rcB12PBlLJKse+8H
X-Google-Smtp-Source: ABdhPJyuaToOy9SqxSzsIW8iJuBch2LlJ1HOXRUCLMqk/4ULdN6Eo3vTGOjIwlm2YhUvPos9HSqBiw==
X-Received: by 2002:a63:5fcc:: with SMTP id t195mr6609877pgb.56.1594952187556;
        Thu, 16 Jul 2020 19:16:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id b4sm6009475pfo.137.2020.07.16.19.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 19:16:26 -0700 (PDT)
Date:   Thu, 16 Jul 2020 19:16:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and tailcall
 handling in JIT
Message-ID: <20200717021624.do6mrxxr37vc7ajd@ast-mbp.dhcp.thefacebook.com>
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-5-maciej.fijalkowski@intel.com>
 <932141f5-7abb-1c01-111d-a64baf187a40@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <932141f5-7abb-1c01-111d-a64baf187a40@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 01:06:07AM +0200, Daniel Borkmann wrote:
> > +				ret = bpf_arch_text_poke(poke->tailcall_bypass,
> > +							 BPF_MOD_JUMP,
> > +							 NULL, bypass_addr);
> > +				BUG_ON(ret < 0 && ret != -EINVAL);
> > +				/* let other CPUs finish the execution of program
> > +				 * so that it will not possible to expose them
> > +				 * to invalid nop, stack unwind, nop state
> > +				 */
> > +				synchronize_rcu();
> 
> Very heavyweight that we need to potentially call this /multiple/ times for just a
> /single/ map update under poke mutex even ... but agree it's needed here to avoid
> racing. :(

Yeah. I wasn't clear with my suggestion earlier.
I meant to say that synchronize_rcu() can be done between two loops.
list_for_each_entry(elem, &aux->poke_progs, list)
   for (i = 0; i < elem->aux->size_poke_tab; i++)
        bpf_arch_text_poke(poke->tailcall_bypass, ...
synchronize_rcu();
list_for_each_entry(elem, &aux->poke_progs, list)
   for (i = 0; i < elem->aux->size_poke_tab; i++)
        bpf_arch_text_poke(poke->poke->tailcall_target, ...

Not sure how much better it will be though.
text_poke is heavy.
I think it's heavier than synchronize_rcu().
Long term we can do batch of text_poke-s.

I'm actually fine with above approach of synchronize_rcu() without splitting the loop.
This kind of optimizations can be done later as a follow up.
I'd really like to land this stuff in this bpf-next cycle.
It's a big improvement to tail_calls and bpf2bpf calls.
