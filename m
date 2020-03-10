Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B799C180854
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 20:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgCJTmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 15:42:55 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:52072 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726899AbgCJTmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 15:42:54 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0B85060005C;
        Tue, 10 Mar 2020 19:42:51 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 10 Mar
 2020 19:41:24 +0000
Subject: Re: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <yhs@fb.com>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
 <20200309235828.wldukb66bdwy2dzd@ast-mbp>
 <3f80b587-c5b0-0446-8cbc-eff1758496e9@solarflare.com>
 <5e67e977eb4f_586d2b10f16785b8f5@john-XPS-13-9370.notmuch>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1e714857-f92c-947f-f3d6-d525f45c3d68@solarflare.com>
Date:   Tue, 10 Mar 2020 19:41:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5e67e977eb4f_586d2b10f16785b8f5@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25280.003
X-TM-AS-Result: No-1.299800-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHmLzc6AOD8DfHkpkyUphL9+IfriO3cV8S0Zkv2GlpvMHpQ
        URdMc/ivCE6dCJ7Xb/jkrlAElJEH9TkCIp+RLKUGiZ28vfWFua5Ui/Q/v/K1WZCxGpJcxGRXRgF
        z7WfssL9FFb03dhGdCXuBFm2tNp/3KFbesJUuOxxHgxQfODgFAGQBrQiRNt2If2dEskHXJhB7Mo
        GOLT7cXt+feruvdwLXBvMn3tYhNQm8+Qw9PrZG9UmVHiC8UozAfS0Ip2eEHnzWRN8STJpl3PoLR
        4+zsDTtWA7iEVqasYbVoFh6OkLsvoEJgnsqvPZC/MvpG2DeWvxlSn1Gfy1kG6/0d7Cw5f1M0MRD
        cJKD0Qwbzw3ufKepsUBeGcFF0pn1gcLjbYgVf4JR029mOM6P0LrcE8xytxC5d5hZXZFoB8PxWx9
        3BSYyyVXK9tOD+u6c
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.299800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25280.003
X-MDID: 1583869372-udeduozjWc_z
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2020 19:24, John Fastabend wrote:
> I guess I'm not opposed to supporting (a) it seems like it should
> be doable.
Ah ok.  Indeed if we add u32 bounds we get (a) for free, I just
 wasn't sure it was reason enough by itself to justify them.

> For (b) the primary reason is to keep symmetry between 32-bit and
> 64-bit cases. But also we could have mixed signed 32-bit comparisons
> which this helps with.
>
> Example tracking bounds with [x,y] being signed 32-bit
> bounds and [x',y'] being unsigned 32-bit bounds.
>
>     r1 = #                   [x,y],[x',y']
>     w1 >    0 goto pc+y      [x,y],[1 ,y']
>     w1 s> -10 goto pc+x      [-10,y],[1 ,y']
>
> We can't really deduce much from that in __reg_deduce_bounds so
> we get stuck with different bounds on signed and unsigned space.
> Same case as 64-bit world fwiw. I guess we could do more work
> and use 64-bit/32-bit together and deduce something
Ah ok, problem is when you have good u32 bounds but know nothing
 about the high 32, so your u64 bounds don't capture those u32
 bounds.  I think I get it now and I agree that u32 bounds are
 worth doing :-)

-ed
