Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A0B4903A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfFQTrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:47:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36230 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726514AbfFQTrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:47:31 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2EB3A80057;
        Mon, 17 Jun 2019 19:47:30 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 17 Jun
 2019 12:47:26 -0700
Subject: Re: [PATCH] bpf: optimize constant blinding
To:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
 <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com>
 <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com>
 <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com>
 <87ef3w5hew.fsf@netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <41dfe080-be03-3344-d279-e638a5a6168d@solarflare.com>
Date:   Mon, 17 Jun 2019 20:47:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87ef3w5hew.fsf@netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24684.005
X-TM-AS-Result: No-8.347200-4.000000-10
X-TMASE-MatchedRID: 6otD/cJAac1EgaBf5eVRwvZvT2zYoYOwC/ExpXrHizwL9Tj77wy87IIU
        G7/tZy4d4hJuRL3IxSAgvQTVRkNXhIZKkFFIbQIAsJribvbshQ9bD9LQcHt6g6zG9MIKeG/Ghvw
        7+mblsJsR3sN5fyQI1UAFcnpD9mZelX+iQruz3vGqNnzrkU+2mnyuCDd9Nsmvy5JfHvVu9Iswx8
        Z6+aQbcHW2ld4lwNr1B9P/R5ohxlWj9HPhXvu25Bcr91Fo5aW9yeUl7aCTy8ifuM4lD6uC8XpQU
        RdMc/iv1SIZGfg1hgkr8CenrAzEVzi6anTfkmiZmq+iLtFCY9LOFaObL3St25soi2XrUn/JmTDw
        p0zM3zoqtq5d3cxkNZd/mwLf2BVUGVWtjHyckC2QDRt+p3R08Pt4JMe+q1RNRa+hecZfLuLFhXM
        jdQIJpg==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.347200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24684.005
X-MDID: 1560800850-oyJf9GqgC5yH
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2019 16:13, Jiong Wang wrote:
> Just an update and keep people posted.
>
> Working on linked list based approach, the implementation looks like the
> following, mostly a combine of discussions happened and Naveen's patch,
> please feel free to comment.
>
>   - Use the reserved opcode 0xf0 with BPF_ALU as new pseudo insn code
>     BPF_LIST_INSN. (0xf0 is also used with BPF_JMP class for tail call).
>
>   - Introduce patch pool into bpf_prog->aux to keep all patched insns.
It's not clear to me what the point of the patch pool is, rather than just
 doing the patch straight away.  Idea is that when prog is half-patched,
 insn idxs / jump offsets / etc. all refer to the original locations, only
 some of those might now be a list rather than a single insn.  Concretely:

struct bpf_insn_list { bpf_insn insn; struct list_head list; }
orig prog: array bpf_insn[3] = {cond jump +1, insn_foo, exit};
start of day verifier converts this into array bpf_insn_list[3],
 each with new.insn = orig.insn; INIT_LIST_HEAD(new.list)

verifier decides to patch insn_foo into {insn_bar, insn_baz}.
so we allocate bpf_insn_list *x;
insn_foo.insn = insn_bar;
x->insn = insn_baz;
list_add_tail(&x->list, &insn_foo.list);

the cond jump +1 is _not_ changed at this point, because it counts
 bpf_insn_lists and not insns.

Then at end of day to linearise we just have int new_idx[3];
 populate it by iterating over the array of bpf_insn_list and adding on
 the list length each time (so we get {0, 1, 3})
 then allocate output prog of the total length (here 4, calculated by
 that same pass as effectively off-the-end entry of new_idx)
 then iterate again to write out the output prog, when we see that 'cond
 jump +1' in old_idx 0 we see that (new_idx[2] - new_idx[0] - 1) = 2, so
 it becomes 'cond jump +2'.


This seems to me like it'd be easier to work with than making the whole
 program one big linked list (where you have to separately keep track of
 what each insn's idx was before patching).  But I haven't tried to code
 it yet, so anything could happen ;-)  It does rely on the assumption
 that only original insns (or the first insn of a list they get patched
 with) will ever be jump targets or otherwise need their insn_idx taken.

-Ed
