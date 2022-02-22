Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C7A4C0029
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbiBVR20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiBVR2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:28:25 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE72616FDE4;
        Tue, 22 Feb 2022 09:27:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645550874; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=eMXn7nOmASwwv8/t2aoVCHxSO4EwQZlrTpysveTHxR6OwSReFt/VRsYY+RACyYit/BCRpGoLdyaq83PWIluLiORR2bxWSwZWnqsJ1dUKrhdQ2AnbBryuKOSRXMIdF0Jo54nKNIwAP+c+iNMFWb9Ff5ytQ7mXDHIMMxwxrFRDJIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645550874; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ew2wKyPNrw+QVX3xBcY5H5zCBKf3+z6sDwLHCQhCBVY=; 
        b=Qjt0nWpzwLW/Lr5OMRKTqTPjzv80Y84XJkI4DP6E5j8+/m2CsaiL5YAZ0CRV76GnV14/bay3syueLKNiE9KQVkjJQeaNLByJ8pP+nMH4fPx9J3jP1KPEX0FSzeURaQPV3h1XqgvqxP3LW6uU8PM7cEhjQHKKh3zVXWcsRTk8HhA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645550874;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=ew2wKyPNrw+QVX3xBcY5H5zCBKf3+z6sDwLHCQhCBVY=;
        b=OWCMDtiBzWLS9bNAv/kKTa8luEdB0RADHpxmoJFGID4s7Y/yBRWvhq4rv//fhPcE
        jdfLFRpn4CTDdfZjYCYZcqSQbBB35VCXHfD6QSR9xRhI98IueyNAtf/ZYHy9wgX1YUq
        5YLhwiYnWuwMBzKrDbmGgQP80NynpxB22zBHsyNE=
Received: from anirudhrb.com (49.207.218.248 [49.207.218.248]) by mx.zohomail.com
        with SMTPS id 1645550870229262.7087263657254; Tue, 22 Feb 2022 09:27:50 -0800 (PST)
Date:   Tue, 22 Feb 2022 22:57:41 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vhost: validate range size before adding to iotlb
Message-ID: <YhUdDUSxuXTLltpZ@anirudhrb.com>
References: <20220221195303.13560-1-mail@anirudhrb.com>
 <CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com>
 <YhRtQEWBF0kqWMsI@anirudhrb.com>
 <CACGkMEvd7ETC_ANyrOSAVz_i64xqpYYazmm=+39E51=DMRFXdw@mail.gmail.com>
 <20220222090511-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222090511-mutt-send-email-mst@kernel.org>
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

On Tue, Feb 22, 2022 at 10:02:29AM -0500, Michael S. Tsirkin wrote:
> On Tue, Feb 22, 2022 at 03:11:07PM +0800, Jason Wang wrote:
> > On Tue, Feb 22, 2022 at 12:57 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> > >
> > > On Tue, Feb 22, 2022 at 10:50:20AM +0800, Jason Wang wrote:
> > > > On Tue, Feb 22, 2022 at 3:53 AM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> > > > >
> > > > > In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
> > > > > before proceeding with adding it to the iotlb.
> > > > >
> > > > > Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > > > One instance where it can happen is when userspace sends an IOTLB
> > > > > message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
> > > > > entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
> > > > > iotlb. Next time a packet is sent, iotlb_access_ok() loops
> > > > > indefinitely due to that erroneous entry:
> > > > >
> > > > >         Call Trace:
> > > > >          <TASK>
> > > > >          iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
> > > > >          vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
> > > > >          vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
> > > > >          vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> > > > >          kthread+0x2e9/0x3a0 kernel/kthread.c:377
> > > > >          ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > > > >          </TASK>
> > > > >
> > > > > Reported by syzbot at:
> > > > >         https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> > > > >
> > > > > Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > > > Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > > > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > > > > ---
> > > > >  drivers/vhost/iotlb.c | 6 ++++--
> > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> > > > > index 670d56c879e5..b9de74bd2f9c 100644
> > > > > --- a/drivers/vhost/iotlb.c
> > > > > +++ b/drivers/vhost/iotlb.c
> > > > > @@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > > > >                               void *opaque)
> > > > >  {
> > > > >         struct vhost_iotlb_map *map;
> > > > > +       u64 size = last - start + 1;
> > > > >
> > > > > -       if (last < start)
> > > > > +       // size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > > > +       if (last < start || size == 0)
> > > > >                 return -EFAULT;
> > > >
> > > > I'd move this check to vhost_chr_iter_write(), then for the device who
> > > > has its own msg handler (e.g vDPA) can benefit from it as well.
> > >
> > > Thanks for reviewing!
> > >
> > > I kept the check here thinking that all devices would benefit from it
> > > because they would need to call vhost_iotlb_add_range() to add an entry
> > > to the iotlb. Isn't that correct?
> > 
> > Correct for now but not for the future, it's not guaranteed that the
> > per device iotlb message handler will use vhost iotlb.
> > 
> > But I agree that we probably don't need to care about it too much now.
> > 
> > > Do you see any other benefit in moving
> > > it to vhost_chr_iter_write()?
> > >
> > > One concern I have is that if we move it out some future caller to
> > > vhost_iotlb_add_range() might forget to handle this case.
> > 
> > Yes.
> > 
> > Rethink the whole fix, we're basically rejecting [0, ULONG_MAX] range
> > which seems a little bit odd.
> 
> Well, I guess ideally we'd split this up as two entries - this kind of
> thing is after all one of the reasons we initially used first,last as
> the API - as opposed to first,size.

IIUC, the APIs exposed to userspace accept first,size. Which means that
right now there is now way for userspace to map this range. So, is there
any value in not simply rejecting this range?

> 
> Anirudh, could you do it like this instead of rejecting?
> 
> 
> > I wonder if it's better to just remove
> > the map->size. Having a quick glance at the the user, I don't see any
> > blocker for this.
> > 
> > Thanks
> 
> I think it's possible but won't solve the bug by itself, and we'd need
> to review and fix all users - a high chance of introducing
> another regression. 

Agreed, I did a quick review of the usages and getting rid of size
didn't seem trivial.

Thanks,

	- Anirudh.

> And I think there's value of fitting under the
> stable rule of 100 lines with context.
> So sure, but let's fix the bug first.
> 
> 
> 
> > >
> > > Thanks!
> > >
> > >         - Anirudh.
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > >         if (iotlb->limit &&
> > > > > @@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > > > >                 return -ENOMEM;
> > > > >
> > > > >         map->start = start;
> > > > > -       map->size = last - start + 1;
> > > > > +       map->size = size;
> > > > >         map->last = last;
> > > > >         map->addr = addr;
> > > > >         map->perm = perm;
> > > > > --
> > > > > 2.35.1
> > > > >
> > > >
> > >
> 
