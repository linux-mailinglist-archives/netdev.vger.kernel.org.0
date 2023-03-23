Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B696C663C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjCWLM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjCWLML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:12:11 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453E42E828;
        Thu, 23 Mar 2023 04:12:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VeU4xLz_1679569919;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeU4xLz_1679569919)
          by smtp.aliyun-inc.com;
          Thu, 23 Mar 2023 19:12:00 +0800
Message-ID: <1679569460.0714788-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 2/8] virtio_net: mergeable xdp: introduce mergeable_xdp_prepare
Date:   Thu, 23 Mar 2023 19:04:20 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
 <20230322030308.16046-3-xuanzhuo@linux.alibaba.com>
 <c7749936-c154-da51-ccfb-f16150d19c62@huawei.com>
 <1679535924.6219428-2-xuanzhuo@linux.alibaba.com>
 <215e791d-1802-2419-ff59-49476bcdcd02@huawei.com>
 <CACGkMEv=0gt6LS0HSgKELQqnWfQ2UdFgAKdvh=CLaAPLeNytww@mail.gmail.com>
 <00509559-f3b6-2914-76f4-39e9e96f37c1@huawei.com>
In-Reply-To: <00509559-f3b6-2914-76f4-39e9e96f37c1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 15:24:38 +0800, Yunsheng Lin <linyunsheng@huawei.com> w=
rote:
> On 2023/3/23 13:40, Jason Wang wrote:
> >>>
> >>>>
> >>>> Also, it seems better to split the xdp_linearize_page() to two funct=
ions
> >>>> as pskb_expand_head() and __skb_linearize() do, one to expand the he=
adroom,
> >>>> the other one to do the linearizing.
> >>>
> >>> No skb here.
> >>
> >> I means following the semantics of pskb_expand_head() and __skb_linear=
ize(),
> >> not to combine the headroom expanding and linearizing into one functio=
n as
> >> xdp_linearize_page() does now if we want a better refoctor result.
> >
> > Not sure it's worth it, since the use is very specific unless we could
> > find a case that wants only one of them.
>
> It seems receive_small() only need the headroom expanding one.
> For receive_mergeable(), it seems we can split into the below cases:
> 1. " (!xdp_prog->aux->xdp_has_frags && (num_buf > 1 || headroom < virtnet=
_get_headroom(vi)))"
>    case only need linearizing.
> 2. other cases only need headroom/tailroom expanding.
>
> Anyway, it is your call to decide if you want to take this
> opportunity do a better refoctoring to virtio_net.

Compared to the chaotic state of the virtio-net XDP, this is a small point.
And I don=E2=80=99t think this brings any practical optimization. If you th=
ink this
division is better. You can submit a new patch on the top of this patch set.
I think the code can be clearer.

Thanks.

>
> >
> > Thanks
> >
> >>
> >>>
> >>>
> >>>>
> >>
> >
> >
> > .
> >
