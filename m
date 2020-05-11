Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9FD1CDEEF
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgEKP0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:26:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:55710 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgEKP0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:26:37 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYAK8-0004PL-AQ; Mon, 11 May 2020 17:26:32 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYAK7-0008Vc-UJ; Mon, 11 May 2020 17:26:31 +0200
Subject: Re: [PATCH] libbpf: Replace zero-length array with flexible-array
To:     Yonghong Song <yhs@fb.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200507185057.GA13981@embeddedor>
 <0ba4c222-b1e6-c003-56f1-6f43405066f0@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <13960d59-3786-a58e-0be0-f9d91f8ee919@iogearbox.net>
Date:   Mon, 11 May 2020 17:26:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0ba4c222-b1e6-c003-56f1-6f43405066f0@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25809/Mon May 11 14:16:55 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/20 9:16 PM, Yonghong Song wrote:
> On 5/7/20 11:50 AM, Gustavo A. R. Silva wrote:
>> The current codebase makes use of the zero-length array language
>> extension to the C90 standard, but the preferred mechanism to declare
>> variable-length types such as these ones is a flexible array member[1][2],
>> introduced in C99:
>>
>> struct foo {
>>          int stuff;
>>          struct boo array[];
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
>> sizeof(flexible-array-member) triggers a warning because flexible array
>> members have incomplete type[1]. There are some instances of code in
>> which the sizeof operator is being incorrectly/erroneously applied to
>> zero-length arrays and the result is zero. Such instances may be hiding
>> some bugs. So, this work (flexible-array member conversions) will also
>> help to get completely rid of those sorts of issues.
>>
>> This issue was found with the help of Coccinelle.
>>
>> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
>> [2] https://github.com/KSPP/linux/issues/21
>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> I think this is probably for bpf-next.
> 
> Acked-by: Yonghong Song <yhs@fb.com>

Applied, thanks!
