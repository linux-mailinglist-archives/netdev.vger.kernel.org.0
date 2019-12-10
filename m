Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE413117CC6
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 01:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfLJA4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 19:56:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfLJA4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 19:56:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE73720637;
        Tue, 10 Dec 2019 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575939389;
        bh=BbLBjR8wcrsANoTlWrEqQPyK+DvAKxv254F1InccAcs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uQ6utAA370KB9xY5+qeGGsoo1HH/Hnt/LDZgeHbTSoRMRHkI8VQJNf4H7ZKlSmj42
         WZSNKaK/IM6JgWSl9QfalBJQuyJfmeZpwpLLwj0NmbsOrQL4FJSoG0TjuPsUzwfCOi
         N9YkLgu4ONG2hyyuwLyRSMczlQwBZdl/iQWpJ6W0=
Date:   Mon, 9 Dec 2019 16:56:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?ISO-8859-1?Q?J=E9r?= =?ISO-8859-1?Q?=F4me?= Glisse 
        <jglisse@redhat.com>, Magnus Karlsson <magnus.karlsson@intel.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Paul Mackerras" <paulus@samba.org>, Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v8 17/26] media/v4l2-core: set pages dirty upon
 releasing DMA buffers
Message-Id: <20191209165627.bf657cb8fdf660e8f91e966c@linux-foundation.org>
In-Reply-To: <20191209225344.99740-18-jhubbard@nvidia.com>
References: <20191209225344.99740-1-jhubbard@nvidia.com>
        <20191209225344.99740-18-jhubbard@nvidia.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 14:53:35 -0800 John Hubbard <jhubbard@nvidia.com> wrote:

> After DMA is complete, and the device and CPU caches are synchronized,
> it's still required to mark the CPU pages as dirty, if the data was
> coming from the device. However, this driver was just issuing a
> bare put_page() call, without any set_page_dirty*() call.
> 
> Fix the problem, by calling set_page_dirty_lock() if the CPU pages
> were potentially receiving data from the device.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: <stable@vger.kernel.org>

What are the user-visible effects of this change?

As it's cc:stable I'd normally send this to Linus within 1-2 weeks, or
sooner.  Please confirm that this is a standalone fix, independent of
the rest of this series.


