Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897244BEB78
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbiBUT6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 14:58:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiBUT6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 14:58:11 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC25C22531;
        Mon, 21 Feb 2022 11:57:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645473463; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=GFCIllRM0JXstnfQu9dNJpdQ1FXf/mLTbryY4AGBuFfplzvxcLxU4zEfUaqf0ex6Rmbtm1Zz1vaR/hGOQURrYCQJeIPi6uwz0i1vKck76P5vur4/2EmtxWnIiM0d6HqTvelA7XaGVFvGhqTzyqp5qzAYMmJL8BWht0P6WyWtyQk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645473463; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qgsrilDNczksuq7T/Z/KkzqksxwwWB5R95lUSLH4//U=; 
        b=iVoUitgIWGeSz5o7a4BMa7xPpmJsb++7kuKpuYuszNg9N5QN4X2ZHnlV1VThC2Z13DGQwn20fimXqdbnIGs5SzS7BsOBsdnNVPUIsS+0bCP/FDRZPkTOkT3PSjJfdO712N95rzOlTKG/srj3b/pE1ReFvcui3poAhQIpi2YQ7Do=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645473463;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=qgsrilDNczksuq7T/Z/KkzqksxwwWB5R95lUSLH4//U=;
        b=OmkZ9IRBCeIMYWEmEyk8ni0n+jZqP1SqJcMlER3IOqdAB9buvzG752p8HOB2DT+P
        pSXv5ZBk01wvMNfJ9lVi28rM2/t8LjesDFZTIzrt5ktfJAVQXxrYrEypdKaKzSXkDS5
        UyI9TIwRnOg36eFZAkquCNhEWYZ1TKSwvcQ0lzyY=
Received: from anirudhrb.com (49.207.206.107 [49.207.206.107]) by mx.zohomail.com
        with SMTPS id 1645473461841291.94881628695555; Mon, 21 Feb 2022 11:57:41 -0800 (PST)
Date:   Tue, 22 Feb 2022 01:27:35 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: handle zero regions in vhost_set_memory
Message-ID: <YhPur8ymuiiHirUc@anirudhrb.com>
References: <20220221072852.31820-1-mail@anirudhrb.com>
 <20220221164817.obpw477w74auxlkn@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221164817.obpw477w74auxlkn@sgarzare-redhat>
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

On Mon, Feb 21, 2022 at 05:48:17PM +0100, Stefano Garzarella wrote:
> On Mon, Feb 21, 2022 at 12:58:51PM +0530, Anirudh Rayabharam wrote:
> > Return early when userspace sends zero regions in the VHOST_SET_MEM_TABLE
> > ioctl.
> > 
> > Otherwise, this causes an erroneous entry to be added to the iotlb. This
> > entry has a range size of 0 (due to u64 overflow). This then causes
> > iotlb_access_ok() to loop indefinitely resulting in a hung thread.
> > Syzbot has reported this here:
> > 
> > https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> 
> IIUC vhost_iotlb_add_range() in the for loop is never called if mem.nregions
> is 0, so I'm not sure the problem reported by syzbot is related.
> 
> In any case maybe this patch is fine, but currently I think we're just
> registering an iotlb without any regions, which in theory shouldn't cause
> any problems.

Sent a new patch: https://lore.kernel.org/lkml/20220221195303.13560-1-mail@anirudhrb.com/T/#u

> 
> Thanks,
> Stefano
> 
> > 
> > Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > ---
> > drivers/vhost/vhost.c | 2 ++
> > 1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 59edb5a1ffe2..821aba60eac2 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1428,6 +1428,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
> > 		return -EFAULT;
> > 	if (mem.padding)
> > 		return -EOPNOTSUPP;
> > +	if (mem.nregions == 0)
> > +		return 0;
> > 	if (mem.nregions > max_mem_regions)
> > 		return -E2BIG;
> > 	newmem = kvzalloc(struct_size(newmem, regions, mem.nregions),
> > -- 
> > 2.35.1
> > 
> 
