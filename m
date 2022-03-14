Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A44D4D8F6E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244723AbiCNWVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiCNWVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:21:19 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C497D12ABB;
        Mon, 14 Mar 2022 15:20:08 -0700 (PDT)
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nTt2s-0008cR-9Z; Mon, 14 Mar 2022 23:20:06 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nTt2s-000UEP-23; Mon, 14 Mar 2022 23:20:06 +0100
Subject: Re: [PATCH] net: xdp: allow user space to request a smaller packet
 headroom requirement
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        "Jesper D. Brouer" <netdev@brouer.com>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
Cc:     brouer@redhat.com, John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220314102210.92329-1-nbd@nbd.name>
 <86137924-b3cb-3d96-51b1-19923252f092@brouer.com>
 <4ff44a95-2818-32d9-c907-20e84f24a3e6@nbd.name> <87pmmouqmt.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a61aef96-5364-e5a5-3827-e84da0c11218@iogearbox.net>
Date:   Mon, 14 Mar 2022 23:20:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87pmmouqmt.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26481/Mon Mar 14 09:39:13 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/22 11:16 PM, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
>> On 14.03.22 21:39, Jesper D. Brouer wrote:
>>> (Cc. BPF list and other XDP maintainers)
>>> On 14/03/2022 11.22, Felix Fietkau wrote:
>>>> Most ethernet drivers allocate a packet headroom of NET_SKB_PAD. Since it is
>>>> rounded up to L1 cache size, it ends up being at least 64 bytes on the most
>>>> common platforms.
>>>> On most ethernet drivers, having a guaranteed headroom of 256 bytes for XDP
>>>> adds an extra forced pskb_expand_head call when enabling SKB XDP, which can
>>>> be quite expensive.
>>>> Many XDP programs need only very little headroom, so it can be beneficial
>>>> to have a way to opt-out of the 256 bytes headroom requirement.
>>>
>>> IMHO 64 bytes is too small.
>>> We are using this area for struct xdp_frame and also for metadata
>>> (XDP-hints).  This will limit us from growing this structures for
>>> the sake of generic-XDP.
>>>
>>> I'm fine with reducting this to 192 bytes, as most Intel drivers
>>> have this headroom, and have defacto established that this is
>>> a valid XDP headroom, even for native-XDP.
>>>
>>> We could go a small as two cachelines 128 bytes, as if xdp_frame
>>> and metadata grows above a cache-line (64 bytes) each, then we have
>>> done something wrong (performance wise).
>> Here's some background on why I chose 64 bytes: I'm currently
>> implementing a userspace + xdp program to act as generic fastpath to
>> speed network bridging.
> 
> Any reason this can't run in the TC ingress hook instead? Generic XDP is
> a bit of an odd duck, and I'm not a huge fan of special-casing it this
> way...

+1, would have been fine with generic reduction to just down to 192 bytes
(though not less than that), but 64 is a bit too little. Also curious on
why not tc ingress instead?

Thanks,
Daniel
