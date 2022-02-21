Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FB04BEA71
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiBUSOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:14:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiBUSMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:12:34 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B56E195;
        Mon, 21 Feb 2022 10:03:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645466599; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=YZyMF51P4+/S3dlgHlVUpxcI7aWblCY2sMq8Mn+tA5JO5mh2/dGB1qSkvIywCFZMGWxNADVWG3JvceJWo0j+8DnPkt+j7/d35uztkjl9wjpIxh+ucPTAl/0dwHmt02PiaSqHXZkWlXmlSrnaP9egmkFqAdSN/rSxunRFP5K6acQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645466599; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=fsIUXYehvEEwhdbyTVnwdNs58dADoiqa7FrNZpH5MvQ=; 
        b=NvDSgUrgG2JK77anNLKyUhkXHdKaC5MSGK1LjlVJNAnX5Jsbw6nmpyNvN6KfcDUM2VMW6N9R9vG+/YOplUKG/kTA4BtA1JZXTrvNHiztsWiWwXGA3sXBTApJnJCNXkgaYF2kKSiP1zheqAuAmUSXEKYqvjJlkILzmbKoFeE3Jxk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645466599;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=fsIUXYehvEEwhdbyTVnwdNs58dADoiqa7FrNZpH5MvQ=;
        b=pIbnLjTv5NJg42fxoUE97UNJyrtYslgTpEEwhf8FdicVjVcQBYZsqyxvEUboafkZ
        +VGYCbnfFkHHKrPiu0l0pSOhitli54K1wStQJTP0RNkgCZWmc6Ak+xTpQ5S0zM6dSg7
        sFjN+o6xvbtIPIpq2CvLUxXU6P1j5MMzaqloFxPY=
Received: from anirudhrb.com (49.207.206.107 [49.207.206.107]) by mx.zohomail.com
        with SMTPS id 1645466598393587.852076311628; Mon, 21 Feb 2022 10:03:18 -0800 (PST)
Date:   Mon, 21 Feb 2022 23:33:11 +0530
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
Message-ID: <YhPT37ETuSfmxr5G@anirudhrb.com>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
 <YhO6bwu7iDtUFQGj@anirudhrb.com>
 <20220221164420.cnhs6sgxizc6tcok@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221164420.cnhs6sgxizc6tcok@sgarzare-redhat>
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

On Mon, Feb 21, 2022 at 05:44:20PM +0100, Stefano Garzarella wrote:
> On Mon, Feb 21, 2022 at 09:44:39PM +0530, Anirudh Rayabharam wrote:
> > On Mon, Feb 21, 2022 at 02:59:30PM +0100, Stefano Garzarella wrote:
> > > On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > >
> > > > vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> > > > ownership. It expects current->mm to be valid.
> > > >
> > > > vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> > > > the user has not done close(), so when we are in do_exit(). In this
> > > > case current->mm is invalid and we're releasing the device, so we
> > > > should clean it anyway.
> > > >
> > > > Let's check the owner only when vhost_vsock_stop() is called
> > > > by an ioctl.
> > > >
> > > > Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> > > > Cc: stable@vger.kernel.org
> > > > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > ---
> > > >  drivers/vhost/vsock.c | 14 ++++++++------
> > > >  1 file changed, 8 insertions(+), 6 deletions(-)
> > > 
> > > Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > 
> > I don't think this patch fixes "INFO: task hung in vhost_work_dev_flush"
> > even though syzbot says so. I am able to reproduce the issue locally
> > even with this patch applied.
> 
> Are you using the sysbot reproducer or another test?
> In that case, can you share it?

I am using the syzbot reproducer.

> 
> From the stack trace it seemed to me that the worker accesses a zone that
> has been cleaned (iotlb), so it is invalid and fails.

Would the thread hang in that case? How?

Thanks,

	- Anirudh.

> That's why I had this patch tested which should stop the worker before
> cleaning.
> 
> Thanks,
> Stefano
> 
