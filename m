Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4FD2AD17B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 09:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgKJIlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 03:41:03 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7512 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJIlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 03:41:02 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVhCP6G4dzhfWW;
        Tue, 10 Nov 2020 16:40:49 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 10 Nov 2020 16:40:53 +0800
Subject: Re: [PATCH v2 bpf] tools: bpftool: Add missing close before bpftool
 net attach exit
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <quentin@isovalent.com>, <mrostecki@opensuse.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andrii@kernel.org>,
        <kpsingh@chromium.org>, <toke@redhat.com>,
        <danieltimlee@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201110014637.6055-1-wanghai38@huawei.com>
 <5faa18319b71_3e187208f@john-XPS-13-9370.notmuch>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <52cbaf9b-0680-6a4d-8d42-cd5f6d7f5714@huawei.com>
Date:   Tue, 10 Nov 2020 16:40:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5faa18319b71_3e187208f@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/11/10 12:33, John Fastabend 写道:
> Wang Hai wrote:
>> progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
>> it should be closed.
>>
>> Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>> v1->v2: use cleanup tag instead of repeated closes
>>   tools/bpf/bpftool/net.c | 14 ++++++++------
>>   1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
>> index 910e7bac6e9e..1ac7228167e6 100644
>> --- a/tools/bpf/bpftool/net.c
>> +++ b/tools/bpf/bpftool/net.c
>> @@ -578,8 +578,8 @@ static int do_attach(int argc, char **argv)
>>   
>>   	ifindex = net_parse_dev(&argc, &argv);
>>   	if (ifindex < 1) {
>> -		close(progfd);
>> -		return -EINVAL;
>> +		err = -EINVAL;
>> +		goto cleanup;
>>   	}
>>   
>>   	if (argc) {
>> @@ -587,8 +587,8 @@ static int do_attach(int argc, char **argv)
>>   			overwrite = true;
>>   		} else {
>>   			p_err("expected 'overwrite', got: '%s'?", *argv);
>> -			close(progfd);
>> -			return -EINVAL;
>> +			err = -EINVAL;
>> +			goto cleanup;
>>   		}
>>   	}
>>   
>> @@ -600,13 +600,15 @@ static int do_attach(int argc, char **argv)
> I think now that return value depends on this err it should be 'if (err)'
> otherwise we risk retunring non-zero error code from do_attach which
> will cause programs to fail.
I agree with you. Thanks.
>>   	if (err < 0) {
>          ^^^^^^^^^^^^
>          if (err) {
>
>>   		p_err("interface %s attach failed: %s",
>>   		      attach_type_strings[attach_type], strerror(-err));
>> -		return err;
>> +		goto cleanup;
>>   	}
>>   
>>   	if (json_output)
>>   		jsonw_null(json_wtr);
>>   
>> -	return 0;
>
> Alternatively we could add an 'err = 0' here, but above should never
> return a value >0 as far as I can see.
It's true that 'err > 0' doesn't exist currently , but adding 'err = 0' 
would make the code clearer. Thanks for your advice.
>> +cleanup:
>> +	close(progfd);
>> +	return err;
>>   }
>>   
>>   static int do_detach(int argc, char **argv)
>> -- 
>> 2.17.1
>>
Can it be fixed like this?

--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -578,8 +578,8 @@ static int do_attach(int argc, char **argv)

         ifindex = net_parse_dev(&argc, &argv);
         if (ifindex < 1) {
-               close(progfd);
-               return -EINVAL;
+               err = -EINVAL;
+               goto cleanup;
         }

         if (argc) {
@@ -587,8 +587,8 @@ static int do_attach(int argc, char **argv)
                         overwrite = true;
                 } else {
                         p_err("expected 'overwrite', got: '%s'?", *argv);
-                       close(progfd);
-                       return -EINVAL;
+                       err = -EINVAL;
+                       goto cleanup;
                 }
         }

@@ -597,16 +597,19 @@ static int do_attach(int argc, char **argv)
                 err = do_attach_detach_xdp(progfd, attach_type, ifindex,
                                            overwrite);

-       if (err < 0) {
+       if (err) {
                 p_err("interface %s attach failed: %s",
                       attach_type_strings[attach_type], strerror(-err));
-               return err;
+               goto cleanup;
         }

         if (json_output)
                 jsonw_null(json_wtr);

-       return 0;
+       ret = 0;
+cleanup:
+       close(progfd);
+       return err;
  }

>
> .
>
