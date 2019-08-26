Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9933D9D3ED
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731425AbfHZQZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:25:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:44074 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbfHZQZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:25:13 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2Hnr-000404-2Z; Mon, 26 Aug 2019 18:25:11 +0200
Received: from [178.197.249.36] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2Hnq-000Tm2-QS; Mon, 26 Aug 2019 18:25:10 +0200
Subject: Re: [PATCH bpf] nfp: bpf: fix latency bug when updating stack index
 register
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Song Liu <liu.song.a23@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
References: <20190824020028.6242-1-jakub.kicinski@netronome.com>
 <CAPhsuW7_dSEPJOdKApQFU-aVmEXgOwmqLS7S1FC4JtnzjR6OiQ@mail.gmail.com>
 <CAJpBn1z736w5_uv7apwyy82vzcnc9c5Gua_9ZyUy-pSEwnQewA@mail.gmail.com>
 <CAADnVQ++TEUK=Cb3sCyunFyYFcpXu=NK71P4-1rEWEGCGewU7A@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1417962c-e63d-6c46-bf07-9284f5332583@iogearbox.net>
Date:   Mon, 26 Aug 2019 18:25:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQ++TEUK=Cb3sCyunFyYFcpXu=NK71P4-1rEWEGCGewU7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25553/Mon Aug 26 10:32:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 6:18 PM, Alexei Starovoitov wrote:
> On Mon, Aug 26, 2019 at 8:57 AM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
>> On Sun, Aug 25, 2019 at 10:37 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>> On Fri, Aug 23, 2019 at 7:04 PM Jakub Kicinski wrote:
>>>> From: Jiong Wang <jiong.wang@netronome.com>
>>>>
>>>> NFP is using Local Memory to model stack. LM_addr could be used as base of
>>>> a 16 32-bit word region of Local Memory. Then, if the stack offset is
>>>> beyond the current region, the local index needs to be updated. The update
>>>> needs at least three cycles to take effect, therefore the sequence normally
>>>> looks like:
>>>>
>>>>    local_csr_wr[ActLMAddr3, gprB_5]
>>>>    nop
>>>>    nop
>>>>    nop
>>>>
>>>> If the local index switch happens on a narrow loads, then the instruction
>>>> preparing value to zero high 32-bit of the destination register could be
>>>> counted as one cycle, the sequence then could be something like:
>>>>
>>>>    local_csr_wr[ActLMAddr3, gprB_5]
>>>>    nop
>>>>    nop
>>>>    immed[gprB_5, 0]
>>>>
>>>> However, we have zero extension optimization that zeroing high 32-bit could
>>>> be eliminated, therefore above IMMED insn won't be available for which case
>>>> the first sequence needs to be generated.
>>>>
>>>> Fixes: 0b4de1ff19bf ("nfp: bpf: eliminate zero extension code-gen")
>>>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>>>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>> I haven't looked into the code yet. But ^^^ should be
>>>
>>> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>>
>>> right?
>>
>> I prefer Review on code I review, ack on code I ack, and sign-off on
>> code I co-author.
> 
> I believe if you're sending somebody else patch you have to add your SOB
> in addition to their 'Author:' and their SOB fields.

+1, for co-authoring there's a 'Co-authored-by:' tag which seems to be frequently
used these days.
