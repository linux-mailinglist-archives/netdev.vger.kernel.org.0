Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68A1184C7
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfLJKRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:17:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:48892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfLJKRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 05:17:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99CB6AD4A;
        Tue, 10 Dec 2019 10:17:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 8681F1E0B23; Tue, 10 Dec 2019 11:17:38 +0100 (CET)
Date:   Tue, 10 Dec 2019 11:17:38 +0100
From:   Jan Kara <jack@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Subject: Re: [PATCH v8 17/26] media/v4l2-core: set pages dirty upon releasing
 DMA buffers
Message-ID: <20191210101738.GE1551@quack2.suse.cz>
References: <20191209225344.99740-1-jhubbard@nvidia.com>
 <20191209225344.99740-18-jhubbard@nvidia.com>
 <20191209165627.bf657cb8fdf660e8f91e966c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209165627.bf657cb8fdf660e8f91e966c@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 09-12-19 16:56:27, Andrew Morton wrote:
> On Mon, 9 Dec 2019 14:53:35 -0800 John Hubbard <jhubbard@nvidia.com> wrote:
> 
> > After DMA is complete, and the device and CPU caches are synchronized,
> > it's still required to mark the CPU pages as dirty, if the data was
> > coming from the device. However, this driver was just issuing a
> > bare put_page() call, without any set_page_dirty*() call.
> > 
> > Fix the problem, by calling set_page_dirty_lock() if the CPU pages
> > were potentially receiving data from the device.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: <stable@vger.kernel.org>
> 
> What are the user-visible effects of this change?

Presumably loss of captured video data if the page writeback hits in the
wrong moment (i.e., after the page was faulted in but before the video HW
stored data in the page) and the page then gets evicted from the page cache.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
