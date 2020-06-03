Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3E11ED383
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgFCPhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 11:37:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40806 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbgFCPhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 11:37:15 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A60E02007D;
        Wed,  3 Jun 2020 15:37:14 +0000 (UTC)
Received: from us4-mdac16-56.at1.mdlocal (unknown [10.110.48.199])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A3540800A4;
        Wed,  3 Jun 2020 15:37:14 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3446340077;
        Wed,  3 Jun 2020 15:37:14 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D0BBF300061;
        Wed,  3 Jun 2020 15:37:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Jun 2020
 16:37:08 +0100
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexander Potapenko <glider@google.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
References: <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
 <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
 <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com>
 <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com>
 <CAG_fn=WaYz5LOyuteF5LAkgFbj8cpgNQyO1ReORTAiCbyGuNQg@mail.gmail.com>
 <38ff5e15-bf76-2d17-f524-3f943a5b8846@solarflare.com>
 <CAG_fn=XR_dRG4vpo-jDS1L-LFD8pkuL8yWaTWbJAAQ679C3big@mail.gmail.com>
 <20200602173216.jrcvzgjhrkvlphew@ast-mbp.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <91a115bb-24d3-3765-a082-555b5999bb42@solarflare.com>
Date:   Wed, 3 Jun 2020 16:37:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200602173216.jrcvzgjhrkvlphew@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25458.003
X-TM-AS-Result: No-2.587300-8.000000-10
X-TMASE-MatchedRID: fgYTp5Xatxai6/VcDv9f0PZvT2zYoYOwC/ExpXrHizxPSgvj4HDUVBFl
        wJhVcSVOyblxJGLnU6/RHe220+u4+9kgF1Y9xet3UeavKZUnS5BKIW2TMRVxOpsoi2XrUn/JIq9
        5DjCZh0zLOq+UXtqwWAtuKBGekqUpnH7sbImOEBTrKs9yjQob2G+oZPRsn1Y3Jmnv/QtUbxdBXt
        Sa9Xf7uhKAjF7uM7EIUdNvZjjOj9C63BPMcrcQuXeYWV2RaAfD8VsfdwUmMsnAvpLE+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.587300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25458.003
X-MDID: 1591198634-sfbHopBDXVYc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/06/2020 18:32, Alexei Starovoitov wrote:
> The target for bpf codegen is JITs.
> bpf interpreter is simulating hw.
> For now if you want UB fuzzer running in your environment please add
> _out_of_tree_ patch that inits all interpreter registers to zero.
+1 to all the above.

Also, note that you can still fuzz BPF JITs by building the kernel
 without the interpreter: CONFIG_BPF_JIT_ALWAYS_ON.
