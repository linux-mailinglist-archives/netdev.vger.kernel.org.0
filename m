Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065428DA3B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfHNRO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:14:26 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33168 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729107AbfHNRO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:14:26 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8D625180062;
        Wed, 14 Aug 2019 17:14:24 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 14 Aug
 2019 10:14:20 -0700
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
 <bdb4b47b-25fa-eb96-aa8d-dd4f4b012277@solarflare.com>
 <18f887ec-99fd-20ae-f5d6-a1f4117b2d77@netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <84aa97e3-5fde-e041-12c6-85863e27d2d9@solarflare.com>
Date:   Wed, 14 Aug 2019 18:14:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <18f887ec-99fd-20ae-f5d6-a1f4117b2d77@netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24846.005
X-TM-AS-Result: No-4.660000-4.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTrmLzc6AOD8DfHkpkyUphL9frTt+hmA5bIrhioeAJKilVrh
        neGACnO83JyZkMBokPLQvbuwy1I9/oQWSPO5cc238KGJCiV+3/JUE+MH85/4VAPBX2NhZtJTr/q
        QdenuXcVZzzDA0sjQDYc8aIZtIudLKjPlgWuJZGwkFrn8AyeCvXpDIEzkG1Rb7TFPIrDjEdXffA
        /WyrSuS98o/LR6nLGKb+8anoKmoxGmO6U9OrWUyDXKFtsDtZ7TWw/S0HB7eoMRGC0rW8q1XSMKo
        2HmNqd69+lWSVgVU32JIG0pP8yLBr9ZdlL8eonaC24oEZ6SpSmb4wHqRpnaDkqZNSncfEh805m6
        yr8nCFiomVaV1WLMqnHm8UEcdz6aaWzb5cWPQLRaU0yTy1qikJEXEPAPyNGcrlaO4F0BnSCS16g
        HcUAYRIfMZMegLDIeGU0pKnas+RbnCJftFZkZizYJYNFU00e7N+XOQZygrvY=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.660000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24846.005
X-MDID: 1565802865-Gp7HgkQUnKV7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/08/2019 17:58, Quentin Monnet wrote:
> 2019-08-14 17:45 UTC+0100 ~ Edward Cree <ecree@solarflare.com>
>> This might be a really dumb suggestion, but: you're wanting to collect a
>>  summary statistic over an in-kernel data structure in a single syscall,
>>  because making a series of syscalls to examine every entry is slow and
>>  racy.  Isn't that exactly a job for an in-kernel virtual machine, and
>>  could you not supply an eBPF program which the kernel runs on each entry
>>  in the map, thus supporting people who want to calculate something else
>>  (mean, min and max, whatever) instead of count?
>>
> Hi Edward, I like the approach, thanks for the suggestion.
>
> But I did not mention that we were using offloaded maps: Tracing the
> kernel would probably work for programs running on the host, but this is
> not a solution we could extend to hardware offload.
I don't see where "tracing" comes into it; this is a new program type and
 a new map op under the bpf() syscall.
Could the user-supplied BPF program not then be passed down to the device
 for it to run against its offloaded maps?
