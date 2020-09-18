Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB5326FCD8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgIRMpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgIRMpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:45:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36099C061756;
        Fri, 18 Sep 2020 05:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=V3X+nIZPxUoB2BOajjqXji1hFeXgDyeXoEcOBeTEcjY=; b=vJlif4ODGlFSaA/X96y95TBxaJ
        n1vQfWDy9aeQQz/QfN88AtyhJjnDQw4iBBxB3dOINUYSWIDVuarqzmR0pZ51u4RNdWq3xd56/l+oR
        5GEDqjcn7bBB3CNVKgHN2a9wCcAG8SVe7T2vZu1M3dI0BtwzjwiuqLtNf9Jp3kLrAw46KAsyjal9/
        QoDWN5trBS3vHnHgnjwv02AJsET1D7F4cR807vr6jIEUKZP+oBkLuggklbUB1OR5q/LzveCjsdCRd
        XkzH7AWVhPje1BKWsGUA6phSyo6a5kaSlGjDsD4kHaEc69ADj0ykAyKUBp48wXzsnb2cVPD/Usdlf
        ivQpFJ1w==;
Received: from [80.122.85.238] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJFle-0008SE-9Z; Fri, 18 Sep 2020 12:45:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
Subject: let import_iovec deal with compat_iovecs as well
Date:   Fri, 18 Sep 2020 14:45:24 +0200
Message-Id: <20200918124533.3487701-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Al,

this series changes import_iovec to transparently deal with comat iovec
structures, and then cleanups up a lot of code dupliation.  But to get
there it first has to fix the pre-existing bug that io_uring compat
contexts don't trigger the in_compat_syscall() check.  This has so far
been relatively harmless as very little code callable from io_uring used
the check, and even that code that could be called usually wasn't.

Diffstat
 arch/arm64/include/asm/unistd32.h                  |   10 
 arch/mips/kernel/syscalls/syscall_n32.tbl          |   10 
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   10 
 arch/parisc/kernel/syscalls/syscall.tbl            |   10 
 arch/powerpc/kernel/syscalls/syscall.tbl           |   10 
 arch/s390/kernel/syscalls/syscall.tbl              |   10 
 arch/sparc/include/asm/compat.h                    |    3 
 arch/sparc/kernel/syscalls/syscall.tbl             |   10 
 arch/x86/entry/syscall_x32.c                       |    5 
 arch/x86/entry/syscalls/syscall_32.tbl             |   10 
 arch/x86/entry/syscalls/syscall_64.tbl             |   10 
 arch/x86/include/asm/compat.h                      |    2 
 block/scsi_ioctl.c                                 |   12 
 drivers/scsi/sg.c                                  |    9 
 fs/aio.c                                           |   38 --
 fs/io_uring.c                                      |   21 -
 fs/read_write.c                                    |  307 ++++-----------------
 fs/splice.c                                        |   57 ---
 include/linux/compat.h                             |   29 -
 include/linux/fs.h                                 |    7 
 include/linux/sched.h                              |    1 
 include/linux/uio.h                                |    7 
 include/uapi/asm-generic/unistd.h                  |   12 
 lib/iov_iter.c                                     |   30 --
 mm/process_vm_access.c                             |   69 ----
 net/compat.c                                       |    4 
 security/keys/compat.c                             |   37 --
 security/keys/internal.h                           |    5 
 security/keys/keyctl.c                             |    2 
 tools/include/uapi/asm-generic/unistd.h            |   12 
 tools/perf/arch/powerpc/entry/syscalls/syscall.tbl |   10 
 tools/perf/arch/s390/entry/syscalls/syscall.tbl    |   10 
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl  |   10 
 33 files changed, 207 insertions(+), 582 deletions(-)
