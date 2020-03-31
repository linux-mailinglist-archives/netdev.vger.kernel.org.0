Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E15419A19E
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 00:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbgCaWGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 18:06:34 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60738 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728493AbgCaWGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 18:06:34 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C5664200A3;
        Tue, 31 Mar 2020 22:06:33 +0000 (UTC)
Received: from us4-mdac16-32.at1.mdlocal (unknown [10.110.49.216])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C26C1600A1;
        Tue, 31 Mar 2020 22:06:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 464A3220075;
        Tue, 31 Mar 2020 22:06:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ED85CB80065;
        Tue, 31 Mar 2020 22:06:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 31 Mar
 2020 23:05:53 +0100
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     David Ahern <dsahern@gmail.com>, Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Andrey Ignatov" <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
 <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
 <20200327230253.txq54keztlwsok2s@ast-mbp>
 <eba2b6df-e2e8-e756-dead-3f1044a061cd@solarflare.com>
 <20200331034319.lg2tgxxs5eyiqebi@ast-mbp>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <8c55c053-ab95-3657-e271-dd47c1daaf5e@solarflare.com>
Date:   Tue, 31 Mar 2020 23:05:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200331034319.lg2tgxxs5eyiqebi@ast-mbp>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25324.003
X-TM-AS-Result: No-4.539700-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hfmLzc6AOD8DfHkpkyUphL9SeIjeghh/zNfUCHPns/+Pr63
        pbm07ZZeSdLL6kjt9I/Gp/huIU6WTMr9HDn98b6SjoyKzEmtrEcIN+xzZWKXEOWE75Fmw3RmEl3
        R3+Zqra1PMNGJAkPaVAd2m1cUUwTvQd6ggaZlaf6eAiCmPx4NwJwhktVkBBrQFybFQYnP6TwBl3
        N74/wGv9AtbEEX0MxBxEHRux+uk8ifEzJ5hPndGQElZdLuNhARK//LMAOgyc0E3K+iS0K6C71EK
        bAUmW4p7QJ7Nr/4NU5sp4ZnnT3PvZ0p9lps94EPd/Hv57tPUOviIkk+eg27pdQ17CngTb9OBKmZ
        VgZCVnezGTWRXUlrxxtsJUxyzWNSVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.539700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25324.003
X-MDID: 1585692393-cft8yebpXU8a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2020 04:43, Alexei Starovoitov wrote:
> On Mon, Mar 30, 2020 at 04:25:07PM +0100, Edward Cree wrote:
>> Everything that a human operator can do, so can any program with the
>>  same capabilities/wheel bits.  Especially as the API that the
>>  operator-tool uses *will* be open and documented.  The Unix Way does
>>  not allow unscriptable interfaces, and heavily frowns at any kind of
>>  distinction between 'humans' and 'programs'.
> can you share a link on such philosophy?
It's not quite as explicit about it as I'd like, but
 http://www.catb.org/esr/writings/taoup/html/ch01s06.html#id2877684
 is the closest I can find right now.

-ed
