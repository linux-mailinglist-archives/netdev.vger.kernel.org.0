Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E09449237
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfFQVQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:16:42 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:50596 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbfFQVQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:16:42 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C1B6628007C;
        Mon, 17 Jun 2019 21:16:39 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 17 Jun
 2019 14:16:34 -0700
Subject: Re: [PATCH] bpf: optimize constant blinding
To:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
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
 <58d86352-4989-38d6-666b-5e932df9ed46@solarflare.com>
 <877e9kgd39.fsf@netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <f2a74aac-7350-8b35-236a-b17323bb79e6@solarflare.com>
Date:   Mon, 17 Jun 2019 22:16:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <877e9kgd39.fsf@netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24684.005
X-TM-AS-Result: No-5.998100-4.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hdEgaBf5eVRwvZvT2zYoYOwC/ExpXrHizz5+tteD5Rzhb/0
        pkNbQpuU2cBrC5VzXZijDwh25qtF1+wy2NhRsPybA9lly13c/gGFUOeR/MPu5l6ZbCgJcOP1K6N
        gXi8D7Qhlrwi/uVF+3RWjJZzvebtwkQ+VI66DgF6cxB01DrjF96RKBWxEuWDzmyiLZetSf8my5/
        tFZu9S3Ku6xVHLhqfxwrbXMGDYqV8NstCXmf87HE2j4CflSSdbPftAkXfHYuxekegG5gtgKl+1A
        CAa9ge4B8RSXFHFbbj0y3cDig99ZjqjEMi+V3bYtIu3kwejqlhFmXJm4PLyqVHTb2Y4zo/QutwT
        zHK3ELl3mFldkWgHw/pJH+h4T7AX
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.998100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24684.005
X-MDID: 1560806200-hAfrg_k4Cn-a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/06/2019 21:40, Jiong Wang wrote:
> Now if we don't split patch when patch an insn inside patch, instead, if we
> replace the patched insn using what you suggested, then the logic looks to
> me becomes even more complex, something like
>
>    for (idx = 0; idx < insn_cnt; idx++) {
>      if (insns[idx] is not BPF_LIST_INSN) {
>        do_insn(...)
>      }
>      else if (insns[idx] is BPF_LIST_INSN) {
>        list = pool_base + insn.imm;
>        while (list) {
>          insn = list_head->insn;
>          if (insn is BF_LIST_INSN) {
>            sub_list = ...
>            while ()
>              do_insn()
>            continue;
>          }
>          do_insn(...)
>          list = pool_base + list->next;
>        }
>      }
>    }
Why can't do_insn() just go like:
    if (insn is BPF_LIST_INSN)
        for (idx = 0; idx < LIST_COUNT(insn); idx++)
            do_insn(pool_base + LIST_START(insn) + idx);
    else
        rest of processing
?

Alternatively, iterate with something more sophisticated than 'idx++'
 (standard recursion-to-loop transformation).
You shouldn't ever need a for() tower statically in the code...

> So, I am thinking what Alexei and Andrii suggested make sense, just use
> single data structure (singly linked list) to represent everything, so the
> insn traversal etc could be simple
But then you have to also store orig_insn_idx with each insn, so you can
 calculate the new jump offsets when you linearise.  Having an array of
 patched_orig_insns gives you that for free.
