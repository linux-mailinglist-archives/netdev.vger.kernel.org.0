Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B23EEA25
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfKDUso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:48:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729248AbfKDUso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572900523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mn5RsMcwjgSz4Uc3SsLk9u7OdhxITCoqvev72K3k0/w=;
        b=hQ9+wUclM/gzvrwXlA0dBmvh/ki8tPcPI4NMrzUSwOoLjc6TTXi4ppLn6A8JYvsmhSCT/q
        9xJ9ZYZR1XsNeEJ6PbCbPyMze2ZLL00duT3IgVl7S51Ld6Zf0Dtf0e8LS6qh+AhfwtBiPB
        MvLGtYW2tZJFAys78ar8r6R6dU8re+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-XtiEJ6MJOtixJceTBvorsw-1; Mon, 04 Nov 2019 15:48:39 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 279BB1800DFD;
        Mon,  4 Nov 2019 20:48:35 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AEACB5C3F8;
        Mon,  4 Nov 2019 20:48:29 +0000 (UTC)
Date:   Mon, 4 Nov 2019 15:48:28 -0500
From:   Jerome Glisse <jglisse@redhat.com>
To:     David Rientjes <rientjes@google.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Message-ID: <20191104204828.GC7731@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <alpine.DEB.2.21.1911041231520.74801@chino.kir.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1911041231520.74801@chino.kir.corp.google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: XtiEJ6MJOtixJceTBvorsw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 12:33:09PM -0800, David Rientjes wrote:
>=20
>=20
> On Sun, 3 Nov 2019, John Hubbard wrote:
>=20
> > Introduce pin_user_pages*() variations of get_user_pages*() calls,
> > and also pin_longterm_pages*() variations.
> >=20
> > These variants all set FOLL_PIN, which is also introduced, and
> > thoroughly documented.
> >=20
> > The pin_longterm*() variants also set FOLL_LONGTERM, in addition
> > to FOLL_PIN:
> >=20
> >     pin_user_pages()
> >     pin_user_pages_remote()
> >     pin_user_pages_fast()
> >=20
> >     pin_longterm_pages()
> >     pin_longterm_pages_remote()
> >     pin_longterm_pages_fast()
> >=20
> > All pages that are pinned via the above calls, must be unpinned via
> > put_user_page().
> >=20
>=20
> Hi John,
>=20
> I'm curious what consideration is given to what pageblock migrate types=
=20
> that FOLL_PIN and FOLL_LONGTERM pages originate from, assuming that=20
> longterm would want to originate from MIGRATE_UNMOVABLE pageblocks for th=
e=20
> purposes of anti-fragmentation?

We do not control page block, GUP can happens on _any_ page that is
map inside a process (anonymous private vma or regular file back one).

Cheers,
J=E9r=F4me

