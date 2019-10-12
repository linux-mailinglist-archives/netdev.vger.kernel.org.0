Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EFFD5263
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 22:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbfJLU1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 16:27:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbfJLU1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 16:27:49 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EFC37C058CA4
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 20:27:48 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id 190so5450117wme.4
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 13:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EqTOWjC4L/Kz6sFQs9jCsgXd8dSNgdgkSYjDXmXjolo=;
        b=MTVe351GAIr+iguv1V+PV+wgR88cBxOKcJy8DgZkwhgIe6c4gLRqrJQOH7+azuptOG
         NjYJglrfqKz9DcnWitDtds4E/Dz2/0nNkhywNoopuNP2qhyErkOund6nmBdVrGaK6vdQ
         xSJ4fF/n6yp6gQaxp5SShEkhyr+HvwYWfJ1YuJLiZNk6dc1AQjapmxaf00qfryb+FxmL
         DkYcaHRCSwgUW2zFKsSjof0LNriU9tRFDpXJ1Fxt7VB677oJGjjFRSHdN6bt5lSmuYeU
         NQ+JD7O+FW/sSsC7FEbt0rtzA9bg/ugWmT7j7D0bmVi/lITUO3zPdXnmT7KXA0C0b7ZJ
         3ktw==
X-Gm-Message-State: APjAAAXTfWGmCvGLF6etGxVC25Kd/59A9LxL7FoJI/zMPvZLqhYHt6EZ
        GZaYFP085vub/gPQV1I9gjrdj9srUJRuOhSUNTJIoLI4kd0FWXZrJJQ4hqOfI6EieytiLN/SqrK
        tkLwNkZxxvUBOVGkU
X-Received: by 2002:a05:600c:21c8:: with SMTP id x8mr7778915wmj.123.1570912067636;
        Sat, 12 Oct 2019 13:27:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwQzyMBrFDfWTdK5lUQ3sY5hHb4OoDfa1GaxOr1ruBpGf2toaNre0YJeRWwm2tOu4hgB0VNpQ==
X-Received: by 2002:a05:600c:21c8:: with SMTP id x8mr7778905wmj.123.1570912067370;
        Sat, 12 Oct 2019 13:27:47 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id s9sm14550556wme.36.2019.10.12.13.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 13:27:46 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:27:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v1 1/2] vhost: option to fetch descriptors through an
 independent struct
Message-ID: <20191012162445-mutt-send-email-mst@kernel.org>
References: <20191011134358.16912-1-mst@redhat.com>
 <20191011134358.16912-2-mst@redhat.com>
 <3b2a6309-9d21-7172-a581-9f0f1d5c1427@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b2a6309-9d21-7172-a581-9f0f1d5c1427@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 03:28:49PM +0800, Jason Wang wrote:
> 
> On 2019/10/11 下午9:45, Michael S. Tsirkin wrote:
> > The idea is to support multiple ring formats by converting
> > to a format-independent array of descriptors.
> > 
> > This costs extra cycles, but we gain in ability
> > to fetch a batch of descriptors in one go, which
> > is good for code cache locality.
> > 
> > To simplify benchmarking, I kept the old code
> > around so one can switch back and forth by
> > writing into a module parameter.
> > This will go away in the final submission.
> > 
> > This patch causes a minor performance degradation,
> > it's been kept as simple as possible for ease of review.
> > Next patch gets us back the performance by adding batching.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/vhost/test.c  |  17 ++-
> >   drivers/vhost/vhost.c | 299 +++++++++++++++++++++++++++++++++++++++++-
> >   drivers/vhost/vhost.h |  16 +++
> >   3 files changed, 327 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > index 056308008288..39a018a7af2d 100644
> > --- a/drivers/vhost/test.c
> > +++ b/drivers/vhost/test.c
> > @@ -18,6 +18,9 @@
> >   #include "test.h"
> >   #include "vhost.h"
> > +static int newcode = 0;
> > +module_param(newcode, int, 0644);
> > +
> >   /* Max number of bytes transferred before requeueing the job.
> >    * Using this limit prevents one virtqueue from starving others. */
> >   #define VHOST_TEST_WEIGHT 0x80000
> > @@ -58,10 +61,16 @@ static void handle_vq(struct vhost_test *n)
> >   	vhost_disable_notify(&n->dev, vq);
> >   	for (;;) {
> > -		head = vhost_get_vq_desc(vq, vq->iov,
> > -					 ARRAY_SIZE(vq->iov),
> > -					 &out, &in,
> > -					 NULL, NULL);
> > +		if (newcode)
> > +			head = vhost_get_vq_desc_batch(vq, vq->iov,
> > +						       ARRAY_SIZE(vq->iov),
> > +						       &out, &in,
> > +						       NULL, NULL);
> > +		else
> > +			head = vhost_get_vq_desc(vq, vq->iov,
> > +						 ARRAY_SIZE(vq->iov),
> > +						 &out, &in,
> > +						 NULL, NULL);
> >   		/* On error, stop handling until the next kick. */
> >   		if (unlikely(head < 0))
> >   			break;
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 36ca2cf419bf..36661d6cb51f 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -301,6 +301,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> >   			   struct vhost_virtqueue *vq)
> >   {
> >   	vq->num = 1;
> > +	vq->ndescs = 0;
> >   	vq->desc = NULL;
> >   	vq->avail = NULL;
> >   	vq->used = NULL;
> > @@ -369,6 +370,9 @@ static int vhost_worker(void *data)
> >   static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> >   {
> > +	kfree(vq->descs);
> > +	vq->descs = NULL;
> > +	vq->max_descs = 0;
> >   	kfree(vq->indirect);
> >   	vq->indirect = NULL;
> >   	kfree(vq->log);
> > @@ -385,6 +389,10 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
> >   	for (i = 0; i < dev->nvqs; ++i) {
> >   		vq = dev->vqs[i];
> > +		vq->max_descs = dev->iov_limit;
> > +		vq->descs = kmalloc_array(vq->max_descs,
> > +					  sizeof(*vq->descs),
> > +					  GFP_KERNEL);
> 
> 
> Is iov_limit too much here? It can obviously increase the footprint. I guess
> the batching can only be done for descriptor without indirect or next set.
> Then we may batch 16 or 64.
> 
> Thanks

Yes, next patch only batches up to 64.  But we do need iov_limit because
guest can pass a long chain of scatter/gather.
We already have iovecs in a huge array so this does not look like
a big deal. If we ever teach the code to avoid the huge
iov arrays by handling huge s/g lists piece by piece,
we can make the desc array smaller at the same point.


