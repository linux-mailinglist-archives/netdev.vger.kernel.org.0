Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F426104D7B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKUIKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:10:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfKUIKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:10:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VjO9eYbS8IFyLCNQdhIWL3IwgO2zhTRITxFTV7Q4ke0=; b=fWeW5VfFSpSocy6gUTyTq7ohZ
        duWI/ht/WJEZCytte4q/OoCO3XHZsxub0zfdWXgJMwm0kxZ4Evu+pSu8vDqAde8NJcekP1KvZWTtD
        xHQFS3QQWbDzJp6QKE6jzpGTkVBlvWLzk+RBcL8X5N1TsvDfMwPHaaBCvtN9JjwQ1rQi+7po+k2A4
        Z39WgOu5ergP2HMb8sGCzyRKDSO/I+mbgAEZqSFGA0pwIVj1Qkrec7CtCQPnXQeGS/IaPqmpnFKNf
        aZrMXAwd8HXogYEVWB+AdeEhKcdzRbKuMoG04Ftic11jIRTcwm+pNK8JK68LoASBzHMxqDwKIt+f7
        gT4vwZRAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXhWR-0000HT-5s; Thu, 21 Nov 2019 08:09:03 +0000
Date:   Thu, 21 Nov 2019 00:09:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH v7 08/24] media/v4l2-core: set pages dirty upon releasing
 DMA buffers
Message-ID: <20191121080903.GE30991@infradead.org>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-9-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121071354.456618-9-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 11:13:38PM -0800, John Hubbard wrote:
> After DMA is complete, and the device and CPU caches are synchronized,
> it's still required to mark the CPU pages as dirty, if the data was
> coming from the device. However, this driver was just issuing a
> bare put_page() call, without any set_page_dirty*() call.
> 
> Fix the problem, by calling set_page_dirty_lock() if the CPU pages
> were potentially receiving data from the device.

Looks good, and like a fix that should be queued up through the media
tree for 5.5 and maybe even added to -stable.

Reviewed-by: Christoph Hellwig <hch@lst.de>
