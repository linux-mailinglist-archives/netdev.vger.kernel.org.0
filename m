Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065EC56345D
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiGAN3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiGAN3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:29:32 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232B712AEA;
        Fri,  1 Jul 2022 06:29:32 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o7Gi2-0008yQ-ME; Fri, 01 Jul 2022 15:29:22 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o7Gi2-00059I-78; Fri, 01 Jul 2022 15:29:22 +0200
Subject: Re: [PATCH bpf] xdp: Fix spurious packet loss in generic XDP TX path
To:     Eric Dumazet <edumazet@google.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, song@kernel.org,
        martin.lau@linux.dev, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, haoluo@google.com,
        jolsa@kernel.org, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
 <CANn89i+FZ7t6F6tA8iFMjAzGmKkK=A+kdFpsm6ioygg5DnwT8g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <73774e57-64c3-e32d-d762-1fcf64d5628c@iogearbox.net>
Date:   Fri, 1 Jul 2022 15:29:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANn89i+FZ7t6F6tA8iFMjAzGmKkK=A+kdFpsm6ioygg5DnwT8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26590/Fri Jul  1 09:25:21 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/22 11:57 AM, Eric Dumazet wrote:
> On Fri, Jul 1, 2022 at 11:43 AM Johan Almbladh
> <johan.almbladh@anyfinetworks.com> wrote:
>>
>> The byte queue limits (BQL) mechanism is intended to move queuing from
>> the driver to the network stack in order to reduce latency caused by
>> excessive queuing in hardware. However, when transmitting or redirecting
>> a packet with XDP, the qdisc layer is bypassed and there are no
>> additional queues. Since netif_xmit_stopped() also takes BQL limits into
>> account, but without having any alternative queuing, packets are
>> silently dropped.
>>
>> This patch modifies the drop condition to only consider cases when the
>> driver itself cannot accept any more packets. This is analogous to the
>> condition in __dev_direct_xmit(). Dropped packets are also counted on
>> the device.
> 
> This means XDP packets are able to starve other packets going through a qdisc,
> DDOS attacks will be more effective.
> 
> in-driver-XDP use dedicated TX queues, so they do not have this
> starvation issue.
> 
> This should be mentioned somewhere I guess.

+1, Johan, could you add this as comment and into commit description in a v2
of your fix? Definitely should be clarified that it's limited to generic XDP.

Thanks,
Daniel
