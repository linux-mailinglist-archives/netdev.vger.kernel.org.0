Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DCE63FF92
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiLBEui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiLBEuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:50:37 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D817CC86B7;
        Thu,  1 Dec 2022 20:50:35 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VWBVp5d_1669956631;
Received: from 30.221.147.159(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VWBVp5d_1669956631)
          by smtp.aliyun-inc.com;
          Fri, 02 Dec 2022 12:50:33 +0800
Message-ID: <1b95612c-a38b-90e2-cbe3-211d8129fb9f@linux.alibaba.com>
Date:   Fri, 2 Dec 2022 12:50:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:107.0)
 Gecko/20100101 Thunderbird/107.0
Subject: Re: [RFC PATCH 0/9] virtio_net: support multi buffer xdp
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
In-Reply-To: <20221122074348.88601-1-hengqi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jason.

Do you have any comments on this series?

Thanks.

在 2022/11/22 下午3:43, Heng Qi 写道:
> Currently, virtio net only supports xdp for single-buffer packets
> or linearized multi-buffer packets. This patchset supports xdp for
> multi-buffer packets, then GRO_HW related features can be
> negotiated, and do not affect the processing of single-buffer xdp.
>
> In order to build multi-buffer xdp neatly, we integrated the code
> into virtnet_build_xdp_buff() for xdp. The first buffer is used
> for prepared xdp buff, and the rest of the buffers are added to
> its skb_shared_info structure. This structure can also be
> conveniently converted during XDP_PASS to get the corresponding skb.
>
> Since virtio net uses comp pages, and bpf_xdp_frags_increase_tail()
> is based on the assumption of the page pool,
> (rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag))
> is negative in most cases. So we didn't set xdp_rxq->frag_size in
> virtnet_open() to disable the tail increase.
>
> Heng Qi (9):
>    virtio_net: disable the hole mechanism for xdp
>    virtio_net: set up xdp for multi buffer packets
>    virtio_net: update bytes calculation for xdp_frame
>    virtio_net: remove xdp related info from page_to_skb()
>    virtio_net: build xdp_buff with multi buffers
>    virtio_net: construct multi-buffer xdp in mergeable
>    virtio_net: build skb from multi-buffer xdp
>    virtio_net: transmit the multi-buffer xdp
>    virtio_net: support multi-buffer xdp
>
>   drivers/net/virtio_net.c | 356 ++++++++++++++++++++++++---------------
>   1 file changed, 219 insertions(+), 137 deletions(-)
>

