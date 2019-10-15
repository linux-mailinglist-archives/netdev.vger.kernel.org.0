Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD557D7F19
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbfJOSdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:33:44 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:32930 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727200AbfJOSdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:33:43 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 27AB9680089;
        Tue, 15 Oct 2019 18:33:42 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 15 Oct
 2019 11:33:36 -0700
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
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
Date:   Tue, 15 Oct 2019 19:33:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87r23egdua.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24978.005
X-TM-AS-Result: No-0.957600-4.000000-10
X-TMASE-MatchedRID: eVEkOcJu0F7mLzc6AOD8DfHkpkyUphL93TijyM9Pm06NIyHZwe1QFtGV
        QrnZJqIeasiy2Gq55dNu8Fu5ca3VaWiqvF73selK4qCB2ZT6yAz4h+uI7dxXxE+86maMM3aSxM4
        LnHemWNicsoSgKGmgXwsomT4JOOOJhEHl6wFFv6eAO0kpgKezRAILzOoe9wba4ZmC0TPZtohibQ
        Tt34yFor8sWxR09nTRivZDYfXQrkr/XoXWj+sk7m6HurDH4PpPUb4EdIZGxuBRD5heJnxuK5/DV
        afvDf6BfsIfixHvnM+IvG1appPoNAhU4yeqg71ukJi1wdeHFtrCWn3gcatca8sh83hywc54nP9s
        HBbfaKR06g90LjJRaOdzbjlZ7erCkfRhdidsajODGx/OQ1GV8t0H8LFZNFG7CKFCmhdu5cW14Ak
        etjaBvVZYgdbj4xotNQC5FVraiU9hyIlyPZE5A+vY9CuBUVAhQ2JUiSK5OHeG+T/pjmHIzorTPv
        /DTrrw+TiDwGH5+omigEHy7J4S6ylkreA5r24aYnCi5itk3iprD5+Qup1qU56oP1a0mRIj
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.957600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24978.005
X-MDID: 1571164423-RtGudYRNUMs8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/10/2019 17:42, Toke Høiland-Jørgensen wrote:
> Edward Cree <ecree@solarflare.com> writes:
>> On 14/10/2019 19:48, Toke Høiland-Jørgensen wrote:
>>> So that will end up with a single monolithic BPF program being loaded
>>> (from the kernel PoV), right? That won't do; we want to be able to go
>>> back to the component programs, and manipulate them as separate kernel
>>> objects.
>> Why's that? (Since it also applies to the static-linking PoC I'm
>> putting together.) What do you gain by having the components be
>> kernel-visible?
> Because then userspace will have to keep state to be able to answer
> questions like "show me the list of programs that are currently loaded
> (and their call chain)", or do operations like "insert this program into
> the call chain at position X".
Userspace keeps state for stuff all the time.  We call them "daemons" ;)
Now you might have arguments for why putting a given piece of state in
 userspace is a bad idea — there's a reason why not everything is a
 microkernel — but those arguments need to be made.

> We already keep all this state in the kernel,
The kernel keeps the state of "current (monolithic) BPF program loaded
 (against each hook)".  Prior to this patch series, the kernel does
 *not* keep any state on what that BPF program was made of (except in
 the sense of BTF debuginfos, which a linker could combine appropriately).

So if we _don't_ add your chained-programs functionality into the kernel,
 and then _do_ implement userspace linking, then there isn't any
 duplicated functionality or even duplicated state — the userland state
 is "what are my components and what's the linker invocation that glues
 them together", the kernel state is "here is one monolithic BPF blob,
 along with a BTF blob to debug it".  The kernel knows nothing of the
 former, and userspace doesn't store (but knows how to recreate) the
 latter.

(That said, proper dynamic linking is better than static linking OR chain
 calls, because it gives us the full flexibility of linking while giving
 you your 'subprogs as kernel objects & kernel state'.  But I think we'll
 need to prototype things with static linking first so that we can be
 sure of the linker semantics we want, before we try to put a new dynamic
 linker in the kernel.)

-Ed
