Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B0B86F45
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405390AbfHIB0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:26:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16697 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405142AbfHIB0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:26:44 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d4ccbd50000>; Thu, 08 Aug 2019 18:26:45 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 08 Aug 2019 18:26:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 08 Aug 2019 18:26:43 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Aug
 2019 01:26:42 +0000
Subject: Re: [PATCH v3 38/41] powerpc: convert put_page() to put_user_page*()
To:     Michael Ellerman <mpe@ellerman.id.au>,
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
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Hellwig <hch@lst.de>, <linuxppc-dev@lists.ozlabs.org>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
 <20190807013340.9706-39-jhubbard@nvidia.com>
 <87k1botdpx.fsf@concordia.ellerman.id.au>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <248c9ab2-93cc-6d8b-606d-d85b83e791e5@nvidia.com>
Date:   Thu, 8 Aug 2019 18:26:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87k1botdpx.fsf@concordia.ellerman.id.au>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565314005; bh=mIo2y95DYwpm5TwfN0ChMwsAj72bzfnkFfj+rLdjqVU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=sN/0osHqfMASG3Gn5uYJsmBevNgkDITrwy5z0XhYDRnSVjTtczC6Zn93vXUVACtgl
         zsE5J5OQn1U0e8RQtUv/QuY5iXNoztc7U7xk0b8D/XTbbdQX85oERprBP+FlchEBmH
         cDA/Z0zP30Are5EcBXQtJgaAWOYtGMQytxGRabpoiJwuifLVi+3nH2crRLrU8L/jsz
         NjANrKoFZE22mpOq52s3fZ9ut+mKAUlAXHfdi2WiqPjr5KVieTASv9oPdSZ5QUx628
         sL0qbeXqIPI+CnsO9wdJm+9w+qSRY9+X67MIO8EOa4e3TPJTGVb16/VuBW7YteYrzL
         bdoBRcdIA11ng==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 10:42 PM, Michael Ellerman wrote:
> Hi John,
> 
> john.hubbard@gmail.com writes:
>> diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
>> index b056cae3388b..e126193ba295 100644
>> --- a/arch/powerpc/mm/book3s64/iommu_api.c
>> +++ b/arch/powerpc/mm/book3s64/iommu_api.c
>> @@ -203,6 +202,7 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
>>  {
>>  	long i;
>>  	struct page *page = NULL;
>> +	bool dirty = false;
> 
> I don't think you need that initialisation do you?
> 

Nope, it can go. Fixed locally, thanks.

Did you get a chance to look at enough of the other bits to feel comfortable 
with the patch, overall?

thanks,
-- 
John Hubbard
NVIDIA
