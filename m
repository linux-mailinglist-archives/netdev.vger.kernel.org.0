Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522894BE90E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380020AbiBUQQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:16:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379981AbiBUQPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:15:53 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3115F23BD4;
        Mon, 21 Feb 2022 08:15:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645460114; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=DuraJutovSGUPCk2XURRrMVrKu6VjFrkpxn3ohqo5fprZYZythN4kZr5L9vB+4OWuIwfdwPp+RpUOJquHBSulT8FY/qwXVq43kqpJaKCM9aJM2wf7dl29hIRxg7vzkYPpGh2RMi+ark3/46aurhztCscwZ1lXvxWARegXKg5BD0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645460114; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WKgVCY1x560wjpb2d6+V1DLhy9frcWvJFP7CwbCVLYo=; 
        b=nicyYhark7OR16sCX1xhUBcwDGIYt4LknSzouz0gc7yc5uN5RKAAm8i9TKH/DRcPHjW8wTWm7vmGVvlD9PBKLQiAhutmoNm2zD4KL4rynz9FX3JxcFggEgUyRTIkgWPodjkn3d3po5z4HU+hnL/RWx6iATs5fF4HkVVIhIygPvE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645460114;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=WKgVCY1x560wjpb2d6+V1DLhy9frcWvJFP7CwbCVLYo=;
        b=jGUZ9sbhScheWcPDrud7NDlwDJxZu5m76omQlDu2Vg5+271FB2w8f/PRG7UQpB2f
        2EjASNOE+EbFI/B0ooZl7DSteqIpUvjkw0RXrCMT3fHe+bdJDeSJIv/Cp0CMN4t4RX6
        QgxShMv7rSPGHGKHtXew11+2odP6x1wKSZ0tz0FA=
Received: from anirudhrb.com (49.207.206.107 [49.207.206.107]) by mx.zohomail.com
        with SMTPS id 1645460088394764.7856299620081; Mon, 21 Feb 2022 08:14:48 -0800 (PST)
Date:   Mon, 21 Feb 2022 21:44:39 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <YhO6bwu7iDtUFQGj@anirudhrb.com>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 02:59:30PM +0100, Stefano Garzarella wrote:
> On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> > ownership. It expects current->mm to be valid.
> >
> > vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> > the user has not done close(), so when we are in do_exit(). In this
> > case current->mm is invalid and we're releasing the device, so we
> > should clean it anyway.
> >
> > Let's check the owner only when vhost_vsock_stop() is called
> > by an ioctl.
> >
> > Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> > Cc: stable@vger.kernel.org
> > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  drivers/vhost/vsock.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com

I don't think this patch fixes "INFO: task hung in vhost_work_dev_flush"
even though syzbot says so. I am able to reproduce the issue locally
even with this patch applied.

Thanks,

	- Anirudh.

> Reported-and-tested-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com
> 
