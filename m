Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E6A1A2C25
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDHXRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:17:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:52962 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgDHXRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:17:16 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jMJwM-0006LK-Qf; Thu, 09 Apr 2020 01:17:02 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jMJwM-000JK4-93; Thu, 09 Apr 2020 01:17:02 +0200
Subject: Re: [PATCH bpf] arm: bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift
 by 0
To:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20200408181229.10909-1-luke.r.nels@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <65cdd042-c037-d7c8-e6e7-bcfb6e8b00cb@iogearbox.net>
Date:   Thu, 9 Apr 2020 01:17:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200408181229.10909-1-luke.r.nels@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25776/Wed Apr  8 14:56:40 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/20 8:12 PM, Luke Nelson wrote:
> The current arm BPF JIT does not correctly compile RSH or ARSH when the
> immediate shift amount is 0. This causes the "rsh64 by 0 imm" and "arsh64
> by 0 imm" BPF selftests to hang the kernel by reaching an instruction
> the verifier determines to be unreachable.
> 
> The root cause is in how immediate right shifts are encoded on arm.
> For LSR and ASR (logical and arithmetic right shift), a bit-pattern
> of 00000 in the immediate encodes a shift amount of 32. When the BPF
> immediate is 0, the generated code shifts by 32 instead of the expected
> behavior (a no-op).
> 
> This patch fixes the bugs by adding an additional check if the BPF
> immediate is 0. After the change, the above mentioned BPF selftests pass.
> 
> Fixes: 39c13c204bb11 ("arm: eBPF JIT compiler")
> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Yikes, thanks for fixing, applied. Looks like noone was running BPF kselftests
on arm32 for quite a while. :(
