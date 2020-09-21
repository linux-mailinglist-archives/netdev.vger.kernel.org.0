Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45029272C2E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgIUQ2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgIUQ2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:28:05 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC5CC061755;
        Mon, 21 Sep 2020 09:28:04 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKOfR-003EDr-FT; Mon, 21 Sep 2020 16:27:53 +0000
Date:   Mon, 21 Sep 2020 17:27:53 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Laight <David.Laight@aculab.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 02/11] mm: call import_iovec() instead of
 rw_copy_check_uvector() in process_vm_rw()
Message-ID: <20200921162753.GY3421308@ZenIV.linux.org.uk>
References: <20200921143434.707844-1-hch@lst.de>
 <20200921143434.707844-3-hch@lst.de>
 <20200921150211.GS3421308@ZenIV.linux.org.uk>
 <ef67787edb2f48548d69caaaff6997ba@AcuMS.aculab.com>
 <20200921152937.GX3421308@ZenIV.linux.org.uk>
 <226e03bf941844eba4d64af31633c177@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <226e03bf941844eba4d64af31633c177@AcuMS.aculab.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 03:44:00PM +0000, David Laight wrote:
> From: Al Viro
> > Sent: 21 September 2020 16:30
> > 
> > On Mon, Sep 21, 2020 at 03:21:35PM +0000, David Laight wrote:
> > 
> > > You really don't want to be looping through the array twice.
> > 
> > Profiles, please.
> 
> I did some profiling of send() v sendmsg() much earlier in the year.
> I can't remember the exact details but the extra cost of sendmsg()
> is far more than you might expect.
> (I was timing sending fully built IPv4 UDP packets using a raw socket.)
> 
> About half the difference does away if you change the
> copy_from_user() to __copy_from_user() when reading the struct msghdr
> and iov[] from userspace (user copy hardening is expensive).

Wha...?  So the difference is within 4 times the overhead of the
hardening checks done for one call of copy_from_user()?

> The rest is just code path, my gut feeling is that a lot of that
> is in import_iovec().
> 
> Remember semdmsg() is likely to be called with an iov count of 1.

... which makes that loop unlikely to be noticable in the entire
mess, whether you pass it once or twice.  IOW, unless you can show
profiles where that loop is sufficiently hot or if you can show
the timings change from splitting it in two, I'll remain very
sceptical about that assertion.
