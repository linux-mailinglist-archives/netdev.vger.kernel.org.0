Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C55222EC1
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgGPXKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgGPXJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:09:20 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ED7C08C5EF;
        Thu, 16 Jul 2020 15:46:29 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwCdw-000733-Q9; Fri, 17 Jul 2020 00:46:20 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwCdw-000PAw-Jp; Fri, 17 Jul 2020 00:46:20 +0200
Subject: Re: [PATCH bpf-next 2/5] bpf: allow for tailcalls in BPF subprograms
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-3-maciej.fijalkowski@intel.com>
 <912b5e97-1951-5a7c-e3c1-41bc3bf4b58a@iogearbox.net>
Message-ID: <d12561c3-23c6-3f48-611f-868be990e1a2@iogearbox.net>
Date:   Fri, 17 Jul 2020 00:46:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <912b5e97-1951-5a7c-e3c1-41bc3bf4b58a@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/20 11:29 PM, Daniel Borkmann wrote:
> On 7/16/20 1:36 AM, Maciej Fijalkowski wrote:
>> Relax verifier's restriction that was meant to forbid tailcall usage
>> when subprog count was higher than 1.
>>
>> Also, do not max out the stack depth of program that utilizes tailcalls.
>>
>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> ---
>>   kernel/bpf/verifier.c | 5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 3c1efc9d08fd..6481342b31ba 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -4172,10 +4172,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>>       case BPF_FUNC_tail_call:
>>           if (map->map_type != BPF_MAP_TYPE_PROG_ARRAY)
>>               goto error;
>> -        if (env->subprog_cnt > 1) {
>> -            verbose(env, "tail_calls are not allowed in programs with bpf-to-bpf calls\n");
>> -            return -EINVAL;
>> -        }
>>           break;
>>       case BPF_FUNC_perf_event_read:
>>       case BPF_FUNC_perf_event_output:
>> @@ -10252,7 +10248,6 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>>                * the program array.
>>                */
>>               prog->cb_access = 1;
>> -            env->prog->aux->stack_depth = MAX_BPF_STACK;
>>               env->prog->aux->max_pkt_offset = MAX_PACKET_OFF;
>>               /* mark bpf_tail_call as different opcode to avoid
> 
> Also, isn't this broken when JIT is not used (as in stack oob access)?

(Similarly for non-x86 archs after this set.)
