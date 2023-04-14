Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278756E1F66
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjDNJgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjDNJgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:36:31 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989CC5B82;
        Fri, 14 Apr 2023 02:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=LW6cOST+IVw4mFa0Tl2bUIYuEJ4a7bS+eYImfnyQXA8=; b=iBM8Wuei8FIzDoAK0k2csyvDVV
        k/8Usw0+JklwaEy68DxdSB0NdgpqvwrmWSGTpHPQTYNA4ZLpyv0WgZRwG7v2VWEGvJqi/UOYDc2B+
        7+oyw04nMzkiFgwYea9P/S4hxj9CreMinAZecQ1uEypzeCaUa8SAAdAho9ekqjcOlV6wcOsomVYj1
        g3jJZZGS0rYGjNfjKvngt4o5JkjO56eKe4+fTbEipfxtazh8RCjrlh1SnuWjcccSn7dg7acn73Opv
        2OOaphx00GoI+fEI+zjVOBvqryjWascKCi8cEtxX3jlhzdc9q294Idd5QouV39V19XAN0XbFKseY8
        XbVRu/0Q==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pnFph-000Ahm-Hr; Fri, 14 Apr 2023 11:35:07 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pnFph-000URX-1E; Fri, 14 Apr 2023 11:35:05 +0200
Subject: Re: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Yafang Shao <laoar.shao@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev
References: <20230413025350.79809-1-laoar.shao@gmail.com>
 <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net> <874jpj2682.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ee52c2e4-4199-da40-8e86-57ef4085c968@iogearbox.net>
Date:   Fri, 14 Apr 2023 11:34:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <874jpj2682.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26875/Fri Apr 14 09:23:27 2023)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/23 4:43 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>>> 2). We can't redirect ingress packet to ifb with bpf
>>> By trying to analyze if it is possible to redirect the ingress packet to
>>> ifb with a bpf program, we find that the ifb device is not supported by
>>> bpf redirect yet.
>>
>> You actually can: Just let BPF program return TC_ACT_UNSPEC for this
>> case and then add a matchall with higher prio (so it runs after bpf)
>> that contains an action with mirred egress redirect that pushes to ifb
>> dev - there is no change needed.
> 
> I wasn't aware that BPF couldn't redirect directly to an IFB; any reason
> why we shouldn't merge this patch in any case?
> 
>>> This patch tries to resolve it by supporting redirecting to ifb with bpf
>>> program.
>>>
>>> Ingress bandwidth limit is useful in some scenarios, for example, for the
>>> TCP-based service, there may be lots of clients connecting it, so it is
>>> not wise to limit the clients' egress. After limiting the server-side's
>>> ingress, it will lower the send rate of the client by lowering the TCP
>>> cwnd if the ingress bandwidth limit is reached. If we don't limit it,
>>> the clients will continue sending requests at a high rate.
>>
>> Adding artificial queueing for the inbound traffic, aren't you worried
>> about DoS'ing your node?
> 
> Just as an aside, the ingress filter -> ifb -> qdisc on the ifb
> interface does work surprisingly well, and we've been using that over in
> OpenWrt land for years[0]. It does have some overhead associated with it,
> but I wouldn't expect it to be a source of self-DoS in itself (assuming
> well-behaved TCP traffic).

Out of curiosity, wrt OpenWrt case, can you elaborate on the use case to why
choosing to do this on ingress via ifb rather than on the egress side? I
presume in this case it's regular router, so pkts would be forwarded anyway,
and in your case traversing qdisc layer / queuing twice (ingress phys dev ->
ifb, egress phys dev), right? What is the rationale that would justify such
setup aka why it cannot be solved differently?

Thanks,
Daniel

> -Toke
> 
> [0] https://openwrt.org/docs/guide-user/network/traffic-shaping/sqm
