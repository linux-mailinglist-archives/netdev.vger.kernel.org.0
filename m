Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD515109490
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 21:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfKYUN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 15:13:58 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10773 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKYUN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 15:13:57 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddc36070000>; Mon, 25 Nov 2019 12:14:00 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 Nov 2019 12:13:56 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 Nov 2019 12:13:56 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 20:13:55 +0000
Subject: Re: [PATCH 07/19] mm/gup: introduce pin_user_pages*() and FOLL_PIN
To:     kbuild test robot <lkp@intel.com>
CC:     <kbuild-all@lists.01.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>,
        <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Paul Mackerras <paulus@samba.org>,
        <linux-kselftest@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, <linux-rdma@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        <linux-media@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        <linux-block@vger.kernel.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jens Axboe <axboe@kernel.dk>, <netdev@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-fsdevel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mike Kravetz <mike.kravetz@oracle.com>
References: <20191125042011.3002372-8-jhubbard@nvidia.com>
 <201911251639.UWS3hE3Y%lkp@intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <3989f406-c333-59f8-027a-e3506af59028@nvidia.com>
Date:   Mon, 25 Nov 2019 12:13:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <201911251639.UWS3hE3Y%lkp@intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574712840; bh=xIrvhzi9FQlGBM90SU8S2M4hsd9JLL89vrPzYePQebc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=nLQ5e77gFGxdvd47gRiRGHQbc1wVG8bwNbuGbyST1Q+jBowT4WflUsZ9otzD54lLB
         J2wcW1AWxZ1vtAVadAvnnzHYEB9/RMQVx2Q02xRhkx6jKeVYJqp1Vzd24M3MZT/KvC
         2r/IXfhmoHhQNFs1s+Ijlm3sbCcfcCTqQLXfh/u6EJodBjYv13WjZ+5uA/qpRqF5KJ
         cgfhkSAYwIIVs+guU8WDjo4g7p8fk0VqKWKusesTvojs5xnlpb4TJcK/V2onbK8LWW
         ksqnqfXGTA8sAX8XklRUC+OhMkFBYvdHQY7BxmxtkVVkFbYIpBRqVJEp1i5QjV+FwU
         IkbF7UmcnHQ6g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/19 12:44 AM, kbuild test robot wrote:
> Hi John,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on rdma/for-next]
> [cannot apply to v5.4 next-20191122]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/John-Hubbard/pin_user_pages-reduced-risk-series-for-Linux-5-5/20191125-125637
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
> config: arm-randconfig-a001-20191125 (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=arm 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    mm/gup.o: In function `pin_user_pages_remote':
>>> mm/gup.c:2528: undefined reference to `get_user_pages_remote'
> 
> vim +2528 mm/gup.c


This, and the other (sh) report, is due to !CONFIG_MMU lacking a get_user_pages_remote(), 
but pin_user_pages_remote() needs it for a (temporary) implementation. I'll post the fix, 
in v2.


thanks,
-- 
John Hubbard
NVIDIA
