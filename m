Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863C5D7B95
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388065AbfJOQas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:30:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:52992 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388058AbfJOQas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:30:48 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C5B9CB40053;
        Tue, 15 Oct 2019 16:30:42 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 15 Oct
 2019 09:30:13 -0700
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
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
Date:   Tue, 15 Oct 2019 17:30:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87eezfi2og.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24978.005
X-TM-AS-Result: No-0.496500-4.000000-10
X-TMASE-MatchedRID: nVQUmLJJeybmLzc6AOD8DfHkpkyUphL9nrrV5UnUVY1sMPuLZB/IR8t9
        tjrCgO8yrLIEP6IJZx0ASM4PYo8fU8p/EvLM+WIYolVO7uyOCDUX2zxRNhh61dljMRw7s1zH166
        Xb3/Hw4PnXrPEAj+VtuetMKTFMRnec0hqwQME+MDTbR5agAsD130tCKdnhB58ZYJ9vPJ1vSDefx
        4FmMaZTOTCMddcL/gjro1URZJFbJv2g69gzriLd6FWN0PM8v/PNE8krdZyc2rpKTeBtD5DpN4z0
        7uD0KwaunY63U3BB2vn9cFnZmGWiGfflrv2TYer100DhXWA6BKFcgJc+QNMwu8bJovJYm8FYupx
        0XjSQPLDOFVmKqGJ4bPn3tFon6UK
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.496500-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24978.005
X-MDID: 1571157047-4-MkRb-Vdsnf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/2019 19:48, Toke Høiland-Jørgensen wrote:
> So that will end up with a single monolithic BPF program being loaded
> (from the kernel PoV), right? That won't do; we want to be able to go
> back to the component programs, and manipulate them as separate kernel
> objects.
Why's that?  (Since it also applies to the static-linking PoC I'm
 putting together.)  What do you gain by having the components be
 kernel-visible?
(Bad analogy time: the kernel doesn't care about the .o files you
 linked together to make a userspace executable; any debugging you
 do on that relies on other userspace infrastructure — loading
 symbol tables into a debugger — to interpret things.)

-Ed
