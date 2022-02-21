Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B69B4BEA8D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiBUSL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:11:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiBUSJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:09:23 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7B9E0B4;
        Mon, 21 Feb 2022 09:59:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645466360; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=M4HbPSHqQKqT0lY5KANOxHIA/V18IHgXRINGEiXGa/Ptf2HOQa3nR30sszW3nVQxWhVs+aGf4V6NhW+7xbVXcn20feqImYQIR6YHgNOL6aX04pSjJxfEoKvQ0+w1rfEn9dlhC1LyGDC1reyCFCPCmL0y+N5yjsLB4snyofavBkA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645466360; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=p9FMeARyU/UK9vImcBhCGDjm5/pEu3zr2S3g4npkyi4=; 
        b=MPGB/Id+ZkCzDIp8KMgCJhYGoNDAwQyKrZsTMr19vkAHP278Si9G0ONtgw380G9HTpc5Qgambc+33QeVOLh42aIH+wmCWDZC9Fqhr+RZ2/oFm8I3PdbvPUKPGeayZSbfYWSMz5yNrFdFbn601whG+k4pvlN9b4GeoXYqrkquUYI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645466360;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=p9FMeARyU/UK9vImcBhCGDjm5/pEu3zr2S3g4npkyi4=;
        b=nW2HZOHEfH//uWW8jvCWZnXehAVwQz2Y9aWhD1Tairk9+2GwmGPc1tGFXbH1qLZL
        GoEY0xM1CTs7GKRiqTSg+e4Ka3nZXhXpHMs1K2DTTXGdq3BTQdIS5O7EqQyApp5WPpG
        MtVaPsQqZm4zsH0d0mexgLG6Dtj03IlkCq24yU80=
Received: from anirudhrb.com (49.207.206.107 [49.207.206.107]) by mx.zohomail.com
        with SMTPS id 1645466358576851.8410784523194; Mon, 21 Feb 2022 09:59:18 -0800 (PST)
Date:   Mon, 21 Feb 2022 23:29:11 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: handle zero regions in vhost_set_memory
Message-ID: <YhPS78dGWh3LY+8t@anirudhrb.com>
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

Oh you're right. My bad! The problem is actually elsewhere.

> 
> In any case maybe this patch is fine, but currently I think we're just
> registering an iotlb without any regions, which in theory shouldn't cause
> any problems.

Yeah, there shouldn't be any problems here. The problem actually seems
to be in vhost_process_iotlb_msg() where we end up adding a zero sized
region to the iotlb. I will send a new patch...

Thanks!
	- Anirudh.

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
