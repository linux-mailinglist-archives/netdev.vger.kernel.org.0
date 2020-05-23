Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0168F1DF3DA
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 03:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbgEWBdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 21:33:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:40342 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387418AbgEWBdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 21:33:51 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcJ2q-0001WP-IF; Sat, 23 May 2020 03:33:48 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcJ2q-0005Mb-9u; Sat, 23 May 2020 03:33:48 +0200
Subject: Re: [PATCH iproute2 v3 0/2] bpf: memory access fixes
To:     Jamal Hadi Salim <jhs@mojatatu.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        asmadeus@codewreck.org
References: <20200423175857.20180-1-jhs@emojatatu.com>
 <125e68f2-2868-34c1-7c13-f3fcdf844835@mojatatu.com>
 <1d1e025b-346b-d5f7-6c44-da5a64f31a2c@mojatatu.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e192690f-ad1a-14c1-8052-e1a3fc0a1b8f@iogearbox.net>
Date:   Sat, 23 May 2020 03:33:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1d1e025b-346b-d5f7-6c44-da5a64f31a2c@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25820/Fri May 22 14:21:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 3:00 PM, Jamal Hadi Salim wrote:
> ping?
> 
> Note: these are trivial bug fixes.

Looking at c0325b06382c ("bpf: replace snprintf with asprintf when dealing with long buffers"),
I wonder whether it's best to just revert and redo cleanly from scratch.. How much testing has
been performed on the original patch? We know it is causing regressions, and looking Jamal's
2nd patch we do have patterns all over the place wrt error path that go like:

   +	char *file = NULL;
   +	char buff[4096];
  	FILE *fp;
   +	int ret;

   -	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
   +	ret = asprintf(&file, "/proc/%d/fdinfo/%d", getpid(), fd);
   +	if (ret < 0) {
   +		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
   +		free(file);
   +		return ret;
   +	}

The man page on asprintf(char **strp, ...) says: "When successful, these functions return
the number of bytes printed, just like sprintf(3). If memory allocation wasn't possible,
or some other error occurs, these functions will return -1, and the contents of strp are
undefined." What is the rationale that are we passing it to free() /everywhere/ in error
path when the API spec does say it's undefined? It may happen to work but file's value
could just as well be, say, 42 ...

Thanks,
Daniel

> cheers,
> jamal
> 
> On 2020-04-28 12:15 p.m., Jamal Hadi Salim wrote:
>> Stephen,
>> What happened to this?
>>
>> cheers,
>> jamal
>>
>> On 2020-04-23 1:58 p.m., Jamal Hadi Salim wrote:
>>> From: Jamal Hadi Salim <jhs@mojatatu.com>
>>>
>>> Changes from V2:
>>>   1) Dont initialize tmp on stack (Stephen)
>>>   2) Dont look at the return code of snprintf (Dominique)
>>>   3) Set errno to EINVAL instead of returning -EINVAL for consistency (Dominique)
>>>
>>> Changes from V1:
>>>   1) use snprintf instead of sprintf and fix corresponding error message.
>>>   Caught-by: Dominique Martinet <asmadeus@codewreck.org>
>>>   2) Fix memory leak and extraneous free() in error path
>>>
>>> Jamal Hadi Salim (2):
>>>    bpf: Fix segfault when custom pinning is used
>>>    bpf: Fix mem leak and extraneous free() in error path
>>>
>>>   lib/bpf.c | 17 +++++++----------
>>>   1 file changed, 7 insertions(+), 10 deletions(-)
>>>
>>
> 

