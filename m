Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA3E275116
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgIWGHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgIWGGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 02:06:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74F2C0613D1;
        Tue, 22 Sep 2020 23:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1Vh0dAKOdnXFeXkvpj04uvS6NbxfgNRMpuVYVFb02f4=; b=UHUJHa1QYjtLCQQD5BgcksLg9Q
        ogJ562LcQiJIT5vdgrH0k4zEs1KHZKEtE5FKLLBpdPMh61bVcd85zhmEsDbr6XSCO5/IYcC5xosc+
        +Bs/Af8KVfawjVAHZhgFtXS8OiPnerF4zdWvt5BNj0oHrZft0kEI4+9TtBZcFd3lyEVe37nzNVbH0
        aZadmqU25GvmueBPpKO5jnBNpPCgYeh+qgig1FxlRqFgPDmiWBJxKwTYM40NB0p30YQScbA4MiDmO
        lYYgIhxZbqaTBRDM4Yi29He2+pqLkpKcUM8CEtjyUQQ2/n3lFqVS/1SQoX+7346gfnroqdVZS236p
        XbWKDsJg==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKxuZ-0003T1-26; Wed, 23 Sep 2020 06:05:51 +0000
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
Subject: let import_iovec deal with compat_iovecs as well v3
Date:   Wed, 23 Sep 2020 08:05:38 +0200
Message-Id: <20200923060547.16903-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Al,

this series changes import_iovec to transparently deal with comat iovec
structures, and then cleanups up a lot of code dupliation.

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
