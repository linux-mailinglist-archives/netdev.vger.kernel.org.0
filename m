Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B2D1D9880
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgESNo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgESNo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:44:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66041C08C5C0;
        Tue, 19 May 2020 06:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=VA+rkbbJ9Gdu2pIdIJCd0hxkxzOrtfH9/4cfURE97w4=; b=s5jGcOuFcMqXXsAcexu5WkkZpW
        SqMchNqCMYatHho2iD6t0yuHPPsnOU7ddh0uHbCBrRC1iUo6xwomnsizcFL8lqJCbsH762aqgv9f1
        M3UX75xgLM/hLHthh07qF4USOtDaNRjvSnclU4YUozuiTb8LWYOEgjMlNNXPhMl5uBUDJ/VaVA6ju
        ZYOmK5YEdFlIf5whS9gHwr3RdmlbwgpmqhC40VmWGXUQmYyfNQUPBdsaCPh1TLNjxE1ub3Q8jgTGh
        VjQUwge2yc4VojVSjpq7694uk3yIBqjzpHN6/RQXB0KByEZY3OhQCrBzDRPhy3k9+ljWwoFcuXPml
        UbSLfoTA==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb2Y7-0000zQ-W6; Tue, 19 May 2020 13:44:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: clean up and streamline probe_kernel_* and friends v3
Date:   Tue, 19 May 2020 15:44:29 +0200
Message-Id: <20200519134449.1466624-1-hch@lst.de>
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

I kept the x86 helprs as-is without calling unsage_{get,put}_user as
that avoids a number of hard to trace casts, and it will still work
with the asm-goto based version easily.

Changes since v2:
 - rebased on 5.7-rc6 with the bpf trace format string changes
 - rename arch_kernel_read to __get_kernel_nofault and arch_kernel_write
   to __put_kernel_nofault
 - clean up the tracers to only allowd "mixed" reads when the kernel
   has non-overlapping address spaces
