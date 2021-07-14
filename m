Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103B93C7EAF
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 08:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbhGNGue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 02:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237948AbhGNGud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 02:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96EA5613AA;
        Wed, 14 Jul 2021 06:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626245261;
        bh=YNUqH8SXbCanLQzbk4axEfesSFurixvhv/5EA0zfQNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wAUkEGuaJJ+xyTOr/3CDeDn85Emf2yTZJe5ZHYx0VnNfvTbl7kecruHBrIiXB9tD4
         hOTnqvfdmfYs99MmWfQCGkqgZRAEQaJUr3W2yvScHeXWy0hWoFfBhRxFqDrGmW4RKY
         pl0XDR1Yzvo9UeO+3Eo4T4k0nBkLz7h3AOHxAbt0=
Date:   Wed, 14 Jul 2021 08:47:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 16/17] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <YO6IiDIMUjQsA2LS@kroah.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-17-xieyongji@bytedance.com>
 <26116714-f485-eeab-4939-71c4c10c30de@redhat.com>
 <20210714014817-mutt-send-email-mst@kernel.org>
 <0565ed6c-88e2-6d93-7cc6-7b4afaab599c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0565ed6c-88e2-6d93-7cc6-7b4afaab599c@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 02:02:50PM +0800, Jason Wang wrote:
> 
> 在 2021/7/14 下午1:54, Michael S. Tsirkin 写道:
> > On Wed, Jul 14, 2021 at 01:45:39PM +0800, Jason Wang wrote:
> > > > +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> > > > +			      struct vduse_dev_msg *msg)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	init_waitqueue_head(&msg->waitq);
> > > > +	spin_lock(&dev->msg_lock);
> > > > +	msg->req.request_id = dev->msg_unique++;
> > > > +	vduse_enqueue_msg(&dev->send_list, msg);
> > > > +	wake_up(&dev->waitq);
> > > > +	spin_unlock(&dev->msg_lock);
> > > > +
> > > > +	wait_event_killable_timeout(msg->waitq, msg->completed,
> > > > +				    VDUSE_REQUEST_TIMEOUT * HZ);
> > > > +	spin_lock(&dev->msg_lock);
> > > > +	if (!msg->completed) {
> > > > +		list_del(&msg->list);
> > > > +		msg->resp.result = VDUSE_REQ_RESULT_FAILED;
> > > > +	}
> > > > +	ret = (msg->resp.result == VDUSE_REQ_RESULT_OK) ? 0 : -EIO;
> > > 
> > > I think we should mark the device as malfunction when there is a timeout and
> > > forbid any userspace operations except for the destroy aftwards for safety.
> > This looks like if one tried to run gdb on the program the behaviour
> > will change completely because kernel wants it to respond within
> > specific time. Looks like a receipe for heisenbugs.
> > 
> > Let's not build interfaces with arbitrary timeouts like that.
> > Interruptible wait exists for this very reason.
> 
> 
> The problem is. Do we want userspace program like modprobe to be stuck for
> indefinite time and expect the administrator to kill that?

Why would modprobe be stuck for forever?

Is this on the module probe path?
