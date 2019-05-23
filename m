Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AD627BEC
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 13:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbfEWLg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 07:36:59 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35500 "EHLO
        tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730493AbfEWLg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 07:36:59 -0400
Received: from vc1.ecl.ntt.co.jp (vc1.ecl.ntt.co.jp [129.60.86.153])
        by tama500.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id x4NBaIOS030130;
        Thu, 23 May 2019 20:36:18 +0900
Received: from vc1.ecl.ntt.co.jp (localhost [127.0.0.1])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id DAD84EA8084;
        Thu, 23 May 2019 20:36:18 +0900 (JST)
Received: from jcms-pop21.ecl.ntt.co.jp (jcms-pop21.ecl.ntt.co.jp [129.60.87.134])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id CFD0AEA8082;
        Thu, 23 May 2019 20:36:18 +0900 (JST)
Received: from [IPv6:::1] (eb8460w-makita.sic.ecl.ntt.co.jp [129.60.241.47])
        by jcms-pop21.ecl.ntt.co.jp (Postfix) with ESMTPSA id C28214007AA;
        Thu, 23 May 2019 20:36:18 +0900 (JST)
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <87zhnd1kg9.fsf@toke.dk>
From:   Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Message-ID: <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
Date:   Thu, 23 May 2019 20:35:50 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87zhnd1kg9.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CC-Mail-RelayStamp: 1
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/05/23 20:25, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
> 
>> This improves XDP_TX performance by about 8%.
>>
>> Here are single core XDP_TX test results. CPU consumptions are taken
>> from "perf report --no-child".
>>
>> - Before:
>>
>>   7.26 Mpps
>>
>>   _raw_spin_lock  7.83%
>>   veth_xdp_xmit  12.23%
>>
>> - After:
>>
>>   7.84 Mpps
>>
>>   _raw_spin_lock  1.17%
>>   veth_xdp_xmit   6.45%
>>
>> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
>> ---
>>  drivers/net/veth.c | 26 +++++++++++++++++++++++++-
>>  1 file changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>> index 52110e5..4edc75f 100644
>> --- a/drivers/net/veth.c
>> +++ b/drivers/net/veth.c
>> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>  	return ret;
>>  }
>>  
>> +static void veth_xdp_flush_bq(struct net_device *dev)
>> +{
>> +	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
>> +	int sent, i, err = 0;
>> +
>> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);
> 
> Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
> you're introducing an additional per-cpu bulk queue, only to avoid lock
> contention around the existing pointer ring. But the pointer ring is
> per-rq, so if you have lock contention, this means you must have
> multiple CPUs servicing the same rq, no?

Yes, it's possible. Not recommended though.

> So why not just fix that
> instead?

The queues are shared with packets from stack sent from peer. That's
because I needed the lock. I have tried to separate the queues, one for
redirect and one for stack, but receiver side got too complicated and it
ended up with worse performance.

-- 
Toshiaki Makita

