Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2860228ED5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 03:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388580AbfEXBfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 21:35:23 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:49618 "EHLO
        tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388378AbfEXBfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 21:35:23 -0400
Received: from vc1.ecl.ntt.co.jp (vc1.ecl.ntt.co.jp [129.60.86.153])
        by tama50.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id x4O1YXBI028947;
        Fri, 24 May 2019 10:34:33 +0900
Received: from vc1.ecl.ntt.co.jp (localhost [127.0.0.1])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id D29F7EA7ABE;
        Fri, 24 May 2019 10:34:33 +0900 (JST)
Received: from jcms-pop21.ecl.ntt.co.jp (jcms-pop21.ecl.ntt.co.jp [129.60.87.134])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id C7894EA79E3;
        Fri, 24 May 2019 10:34:33 +0900 (JST)
Received: from [IPv6:::1] (eb8460w-makita.sic.ecl.ntt.co.jp [129.60.241.47])
        by jcms-pop21.ecl.ntt.co.jp (Postfix) with ESMTPSA id BAB76400870;
        Fri, 24 May 2019 10:34:33 +0900 (JST)
Subject: Re: [PATCH bpf-next 2/3] xdp: Add tracepoint for bulk XDP_TX
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-3-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <20190523151237.190fe76e@carbon>
From:   Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Message-ID: <9ac8402e-fd27-519c-0c1c-d1b306b3441b@lab.ntt.co.jp>
Date:   Fri, 24 May 2019 10:33:47 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190523151237.190fe76e@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CC-Mail-RelayStamp: 1
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/05/23 22:12, Jesper Dangaard Brouer wrote:
> On Thu, 23 May 2019 19:56:47 +0900
> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> wrote:
> 
>> This is introduced for admins to check what is happening on XDP_TX when
>> bulk XDP_TX is in use.
>>
>> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
>> ---
>>  include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
>>  kernel/bpf/core.c          |  1 +
>>  2 files changed, 26 insertions(+)
>>
>> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
>> index e95cb86..e06ea65 100644
>> --- a/include/trace/events/xdp.h
>> +++ b/include/trace/events/xdp.h
>> @@ -50,6 +50,31 @@
>>  		  __entry->ifindex)
>>  );
>>  
>> +TRACE_EVENT(xdp_bulk_tx,
>> +
> 
> You are using this tracepoint like/instead of trace_xdp_devmap_xmit if
> I understand correctly?  Or maybe the trace_xdp_redirect tracepoint.

Yes, I have trace_xdp_devmap_xmit in mind, which is for XDP_REDIRECT.

> The point is that is will be good if the tracepoints can share the
> TP_STRUCT layout beginning, as it allows for attaching and reusing eBPF
> code that is only interested in the top part of the struct.

It's good, but this tracepoint does not have map concept so differs from
xdp_devmap_xmit.

> I would also want to see some identifier, that trace programs can use
> to group and corrolate these events, you do have ifindex, but most
> other XDP tracepoints also have "prog_id".

I have considered that too. The problem is that we cannot pass a
reliable prog_id since bulk xmit happens after RCU critical section of
XDP_TX.
xdp_devmap_xmit does not have prog_id and I guess there is a similar
reason for it?

-- 
Toshiaki Makita

