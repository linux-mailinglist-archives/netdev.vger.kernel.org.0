Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943E31A8B4A
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505131AbgDNTnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:43:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:51048 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731836AbgDNTnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:43:40 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORSs-0002KH-Mm; Tue, 14 Apr 2020 21:43:22 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORSs-00044G-5p; Tue, 14 Apr 2020 21:43:22 +0200
Subject: Re: [PATCH bpf] arm, bpf: Fix offset overflow for BPF_MEM BPF_DW
To:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20200409221752.28448-1-luke.r.nels@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0eb3fe81-973b-1a96-df00-a68c74b84eba@iogearbox.net>
Date:   Tue, 14 Apr 2020 21:43:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200409221752.28448-1-luke.r.nels@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25782/Tue Apr 14 13:57:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/20 12:17 AM, Luke Nelson wrote:
> This patch fixes an incorrect check in how immediate memory offsets are
> computed for BPF_DW on arm.
> 
> For BPF_LDX/ST/STX + BPF_DW, the 32-bit arm JIT breaks down an 8-byte
> access into two separate 4-byte accesses using off+0 and off+4. If off
> fits in imm12, the JIT emits a ldr/str instruction with the immediate
> and avoids the use of a temporary register. While the current check off
> <= 0xfff ensures that the first immediate off+0 doesn't overflow imm12,
> it's not sufficient for the second immediate off+4, which may cause the
> second access of BPF_DW to read/write the wrong address.
> 
> This patch fixes the problem by changing the check to
> off <= 0xfff - 4 for BPF_DW, ensuring off+4 will never overflow.
> 
> A side effect of simplifying the check is that it now allows using
> negative immediate offsets in ldr/str. This means that small negative
> offsets can also avoid the use of a temporary register.
> 
> This patch introduces no new failures in test_verifier or test_bpf.c.
> 
> Fixes: c5eae692571d6 ("ARM: net: bpf: improve 64-bit store implementation")
> Fixes: ec19e02b343db ("ARM: net: bpf: fix LDX instructions")
> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Applied, thanks!
