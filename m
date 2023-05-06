Return-Path: <netdev+bounces-667-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DED6F8DD6
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 04:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A1991C21A6D
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5861365;
	Sat,  6 May 2023 02:08:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E78010E6
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 02:08:02 +0000 (UTC)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D945274;
	Fri,  5 May 2023 19:07:59 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VhrSoEj_1683338876;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VhrSoEj_1683338876)
          by smtp.aliyun-inc.com;
          Sat, 06 May 2023 10:07:57 +0800
Message-ID: <1683338663.2120674-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
Date: Sat, 6 May 2023 10:04:23 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 zhengqi.arch@bytedance.com,
 willemdebruijn.kernel@gmail.com,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Wenliang Wang <wangwenliang.1995@bytedance.com>
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
 <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
In-Reply-To: <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
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

On Fri, 5 May 2023 11:28:25 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Thu, May 4, 2023 at 10:27=E2=80=AFAM Wenliang Wang
> <wangwenliang.1995@bytedance.com> wrote:
> >
> > For multi-queue and large ring-size use case, the following error
> > occurred when free_unused_bufs:
> > rcu: INFO: rcu_sched self-detected stall on CPU.
> >
> > Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
> > Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> > ---
> > v2:
> > -add need_resched check.
> > -apply same logic to sq.
> > v3:
> > -use cond_resched instead.
> > v4:
> > -add fixes tag
> > ---
> >  drivers/net/virtio_net.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 8d8038538fc4..a12ae26db0e2 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct virtnet_inf=
o *vi)
> >                 struct virtqueue *vq =3D vi->sq[i].vq;
> >                 while ((buf =3D virtqueue_detach_unused_buf(vq)) !=3D N=
ULL)
> >                         virtnet_sq_free_unused_buf(vq, buf);
> > +               cond_resched();
>
> Does this really address the case when the virtqueue is very large?

Yes, I also have this question. I think cond_resched() should be called eve=
ry
time a certain number of buffers are processed.

Thanks.

>
> Thanks
>
> >         }
> >
> >         for (i =3D 0; i < vi->max_queue_pairs; i++) {
> >                 struct virtqueue *vq =3D vi->rq[i].vq;
> >                 while ((buf =3D virtqueue_detach_unused_buf(vq)) !=3D N=
ULL)
> >                         virtnet_rq_free_unused_buf(vq, buf);
> > +               cond_resched();
> >         }
> >  }
> >
> > --
> > 2.20.1
> >
>

