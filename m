Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FFE277F54
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 06:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgIYEwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 00:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgIYEwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 00:52:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA23C0613D5;
        Thu, 24 Sep 2020 21:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=A+T/x3ppYi6QNsP2t+QiJ1AjmOgx9xWo2H6NAG0/aPM=; b=k9BJO212aIGjTM67lCOkTpCrht
        B20Wf2zjNYR87uLFP2BRrzt5cCrEk0KFpOMk3+io62CblpW7Y77IqzHPhNFZqwDnVNpJgjcOWkhrs
        Z8GRxpu7FjGxV+hNEbHeKyL912gkvTLvP4DBne8Te3c43Bttle2gfOVWfy6MwqIsof1MCTX4rxO24
        Kx+lnKnrKhrsYvG/2XpbtSvE8DYXDyXxSwaM81JHTOVvJu9V5Jarcs/1LeXw6G549Mxci7m54zzCp
        f1etRanliNQK8rGzJ9PmD1VPBy0Rci2ZVjpscKDGnzDGoBasw11g0MfksMIslOR+W3JyKfkaf/KsM
        BhKY/8wQ==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLfi0-0002pf-1s; Fri, 25 Sep 2020 04:51:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
Subject: let import_iovec deal with compat_iovecs as well v4
Date:   Fri, 25 Sep 2020 06:51:37 +0200
Message-Id: <20200925045146.1283714-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Al,

this series changes import_iovec to transparently deal with compat iovec
structures, and then cleanups up a lot of code dupliation.

Changes since v3:
 - fix up changed prototypes in compat.h as well

Changes since v2:
 - revert the switch of the access process vm sysclls to iov_iter
 - refactor the import_iovec internals differently
 - switch aio to use __import_iovec

Changes since v1:
 - improve a commit message
 - drop a pointless unlikely
 - drop the PF_FORCE_COMPAT flag
 - add a few more cleanups (including two from David Laight)

Diffstat:
 arch/arm64/include/asm/unistd32.h                  |   10 
 arch/mips/kernel/syscalls/syscall_n32.tbl          |   10 
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   10 
 arch/parisc/kernel/syscalls/syscall.tbl            |   10 
 arch/powerpc/kernel/syscalls/syscall.tbl           |   10 
 arch/s390/kernel/syscalls/syscall.tbl              |   10 
 arch/sparc/kernel/syscalls/syscall.tbl             |   10 
 arch/x86/entry/syscall_x32.c                       |    5 
 arch/x86/entry/syscalls/syscall_32.tbl             |   10 
 arch/x86/entry/syscalls/syscall_64.tbl             |   10 
 block/scsi_ioctl.c                                 |   12 
 drivers/scsi/sg.c                                  |    9 
 fs/aio.c                                           |   38 --
 fs/io_uring.c                                      |   20 -
 fs/read_write.c                                    |  362 +--------------------
 fs/splice.c                                        |   57 ---
 include/linux/compat.h                             |   24 -
 include/linux/fs.h                                 |   11 
 include/linux/uio.h                                |   10 
 include/uapi/asm-generic/unistd.h                  |   12 
 lib/iov_iter.c                                     |  161 +++++++--
 mm/process_vm_access.c                             |   85 ----
 net/compat.c                                       |    4 
 security/keys/compat.c                             |   37 --
 security/keys/internal.h                           |    5 
 security/keys/keyctl.c                             |    2 
 tools/include/uapi/asm-generic/unistd.h            |   12 
 tools/perf/arch/powerpc/entry/syscalls/syscall.tbl |   10 
 tools/perf/arch/s390/entry/syscalls/syscall.tbl    |   10 
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl  |   10 
 30 files changed, 280 insertions(+), 706 deletions(-)
