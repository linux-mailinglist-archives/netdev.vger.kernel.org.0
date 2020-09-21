Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D8327299B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgIUPL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgIUPL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:11:26 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5750C061755;
        Mon, 21 Sep 2020 08:11:25 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKNTL-003Byz-4d; Mon, 21 Sep 2020 15:11:19 +0000
Date:   Mon, 21 Sep 2020 16:11:19 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Christoph Hellwig' <hch@lst.de>,
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
Subject: Re: [PATCH 04/11] iov_iter: explicitly check for CHECK_IOVEC_ONLY in
 rw_copy_check_uvector
Message-ID: <20200921151119.GU3421308@ZenIV.linux.org.uk>
References: <20200921143434.707844-1-hch@lst.de>
 <20200921143434.707844-5-hch@lst.de>
 <7336624280b8444fb4cb00407317741b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7336624280b8444fb4cb00407317741b@AcuMS.aculab.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 03:05:32PM +0000, David Laight wrote:

> I've actually no idea:
> 1) Why there is an access_ok() check here.
>    It will be repeated by the user copy functions.

Early sanity check.

> 2) Why it isn't done when called from mm/process_vm_access.c.
>    Ok, the addresses refer to a different process, but they
>    must still be valid user addresses.
> 
> Is 2 a legacy from when access_ok() actually checked that the
> addresses were mapped into the process's address space?

It never did.  2 is for the situation when a 32bit process
accesses 64bit one; addresses that are perfectly legitimate
for 64bit userland (and fitting into the first 4Gb of address
space, so they can be represented by 32bit pointers just fine)
might be rejected by access_ok() if the caller is 32bit.
