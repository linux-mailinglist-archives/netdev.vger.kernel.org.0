Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78A711BEAE
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 21:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfLKU5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 15:57:42 -0500
Received: from ms.lwn.net ([45.79.88.28]:58190 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfLKU5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 15:57:41 -0500
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 7D799739;
        Wed, 11 Dec 2019 20:57:38 +0000 (UTC)
Date:   Wed, 11 Dec 2019 13:57:37 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@intel.com>, Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
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
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v9 10/25] mm/gup: introduce pin_user_pages*() and
 FOLL_PIN
Message-ID: <20191211135737.581add2f@lwn.net>
In-Reply-To: <20191211025318.457113-11-jhubbard@nvidia.com>
References: <20191211025318.457113-1-jhubbard@nvidia.com>
        <20191211025318.457113-11-jhubbard@nvidia.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 18:53:03 -0800
John Hubbard <jhubbard@nvidia.com> wrote:

> Introduce pin_user_pages*() variations of get_user_pages*() calls,
> and also pin_longterm_pages*() variations.

Just a couple of nits on the documentation patch

> +++ b/Documentation/core-api/pin_user_pages.rst
> @@ -0,0 +1,232 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +====================================================
> +pin_user_pages() and related calls
> +====================================================
> +
> +.. contents:: :local:
> +
> +Overview
> +========
> +
> +This document describes the following functions: ::
> +
> + pin_user_pages
> + pin_user_pages_fast
> + pin_user_pages_remote

You could just say "the following functions::" and get the result you're
after with a slightly less alien plain-text reading experience.

Of course, you could also just say "This document describes
pin_user_pages(), pin_user_pages_fast(), and pin_user_pages_remote()." But
that's a matter of personal taste, I guess.  Using the function() notation
will cause the docs system to automatically link to the kerneldoc info,
though.  

> +Basic description of FOLL_PIN
> +=============================
> +
> +FOLL_PIN and FOLL_LONGTERM are flags that can be passed to the get_user_pages*()
> +("gup") family of functions. FOLL_PIN has significant interactions and
> +interdependencies with FOLL_LONGTERM, so both are covered here.
> +
> +FOLL_PIN is internal to gup, meaning that it should not appear at the gup call
> +sites. This allows the associated wrapper functions  (pin_user_pages*() and
> +others) to set the correct combination of these flags, and to check for problems
> +as well.
> +
> +FOLL_LONGTERM, on the other hand, *is* allowed to be set at the gup call sites.
> +This is in order to avoid creating a large number of wrapper functions to cover
> +all combinations of get*(), pin*(), FOLL_LONGTERM, and more. Also, the
> +pin_user_pages*() APIs are clearly distinct from the get_user_pages*() APIs, so
> +that's a natural dividing line, and a good point to make separate wrapper calls.
> +In other words, use pin_user_pages*() for DMA-pinned pages, and
> +get_user_pages*() for other cases. There are four cases described later on in
> +this document, to further clarify that concept.
> +
> +FOLL_PIN and FOLL_GET are mutually exclusive for a given gup call. However,
> +multiple threads and call sites are free to pin the same struct pages, via both
> +FOLL_PIN and FOLL_GET. It's just the call site that needs to choose one or the
> +other, not the struct page(s).
> +
> +The FOLL_PIN implementation is nearly the same as FOLL_GET, except that FOLL_PIN
> +uses a different reference counting technique.
> +
> +FOLL_PIN is a prerequisite to FOLL_LONGTGERM. Another way of saying that is,

FOLL_LONGTERM typoed there.

Thanks,

jon
