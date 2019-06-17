Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA5449101
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfFQUMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:12:00 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:52318 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726048AbfFQUL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:11:59 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EA69D10008A;
        Mon, 17 Jun 2019 20:11:57 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 17 Jun
 2019 13:11:53 -0700
Subject: Re: [PATCH] bpf: optimize constant blinding
To:     Jiong Wang <jiong.wang@netronome.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
 <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com>
 <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com>
 <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com>
 <87ef3w5hew.fsf@netronome.com>
 <41dfe080-be03-3344-d279-e638a5a6168d@solarflare.com>
 <878su0geyt.fsf@netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <58d86352-4989-38d6-666b-5e932df9ed46@solarflare.com>
Date:   Mon, 17 Jun 2019 21:11:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <878su0geyt.fsf@netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24684.005
X-TM-AS-Result: No-8.943500-4.000000-10
X-TMASE-MatchedRID: y/2oPz6gbvhEgaBf5eVRwvZvT2zYoYOwC/ExpXrHizwPyJBNuE5b69tu
        Lnl6rSi7SnfVZ2aMt0e+bOXDHRRBaEPbYPqd/GaJLCDCajDZWp2PGXEebjsPOn5Isu006IGGjXR
        nWwYGEzqs8gTMwhvzAYn27DnckA3cUOp/60TQFCq84C/3iwAgxORETaH2dwRcEcWQUCNHW2dUav
        I/uMDDCXAQFpRd+85iXOElEaO4oPwaeqxnyxGvYqMY62qeQBkL9fDvVOE+QZbCtB5AXGRY2yvz6
        n8ktwf/N8alXlRNJsXVH1UVVv32JnqE/IIafU+/ngIgpj8eDcByZ8zcONpAscRB0bsfrpPIXzYx
        eQR1Dvvx88a+G1owGpiaB8881L5ZOgNABZ1pahdN/WHqJ386BPGjPznMBKfa
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.943500-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24684.005
X-MDID: 1560802318-Frm4lMFiYHFC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/06/2019 20:59, Jiong Wang wrote:
> Edward Cree writes:
>
>> On 14/06/2019 16:13, Jiong Wang wrote:
>>> Just an update and keep people posted.
>>>
>>> Working on linked list based approach, the implementation looks like the
>>> following, mostly a combine of discussions happened and Naveen's patch,
>>> please feel free to comment.
>>>
>>>   - Use the reserved opcode 0xf0 with BPF_ALU as new pseudo insn code
>>>     BPF_LIST_INSN. (0xf0 is also used with BPF_JMP class for tail call).
>>>
>>>   - Introduce patch pool into bpf_prog->aux to keep all patched insns.
>> It's not clear to me what the point of the patch pool is, rather than just
>>  doing the patch straight away. 
> I used pool because I was thinking insn to be patched could be high
> percentage, so doing lots of alloc call is going to be less efficient? so
> allocate a big pool, and each time when creating new patch node, allocate
> it from the pool directly. Node is addressed using pool_base + offset, each
> node only need to keep offset.
Good idea; but in that case it doesn't need to be a pool of patches (storing
 their prev and next), just a pool of insns.  I.e. struct bpf_insn pool[many];
 then in orig prog when patching an insn replace it with BPF_LIST_INSN.  If
 we later decide to patch an insn within a patch, we can replace it (i.e. the
 entry in bpf_insn_pool) with another BPF_LIST_INSN pointing to some later bit
 of the pool, then we just have a little bit of recursion at linearise time.
Does that work?

-Ed
