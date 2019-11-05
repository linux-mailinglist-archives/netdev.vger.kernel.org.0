Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E20EFA01
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388159AbfKEJto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:49:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53342 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730731AbfKEJtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 04:49:43 -0500
Received: by mail-wm1-f66.google.com with SMTP id x4so8927984wmi.3
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 01:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=oRi35sDRRYSuldGaopElz5IjGs2HKuOAcqpcVoq2wdY=;
        b=KE3dP9KvcLUq0hJbOhSYMXJr4Z1Cuc2Vc3sYtj3A588K1AxiPBhNRv2jLPVvg3HpiB
         asO9jGRsCrrAGrGXQuynbnaqIOtPdku/48txDbkC3jyEv0zbAYA99l9MmTsEF4lXmu4c
         UlGTi/e9P81uVhAoSbMh6OU7HFW5tO869wbeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=oRi35sDRRYSuldGaopElz5IjGs2HKuOAcqpcVoq2wdY=;
        b=mWoF75vloNtoaOZNQwP1k19UBvYxmsHnMCWlEQ07X517UhqdJwa9Ei9xcnlpg5/Gj5
         uWv9Ry92DBzr2j3kuOGDT459WsKL8dUdedj0SnOyZt6FAJ4psCL6dezSdZrRdvbzmSz6
         SEr7mHl+4v2jdAjiAqWZIZL1ayUK7UZpbexM+M8MYiB0y5BPiqixvh8FGAh6gDWh1PbQ
         0E5unKCwnwKHqtaiXVvdQ/EEPgGRq2rzv8XgMvtGO14zGJmcojWpNYB5iXc5IU1bOEax
         XASPMg7wcDVy5fd+ctV0L5trqhXUVJWD/QPSggMgEjhaejIS0Gdc/B8b5hExwVOW5X0c
         YH0w==
X-Gm-Message-State: APjAAAXo17F7Y8BbmJwDU4EL+2MpgxY97wjR/wDdsapHDn3K7daBl0yP
        Kn3mp6yRjPBSpNp0beuFjOTwHw==
X-Google-Smtp-Source: APXvYqy+m+ZJ5zxOn/Dji3l65qB+TEfMmH5EiR/oP/iFPjGmYGokusjpTK+YoOlM7MNeuKLe8vHIRQ==
X-Received: by 2002:a7b:c925:: with SMTP id h5mr3591415wml.115.1572947379914;
        Tue, 05 Nov 2019 01:49:39 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id j19sm25704277wre.0.2019.11.05.01.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 01:49:39 -0800 (PST)
Date:   Tue, 5 Nov 2019 10:49:36 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/19] drm/via: set FOLL_PIN via pin_user_pages_fast()
Message-ID: <20191105094936.GZ10326@phenom.ffwll.local>
Mail-Followup-To: John Hubbard <jhubbard@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>, David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>, Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-10-jhubbard@nvidia.com>
 <20191031233628.GI14771@iweiny-DESK2.sc.intel.com>
 <20191104181055.GP10326@phenom.ffwll.local>
 <48d22c77-c313-59ff-4847-bc9a9813b8a7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d22c77-c313-59ff-4847-bc9a9813b8a7@nvidia.com>
X-Operating-System: Linux phenom 5.2.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 11:20:38AM -0800, John Hubbard wrote:
> On 11/4/19 10:10 AM, Daniel Vetter wrote:
> > On Thu, Oct 31, 2019 at 04:36:28PM -0700, Ira Weiny wrote:
> >> On Wed, Oct 30, 2019 at 03:49:20PM -0700, John Hubbard wrote:
> >>> Convert drm/via to use the new pin_user_pages_fast() call, which sets
> >>> FOLL_PIN. Setting FOLL_PIN is now required for code that requires
> >>> tracking of pinned pages, and therefore for any code that calls
> >>> put_user_page().
> >>>
> >>
> >> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > No one's touching the via driver anymore, so feel free to merge this
> > through whatever tree suits best (aka I'll drop this on the floor and
> > forget about it now).
> > 
> > Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > 
> 
> OK, great. Yes, in fact, I'm hoping Andrew can just push the whole series
> in through the mm tree, because that would allow it to be done in one 
> shot, in 5.5

btw is there more? We should have a bunch more userptr stuff in various
drivers, so was really surprised that drm/via is the only thing in your
series.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
