Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0713C7B7
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAOPam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:30:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgAOPal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:30:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hlxbWHBq8lfTBkbbWblALE5WfMIrcmCMtir+afT5h7g=; b=KTafuKCnLEQxrDndx0KF1DZxC
        rnKdoLI6sypMh61W+oBSzZckG9nErVqXpqRux90/jnJHBoNxCmDRhLN16rsx5kcLMMQTzpNlRHW3V
        Kn+EfBOj9xXDn+MMy1P1Ce1dDs4zbgiDeuR8jQgZiUt61hA4+gx5SghScUnsRQG1ziTZYHV9R9Zgf
        pJxhgaR5AeWS3+N32IQliDA3Jqotb5XQKegSIoZaLpNN+GhynXNs1L5cGpIhmQbJynCGULBXCRnjC
        vAgzg7hshbf2g9UxNsiPKchC1nKbZKVYFzdAbYAS/fNwV5Y2i+QhIqJe1mPDizEBhtnZaTAQECgQV
        KQqONFysg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irkce-0002dy-Qu; Wed, 15 Jan 2020 15:30:20 +0000
Date:   Wed, 15 Jan 2020 07:30:20 -0800
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
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
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v12 11/22] mm/gup: introduce pin_user_pages*() and
 FOLL_PIN
Message-ID: <20200115153020.GF19546@infradead.org>
References: <20200107224558.2362728-1-jhubbard@nvidia.com>
 <20200107224558.2362728-12-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107224558.2362728-12-jhubbard@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 02:45:47PM -0800, John Hubbard wrote:
> Introduce pin_user_pages*() variations of get_user_pages*() calls,
> and also pin_longterm_pages*() variations.
> 
> For now, these are placeholder calls, until the various call sites
> are converted to use the correct get_user_pages*() or
> pin_user_pages*() API.

What do the pure placeholders buy us?  The API itself looks ok,
but until it actually is properly implemented it doesn't help at
all, and we've had all kinds of bad experiences with these sorts
of stub APIs.
