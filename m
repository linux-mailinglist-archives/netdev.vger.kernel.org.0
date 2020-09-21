Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D759F2728DD
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgIUOsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgIUOsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:48:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EACAC061755;
        Mon, 21 Sep 2020 07:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GrLgQ81RMs4yZLkbL25hSswMVubhakBrsXk6y8LUTp8=; b=S8rXcGNBi4i4qPD575hId32KQP
        nqI0uPNrzjdQyj4vl0WSsJjqoLdiHU15JD1QivHJE4gsE9/TJFijUkmzx5PTowCkBnlyPqxob4RLC
        g2OXJsSYMe2XxF/qrlzQ7lUj5CLowOZfdUeitiDgvjL0vok0YlCDOptjFYkIwRz2amnUfKLAMpxWs
        2L9E7YRIK5ucqdS/0WgivYaSwDXpH/HNj0bdbbrCRjJyIOhnR4envxalVmDy7Nd3SjyV7VPX22s6G
        He+tEU28SCP4TsdzxKZjtGYCdDpqu2O8SYVePA8n7SQLKmiA0QJhgmYonOPb/A76qlqHpCJlQFCa1
        Z1eFhQPA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKN6v-0001MT-TO; Mon, 21 Sep 2020 14:48:09 +0000
Date:   Mon, 21 Sep 2020 15:48:09 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 02/11] mm: call import_iovec() instead of
 rw_copy_check_uvector() in process_vm_rw()
Message-ID: <20200921144809.GV32101@casper.infradead.org>
References: <20200921143434.707844-1-hch@lst.de>
 <20200921143434.707844-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921143434.707844-3-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 04:34:25PM +0200, Christoph Hellwig wrote:
>  {
> -	WARN_ON(direction & ~(READ | WRITE));
> +	WARN_ON(direction & ~(READ | WRITE | CHECK_IOVEC_ONLY));

This is now a no-op because:

include/linux/fs.h:#define CHECK_IOVEC_ONLY -1

I'd suggest we renumber it to 2?

(READ is 0, WRITE is 1.  This WARN_ON should probably be
	WARN_ON(direction > CHECK_IOVEC_ONLY)
