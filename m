Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D3842A0A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438107AbfFLO4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:56:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:47570 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfFLO4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 10:56:18 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb4fe-00007v-4O; Wed, 12 Jun 2019 16:56:14 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb4fd-0005or-V5; Wed, 12 Jun 2019 16:56:13 +0200
Subject: Re: [PATCH] bpf/core.c - silence warning messages
To:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <29466.1559875167@turing-police>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d693c3bd-7491-588e-3648-59bbef3b88fa@iogearbox.net>
Date:   Wed, 12 Jun 2019 16:56:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <29466.1559875167@turing-police>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25478/Wed Jun 12 10:14:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2019 04:39 AM, Valdis Klētnieks wrote:
> Compiling kernel/bpf/core.c with W=1 causes a flood of warnings:
> 
> kernel/bpf/core.c:1198:65: warning: initialized field overwritten [-Woverride-init]
>  1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
>       |                                                                 ^~~~
> kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
>  1087 |  INSN_3(ALU, ADD,  X),   \
>       |  ^~~~~~
> kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
>  1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
>       |   ^~~~~~~~~~~~
> kernel/bpf/core.c:1198:65: note: (near initialization for 'public_insntable[12]')
>  1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
>       |                                                                 ^~~~
> kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
>  1087 |  INSN_3(ALU, ADD,  X),   \
>       |  ^~~~~~
> kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
>  1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
>       |   ^~~~~~~~~~~~
> 
> 98 copies of the above.
> 
> The attached patch silences the warnings, because we *know* we're overwriting
> the default initializer. That leaves bpf/core.c with only 6 other warnings,
> which become more visible in comparison.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Makes sense, applied!
