Return-Path: <netdev+bounces-769-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3CCE6F9D85
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 03:48:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DCF8280EB2
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 01:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD289125B9;
	Mon,  8 May 2023 01:48:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CCF15D1;
	Mon,  8 May 2023 01:48:18 +0000 (UTC)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EDD26BD;
	Sun,  7 May 2023 18:48:15 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vhymz9._1683510491;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vhymz9._1683510491)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 09:48:12 +0800
Message-ID: <1683510351.569717-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net v3] virtio_net: Fix error unwinding of XDP initialization
Date: Mon, 8 May 2023 09:45:51 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Feng Liu <feliu@nvidia.com>
Cc: Jason Wang <jasowang@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Simon Horman <simon.horman@corigine.com>,
 Bodong Wang <bodong@nvidia.com>,
 William Tu <witu@nvidia.com>,
 Parav Pandit <parav@nvidia.com>,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org
References: <20230503003525.48590-1-feliu@nvidia.com>
 <1683340417.612963-3-xuanzhuo@linux.alibaba.com>
 <559ad341-2278-5fad-6805-c7f632e9894e@nvidia.com>
In-Reply-To: <559ad341-2278-5fad-6805-c7f632e9894e@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Sat, 6 May 2023 08:08:02 -0400, Feng Liu <feliu@nvidia.com> wrote:
>
>
> On 2023-05-05 p.m.10:33, Xuan Zhuo wrote:
> > External email: Use caution opening links or attachments
> >
> >
> > On Tue, 2 May 2023 20:35:25 -0400, Feng Liu <feliu@nvidia.com> wrote:
> >> When initializing XDP in virtnet_open(), some rq xdp initialization
> >> may hit an error causing net device open failed. However, previous
> >> rqs have already initialized XDP and enabled NAPI, which is not the
> >> expected behavior. Need to roll back the previous rq initialization
> >> to avoid leaks in error unwinding of init code.
> >>
> >> Also extract a helper function of disable queue pairs, and use newly
> >> introduced helper function in error unwinding and virtnet_close;
> >>
> >> Issue: 3383038
> >> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> >> Signed-off-by: Feng Liu <feliu@nvidia.com>
> >> Reviewed-by: William Tu <witu@nvidia.com>
> >> Reviewed-by: Parav Pandit <parav@nvidia.com>
> >> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> >> Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
> >> ---
> >>   drivers/net/virtio_net.c | 30 ++++++++++++++++++++----------
> >>   1 file changed, 20 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >> index 8d8038538fc4..3737cf120cb7 100644
> >> --- a/drivers/net/virtio_net.c
> >> +++ b/drivers/net/virtio_net.c
> >> @@ -1868,6 +1868,13 @@ static int virtnet_poll(struct napi_struct *nap=
i, int budget)
> >>        return received;
> >>   }
> >>
> >> +static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
> >> +{
> >> +     virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
> >> +     napi_disable(&vi->rq[qp_index].napi);
> >> +     xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
> >> +}
> >> +
> >>   static int virtnet_open(struct net_device *dev)
> >>   {
> >>        struct virtnet_info *vi =3D netdev_priv(dev);
> >> @@ -1883,20 +1890,26 @@ static int virtnet_open(struct net_device *dev)
> >>
> >>                err =3D xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi=
->rq[i].napi.napi_id);
> >>                if (err < 0)
> >> -                     return err;
> >> +                     goto err_xdp_info_reg;
> >>
> >>                err =3D xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
> >>                                                 MEM_TYPE_PAGE_SHARED, =
NULL);
> >> -             if (err < 0) {
> >> -                     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> >> -                     return err;
> >> -             }
> >> +             if (err < 0)
> >> +                     goto err_xdp_reg_mem_model;
> >>
> >>                virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
> >>                virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].nap=
i);
> >>        }
> >>
> >>        return 0;
> >> +
> >> +err_xdp_reg_mem_model:
> >> +     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> >> +err_xdp_info_reg:
> >> +     for (i =3D i - 1; i >=3D 0; i--)
> >> +             virtnet_disable_qp(vi, i);
> >
> >
> > I would to know should we handle for these:
> >
> >          disable_delayed_refill(vi);
> >          cancel_delayed_work_sync(&vi->refill);
> >
> >
> > Maybe we should call virtnet_close() with "i" directly.
> >
> > Thanks.
> >
> >
> Can=E2=80=99t use i directly here, because if xdp_rxq_info_reg fails, nap=
i has
> not been enabled for current qp yet, I should roll back from the queue
> pairs where napi was enabled before(i--), otherwise it will hang at napi
> disable api

This is not the point, the key is whether we should handle with:

          disable_delayed_refill(vi);
          cancel_delayed_work_sync(&vi->refill);

Thanks.


>
> >> +
> >> +     return err;
> >>   }
> >>
> >>   static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> >> @@ -2305,11 +2318,8 @@ static int virtnet_close(struct net_device *dev)
> >>        /* Make sure refill_work doesn't re-enable napi! */
> >>        cancel_delayed_work_sync(&vi->refill);
> >>
> >> -     for (i =3D 0; i < vi->max_queue_pairs; i++) {
> >> -             virtnet_napi_tx_disable(&vi->sq[i].napi);
> >> -             napi_disable(&vi->rq[i].napi);
> >> -             xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> >> -     }
> >> +     for (i =3D 0; i < vi->max_queue_pairs; i++)
> >> +             virtnet_disable_qp(vi, i);
> >>
> >>        return 0;
> >>   }
> >> --
> >> 2.37.1 (Apple Git-137.1)
> >>

