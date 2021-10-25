Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1501143A7F0
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhJYW5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:57:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:49534 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbhJYW5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 18:57:09 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mf8rY-0000FB-RX; Tue, 26 Oct 2021 00:54:40 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mf8rY-0002oR-Gs; Tue, 26 Oct 2021 00:54:40 +0200
Subject: Re: [PATCH] powerpc/bpf: fix write protecting JIT code
To:     "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, ast@kernel.org,
        christophe.leroy@csgroup.eu, Hari Bathini <hbathini@linux.ibm.com>,
        jniethe5@gmail.com, mpe@ellerman.id.au
Cc:     andrii@kernel.org, bpf@vger.kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, paulus@samba.org, songliubraving@fb.com,
        stable@vger.kernel.org, yhs@fb.com
References: <20211025055649.114728-1-hbathini@linux.ibm.com>
 <1635142354.46h6w5c2rx.naveen@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c8d7390b-c07c-75cd-e9e9-4b8f0b786cc6@iogearbox.net>
Date:   Tue, 26 Oct 2021 00:54:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1635142354.46h6w5c2rx.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26333/Mon Oct 25 10:29:40 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 8:15 AM, Naveen N. Rao wrote:
> Hari Bathini wrote:
>> Running program with bpf-to-bpf function calls results in data access
>> exception (0x300) with the below call trace:
>>
>>     [c000000000113f28] bpf_int_jit_compile+0x238/0x750 (unreliable)
>>     [c00000000037d2f8] bpf_check+0x2008/0x2710
>>     [c000000000360050] bpf_prog_load+0xb00/0x13a0
>>     [c000000000361d94] __sys_bpf+0x6f4/0x27c0
>>     [c000000000363f0c] sys_bpf+0x2c/0x40
>>     [c000000000032434] system_call_exception+0x164/0x330
>>     [c00000000000c1e8] system_call_vectored_common+0xe8/0x278
>>
>> as bpf_int_jit_compile() tries writing to write protected JIT code
>> location during the extra pass.
>>
>> Fix it by holding off write protection of JIT code until the extra
>> pass, where branch target addresses fixup happens.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 62e3d4210ac9 ("powerpc/bpf: Write protect JIT code")
>> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
>> ---
>>  arch/powerpc/net/bpf_jit_comp.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Thanks for the fix!
> 
> Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

LGTM, I presume this fix will be routed via Michael.

BPF selftests have plenty of BPF-to-BPF calls in there, too bad this was
caught so late. :/
