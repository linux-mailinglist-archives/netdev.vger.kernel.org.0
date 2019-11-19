Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBC1019EB
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfKSHAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:00:37 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14990 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfKSHAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:00:36 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd3930f0000>; Mon, 18 Nov 2019 23:00:32 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 18 Nov 2019 23:00:34 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 18 Nov 2019 23:00:34 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 07:00:34 +0000
Subject: Re: [PATCH v5 02/24] mm/gup: factor out duplicate code from four
 routines
To:     Jan Kara <jack@suse.cz>
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
        Ira Weiny <ira.weiny@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-3-jhubbard@nvidia.com>
 <20191118094604.GC17319@quack2.suse.cz>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <152e2ea9-edd9-f868-7731-ff467d692f5f@nvidia.com>
Date:   Mon, 18 Nov 2019 23:00:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191118094604.GC17319@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574146832; bh=u3YCRE77HsuXbqK9BxFmzDLl8JhQHMG9gXXaYRfagTQ=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=OHB+eUp2jQQmHLrGYBTtAkydhQax1jgPbRIdqXv/zT7mJheOoxm2jC/o00J+31bDd
         psR1uWZTYTlZpkmYbJIlMzoHbpxnwxoe7ZrZ8UMQNDddfR1HU1k+hUj3JCOx3ZRd5b
         XT8Ag7PAkGX6G4pIQ7geJmQblkDOtgu1RTN+An2f8z0fTBevVuF5GINewI0N+iPfcv
         YgagSYh5LQVW6KL8izWZSAMBRDSFlAEl3uHonusWk1CkuRAUgvh73saFcEMPgIKbUo
         7msrJOumHG3EP3Mzt2Z3Dov3XH2Wq2MWpaj0JPNxYk4UIQaUft9LMOT0FAc0/WGi6i
         OtciRBna4adWA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 1:46 AM, Jan Kara wrote:
> On Thu 14-11-19 21:53:18, John Hubbard wrote:
>> There are four locations in gup.c that have a fair amount of code
>> duplication. This means that changing one requires making the same
>> changes in four places, not to mention reading the same code four
>> times, and wondering if there are subtle differences.
>>
>> Factor out the common code into static functions, thus reducing the
>> overall line count and the code's complexity.
>>
>> Also, take the opportunity to slightly improve the efficiency of the
>> error cases, by doing a mass subtraction of the refcount, surrounded
>> by get_page()/put_page().
>>
>> Also, further simplify (slightly), by waiting until the the successful
>> end of each routine, to increment *nr.
>>
>> Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Ira Weiny <ira.weiny@intel.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
>>  mm/gup.c | 95 ++++++++++++++++++++++++--------------------------------
>>  1 file changed, 40 insertions(+), 55 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 85caf76b3012..858541ea30ce 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -1969,6 +1969,29 @@ static int __gup_device_huge_pud(pud_t pud, pud_t=
 *pudp, unsigned long addr,
>>  }
>>  #endif
>> =20
>> +static int __record_subpages(struct page *page, unsigned long addr,
>> +			     unsigned long end, struct page **pages)
>> +{
>> +	int nr =3D 0;
>> +	int nr_recorded_pages =3D 0;
>> +
>> +	do {
>> +		pages[nr] =3D page;
>> +		nr++;
>> +		page++;
>> +		nr_recorded_pages++;
>> +	} while (addr +=3D PAGE_SIZE, addr !=3D end);
>> +	return nr_recorded_pages;
>=20
> nr =3D=3D nr_recorded_pages so no need for both... BTW, structuring this =
as a
> for loop would be probably more logical and shorter now:
>=20
> 	for (nr =3D 0; addr !=3D end; addr +=3D PAGE_SIZE)
> 		pages[nr++] =3D page++;
> 	return nr;
>=20

Nice touch, I've applied it.

thanks,
--=20
John Hubbard
NVIDIA



> The rest of the patch looks good to me.
>=20
> 								Honza
>=20
