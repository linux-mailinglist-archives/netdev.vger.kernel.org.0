Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5FF2732C6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgIUT1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:27:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:54382 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgIUT1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 15:27:51 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kKRTU-00009P-OC; Mon, 21 Sep 2020 21:27:44 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kKRTU-000RPa-G4; Mon, 21 Sep 2020 21:27:44 +0200
Subject: Re: [RFC PATCH] bpf: Fix potential call bpf_link_free() in atomic
 context
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20200917074453.20621-1-songmuchun@bytedance.com>
 <CAEf4Bzad2LDGH_qnE+Qumy=B0N9WXGrwaK5pAdhNm53Q-XzawA@mail.gmail.com>
 <CAEf4BzbbU-EmBQn_eTwNR-L1+XgwEgn9e5t8Z5ssVBmoLu-Uow@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c1d4c411-5536-0857-639e-1f66f30decfc@iogearbox.net>
Date:   Mon, 21 Sep 2020 21:27:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbbU-EmBQn_eTwNR-L1+XgwEgn9e5t8Z5ssVBmoLu-Uow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25934/Mon Sep 21 15:52:04 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/20 8:31 PM, Andrii Nakryiko wrote:
> On Mon, Sep 21, 2020 at 10:29 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Thu, Sep 17, 2020 at 12:46 AM Muchun Song <songmuchun@bytedance.com> wrote:
>>>
>>> The in_atomic macro cannot always detect atomic context. In particular,
>>> it cannot know about held spinlocks in non-preemptible kernels. Although,
>>> there is no user call bpf_link_put() with holding spinlock now. Be the
>>> safe side, we can avoid this in the feature.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>
>> This change seems unnecessary (or at least premature), as if we ever
>> get a use case that does bpf_link_put() from under held spinlock, we
>> should see a warning about that (and in that case I bet code can be
>> rewritten to not hold spinlock during bpf_link_put()). But on the
>> other hand it makes bpf_link_put() to follow the pattern of
>> bpf_map_put(), which always defers the work, so I'm ok with this. As
>> Song mentioned, this is not called from a performance-critical hot
>> path, so doesn't matter all that much.
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>

Agree, SGTM.

> btw, you probably need to resubmit this patch as a non-RFC one for it
> to be applied?..

Given first time BPF contributor & it has already several ACKs, I took it
into bpf-next, thanks!
