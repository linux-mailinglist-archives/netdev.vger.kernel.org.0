Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2B2803D2
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 03:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403994AbfHCBlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 21:41:42 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14532 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387864AbfHCBll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 21:41:41 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d44e6540001>; Fri, 02 Aug 2019 18:41:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 02 Aug 2019 18:41:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 02 Aug 2019 18:41:39 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 3 Aug
 2019 01:41:38 +0000
Subject: Re: [PATCH 31/34] nfs: convert put_page() to put_user_page*()
To:     Calum Mackay <calum.mackay@oracle.com>, <john.hubbard@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <amd-gfx@lists.freedesktop.org>, <ceph-devel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <devel@lists.orangefs.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-block@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-nfs@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-xfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <sparclinux@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-32-jhubbard@nvidia.com>
 <1738cb1e-15d8-0bbe-5362-341664f6efc8@oracle.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <db136399-ed87-56ea-bd6e-e5d29b145eda@nvidia.com>
Date:   Fri, 2 Aug 2019 18:41:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1738cb1e-15d8-0bbe-5362-341664f6efc8@oracle.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564796500; bh=zc1wJBCk6oa4TZJ5kpnxYLs8I/mCQFC0KqXiV/MQqAc=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=OLRFKsHoXBw1TGfx4yjE0Mz6/NwSHjUP/99RYZUV8BmAJcU3vy970b00AWaqBbqwn
         eDliId8mLescIf+v3MwQ2SrvN7VrnEwLTirEIw8jXzAjeXgqN3dtxI2Suyrp0L+f3G
         YPfLBq5YLuEzykUeYyNQ/IXUTk0ew3pKoxF86cxfpvc0Iih+8axjrF9wmXCYOssEh/
         dFyCupj1u3LqFaTu0iXYZzaL8I/Fkdd+Hdao45WQIFetVoCK43sV9CCZfHZ6uY+1an
         0Rm4XSFjiP2H1hfdLpXkesSoEJK75cPPtD+8sANcEv6R5DjbxYeg7dbcB8wnnzerOG
         BX10+9E+Fxe0Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 6:27 PM, Calum Mackay wrote:
> On 02/08/2019 3:20 am, john.hubbard@gmail.com wrote:
...=20
> Since it's static, and only called twice, might it be better to change it=
s two callers [nfs_direct_{read,write}_schedule_iovec()] to call put_user_p=
ages() directly, and remove nfs_direct_release_pages() entirely?
>=20
> thanks,
> calum.
>=20
>=20
>> =C2=A0 =C2=A0 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinf=
o,
>>
=20
Hi Calum,

Absolutely! Is it OK to add your reviewed-by, with the following incrementa=
l
patch made to this one?

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index b00b89dda3c5..c0c1b9f2c069 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -276,11 +276,6 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_i=
ter *iter)
        return nfs_file_direct_write(iocb, iter);
 }
=20
-static void nfs_direct_release_pages(struct page **pages, unsigned int npa=
ges)
-{
-       put_user_pages(pages, npages);
-}
-
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
                              struct nfs_direct_req *dreq)
 {
@@ -510,7 +505,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nf=
s_direct_req *dreq,
                        pos +=3D req_len;
                        dreq->bytes_left -=3D req_len;
                }
-               nfs_direct_release_pages(pagevec, npages);
+               put_user_pages(pagevec, npages);
                kvfree(pagevec);
                if (result < 0)
                        break;
@@ -933,7 +928,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct n=
fs_direct_req *dreq,
                        pos +=3D req_len;
                        dreq->bytes_left -=3D req_len;
                }
-               nfs_direct_release_pages(pagevec, npages);
+               put_user_pages(pagevec, npages);
                kvfree(pagevec);
                if (result < 0)
                        break;



thanks,
--=20
John Hubbard
NVIDIA
