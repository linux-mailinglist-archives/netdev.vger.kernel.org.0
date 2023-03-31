Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F646D187D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjCaHVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjCaHVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:21:37 -0400
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D0A1A955;
        Fri, 31 Mar 2023 00:21:16 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vf1F9lX_1680247271;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vf1F9lX_1680247271)
          by smtp.aliyun-inc.com;
          Fri, 31 Mar 2023 15:21:12 +0800
Message-ID: <1680247235.3085878-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 8/8] virtio_net: introduce receive_small_xdp()
Date:   Fri, 31 Mar 2023 15:20:35 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
 <20230328120412.110114-9-xuanzhuo@linux.alibaba.com>
 <343825bad568ec0a21c283f876585585b040da9f.camel@redhat.com>
In-Reply-To: <343825bad568ec0a21c283f876585585b040da9f.camel@redhat.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 12:48:22 +0200, Paolo Abeni <pabeni@redhat.com> wrote:
> On Tue, 2023-03-28 at 20:04 +0800, Xuan Zhuo wrote:
> > @@ -949,15 +1042,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >  {
> >  	struct sk_buff *skb;
> >  	struct bpf_prog *xdp_prog;
> > -	unsigned int xdp_headroom = (unsigned long)ctx;
> > -	unsigned int header_offset = VIRTNET_RX_PAD + xdp_headroom;
> > +	unsigned int header_offset = VIRTNET_RX_PAD;
> >  	unsigned int headroom = vi->hdr_len + header_offset;
>
> This changes (reduces) the headroom for non-xpd-pass skbs.
>
> [...]
> > +	buf += header_offset;
> > +	memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>
> AFAICS, that also means that receive_small(), for such packets, will
> look for the virtio header in a different location. Is that expected?


That is a mistake.

Will fix.

Thanks.

>
> Thanks.
>
> Paolo
>
