Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B81742A8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 02:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbfGYAop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 20:44:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387421AbfGYAoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 20:44:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6P0dlXf171093;
        Thu, 25 Jul 2019 00:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=gv2SPbpkF9xScJE1PHpWHpgE3ifu6hFMD2cmVIyD7TY=;
 b=muZVds6swMHMAuFbMxKchNkOUd8CqTrPV0KBCMC49yrWg/LxnLuU6ow/RmgyiMUnnjmy
 MAiRa6Zm+jzf7B99ZPeMXmyGgQxIYQlCeWqFQqyGoNTjbspAoTiqbjfg4/VmNuRd7Vm5
 HrFVwz2k57PMYa/HPZcBBc0f5omPk+LrAWZPjNDUaWWol7Y67+yRcy8wbGU1Wbct1RLH
 zVzTyoIxGQlKet79OucxPmXfLkDZ0FkQP1v/RZBYzmhhy8PDfe/AB0YbSVtLklYjMvP9
 lz6P71WYbBjNCITeo6xlPXLd7l7LVGerjJLbDawimLUiySB/y4c3YF5VO7XLIrxNTkjP MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tx61c0gjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 00:41:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6P0beDT189084;
        Thu, 25 Jul 2019 00:41:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tx60yhed4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 00:41:24 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6P0fGBA002510;
        Thu, 25 Jul 2019 00:41:16 GMT
Received: from [192.168.1.14] (/180.165.87.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jul 2019 17:41:15 -0700
Subject: Re: [PATCH 00/12] block/bio, fs: convert put_page() to
 put_user_page*()
To:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, ceph-devel@vger.kernel.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        v9fs-developer@lists.sourceforge.net,
        virtualization@lists.linux-foundation.org,
        John Hubbard <jhubbard@nvidia.com>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <8621066c-e242-c449-eb04-4f2ce6867140@oracle.com>
Date:   Thu, 25 Jul 2019 08:41:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190724042518.14363-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9328 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9328 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/19 12:25 PM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> Hi,
> 
> This is mostly Jerome's work, converting the block/bio and related areas
> to call put_user_page*() instead of put_page(). Because I've changed
> Jerome's patches, in some cases significantly, I'd like to get his
> feedback before we actually leave him listed as the author (he might
> want to disown some or all of these).
> 

Could you add some background to the commit log for people don't have the context..
Why this converting? What's the main differences?

Regards, -Bob

> I added a new patch, in order to make this work with Christoph Hellwig's
> recent overhaul to bio_release_pages(): "block: bio_release_pages: use
> flags arg instead of bool".
> 
> I've started the series with a patch that I've posted in another
> series ("mm/gup: add make_dirty arg to put_user_pages_dirty_lock()"[1]),
> because I'm not sure which of these will go in first, and this allows each
> to stand alone.
> 
> Testing: not much beyond build and boot testing has been done yet. And
> I'm not set up to even exercise all of it (especially the IB parts) at
> run time.
> 
> Anyway, changes here are:
> 
> * Store, in the iov_iter, a "came from gup (get_user_pages)" parameter.
>   Then, use the new iov_iter_get_pages_use_gup() to retrieve it when
>   it is time to release the pages. That allows choosing between put_page()
>   and put_user_page*().
> 
> * Pass in one more piece of information to bio_release_pages: a "from_gup"
>   parameter. Similar use as above.
> 
> * Change the block layer, and several file systems, to use
>   put_user_page*().
> 
> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_r_20190724012606.25844-2D2-2Djhubbard-40nvidia.com&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=FpFhv2rjbKCAYGmO6Hy8WJAottr1Qz_mDKDLObQ40FU&s=q-_mX3daEr22WbdZMElc_ZbD8L9oGLD7U0xLeyJ661Y&e= 
>     And please note the correction email that I posted as a follow-up,
>     if you're looking closely at that patch. :) The fixed version is
>     included here.
> 
> John Hubbard (3):
>   mm/gup: add make_dirty arg to put_user_pages_dirty_lock()
>   block: bio_release_pages: use flags arg instead of bool
>   fs/ceph: fix a build warning: returning a value from void function
> 
> Jérôme Glisse (9):
>   iov_iter: add helper to test if an iter would use GUP v2
>   block: bio_release_pages: convert put_page() to put_user_page*()
>   block_dev: convert put_page() to put_user_page*()
>   fs/nfs: convert put_page() to put_user_page*()
>   vhost-scsi: convert put_page() to put_user_page*()
>   fs/cifs: convert put_page() to put_user_page*()
>   fs/fuse: convert put_page() to put_user_page*()
>   fs/ceph: convert put_page() to put_user_page*()
>   9p/net: convert put_page() to put_user_page*()
> 
>  block/bio.c                                |  81 ++++++++++++---
>  drivers/infiniband/core/umem.c             |   5 +-
>  drivers/infiniband/hw/hfi1/user_pages.c    |   5 +-
>  drivers/infiniband/hw/qib/qib_user_pages.c |   5 +-
>  drivers/infiniband/hw/usnic/usnic_uiom.c   |   5 +-
>  drivers/infiniband/sw/siw/siw_mem.c        |   8 +-
>  drivers/vhost/scsi.c                       |  13 ++-
>  fs/block_dev.c                             |  22 +++-
>  fs/ceph/debugfs.c                          |   2 +-
>  fs/ceph/file.c                             |  62 ++++++++---
>  fs/cifs/cifsglob.h                         |   3 +
>  fs/cifs/file.c                             |  22 +++-
>  fs/cifs/misc.c                             |  19 +++-
>  fs/direct-io.c                             |   2 +-
>  fs/fuse/dev.c                              |  22 +++-
>  fs/fuse/file.c                             |  53 +++++++---
>  fs/nfs/direct.c                            |  10 +-
>  include/linux/bio.h                        |  22 +++-
>  include/linux/mm.h                         |   5 +-
>  include/linux/uio.h                        |  11 ++
>  mm/gup.c                                   | 115 +++++++++------------
>  net/9p/trans_common.c                      |  14 ++-
>  net/9p/trans_common.h                      |   3 +-
>  net/9p/trans_virtio.c                      |  18 +++-
>  24 files changed, 357 insertions(+), 170 deletions(-)
> 

