Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64ADEFBAF2
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 22:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfKMVko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 16:40:44 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56520 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbfKMVko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 16:40:44 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5E482340078;
        Wed, 13 Nov 2019 21:40:37 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 13 Nov
 2019 21:40:30 +0000
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        <bpf@vger.kernel.org>, <magnus.karlsson@gmail.com>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
 <20191113204737.31623-3-bjorn.topel@gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <fa188bb2-6223-5aef-98e4-b5f7976ed485@solarflare.com>
Date:   Wed, 13 Nov 2019 21:40:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191113204737.31623-3-bjorn.topel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25040.003
X-TM-AS-Result: No-10.472200-8.000000-10
X-TMASE-MatchedRID: fE0JoqABJp3mLzc6AOD8DfHkpkyUphL90Y5wB8cprq6Sx8doohnYU2ii
        8WGiB+jQqlxTM6TAzfnJROKaj0N2c5UUJ2qIihMkVLNEw2/V9EP2wh+4N7V7f7JDzu0tK/1i+Hm
        BPyReSgwePEYCXfGzgHe1ZiKPDx850ijRgGspNZWK5Jq39CIIv0Yj0zDHPzJplzy6qhJBbZYTgt
        4grpaSCuKK7fBuUrWmCN/w4nwrIQc3b5PzfuylFElR2DE0NRdac3ewuwbSaG45yibxcff/sktBn
        z4Rvwao3EIz+3TQvGrHXz1ITlDcEPve3kImqG8FGjzBgnFZvQ41X1Ls767cppGPHiE2kiT41Dbv
        xsIF6u7nr9gxjpWID8Vep822FzDpiA9C6oekWIS+hCRkqj3j01DzuFKf8NKTavR/jURCwlajxYy
        RBa/qJaEwgORH8p/AjaPj0W1qn0Q7AFczfjr/7DvWz5B3n77pj153+8Nt8vJJkQVOPS+9ckG4NU
        Y5VI0mhtQGJMjRqDc=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.472200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25040.003
X-MDID: 1573681242-8m1j9RYHvhbB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/11/2019 20:47, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The BPF dispatcher builds on top of the BPF trampoline ideas;
> Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
> code. The dispatcher builds a dispatch table for XDP programs, for
> retpoline avoidance. The table is a simple binary search model, so
> lookup is O(log n). Here, the dispatch table is limited to four
> entries (for laziness reason -- only 1B relative jumps :-P). If the
> dispatch table is full, it will fallback to the retpoline path.
> 
> An example: A module/driver allocates a dispatcher. The dispatcher is
> shared for all netdevs. Each netdev allocate a slot in the dispatcher
> and a BPF program. The netdev then uses the dispatcher to call the
> correct program with a direct call (actually a tail-call).
> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
The first-come-first-served model for dispatcher slots might mean that
 a low-traffic user ends up getting priority while a higher-traffic
 user is stuck with the retpoline fallback.  Have you considered using
 a learning mechanism, like in my dynamic call RFC [1] earlier this
 year?  (Though I'm sure a better learning mechanism than the one I
 used there could be devised.)

> +static int bpf_dispatcher_add_prog(struct bpf_dispatcher *d,
> +				   struct bpf_prog *prog)
> +{
> +	struct bpf_prog **entry = NULL;
> +	int i, err = 0;
> +
> +	if (d->num_progs == BPF_DISPATCHER_MAX)
> +		return err;
> +
> +	for (i = 0; i < BPF_DISPATCHER_MAX; i++) {
> +		if (!entry && !d->progs[i])
> +			entry = &d->progs[i];
> +		if (d->progs[i] == prog)
> +			return err;
> +	}
> +
> +	prog = bpf_prog_inc(prog);
> +	if (IS_ERR(prog))
> +		return err;
> +
> +	*entry = prog;
> +	d->num_progs++;
> +	return err;
> +}
If I'm reading this function right, it always returns zero; was that
 the intention, and if so why isn't it void?

-Ed

[1] https://lkml.org/lkml/2019/2/1/948
