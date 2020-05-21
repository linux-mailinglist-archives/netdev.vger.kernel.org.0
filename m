Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FAC1DD122
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgEUPXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgEUPXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EAEC061A0E;
        Thu, 21 May 2020 08:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=YqSSwt2eEcfdPvUAJEANUMpS+LY40r0n4Vfg5+OG7wQ=; b=EEJCEnohLFlkeBK40BapbvBN8B
        STzhDvoXDi6tKlY0y9EJyn9cirSq8jAFNVOnAudZkOqwZw1AmD7q/TODvpr9c9vXbt/wp1uyiKDrL
        JnXNH0f/a2eGVzzMvif5JYp9g8Q2nIkTHG0J0DaB/RdnLYlUTkNMv3wfnys2TXfQoGngUeetWOBh2
        49EjI/2ECxzLrR6L3IN6772XB/UeBe7cuoKvQGFoXmoftQ0OU4m9M+BN7p1LZLHCWYJebf2w/GMB9
        oOZWBeR82AWRsWyIILbr0CtUMwxyV8pzt+lJchXXL6fCPVBtyGnXT7GEMCYvYogWI0/8PbRZUTy+t
        ZFUTdkOQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn2F-0003xo-7d; Thu, 21 May 2020 15:23:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: clean up and streamline probe_kernel_* and friends v4
Date:   Thu, 21 May 2020 17:22:38 +0200
Message-Id: <20200521152301.2587579-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series start cleaning up the safe kernel and user memory probing
helpers in mm/maccess.c, and then allows architectures to implement
the kernel probing without overriding the address space limit and
temporarily allowing access to user memory.  It then switches x86
over to this new mechanism by reusing the unsafe_* uaccess logic.

This version also switches to the saner copy_{from,to}_kernel_nofault
naming suggested by Linus.

I kept the x86 helpers as-is without calling unsage_{get,put}_user as
that avoids a number of hard to trace casts, and it will still work
with the asm-goto based version easily.

Changes since v3:
 - cleanup how bpf and trace_kprobe perform the TASK_SIZE checks
 - remove the unused dst argument to probe_kernel_read_allowed
 - document the -ERANGE return value

Changes since v2:
 - rebased on 5.7-rc6 with the bpf trace format string changes
 - rename arch_kernel_read to __get_kernel_nofault and arch_kernel_write
   to __put_kernel_nofault
 - clean up the tracers to only allowd "mixed" reads when the kernel
   has non-overlapping address spaces
