Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA43E0A91
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfJVR1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:27:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:52926 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730141AbfJVR1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:27:35 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2150D58005C;
        Tue, 22 Oct 2019 17:27:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 22 Oct
 2019 10:27:27 -0700
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
 <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk>
 <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
 <87o8yqjqg0.fsf@toke.dk>
 <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk>
 <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
 <87eezfi2og.fsf@toke.dk>
 <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
Date:   Tue, 22 Oct 2019 18:27:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <874l07fu61.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24994.005
X-TM-AS-Result: No-12.876700-4.000000-10
X-TMASE-MatchedRID: yebcs53SkkDmLzc6AOD8DfHkpkyUphL9IiTd2l7lf6GUxLMcAJhzChjb
        R/XCsHXW+ELXJL/WKRNyb4nbWHnWKTKS5ImHGk0PVdc4VcPHbmLdXhRKGhNdp/yQXCBzKijhKKi
        9XIZVdsVjpQP5oqJIRijaOlBSoSUInlAKTQ62b5AYkAMBsEcZTKpW8MqA90G1pfrLsBaiuHlqV9
        pLhV9g1u2hr3+UqPGHcCuDFZNBTwYAXrk/UTsS9S0x8J2DopENwZy9wGhpvaNtpkxrR+BG1tfW9
        lAubxAgZtxspcn5hZW+lQJ6nf193eimkKfNjSYcOM7ns3UgBY3LRD51bz5RZJS5x6M6jKbvOArq
        sGNfHKItRBycb/xw2QywZcdBKTJJEdBtUuDCdgwSkDbX2wMzOadlL9piCOvOO3tmMk8BUiKEyP6
        1LxM13gdeFLFituFxJ4Rc36hcMdaKQsBMcfAIqTiST9KZzBhF45oDENe4eesEV6mM/gDBuT+le1
        80SJAGpZDlHR4OgYBJS3z1k1kZyj6hJYir1MIcvOAv94sAIMQ7pfSjRsD2OuQ45nVtPqmxc3wuq
        c+4WoxGAfwt8m0Q+hUWc5DwcsWWD7X2VQg3bPRR+pHf1lsiVUGaUEX8gnR8Xs4sv9ryyGN5WzSy
        TIRpLfYAAJQzY7UwlHnCsbYVBIYVc5YGPfAGy8+QmA3DfdSbgcsVZH3dOCRpsnGGIgWMmXgjVdZ
        jIv+Odp6aRRnWVP+JxaLf2x540nUcz7FjVcunAJIdE3gUsGtbNK961m3j7r142xO28EPefhv4SA
        oZsmodga6bKYrkWZTebcoGapT0pt1OjypUh9OeAiCmPx4NwFkMvWAuahr8+gD2vYtOFhgqtq5d3
        cxkNcPor1/FiEfhin3X7TBxkdXqsFWyOVb1l14RJZLHQAwMJ2NCz5R759Q=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.876700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24994.005
X-MDID: 1571765253-BOjysTQ_wxcZ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/10/2019 13:11, Toke Høiland-Jørgensen wrote:
> I think there's a conceptual disconnect here in how we view what an XDP
> program is. In my mind, an XDP program is a stand-alone entity tied to a
> particular application; not a library function that can just be inserted
> into another program.
To me, an XDP (or any other eBPF) program is a function that is already
 being 'inserted into another program', namely, the kernel.  It's a
 function that's being wired up to a hook in the kernel.  Which isn't
 so different to wiring it up to a hook in a function that's wired up to
 a hook in the kernel (which is what my proposal effectively does).

> Setting aside that for a moment; the reason I don't think this belongs
> in userspace is that putting it there would carry a complexity cost that
> is higher than having it in the kernel.
Complexity in the kernel is more expensive than in userland.  There are
 several reasons for this, such as:
* The kernel's reliability requirements are stricter — a daemon that
  crashes can be restarted, a kernel that crashes ruins your day.
* Userland has libraries available for many common tasks that can't be
  used in the kernel.
* Anything ABI-visible (which this would be) has to be kept forever even
  if it turns out to be a Bad Idea™, because We Do Not Break Userspace™.
The last of these is the big one, and means that wherever possible the
 proper course is to prototype functionality in userspace, and then once
 the ABI is solid and known-useful, it can move to the kernel if there's
 an advantage to doing so (typically performance).  Yes, that means
 applications may have to change twice (though hopefully just a matter
 of building against a new libbpf), but the old applications can be kept
 working (by keeping the daemon around on such systems).

> Specifically, if we do implement
> an 'xdpd' daemon to handle all this, that would mean that we:
>
> - Introduce a new, separate code base that we'll have to write, support
>   and manage updates to.
Separation is a good thing.  Whichever way we do this, we have to write
 some new code.  Having that code _outside_ the kernel tree helps to keep
 our layers separate.  Chain calling is a layering violation!

> - Add a new dependency to using XDP (now you not only need the kernel
>   and libraries, you'll also need the daemon).
You'll need *a* daemon.  You won't be tied to a specific implementation.
And if you're just developing, you won't even need that — you can still
 bind a prog directly to the device if you have the ackles — so it's
 only for application deployment that it's needed.  By the time you're
 at the point of deploying an application that people are going to be
 installing with "yum install myFirewall", you have the whole package
 manager dependency resolution system to deal with the daemon.

> - Have to duplicate or wrap functionality currently found in the kernel;
>   at least:
>   
>     - Keeping track of which XDP programs are loaded and attached to
>       each interface
There's already an API to query this.  You would probably want an atomic
 cmpxchg operation, so that you can detect if someone else is fiddling
 with XDP and scream noisy warnings.

> (as well as the "new state" of their attachment order).
That won't be duplicate, because it won't be in the kernel.  The kernel
 will only ever see one blob and it doesn't know or care how userland
 assembled it.

>     - Some kind of interface with the verifier; if an app does
>       xdpd_rpc_load(prog), how is the verifier result going to get back
>       to the caller?
The daemon will get the verifier log back when it tries to update the
 program; it might want to do a bit of translation before passing it on,
 but an RPC call can definitely return errors to the caller.
In the Ideal World of kernel dynamic linking, of course, each app prog
 gets submitted to the verifier by the app to create a floating function
 in the kernel that's not bound to any XDP hook (app gets its verifier
 responses at this point) and then the app just sends an fd for that
 function to the daemon; at that point any verifier errors after linking
 are the fault of the daemon and its master program.  Thus the Ideal
 World doesn't need any kind of translation of verifier output to make
 it match up with individual app's program.

> - Have to deal with state synchronisation issues (how does xdpd handle
>   kernel state changing from underneath it?).
The cmpxchg I mentioned above would help with that.

> While these are issues that are (probably) all solvable, I think the
> cost of solving them is far higher than putting the support into the
> kernel. Which is why I think kernel support is the best solution :)
See my remarks above about kernel ABIs.
Also, chain calling and the synchronisation dance between apps still
 looks needlessly complex and fragile to me — it's like you're having
 the kernel there to be the central point of control and then not
 actually having a central point of control after all.  (But if chain
 calling does turn out to be the right API, well, the daemon can
 always implement that!)

-Ed
