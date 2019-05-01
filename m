Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217EA10EAF
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfEAVoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:44:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:42956 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfEAVoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 17:44:05 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hLx14-0008OJ-3n; Wed, 01 May 2019 23:43:50 +0200
Received: from [173.228.226.134] (helo=localhost.localdomain)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hLx13-000M1d-Ia; Wed, 01 May 2019 23:43:49 +0200
Subject: Re: [PATCH] bpf, x32: Fix bug for BPF_ALU64 | BPF_NEG
To:     Wang YanQing <udknight@gmail.com>, ast@kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, tglx@linutronix.de,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190428023302.GA29326@udknight>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <091c2ed4-a07f-cc75-7b18-1c7cb7068652@iogearbox.net>
Date:   Wed, 1 May 2019 23:43:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190428023302.GA29326@udknight>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25436/Wed May  1 09:58:19 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/28/2019 04:33 AM, Wang YanQing wrote:
> The current implementation has two errors:
> 1: The second xor instruction will clear carry flag which
>    is necessary for following sbb instruction.
> 2: The select coding for sbb instruction is wrong, the coding
>    is "sbb dreg_hi,ecx", but what we need is "sbb ecx,dreg_hi".
> 
> This patch rewrites the implementation and fixes the errors.
> 
> This patch fixes below errors reported by bpf/test_verifier in x32
> platform when the jit is enabled:
> "
> 0: (b4) w1 = 4
> 1: (b4) w2 = 4
> 2: (1f) r2 -= r1
> 3: (4f) r2 |= r1
> 4: (87) r2 = -r2
> 5: (c7) r2 s>>= 63
> 6: (5f) r1 &= r2
> 7: (bf) r0 = r1
> 8: (95) exit
> processed 9 insns (limit 131072), stack depth 0
> 0: (b4) w1 = 4
> 1: (b4) w2 = 4
> 2: (1f) r2 -= r1
> 3: (4f) r2 |= r1
> 4: (87) r2 = -r2
> 5: (c7) r2 s>>= 63
> 6: (5f) r1 &= r2
> 7: (bf) r0 = r1
> 8: (95) exit
> processed 9 insns (limit 131072), stack depth 0
> ......
> Summary: 1189 PASSED, 125 SKIPPED, 15 FAILED
> "
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Applied, thanks!
