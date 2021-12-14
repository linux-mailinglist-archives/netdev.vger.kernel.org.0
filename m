Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39ABB47453B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhLNOf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:35:57 -0500
Received: from www62.your-server.de ([213.133.104.62]:57542 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbhLNOf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:35:56 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mx8uE-000BLw-Sj; Tue, 14 Dec 2021 15:35:50 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mx8uE-000Eo7-LN; Tue, 14 Dec 2021 15:35:50 +0100
Subject: Re: [PATCH bpf-next] xsk: add test for tx_writeable to batched path
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
References: <20211214102647.7734-1-magnus.karlsson@gmail.com>
 <Ybip7mXZuCXYTlwn@boxer>
 <CAJ8uoz1ioNtZyCRG2b3OH4pGh8b2CwHeXKC=M+4Xtf0OouxORw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <029c16c2-f344-7089-a941-079d0a293189@iogearbox.net>
Date:   Tue, 14 Dec 2021 15:35:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz1ioNtZyCRG2b3OH4pGh8b2CwHeXKC=M+4Xtf0OouxORw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26387/Tue Dec 14 10:33:30 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 3:29 PM, Magnus Karlsson wrote:
> On Tue, Dec 14, 2021 at 3:28 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
>> On Tue, Dec 14, 2021 at 11:26:47AM +0100, Magnus Karlsson wrote:
>>> From: Magnus Karlsson <magnus.karlsson@intel.com>
>>>
>>> Add a test for the tx_writeable condition to the batched Tx processing
>>> path. This test is in the skb and non-batched code paths but not in the
>>> batched code path. So add it there. This test makes sure that a
>>> process is not woken up until there are a sufficiently large number of
>>> free entries in the Tx ring. Currently, any driver using the batched
>>> interface will be woken up even if there is only one free entry,
>>> impacting performance negatively.
>>
>> I gave this patch a shot on ice driver with the Tx batching patch that i'm
>> about to send which is using the xsk_tx_peek_release_desc_batch(). I ran
>> the 2 core setup with no busy poll and it turned out that this change has
>> a negative impact on performance - it degrades by 5%.
>>
>> After a short chat with Magnus he said it's due to the touch to the global
>> state of a ring that xsk_tx_writeable() is doing.
>>
>> So maintainers, please do not apply this yet, we'll come up with a
>> solution.
>>
>> Also, should this be sent to bpf tree (not bpf-next) ?
> 
> It is just a performance fix, so I would say bpf-next.

Ok, np. I'm tossing it from patchwork in that case now, and wait for a v2.
Given the fix is a two-liner, I'll leave it up to you which tree you think
it would be best.

Thanks,
Daniel
