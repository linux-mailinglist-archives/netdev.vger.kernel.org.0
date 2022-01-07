Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9583D48789B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbiAGN4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:56:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:59650 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiAGN4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 08:56:14 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5pj2-0004Aj-6m; Fri, 07 Jan 2022 14:56:12 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5pj1-000D4B-SS; Fri, 07 Jan 2022 14:56:11 +0100
Subject: Re: [PATCH net-next] veth: Do not record rx queue hint in veth_xmit
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     netdev@vger.kernel.org, laurent.bernaille@datadoghq.com,
        maciej.fijalkowski@intel.com, eric.dumazet@gmail.com,
        pabeni@redhat.com, john.fastabend@gmail.com, willemb@google.com,
        davem@davemloft.net, kuba@kernel.org, magnus.karlsson@gmail.com
References: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
 <f1d8f965-d369-3438-38f8-b65fb79c9f91@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3927bf4a-0034-a985-6899-d50b7eb8a8a5@iogearbox.net>
Date:   Fri, 7 Jan 2022 14:56:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <f1d8f965-d369-3438-38f8-b65fb79c9f91@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26415/Fri Jan  7 10:26:59 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/22 1:57 PM, Toshiaki Makita wrote:
> On 2022/01/06 9:46, Daniel Borkmann wrote:
> 
> Thank you for the fix.
> 
>> (unless configured in non-default manner).
> 
> Just curious, is there any special configuration to record rx queue index on veth after your patch?

Right now skb->queue_mapping represents the tx queue number. So assuming
dev->real_num_tx_queues == dev->real_num_rx_queues for the veth creation,
then veth_xmit() picks the rx queue via rcv_priv->rq[rxq] based on tx queue
number. So, by default veth is created with dev->real_num_tx_queues ==
dev->real_num_rx_queues == 1, in which case the queue_mapping stays 0.
Checking with e.g. ...

   ip link add foo numtxqueues 64 numrxqueues 64 type veth peer numtxqueues 64 numrxqueues 64

... then stack inside the netns on the veth dev picks a TX queue via
netdev_core_pick_tx(). Due to the skb_record_rx_queue() / skb_get_rx_queue()
it is off by one in generic XDP [in hostns] at bpf_prog_run_generic_xdp() for
the case where veth has more than single queue (Single queue case netif_get_rxqueue()
will see that skb_rx_queue_recorded() is false and just pick the first queue
so at least there it's correct).

Not sure if there is a good way to detect inside bpf_prog_run_generic_xdp()
that skb was looped to host from netns and then fix up the offset .. other
option could potentially be an extra device parameter and when enabled only
then do the skb_record_rx_queue() so it's an explicit opt-in where admin needs
to be aware of potential implications.

My worry is that if the skb ends up being pushed out the phys dev, then 1)
if veth was provisioned with >1 TX queues the admin must also take into
account the TX queues e.g. on phys devices like ena, so that we're not under-
utilizing it (or have something like BPF clear the queue mapping before
it's forwarded). And if we do skb_record_rx_queue() and, say, TX queue numbers
of veth and phys dev are provisioned to be the same, then we jump +1 on the
phys dev with a skb_record_rx_queue() which may be unintentional. Hence maybe
explicit opt-in could be better option?

Thanks,
Daniel
