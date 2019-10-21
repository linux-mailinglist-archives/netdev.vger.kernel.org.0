Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E4FDF8CD
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 01:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfJUXvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 19:51:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:45878 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729718AbfJUXvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 19:51:20 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6F3BC4C0058;
        Mon, 21 Oct 2019 23:51:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 21 Oct
 2019 16:51:12 -0700
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
From:   Edward Cree <ecree@solarflare.com>
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
Message-ID: <e968af34-b538-d1d3-1cf1-5b4e22294a78@solarflare.com>
Date:   Tue, 22 Oct 2019 00:51:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24990.005
X-TM-AS-Result: No-8.133900-4.000000-10
X-TMASE-MatchedRID: fE0JoqABJp3mLzc6AOD8DfHkpkyUphL9IiTd2l7lf6GuNd+pu3dTGg6Q
        J3m2Fr47hBgW1oWqoGkWr39K8vorPoeEblCEuUZaiVJZi91I9Jh02ZC6RJyIuLkyLBU2tuXnXUC
        QpaQ/+KfREzGIv6wO3jQUkohHLxxaY8o+fcjxpOT4vYawCsCC2qbsRRaTaNLRmJBe2bRXwlNyMB
        AlYDmp4j0KKqGcyZ1Z04LY8Bk2g+1dxEg+iEaV6p3bt4XlQMWj21y0oPfgygpoe+v2w6RhK3Ioz
        Ga69omdowV+mkFB3ea8eHU+jqFqzXZW0C+m8SohrMcMK3Nm8dmpvf+jmz45wxvvaBlBXZew+QvP
        BNKffRnARoIcSvIvLKOwbF0w9VOsbWNBitJBrR/C0TXpqtexIuBwxa/RDufiTIqcL+xT7KlARXr
        3iG5/5+fOVcxjDhcwPcCXjNqUmkV5zdAzex5xZqgdZ197Ssb/p5P4zSQ2X91NS+rGHHX2H6rmcS
        BGUK9niIyodu7J+teUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.133900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24990.005
X-MDID: 1571701879-PlLC6XqtyU25
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/10/2019 19:33, Edward Cree wrote:
> But I think we'll
>  need to prototype things with static linking first so that we can be
>  sure of the linker semantics we want, before we try to put a new dynamic
>  linker in the kernel.
For anyone wanting to follow my progress on this, the first-draft eBPF
 linker 'ebld.py' can now be found at
 https://github.com/solarflarecom/ebpf_asm/tree/linker

It's able to resolve inter-object calls (at least in a _really simple_ test
 I did, where prog A was "call pass_fn; exit" and prog B was "pass_fn:
 ld r0, XDP_PASS; exit"), but I haven't got as far as feeding the resulting
 object file to the kernel (no obvious reason that shouldn't work, I just
 haven't tried it yet).
What it _doesn't_ do yet is deal with BTF — it just silently discards any
 BTF or BTF.ext sections in the input object files.  I'll need to re-read
 the BTF spec to see what's changed there since last I was involved (I hope
 the spec has been kept up to date as BTF has evolved...!)

But with the basic linker there, I think a prototype daemon is probably a
 higher priority than getting fully-featured with BTF, so that's what I
 plan to do next.

-Ed

PS: Yes, it's in Python.  I started out in C, and quickly backed myself
 into a corner trying to keep the data structures simple.  Having first-
 class dictionaries Really Helps.
