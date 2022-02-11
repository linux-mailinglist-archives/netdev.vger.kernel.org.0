Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04F64B2618
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350230AbiBKMo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:44:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349788AbiBKMo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:44:58 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45DBF58;
        Fri, 11 Feb 2022 04:44:57 -0800 (PST)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIVID-000AAh-C5; Fri, 11 Feb 2022 13:44:53 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIVID-000SsD-1w; Fri, 11 Feb 2022 13:44:53 +0100
Subject: Re: [PATCH 1/4] bpf: Add pin_name into struct bpf_prog_aux
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220211121145.35237-1-laoar.shao@gmail.com>
 <20220211121145.35237-2-laoar.shao@gmail.com>
 <9db9fcb9-69de-5fb5-c80a-ade5f36ea039@iogearbox.net>
Message-ID: <f0578614-a27a-53f5-0450-a4dd5775edee@iogearbox.net>
Date:   Fri, 11 Feb 2022 13:44:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9db9fcb9-69de-5fb5-c80a-ade5f36ea039@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26450/Fri Feb 11 10:24:09 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 1:43 PM, Daniel Borkmann wrote:
> On 2/11/22 1:11 PM, Yafang Shao wrote:
>> A new member pin_name is added into struct bpf_prog_aux, which will be
>> set when the prog is set and cleared when the pinned file is removed.
>>
>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>> ---
>>   include/linux/bpf.h      |  2 ++
>>   include/uapi/linux/bpf.h |  1 +
>>   kernel/bpf/inode.c       | 20 +++++++++++++++++++-
>>   3 files changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 0ceb25b..9cf8055 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -933,6 +933,8 @@ struct bpf_prog_aux {
>>           struct work_struct work;
>>           struct rcu_head    rcu;
>>       };
>> +
>> +    char pin_name[BPF_PIN_NAME_LEN];
>>   };
> 
> I'm afraid this is not possible. You are assuming a 1:1 relationship between prog
> and pin location, but it's really a 1:n (prog can be pinned in multiple locations
> and also across multiple mount instances). Also, you can create hard links of pins
> which are not handled via bpf_obj_do_pin().

(Same is also true for BPF maps wrt patch 2.)
