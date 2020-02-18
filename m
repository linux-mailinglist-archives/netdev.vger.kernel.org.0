Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5F61628E4
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgBROx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:53:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:50180 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgBROx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 09:53:28 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j44FP-0002Mk-PX; Tue, 18 Feb 2020 15:53:15 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j44FP-0009S1-Dl; Tue, 18 Feb 2020 15:53:15 +0100
Subject: Re: [PATCH] bpf: queue_stack_maps: Replace zero-length array with
 flexible-array member
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200213152416.GA1873@embeddedor>
 <CAEf4Bzae=Afp_4FGgeFy+=kk64nm1vhRso2zF3j7Qdst66RFZw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8c212e06-dc1f-3a47-ba3e-8f408ba7a972@iogearbox.net>
Date:   Tue, 18 Feb 2020 15:53:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzae=Afp_4FGgeFy+=kk64nm1vhRso2zF3j7Qdst66RFZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25727/Tue Feb 18 15:05:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/20 6:47 PM, Andrii Nakryiko wrote:
> On Thu, Feb 13, 2020 at 7:22 AM Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>>
>> The current codebase makes use of the zero-length array language
>> extension to the C90 standard, but the preferred mechanism to declare
>> variable-length types such as these ones is a flexible array member[1][2],
>> introduced in C99:
>>
>> struct foo {
>>          int stuff;
>>          struct boo array[];
>> };
>>
>> By making use of the mechanism above, we will get a compiler warning
>> in case the flexible array does not occur last in the structure, which
>> will help us prevent some kind of undefined behavior bugs from being
>> inadvertently introduced[3] to the codebase from now on.
>>
>> Also, notice that, dynamic memory allocations won't be affected by
>> this change:
>>
>> "Flexible array members have incomplete type, and so the sizeof operator
>> may not be applied. As a quirk of the original implementation of
>> zero-length arrays, sizeof evaluates to zero."[1]
>>
>> This issue was found with the help of Coccinelle.
>>
>> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
>> [2] https://github.com/KSPP/linux/issues/21
>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Sure, why not, though I don't think that's the only one (e.g.,
> bpf_storage_buffer's data is zero-length as well).
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>

+1, Gustavo, there are several such instances in the whole BPF subsystem. Please combine
them all into a single patch, including https://patchwork.ozlabs.org/patch/1239563/, and
resubmit.

Thanks,
Daniel
