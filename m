Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E3B180482
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCJRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:12:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51462 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbgCJRMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:12:48 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DA1A160006E;
        Tue, 10 Mar 2020 17:12:45 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 10 Mar
 2020 17:12:34 +0000
Subject: Re: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
CC:     <yhs@fb.com>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
 <20200309235828.wldukb66bdwy2dzd@ast-mbp>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <3f80b587-c5b0-0446-8cbc-eff1758496e9@solarflare.com>
Date:   Tue, 10 Mar 2020 17:12:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200309235828.wldukb66bdwy2dzd@ast-mbp>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25280.003
X-TM-AS-Result: No-2.247000-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfvmLzc6AOD8DcEU6KRYGcYdTJDl9FKHbrkWeIgR+ERzLAQ9
        n8U23GDfZhgUf9KGx0qyBxCwqqjAnuMgV7FXaWc0/1dEgwtQ6NC7xmCZDXrutbu1Sf94ro4p3Mj
        q1xDTdMTBZXeE39CjUXNyq0Gwang3FqXLH1tGOWYcLuEDP+gqcuP6p+9mEWlCe4qzNyQgC2omSk
        SBaVwPga0+31c4kc33DdzWRveIwGOkQ4dFqDSK9WhQCsqhuTNiRjqOkKPmpa4aQNdCmy53TaPFj
        JEFr+olSXhbxZVQ5H+OhzOa6g8KrXTle4Z3W3gmV2klpsCc77dw8IfGUlnVed/udOQ+cbnI0GEs
        K/p/1/Eb7b9IgF4bujSfn3I9O1FnFc6hb6P/T4rBgXpZvrVy7eL59MzH0po2K2yzo9Rrj9wPoYC
        35RuihKPUI7hfQSp53zHerOgw3HE=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.247000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25280.003
X-MDID: 1583860366-Q1159t4NNiBO
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2020 23:58, Alexei Starovoitov wrote:> Thinking about it differently... var_off is a bit representation of
> 64-bit register. So that bit representation doesn't really have
> 32 or 16-bit chunks. It's a full 64-bit register. I think all alu32
> and jmp32 ops can update var_off without losing information.
Agreed; AFAICT the 32-bit var_off should always just be the bottom
 32 bits of the full var_off.
In fact, it seems like the only situations where 32-bit bounds are
 needed are (a) the high and low halves of a 64-bit register are
 being used separately, so e.g. r0 = (x << 32) | y with small known
 bounds on y you want to track, or (b) 32-bit signed arithmetic.
(a) doesn't seem like it's in scope to be supported, and (b) should
 (I'm naïvely imagining) only need the s32 bounds, not the u32 or
 var32.

John Fastabend wrote:
> For example, BPF_ADD will do a tnum_add() this is a different
> operation when overflows happen compared to tnum32_add(). Simply
> truncating tnum_add result to 32-bits is not the same operation.
I don't see why.  Overflows from the low (tracked) 32 bits can only
 affect the high 32.  Truncation should be a homomorphism from
 Z_2^n to Z_2^m wrt. both addition and multiplication, and tnums
 are just (a particular class of) subsets of those rings.
Can you construct an example of a tnum addition that breaks the
 homomorphism?

-ed
