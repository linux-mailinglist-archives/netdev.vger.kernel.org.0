Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDDE4BEB47
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiBUThC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 14:37:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiBUThB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 14:37:01 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E47220C0;
        Mon, 21 Feb 2022 11:36:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645472182; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ELj0qaZrVN9+8/MbO+oZkcjZjej+CF9JdOrfBe3B4612MQ9YQxt0D2biwawvkS8riJ5x/basfuC0Vd7/D5CkmnY9auKmtpo3q+p2NM+vWR39OlwtBGjXiUD9fQRS3lAxyagUn158CHDdOoKpanNccHL5Ungs9IpMhM8trLKOLTM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645472182; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=6HIcSMjNNH8sPwVcXqKBcDlV55UD/Yv/2pTDKIr+ocU=; 
        b=W5nVL2dsKwNzJaCQiR0lgx7zD5YZltP8apKkMOFxqWW4be2xaymyNEn4UJ+48DEidBtSDkogC5mTf7bfm2v5HPBx550xiTrcc7vtG7K5VCt8OELDPN11o0j3HTejSnOsWUUf9wU5bHfEqs54fAU28IoRnsxDSuoMivhKAM3u8gg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645472182;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=6HIcSMjNNH8sPwVcXqKBcDlV55UD/Yv/2pTDKIr+ocU=;
        b=lMuTQHsMi3arXTC0WpQxU3pDwjuzhbJSSzs1LMwKERZ/Q11XIBnOhoiDUeby1khs
        TJgzhsi9L4qXS+wNBk286ba7/nxo1nSfJw8LDKAylAgFrUgcDfoaM3KfzWQX739ssuB
        xqRDPRve3rDXLzo0+d++a92drVyW80MUBUVeuTGY=
Received: from anirudhrb.com (49.207.206.107 [49.207.206.107]) by mx.zohomail.com
        with SMTPS id 1645472180057230.55490921676846; Mon, 21 Feb 2022 11:36:20 -0800 (PST)
Date:   Tue, 22 Feb 2022 01:06:12 +0530
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
Message-ID: <YhPprNUAqYS3RVtU@anirudhrb.com>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
 <YhO6bwu7iDtUFQGj@anirudhrb.com>
 <20220221164420.cnhs6sgxizc6tcok@sgarzare-redhat>
 <YhPT37ETuSfmxr5G@anirudhrb.com>
 <20220221182628.vy2bjntxnzqh7elj@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221182628.vy2bjntxnzqh7elj@sgarzare-redhat>
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

On Mon, Feb 21, 2022 at 07:26:28PM +0100, Stefano Garzarella wrote:
> On Mon, Feb 21, 2022 at 11:33:11PM +0530, Anirudh Rayabharam wrote:
> > On Mon, Feb 21, 2022 at 05:44:20PM +0100, Stefano Garzarella wrote:
> > > On Mon, Feb 21, 2022 at 09:44:39PM +0530, Anirudh Rayabharam wrote:
> > > > On Mon, Feb 21, 2022 at 02:59:30PM +0100, Stefano Garzarella wrote:
> > > > > On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > > > >
> > > > > > vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> > > > > > ownership. It expects current->mm to be valid.
> > > > > >
> > > > > > vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> > > > > > the user has not done close(), so when we are in do_exit(). In this
> > > > > > case current->mm is invalid and we're releasing the device, so we
> > > > > > should clean it anyway.
> > > > > >
> > > > > > Let's check the owner only when vhost_vsock_stop() is called
> > > > > > by an ioctl.
> > > > > >
> > > > > > Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> > > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > ---
> > > > > >  drivers/vhost/vsock.c | 14 ++++++++------
> > > > > >  1 file changed, 8 insertions(+), 6 deletions(-)
> > > > >
> > > > > Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > >
> > > > I don't think this patch fixes "INFO: task hung in vhost_work_dev_flush"
> > > > even though syzbot says so. I am able to reproduce the issue locally
> > > > even with this patch applied.
> > > 
> > > Are you using the sysbot reproducer or another test?
> > > In that case, can you share it?
> > 
> > I am using the syzbot reproducer.
> > 
> > > 
> > > From the stack trace it seemed to me that the worker accesses a zone that
> > > has been cleaned (iotlb), so it is invalid and fails.
> > 
> > Would the thread hang in that case? How?
> 
> Looking at this log [1] it seems that the process is blocked on the
> wait_for_completion() in vhost_work_dev_flush().
> 
> Since we're not setting the backend to NULL to stop the worker, it's likely
> that the worker will keep running, preventing the flush work from
> completing.

The log shows that the worker thread is stuck in iotlb_access_ok(). How
will setting the backend to NULL stop it? During my debugging I found
that the worker is stuck in this while loop:

1361         while (len > s) {                                                                     
1362                 map = vhost_iotlb_itree_first(umem, addr, last);                        
1363                 if (map == NULL || map->start > addr) {                                 
1364                         vhost_iotlb_miss(vq, addr, access);     
1365                         return false;                      
1366                 } else if (!(map->perm & access)) {        
1367                         /* Report the possible access violation by
1368                          * request another translation from userspace.    
1369                          */                                           
1370                         return false;                                 
1371                 }                      
1372                                          
1373                 pr_info("iotlb_access_ok: after msize=%llu, mstart=%llu\n",
1374                                 map->size, map->start);                    
1375                 size = map->size - addr + map->start;                      
1376                                                             
1377                 if (orig_addr == addr && size >= len)       
1378                         vhost_vq_meta_update(vq, map, type);                      
1379                                                                                   
1380                 s += size;                                                        
1381                 addr += size;                                                     
1382         }

> 
> [1] https://syzkaller.appspot.com/text?tag=CrashLog&x=153f0852700000
> 
