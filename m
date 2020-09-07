Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F77425FC02
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 16:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgIGOZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:25:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:55104 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbgIGOWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:22:06 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFI1L-0008Bi-TZ; Mon, 07 Sep 2020 16:21:23 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFI1L-0001xa-M0; Mon, 07 Sep 2020 16:21:23 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: permit map_ptr arithmetic with opcode
 add and offset 0
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20200904194900.3031319-1-yhs@fb.com>
 <20200904194900.3031377-1-yhs@fb.com>
 <CAEf4BzboqpYa7Zq=6xcpGez+jk--NTDA0=FQi5utwcFaHwC7bA@mail.gmail.com>
 <c016695c-3d22-ac74-5e2f-9210fb5b58af@fb.com>
 <CAEf4BzaWZqLnR78B3F38bkDP62aDy81oQSAiZMXDULembVyhkA@mail.gmail.com>
 <CAADnVQJrjPynzVZTDvDh7qosBVFO8+iKEKDbC4=yK+4HVZ6Tng@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <417158cc-4b80-83df-0544-e8e6defb44b4@iogearbox.net>
Date:   Mon, 7 Sep 2020 16:21:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQJrjPynzVZTDvDh7qosBVFO8+iKEKDbC4=yK+4HVZ6Tng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25922/Sun Sep  6 15:39:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/20 2:10 AM, Alexei Starovoitov wrote:
> On Fri, Sep 4, 2020 at 5:08 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>> On Fri, Sep 4, 2020 at 4:20 PM Yonghong Song <yhs@fb.com> wrote:
[...]
>>> for scalar constant, reg->var_off.mask should be 0. so we will have
>>> reg->smin_value = reg->smax_value = (s64)reg->var_off.value.
>>>
>>> The smin_val is also used below, e.g., BPF_ADD, for a known value.
>>> That is why I am using smin_val here.
>>>
>>> Will add a comment and submit v2.
>>
>> it would be way-way more obvious (and reliable in the long run,
>> probably) if you just used (known && reg->var_off.value == 0). or just
>> tnum_equals_const(reg->var_off, 0)?
> 
> Pls dont. smin_val == 0 is a standard way to do this.
> Just check all other places in this function and everywhere else.

Also, we taint the reg earlier in that function if its known and min != max:

         if ((known && (smin_val != smax_val || umin_val != umax_val)) ||
             smin_val > smax_val || umin_val > umax_val) {
                 /* Taint dst register if offset had invalid bounds derived from
                  * e.g. dead branches.
                  */
                 __mark_reg_unknown(env, dst_reg);
                 return 0;
         }
