Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64452655F2B
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 03:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiLZCdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 21:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiLZCdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 21:33:01 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E272674;
        Sun, 25 Dec 2022 18:32:59 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VY1b5S1_1672021975;
Received: from 30.39.209.91(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VY1b5S1_1672021975)
          by smtp.aliyun-inc.com;
          Mon, 26 Dec 2022 10:32:56 +0800
Message-ID: <daf585da-ea19-c06f-efba-ec706e9478ff@linux.alibaba.com>
Date:   Mon, 26 Dec 2022 10:32:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [PATCH v2 0/9] virtio_net: support multi buffer xdp
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
In-Reply-To: <20221220141449.115918-1-hengqi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Jason, do you have any comments on this?

Thanks.

在 2022/12/20 下午10:14, Heng Qi 写道:
> Changes since RFC:
> - Using headroom instead of vi->xdp_enabled to avoid re-reading
>    in add_recvbuf_mergeable();
> - Disable GRO_HW and keep linearization for single buffer xdp;
> - Renamed to virtnet_build_xdp_buff_mrg();
> - pr_debug() to netdev_dbg();
> - Adjusted the order of the patch series.
>
> Currently, virtio net only supports xdp for single-buffer packets
> or linearized multi-buffer packets. This patchset supports xdp for
> multi-buffer packets, then larger MTU can be used if xdp sets the
> xdp.frags. This does not affect single buffer handling.
>
> In order to build multi-buffer xdp neatly, we integrated the code
> into virtnet_build_xdp_buff_mrg() for xdp. The first buffer is used
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
>    virtio_net: build xdp_buff with multi buffers
>    virtio_net: construct multi-buffer xdp in mergeable
>    virtio_net: transmit the multi-buffer xdp
>    virtio_net: build skb from multi-buffer xdp
>    virtio_net: remove xdp related info from page_to_skb()
>    virtio_net: support multi-buffer xdp
>
>   drivers/net/virtio_net.c | 332 ++++++++++++++++++++++++++-------------
>   1 file changed, 219 insertions(+), 113 deletions(-)
>

