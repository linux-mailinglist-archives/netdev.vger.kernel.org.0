Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4C46F00BC
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbjD0GXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjD0GXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:23:52 -0400
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B0A3C28;
        Wed, 26 Apr 2023 23:23:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vh6EyIG_1682576626;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vh6EyIG_1682576626)
          by smtp.aliyun-inc.com;
          Thu, 27 Apr 2023 14:23:47 +0800
Message-ID: <1682576442.2203932-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH] virtio_net: suppress cpu stall when free_unused_bufs
Date:   Thu, 27 Apr 2023 14:20:42 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Wenliang Wang <wangwenliang.1995@bytedance.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wenliang Wang <wangwenliang.1995@bytedance.com>,
        mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
References: <20230427043433.2594960-1-wangwenliang.1995@bytedance.com>
In-Reply-To: <20230427043433.2594960-1-wangwenliang.1995@bytedance.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 12:34:33 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
> For multi-queue and large rx-ring-size use case, the following error

Cound you give we one number for example?

> occurred when free_unused_bufs:
> rcu: INFO: rcu_sched self-detected stall on CPU.
>
> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> ---
>  drivers/net/virtio_net.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ea1bd4bb326d..21d8382fd2c7 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3565,6 +3565,7 @@ static void free_unused_bufs(struct virtnet_info *vi)
>  		struct virtqueue *vq = vi->rq[i].vq;
>  		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>  			virtnet_rq_free_unused_buf(vq, buf);
> +		schedule();

Just for rq?

Do we need to do the same thing for sq?

Thanks.


>  	}
>  }
>
> --
> 2.20.1
>
