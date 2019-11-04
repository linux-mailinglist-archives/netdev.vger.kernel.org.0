Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B859EE749
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfKDSW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:22:26 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16082 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfKDSWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 13:22:25 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc06c670000>; Mon, 04 Nov 2019 10:22:31 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 10:22:24 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 Nov 2019 10:22:24 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Nov
 2019 18:22:23 +0000
Subject: Re: [PATCH v2 09/18] drm/via: set FOLL_PIN via pin_user_pages_fast()
To:     Jerome Glisse <jglisse@redhat.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-10-jhubbard@nvidia.com>
 <20191104174445.GF5134@redhat.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <880dbf76-ba9d-2555-27e4-a656c7cd3296@nvidia.com>
Date:   Mon, 4 Nov 2019 10:22:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104174445.GF5134@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572891751; bh=6jW45wKOFDFKBEg0lZ7bTretxwwJVIL7ATzyqCLqcEs=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=q+cPcxTzijEgiG71VTi3ghLiE7GfTQ4coAPAv62hXRzzfbJrqL72vvQzW31t6ElHl
         a14GEr0QvEJ+EgWUGUZvr/G/dg/DO160GJKTWSZ2RJb00ZyoxmozrYK/r7pBI/oTMl
         Ler5Xg8wJ+ZN2h3kBmHfP9Sw6IyvnOUkYQcpRlRzW+raDfRYi607iZ0w1mGtWLJDUd
         OeC58odM3LRQFDuOqtEG4EL4fTJQzFx4oBwJjsq4w851X4PvmAFvjIH2kPLRjgrU0s
         pJjSO5ccYyyba2k6piwVKSCGegs79Mk1YqTR+mkcxWQJ+CLl9VNfnFD05lp5bT2fCz
         LMXjtLCzRFCYw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 9:44 AM, Jerome Glisse wrote:
> On Sun, Nov 03, 2019 at 01:18:04PM -0800, John Hubbard wrote:
>> Convert drm/via to use the new pin_user_pages_fast() call, which sets
>> FOLL_PIN. Setting FOLL_PIN is now required for code that requires
>> tracking of pinned pages, and therefore for any code that calls
>> put_user_page().
>>
>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>=20
> Please be more explicit that via_dmablit.c is already using put_user_page=
()
> as i am expecting that any conversion to pin_user_pages*() must be pair w=
ith
> a put_user_page(). I find above commit message bit unclear from that POV.
>=20

OK. This one, and the fs/io_uring (patch 9) and net/xdp (patch 10) were all
cases that had put_user_page() pre-existing. I will add something like the=
=20
following to each commit description, for v3:

In partial anticipation of this work, the drm/via driver was already=20
calling put_user_page() instead of put_page(). Therefore, in order to
convert from the get_user_pages()/put_page() model, to the
pin_user_pages()/put_user_page() model, the only change required
is to change get_user_pages() to pin_user_pages().

thanks,

John Hubbard
NVIDIA

> Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
>=20
>=20
>> ---
>>  drivers/gpu/drm/via/via_dmablit.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via=
_dmablit.c
>> index 3db000aacd26..37c5e572993a 100644
>> --- a/drivers/gpu/drm/via/via_dmablit.c
>> +++ b/drivers/gpu/drm/via/via_dmablit.c
>> @@ -239,7 +239,7 @@ via_lock_all_dma_pages(drm_via_sg_info_t *vsg,  drm_=
via_dmablit_t *xfer)
>>  	vsg->pages =3D vzalloc(array_size(sizeof(struct page *), vsg->num_page=
s));
>>  	if (NULL =3D=3D vsg->pages)
>>  		return -ENOMEM;
>> -	ret =3D get_user_pages_fast((unsigned long)xfer->mem_addr,
>> +	ret =3D pin_user_pages_fast((unsigned long)xfer->mem_addr,
>>  			vsg->num_pages,
>>  			vsg->direction =3D=3D DMA_FROM_DEVICE ? FOLL_WRITE : 0,
>>  			vsg->pages);
>> --=20
>> 2.23.0
>>
>=20
>=20
