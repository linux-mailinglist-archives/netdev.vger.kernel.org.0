Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED23891A5
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354594AbhESOpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:45:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354506AbhESOok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:44:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JEd2KO076034;
        Wed, 19 May 2021 14:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Lt2hzPnb+NaXsGPtTy/7AUf2I0EdmAttqobMWgtZO9Q=;
 b=u/a9JuWdYxQLkNIDHI58hoDcvb9f1BrHnAwP+LQbVKVG9TQeMnReuLceUmigqnbBssKn
 fo9XI/KuRKxFhfQ2Z7tBBxnoJLJI2ShvfWWNCsJknUw9NBhHgfb1jyjUd++1ct0ZERo1
 51aES+nCLTAwVyP7BlueT1SayrJqrwDROmowex7349T8YZjIFKdWIVfDdm+QSflVQUKi
 IN/Ul7VMaaaOZi82UdSfSLzdagrkLWvAaFMm2VV2hZ7pBmxEiUwLE1/3AMB+4O/7HAUt
 BeB1p9SOPW7RadgJsAx7Wz7eA3EU/+VI5mHvijoLDiMZ0p16N/jjGcC3CY2XxSv5j83R Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38j5qr9tcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:42:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JEe8gP099338;
        Wed, 19 May 2021 14:42:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38mecjdan2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:42:28 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14JEgROO125671;
        Wed, 19 May 2021 14:42:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 38mecjdajd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:42:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14JEgIBB019066;
        Wed, 19 May 2021 14:42:18 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 07:42:17 -0700
Date:   Wed, 19 May 2021 17:42:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        joro@8bytes.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 04/12] virtio-blk: Add validation for block size in
 config space
Message-ID: <20210519144206.GF32682@kadam>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-5-xieyongji@bytedance.com>
 <CACycT3s1rEvNnNkJKQsHGRsyLPADieFdVkb1Sp3GObR0Vox5Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3s1rEvNnNkJKQsHGRsyLPADieFdVkb1Sp3GObR0Vox5Fg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: tKs3QWAbwVfnDVYAmbW5IXOFge9uFM4u
X-Proofpoint-ORIG-GUID: tKs3QWAbwVfnDVYAmbW5IXOFge9uFM4u
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 09:39:20PM +0800, Yongji Xie wrote:
> On Mon, May 17, 2021 at 5:56 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> >
> > This ensures that we will not use an invalid block size
> > in config space (might come from an untrusted device).

I looked at if I should add this as an untrusted function so that Smatch
could find these sorts of bugs but this is reading data from the host so
there has to be some level of trust...

I should add some more untrusted data kvm functions to Smatch.  Right
now I only have kvm_register_read() and I've added kvm_read_guest_virt()
just now.

> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  drivers/block/virtio_blk.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index ebb4d3fe803f..c848aa36d49b 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -826,7 +826,7 @@ static int virtblk_probe(struct virtio_device *vdev)
> >         err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
> >                                    struct virtio_blk_config, blk_size,
> >                                    &blk_size);
> > -       if (!err)
> > +       if (!err && blk_size > 0 && blk_size <= max_size)
> 
> The check here is incorrect. I will use PAGE_SIZE as the maximum
> boundary in the new version.

What does this bug look like to the user?  A minimum block size of 1
seems pretty crazy.  Surely the minimum should be higher?

regards,
dan carpenter

