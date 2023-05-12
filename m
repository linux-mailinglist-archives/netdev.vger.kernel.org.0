Return-Path: <netdev+bounces-2010-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C236FFF44
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDF3B1C21113
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9CA818;
	Fri, 12 May 2023 03:27:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F877E9;
	Fri, 12 May 2023 03:27:50 +0000 (UTC)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689F549E1;
	Thu, 11 May 2023 20:27:47 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0ViNIiVS_1683862063;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ViNIiVS_1683862063)
          by smtp.aliyun-inc.com;
          Fri, 12 May 2023 11:27:44 +0800
Message-ID: <1683861904.528041-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net v3] virtio_net: Fix error unwinding of XDP initialization
Date: Fri, 12 May 2023 11:25:04 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Feng Liu <feliu@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
 Simon Horman <simon.horman@corigine.com>,
 Bodong Wang <bodong@nvidia.com>,
 William Tu <witu@nvidia.com>,
 Parav Pandit <parav@nvidia.com>,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org,
 Jason Wang <jasowang@redhat.com>
References: <20230503003525.48590-1-feliu@nvidia.com>
 <1683340417.612963-3-xuanzhuo@linux.alibaba.com>
 <559ad341-2278-5fad-6805-c7f632e9894e@nvidia.com>
 <1683510351.569717-1-xuanzhuo@linux.alibaba.com>
 <c2c2bfed-bdf1-f517-559c-f51c9ca1807a@nvidia.com>
 <1683596602.483001-1-xuanzhuo@linux.alibaba.com>
 <a13a2d3f-e76e-b6a6-3d30-d5534e2fa917@redhat.com>
 <af272d2c-e952-1c13-80da-b5ce751e834b@nvidia.com>
In-Reply-To: <af272d2c-e952-1c13-80da-b5ce751e834b@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Thu, 11 May 2023 21:54:40 -0400, Feng Liu <feliu@nvidia.com> wrote:
>
>
> On 2023-05-10 a.m.1:00, Jason Wang wrote:
> > External email: Use caution opening links or attachments
> >
> >
> > =E5=9C=A8 2023/5/9 09:43, Xuan Zhuo =E5=86=99=E9=81=93:
> >> On Mon, 8 May 2023 11:00:10 -0400, Feng Liu <feliu@nvidia.com> wrote:
> >>>
> >>> On 2023-05-07 p.m.9:45, Xuan Zhuo wrote:
> >>>> External email: Use caution opening links or attachments
> >>>>
> >>>>
> >>>> On Sat, 6 May 2023 08:08:02 -0400, Feng Liu <feliu@nvidia.com> wrote:
> >>>>>
> >>>>> On 2023-05-05 p.m.10:33, Xuan Zhuo wrote:
> >>>>>> External email: Use caution opening links or attachments
> >>>>>>
> >>>>>>
> >>>>>> On Tue, 2 May 2023 20:35:25 -0400, Feng Liu <feliu@nvidia.com> wro=
te:
> >>>>>>> When initializing XDP in virtnet_open(), some rq xdp initializati=
on
> >>>>>>> may hit an error causing net device open failed. However, previous
> >>>>>>> rqs have already initialized XDP and enabled NAPI, which is not t=
he
> >>>>>>> expected behavior. Need to roll back the previous rq initializati=
on
> >>>>>>> to avoid leaks in error unwinding of init code.
> >>>>>>>
> >>>>>>> Also extract a helper function of disable queue pairs, and use ne=
wly
> >>>>>>> introduced helper function in error unwinding and virtnet_close;
> >>>>>>>
> >>>>>>> Issue: 3383038
> >>>>>>> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> >>>>>>> Signed-off-by: Feng Liu <feliu@nvidia.com>
> >>>>>>> Reviewed-by: William Tu <witu@nvidia.com>
> >>>>>>> Reviewed-by: Parav Pandit <parav@nvidia.com>
> >>>>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >>>>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> >>>>>>> Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
> >>>>>>> ---
> >>>>>>> =C2=A0=C2=A0=C2=A0 drivers/net/virtio_net.c | 30 ++++++++++++++++=
++++----------
> >>>>>>> =C2=A0=C2=A0=C2=A0 1 file changed, 20 insertions(+), 10 deletions=
(-)
> >>>>>>>
> >>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>>>>>> index 8d8038538fc4..3737cf120cb7 100644
> >>>>>>> --- a/drivers/net/virtio_net.c
> >>>>>>> +++ b/drivers/net/virtio_net.c
> >>>>>>> @@ -1868,6 +1868,13 @@ static int virtnet_poll(struct napi_struct
> >>>>>>> *napi, int budget)
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return received;
> >>>>>>> =C2=A0=C2=A0=C2=A0 }
> >>>>>>>
> >>>>>>> +static void virtnet_disable_qp(struct virtnet_info *vi, int
> >>>>>>> qp_index)
> >>>>>>> +{
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 virtnet_napi_tx_disable(&vi->sq[qp_inde=
x].napi);
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 napi_disable(&vi->rq[qp_index].napi);
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 xdp_rxq_info_unreg(&vi->rq[qp_index].xd=
p_rxq);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> =C2=A0=C2=A0=C2=A0 static int virtnet_open(struct net_device *dev)
> >>>>>>> =C2=A0=C2=A0=C2=A0 {
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct virtnet_i=
nfo *vi =3D netdev_priv(dev);
> >>>>>>> @@ -1883,20 +1890,26 @@ static int virtnet_open(struct net_device
> >>>>>>> *dev)
> >>>>>>>
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D xdp_rxq_info_reg(&vi->rq[i].xdp_r=
xq, dev,
> >>>>>>> i, vi->rq[i].napi.napi_id);
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err < 0)
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_xdp_info=
_reg;
> >>>>>>>
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D
> >>>>>>> xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
> >>>>>>>
> >>>>>>> MEM_TYPE_PAGE_SHARED, NULL);
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (err < 0) {
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp_rxq_info_unre=
g(&vi->rq[i].xdp_rxq);
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (err < 0)
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_xdp_reg_=
mem_model;
> >>>>>>>
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 virtnet_napi_enable(vi->rq[i].vq, &vi->rq=
[i].napi);
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 virtnet_napi_tx_enable(vi, vi->sq[i].vq,
> >>>>>>> &vi->sq[i].napi);
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>>>>>>
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> >>>>>>> +
> >>>>>>> +err_xdp_reg_mem_model:
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> >>>>>>> +err_xdp_info_reg:
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D i - 1; i >=3D 0; i--)
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 virtnet_disable_qp(vi, i);
> >>>>>>
> >>>>>> I would to know should we handle for these:
> >>>>>>
> >>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disab=
le_delayed_refill(vi);
> >>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cance=
l_delayed_work_sync(&vi->refill);
> >>>>>>
> >>>>>>
> >>>>>> Maybe we should call virtnet_close() with "i" directly.
> >>>>>>
> >>>>>> Thanks.
> >>>>>>
> >>>>>>
> >>>>> Can=E2=80=99t use i directly here, because if xdp_rxq_info_reg fail=
s, napi has
> >>>>> not been enabled for current qp yet, I should roll back from the qu=
eue
> >>>>> pairs where napi was enabled before(i--), otherwise it will hang at
> >>>>> napi
> >>>>> disable api
> >>>> This is not the point, the key is whether we should handle with:
> >>>>
> >>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 d=
isable_delayed_refill(vi);
> >>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
ancel_delayed_work_sync(&vi->refill);
> >>>>
> >>>> Thanks.
> >>>>
> >>>>
> >>> OK, get the point. Thanks for your careful review. And I check the co=
de
> >>> again.
> >>>
> >>> There are two points that I need to explain:
> >>>
> >>> 1. All refill delay work calls(vi->refill, vi->refill_enabled) are ba=
sed
> >>> on that the virtio interface is successfully opened, such as
> >>> virtnet_receive, virtnet_rx_resize, _virtnet_set_queues, etc. If there
> >>> is an error in the xdp reg here, it will not trigger these subsequent
> >>> functions. There is no need to call disable_delayed_refill() and
> >>> cancel_delayed_work_sync().
> >> Maybe something is wrong. I think these lines may call delay work.
> >>
> >> static int virtnet_open(struct net_device *dev)
> >> {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct virtnet_info *vi =3D netdev_priv=
(dev);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i, err;
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enable_delayed_refill(vi);
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < vi->max_queue_pairs; =
i++) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (i < vi->curr_queue_pairs)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Make sure we h=
ave some buffers: if oom use
> >> wq. */
> >> -->=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!try_fill_recv(vi, &vi->rq[i=
], GFP_KERNEL))
> >> -->=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 schedule_delayed_work(&vi->refill, 0);
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 err =3D xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i,
> >> vi->rq[i].napi.napi_id);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (err < 0)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 err =3D xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MEM_TYPE_PAGE_SHA=
RED,
> >> NULL);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (err < 0) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp_rxq_info_unre=
g(&vi->rq[i].xdp_rxq);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> >> }
> >>
> >>
> >> And I think, if we virtnet_open() return error, then the status of
> >> virtnet
> >> should like the status after virtnet_close().
> >>
> >> Or someone has other opinion.
> >
> >
> > I agree, we need to disable and sync with the refill work.
> >
> > Thanks
> >
> >
> Hi, Jason & Xuan
>
> I will modify the patch according to the comments.
>
> But cannot call virtnet_close(), since virtnet_close cannot disable
> queue pairs from the specified error one. so still need to use disable
> helper function. The reason is as mentioned in the previous email, we
> need to roll back from the specified error queue,  otherwise the queue
> pairs which has not been enabled napi will hang up at napi disable api.
>
> According to the comments, I will call disable_delayed_refill() and
> cancel_delayed_work_sync() in error unwinding, then call the disable
> helper function one by one for the queue pairs before the error one.
>
> Do you have any other comments about these?

LGTM

Thanks.

>
> Thanks
>
> >>
> >> Thanks.
> >>
> >>> The logic here is different from that of
> >>> virtnet_close. virtnet_close is based on the success of virtnet_open =
and
> >>> the tx and rx has been carried out normally. For error unwinding, only
> >>> disable qp is needed. Also encapuslated a helper function of disable =
qp,
> >>> which is used ing error unwinding and virtnet close
> >>> 2. The current error qp, which has not enabled NAPI, can only call xdp
> >>> unreg, and cannot call the interface of disable NAPI, otherwise the
> >>> kernel will be stuck. So for i-- the reason for calling disable qp on
> >>> the previous queue
> >>>
> >>> Thanks
> >>>
> >>>>>>> +
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 return err;
> >>>>>>> =C2=A0=C2=A0=C2=A0 }
> >>>>>>>
> >>>>>>> =C2=A0=C2=A0=C2=A0 static int virtnet_poll_tx(struct napi_struct =
*napi, int budget)
> >>>>>>> @@ -2305,11 +2318,8 @@ static int virtnet_close(struct net_device
> >>>>>>> *dev)
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Make sure ref=
ill_work doesn't re-enable napi! */
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cancel_delayed_w=
ork_sync(&vi->refill);
> >>>>>>>
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < vi->max_queue_pairs; =
i++) {
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 virtnet_napi_tx_disable(&vi->sq[i].napi);
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 napi_disable(&vi->rq[i].napi);
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> >>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < vi->max_queue_pairs; =
i++)
> >>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 virtnet_disable_qp(vi, i);
> >>>>>>>
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> >>>>>>> =C2=A0=C2=A0=C2=A0 }
> >>>>>>> --
> >>>>>>> 2.37.1 (Apple Git-137.1)
> >>>>>>>
> >

