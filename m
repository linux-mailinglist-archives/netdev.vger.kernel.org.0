Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0978D856
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfHNQpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:45:49 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:42640 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbfHNQps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:45:48 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4ECD6280066;
        Wed, 14 Aug 2019 16:45:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 14 Aug
 2019 09:45:42 -0700
Subject: Re: [RFC bpf-next 0/3] tools: bpftool: add subcommand to count map
 entries
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <oss-drivers@netronome.com>
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
 <20190814015149.b4pmubo3s4ou5yek@ast-mbp>
 <ab11a9f2-0fbd-d35f-fee1-784554a2705a@netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <bdb4b47b-25fa-eb96-aa8d-dd4f4b012277@solarflare.com>
Date:   Wed, 14 Aug 2019 17:45:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <ab11a9f2-0fbd-d35f-fee1-784554a2705a@netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24846.005
X-TM-AS-Result: No-3.643100-4.000000-10
X-TMASE-MatchedRID: u7Yf2n7Ca/3mLzc6AOD8DfHkpkyUphL9Do+1MFDUmMIno4Cg1D1PpI41
        Yiw6vZQgB14UsWK24XGjHhSpPxZ4eH7AC5JRaWPkg2tpowTD9VpKRaXN2yYjHqjxqhyDxmYjyqa
        t6b4pc926Dl2o9yLarrI2bT94ZMbK/hPxWhJoaWNl+J8H0/8mq+v6L5uWBkxpe7ijHq7g9oakwF
        TCCpbFR0xCY2RJI2SeNPNBTLe8XOq2dGztBFpBpuCFhwSlJTKmAQ8mtiWx//pTbQ95zRbWVnYcV
        mi5d+yfooANMGNbTwivH6m9IGKWDJkaeWCm57xM6qrX9V+kFlMi2mgG5ouz/Jsoi2XrUn/JmTDw
        p0zM3zoqtq5d3cxkNQC5WvFNNLJUApNL59c3HARWcQU3SQCC4ISaIlgYyzq3FufNfov/hoyFvjr
        P0kXZWjj2MnwZdrWwURF0o02RNxJMLOr+ZKhddGInN/OvqA5wBsRAh8WmTAcG2WAWHb2qekrMHC
        7kmmSWc5S6hNczuvhDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.643100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24846.005
X-MDID: 1565801148-BUSbPqAtwcn8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/08/2019 10:42, Quentin Monnet wrote:
> 2019-08-13 18:51 UTC-0700 ~ Alexei Starovoitov
> <alexei.starovoitov@gmail.com>
>> The same can be achieved by 'bpftool map dump|grep key|wc -l', no?
> To some extent (with subtleties for some other map types); and we use a
> similar command line as a workaround for now. But because of the rate of
> inserts/deletes in the map, the process often reports a number higher
> than the max number of entries (we observed up to ~750k when max_entries
> is 500k), even is the map is only half-full on average during the count.
> On the worst case (though not frequent), an entry is deleted just before
> we get the next key from it, and iteration starts all over again. This
> is not reliable to determine how much space is left in the map.
>
> I cannot see a solution that would provide a more accurate count from
> user space, when the map is under pressure?
This might be a really dumb suggestion, but: you're wanting to collect a
 summary statistic over an in-kernel data structure in a single syscall,
 because making a series of syscalls to examine every entry is slow and
 racy.  Isn't that exactly a job for an in-kernel virtual machine, and
 could you not supply an eBPF program which the kernel runs on each entry
 in the map, thus supporting people who want to calculate something else
 (mean, min and max, whatever) instead of count?
