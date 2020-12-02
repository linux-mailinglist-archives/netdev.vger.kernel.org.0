Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114EA2CB4E2
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 07:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgLBGNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 01:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLBGNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 01:13:40 -0500
Date:   Wed, 2 Dec 2020 15:12:49 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606889579;
        bh=iq4w83r3KcpGNfLojtJbmxsBlIvh9Kd7TGq0E0obhag=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=F94qpNi+CTG+CXQq1P7ay1ITL6NIZT6f8WmGX/L3VuZsjhRU7E2kR16sPrBbSFSEn
         QmoMm1aQAHEU9CvOr8L4rlzkyyyukplqF0FXM9P7KdcOfjgGkfrm5Gh305OyziDv7Z
         0sRC6X026DtASaF+AR+amBxV/jQuVFbhbBI/HSWU=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        akpm@linux-foundation.org, bp@alien8.de, coreteam@netfilter.org,
        syzbot <syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com>,
        davem@davemloft.net, gustavoars@kernel.org, hpa@zytor.com,
        john.stultz@linaro.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        wang.yi59@zte.com.cn, x86@kernel.org
Subject: Re: UBSAN: array-index-out-of-bounds in arch_uprobe_analyze_insn
Message-Id: <20201202151249.52e0648ed53689fe64bb6b05@kernel.org>
In-Reply-To: <202012011616.DFBE3FC5BC@keescook>
References: <00000000000082559e05afc6b97a@google.com>
        <0000000000002cd54805afdf483f@google.com>
        <202012011616.DFBE3FC5BC@keescook>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

On Tue, 1 Dec 2020 16:48:55 -0800
Kees Cook <keescook@chromium.org> wrote:

> Hi,
> 
> There appears to be a problem with prefix counting for the instruction
> decoder. It looks like insn_get_prefixes() isn't keeping "nb" and "nbytes"
> in sync correctly:
> 
>         while (inat_is_legacy_prefix(attr)) {
>                 /* Skip if same prefix */
>                 for (i = 0; i < nb; i++)
>                         if (prefixes->bytes[i] == b)
>                                 goto found;
>                 if (nb == 4)
>                         /* Invalid instruction */
>                         break;
>                 prefixes->bytes[nb++] = b;
> 		...
> found:
>                 prefixes->nbytes++;
>                 insn->next_byte++;
>                 lb = b;
>                 b = peek_next(insn_byte_t, insn);
>                 attr = inat_get_opcode_attribute(b);
>         }
> 
> (nbytes is incremented on repeated prefixes, but "nb" isn't)
> 
> However, it looks like nbytes is used as an offset:
> 
> static inline int insn_offset_rex_prefix(struct insn *insn)
> {
>         return insn->prefixes.nbytes;
> }
> static inline int insn_offset_vex_prefix(struct insn *insn)
> {
>         return insn_offset_rex_prefix(insn) + insn->rex_prefix.nbytes;
> }

Yes, it is designed to do that. nbytes counts how many bytes the prefix is,
and nb is how many bytes of the prefix->bytes consumed.
Since the legacy prefix can be repeated and more than 4 (bytes), we can not
store all of those.

> 
> Which means everything that iterates over prefixes.bytes[] is buggy,
> since they may be trying to read past the end of the array:

Good catch! All following usage are wrong...

> 
> $ git grep -A3 -E '< .*prefixes(\.|->)nbytes'
> boot/compressed/sev-es.c:       for (i = 0; i < insn->prefixes.nbytes; i++) {
> boot/compressed/sev-es.c-               insn_byte_t p =
> insn->prefixes.bytes[i];
> boot/compressed/sev-es.c-
> boot/compressed/sev-es.c-               if (p == 0xf2 || p == 0xf3)
> --
> kernel/uprobes.c:       for (i = 0; i < insn->prefixes.nbytes; i++) {
> kernel/uprobes.c-               insn_attr_t attr;
> kernel/uprobes.c-
> kernel/uprobes.c-               attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
> --
> kernel/uprobes.c:       for (i = 0; i < insn->prefixes.nbytes; i++) {
> kernel/uprobes.c-               if (insn->prefixes.bytes[i] == 0x66)
> kernel/uprobes.c-                       return -ENOTSUPP;
> kernel/uprobes.c-       }
> --
> lib/insn-eval.c:        for (i = 0; i < insn->prefixes.nbytes; i++) {
> lib/insn-eval.c-                insn_byte_t p = insn->prefixes.bytes[i];
> lib/insn-eval.c-
> lib/insn-eval.c-                if (p == 0xf2 || p == 0xf3)
> --
> lib/insn-eval.c:        for (i = 0; i < insn->prefixes.nbytes; i++) {
> lib/insn-eval.c-                insn_attr_t attr;
> lib/insn-eval.c-
> lib/insn-eval.c-                attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
> 
> I don't see a clear way to fix this.

For the loop, we can check the insn.prefixes.bytes[i] == 0 since
it is initialized by 0 and 0x0 is not a prefix like this.

for (i = 0; insn->prefixes.bytes[i] && i < 4; i++) {
...
}

Thank you,

> 
> -Kees
> 
> On Mon, Sep 21, 2020 at 09:20:07PM -0700, syzbot wrote:
> > syzbot has bisected this issue to:
> > 
> > commit 4b2bd5fec007a4fd3fc82474b9199af25013de4c
> > Author: John Stultz <john.stultz@linaro.org>
> > Date:   Sat Oct 8 00:02:33 2016 +0000
> > 
> >     proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1697348d900000
> > start commit:   325d0eab Merge branch 'akpm' (patches from Andrew)
> > git tree:       upstream
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=1597348d900000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1197348d900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=b12e84189082991c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9b64b619f10f19d19a7c
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1573a8ad900000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164ee6c5900000
> > 
> > Reported-by: syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com
> > Fixes: 4b2bd5fec007 ("proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self")
> > 
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> -- 
> Kees Cook


-- 
Masami Hiramatsu <mhiramat@kernel.org>
