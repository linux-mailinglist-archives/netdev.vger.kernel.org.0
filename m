Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F40271549
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgITPPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 11:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITPPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 11:15:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFF7C061755;
        Sun, 20 Sep 2020 08:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ucf7HoNcpbOE1Nwd0GkK0r+4jGnJB6Awau+HMvD5QTQ=; b=BEHRWzksrTjJ0cz6kn/YL4kbO9
        O0S1oDQ5afrWGBLkgZVov0K5DX5P8n3kQPInesZq8Opmeexe0KTNU5zkAjvbPAa7Vu+AwqUEF9kkV
        s09ZOl4m8v1spojFIQBVRxpVintgH+lHEWDdjnkhUWSJDFXQaimPUKpk6c+gLvdLoxlpoR55UirIR
        C7FOSIh6C1I8oA+JRJOY1riBqiSdxp8JHhQOJrK3Az+Zf34gwu76Cu4rYBA3pcShPktuZzK8Fl9p+
        KTdDanCXPZQo05/zui4ihlNXLDU70euY+ORH9c4QQIqcTHg/9okYwp8yGFJLLvFCR++YjtJR+fDE0
        5GxFYx2A==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK13W-00060V-36; Sun, 20 Sep 2020 15:15:10 +0000
Date:   Sun, 20 Sep 2020 16:15:10 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200920151510.GS32101@casper.infradead.org>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918124533.3487701-2-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:45:25PM +0200, Christoph Hellwig wrote:
> Add a flag to force processing a syscall as a compat syscall.  This is
> required so that in_compat_syscall() works for I/O submitted by io_uring
> helper threads on behalf of compat syscalls.

Al doesn't like this much, but my suggestion is to introduce two new
opcodes -- IORING_OP_READV32 and IORING_OP_WRITEV32.  The compat code
can translate IORING_OP_READV to IORING_OP_READV32 and then the core
code can know what that user pointer is pointing to.

