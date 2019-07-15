Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95FDD69ED9
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732957AbfGOWQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:16:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:33478 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbfGOWQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:16:40 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9Gw-0000qf-3w; Tue, 16 Jul 2019 00:16:38 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9Gv-0000rq-Nu; Tue, 16 Jul 2019 00:16:37 +0200
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: fix "alu with different
 scalars 1" on s390
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>
References: <20190704085224.65223-1-iii@linux.ibm.com>
 <CAADnVQ+H9bOW+EY6=AKt7mqgdEgaPhc1Wk_o=Ez43CracLCaiA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <43594293-710b-b217-cd04-a8051e3742f7@iogearbox.net>
Date:   Tue, 16 Jul 2019 00:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+H9bOW+EY6=AKt7mqgdEgaPhc1Wk_o=Ez43CracLCaiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 12:13 AM, Alexei Starovoitov wrote:
> On Thu, Jul 4, 2019 at 1:53 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>>
>> BPF_LDX_MEM is used to load the least significant byte of the retrieved
>> test_val.index, however, on big-endian machines it ends up retrieving
>> the most significant byte.
>>
>> Use the correct least significant byte offset on big-endian machines.
>>
>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>> ---
>>
>> v1->v2:
>> - use __BYTE_ORDER instead of __BYTE_ORDER__.
>>
>>  tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
>> index c3de1a2c9dc5..e5940c4e8b8f 100644
>> --- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
>> +++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
>> @@ -183,7 +183,11 @@
>>         BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>>         BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
>>         BPF_EXIT_INSN(),
>> +#if __BYTE_ORDER == __LITTLE_ENDIAN
>>         BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
>> +#else
>> +       BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, sizeof(int) - 1),
>> +#endif
> 
> I think tests should be arch and endian independent where possible.
> In this case test_val.index is 4 byte and 4 byte load should work just as well.

Yes, agree, this should be fixed with BPF_W as load.

Thanks,
Daniel
