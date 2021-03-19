Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1932341659
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 08:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbhCSHVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 03:21:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:51694 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbhCSHV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 03:21:26 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lN9Rc-0001jL-MO; Fri, 19 Mar 2021 08:21:16 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lN9Rc-000X3O-F3; Fri, 19 Mar 2021 08:21:16 +0100
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Piotr Krysiuk <piotras@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20210319111652.474c0939@canb.auug.org.au>
 <CAFzhf4pCdJStzBcveahKYQFHJCKenuT+VZAP+8PWSEQcooKLgQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4f90ff09-966c-4d86-a3bc-9b52107b6d8a@iogearbox.net>
Date:   Fri, 19 Mar 2021 08:21:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAFzhf4pCdJStzBcveahKYQFHJCKenuT+VZAP+8PWSEQcooKLgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26112/Thu Mar 18 12:08:11 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 3:11 AM, Piotr Krysiuk wrote:
> Hi Daniel,
> 
> On Fri, Mar 19, 2021 at 12:16 AM Stephen Rothwell <sfr@canb.auug.org.au>
> wrote:
> 
>> diff --cc kernel/bpf/verifier.c
>> index 44e4ec1640f1,f9096b049cd6..000000000000
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@@ -5876,10 -6056,22 +6060,23 @@@ static int retrieve_ptr_limit(const str
>>                  if (mask_to_left)
>>                          *ptr_limit = MAX_BPF_STACK + off;
>>                  else
>>   -                      *ptr_limit = -off;
>>   -              return 0;
>>   +                      *ptr_limit = -off - 1;
>>   +              return *ptr_limit >= max ? -ERANGE : 0;
>> +       case PTR_TO_MAP_KEY:
>> +               /* Currently, this code is not exercised as the only use
>> +                * is bpf_for_each_map_elem() helper which requires
>> +                * bpf_capble. The code has been tested manually for
>> +                * future use.
>> +                */
>> +               if (mask_to_left) {
>> +                       *ptr_limit = ptr_reg->umax_value + ptr_reg->off;
>> +               } else {
>> +                       off = ptr_reg->smin_value + ptr_reg->off;
>> +                       *ptr_limit = ptr_reg->map_ptr->key_size - off;
>> +               }
>> +               return 0;
>>
> 
> PTR_TO_MAP_VALUE logic above looks like copy-paste of old PTR_TO_MAP_VALUE
> code from before "bpf: Fix off-by-one for area size in creating mask to
> left" and is apparently affected by the same off-by-one, except this time
> on "key_size" area and not "value_size".
> 
> This needs to be fixed in the same way as we did with PTR_TO_MAP_VALUE.
> What is the best way to proceed?

Hm, not sure why PTR_TO_MAP_KEY was added by 69c087ba6225 in the first place, I
presume noone expects this to be used from unprivileged as the comment says.
Resolution should be to remove the PTR_TO_MAP_KEY case entirely from that switch
until we have an actual user.

Thanks,
Daniel
