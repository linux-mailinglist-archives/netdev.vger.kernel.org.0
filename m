Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD7183CB0
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCLWlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:41:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:33948 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCLWlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:41:04 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCWVY-0003nk-UG; Thu, 12 Mar 2020 23:40:52 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCWVY-000LlI-HM; Thu, 12 Mar 2020 23:40:52 +0100
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
References: <cover.1583927267.git.lukas@wunner.de>
 <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
 <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
 <20200311155451.e3mtgrdvuiujgvs6@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a73dda33-57f4-95d8-ea51-ed483abd6a7a@iogearbox.net>
Date:   Thu, 12 Mar 2020 23:40:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200311155451.e3mtgrdvuiujgvs6@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25749/Thu Mar 12 14:09:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/20 4:54 PM, Lukas Wunner wrote:
> On Wed, Mar 11, 2020 at 03:05:16PM +0100, Daniel Borkmann wrote:
>> no need to make the fast-path slower for exotic protocols
>> which can be solved through other means.
> 
> As said the fast-path gets faster, not slower.
> 
>>> * Without this commit:
>>>     Result: OK: 34240933(c34238375+d2558) usec, 100000000 (60byte,0frags)
>>>     2920481pps 1401Mb/sec (1401830880bps) errors: 0
>>>
>>> * With this commit:
>>>     Result: OK: 33997299(c33994193+d3106) usec, 100000000 (60byte,0frags)
>>>     2941410pps 1411Mb/sec (1411876800bps) errors: 0
>>
>> So you are suggesting that we've just optimized the stack by adding more
>> hooks to it ...?
> 
> Since I've provided numbers to disprove your allegation, I think the
> onus is now on you to prove that your allegation holds any water.
> Please reproduce the measurements and let's go from there.
> 
> This isn't much work, I've made it really easy by providing all the
> steps necessary in the commit message.

So in terms of micro-benchmarking with pktgen, if I understand you correctly,
you are basically measuring loopback device by pushing packets through the
__dev_queue_xmit() -> loopback_xmit() -> netif_rx() till the stack drops them
in IP layer on ingress side? I wonder how your perf profile looks like ...
Setting a drop point in tc layer and then measuring the effect before/after
this change with CONFIG_NETFILTER_EGRESS enabled, I'm getting a stable degration
from ~4.123Mpps to ~4.082Mpps with pktgen, definitely not seeing a speedup.

# ip link add dev foo type dummy
# ip link set dev foo up
# tc qdisc add dev foo clsact
# tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'
# modprobe pktgen
# echo "add_device foo" > /proc/net/pktgen/kpktgend_3
# samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i 'foo' -n 400000000 -m '11:11:11:11:11:11' -d '1.1.1.1'

Also to let pktgen count the skb:

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index acc849df60b5..8920da7a7a67 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3372,11 +3372,11 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
                 ret = dev_queue_xmit(pkt_dev->skb);
                 switch (ret) {
                 case NET_XMIT_SUCCESS:
+               case NET_XMIT_DROP:
                         pkt_dev->sofar++;
                         pkt_dev->seq_num++;
                         pkt_dev->tx_bytes += pkt_dev->last_pkt_size;
                         break;
-               case NET_XMIT_DROP:
                 case NET_XMIT_CN:
                 /* These are all valid return codes for a qdisc but
                  * indicate packets are being dropped or will likely

(In any case, this whole discussion is moot for out of tree code.)

Thanks,
Daniel
