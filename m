Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B01A2CB7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 04:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfH3CVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 22:21:08 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15443 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfH3CVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 22:21:07 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d6888110001>; Thu, 29 Aug 2019 19:21:05 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 29 Aug 2019 19:21:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 29 Aug 2019 19:21:04 -0700
Received: from [10.110.48.201] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Aug
 2019 02:21:03 +0000
Subject: Re: [PATCH v3 00/39] put_user_pages(): miscellaneous call sites
To:     Mike Marshall <hubcap@omnibond.com>
CC:     <john.hubbard@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <amd-gfx@lists.freedesktop.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <devel@lists.orangefs.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-block@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-xfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <sparclinux@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
 <912eb2bd-4102-05c1-5571-c261617ad30b@nvidia.com>
 <CAOg9mSQKGDywcMde2DE42diUS7J8m74Hdv+xp_PJhC39EXZQuw@mail.gmail.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <d453f865-2224-ed53-a2f4-f43d574c130a@nvidia.com>
Date:   Thu, 29 Aug 2019 19:21:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOg9mSQKGDywcMde2DE42diUS7J8m74Hdv+xp_PJhC39EXZQuw@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1567131665; bh=ws5caXaEY0X3GX3egw6JsJDC0L7OwnIAHkDMK9ZQcE4=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=dIUKOH913DAYlocN1x3OWKU66rYzbsvcqMg6XurXOtfsQm0mTaQq0ufL9HiRQjmKf
         MYeR8XR6MbUy9f2nOHFjitJW5jxjU59hEwD2KYzGMRBc0+P+o4b2mkzUliEchFZQzm
         D0OR0ZfFBCp6cKpnoBGakw3Ch1supTeIz+DcDxFqgzxBAMqXWQoRbk0Sq3VWx6u9tp
         6uURi8FKe6XveWY1U9zok9s2um/SF43+51Cnxqw5q2h2Dtp4kEwxNonMDqxzAcZjDx
         HfyaHZc2XUvwuRV5WZb7Ki3OlH/mp5QHGx5CtmwXtp2TNme1r3iXAZgXDKrycQZylt
         qlPWiGD9ap9bQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/2019 6:29 PM, Mike Marshall wrote:
> Hi John...
> 
> I added this patch series on top of Linux 5.3rc6 and ran
> xfstests with no regressions...
> 
> Acked-by: Mike Marshall <hubcap@omnibond.com>
> 

Hi Mike (and I hope Ira and others are reading as well, because
I'm making a bunch of claims further down),

That's great news, thanks for running that test suite and for
the report and the ACK.

There is an interesting pause right now, due to the fact that
we've made some tentative decisions about gup pinning, that affect
the call sites. A key decision is that only pages that were
requested via FOLL_PIN, will require put_user_page*() to release
them. There are 4 main cases, which were first explained by Jan
Kara and Vlastimil Babka, and are now written up in my FOLL_PIN
patch [1].

So, what that means for this series is that:

1. Some call sites (mlock.c for example, and a lot of the mm/ files
in fact, and more) will not be converted: some of these patches will
get dropped, especially in mm/.

2. Call sites that do DirectIO or RDMA will need to set FOLL_PIN, and
will also need to call put_user_page().

3. Call sites that do RDMA will need to set FOLL_LONGTERM *and* FOLL_PIN,

    3.a. ...and will at least in some cases need to provide a link to a
    vaddr_pin object, and thus back to a struct file*...maybe. Still
    under discussion.

4. It's desirable to keep FOLL_* flags (or at least FOLL_PIN) internal
to the gup() calls. That implies using a wrapper call such as Ira's
vaddr_pin_[user]_pages(), instead of gup(), and vaddr_unpin_[user]_pages()
instead of put_user_page*().

5. We don't want to churn the call sites unnecessarily.

With that in mind, I've taken another pass through all these patches
and narrowed it down to:

     a) 12 call sites that I'd like to convert soon, but even those
        really look cleaner with a full conversion to a wrapper call
        similar to (identical to?) vaddr_pin_[user]_pages(), probably
        just the FOLL_PIN only variant (not FOLL_LONGTERM). That
        wrapper call is not ready yet, though.

     b) Some more call sites that require both FOLL_PIN and FOLL_LONGTERM.
        Definitely will wait to use the wrapper calls for these, because
        they may also require hooking up to a struct file*.

     c) A few more that were already applied, which is fine, because they
        show where to convert, and simplify a few sites anyway. But they'll
        need follow-on changes to, one way or another, set FOLL_PIN.

     d) And of course a few sites whose patches get dropped, as mentioned
        above.

[1] https://lore.kernel.org/r/20190821040727.19650-3-jhubbard@nvidia.com

thanks,
-- 
John Hubbard
NVIDIA
