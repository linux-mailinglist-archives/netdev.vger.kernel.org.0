Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2FF1D1A67
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388806AbgEMQAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729561AbgEMQAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:00:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCC0C061A0C;
        Wed, 13 May 2020 09:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=MBXmzxvlvBp3urj1EfRdDjo/Nomb7enLOBCi4+LnpPQ=; b=Ib3n/68sFKiWSoHFw243qGtEKT
        uIMPw1Lc04Of4bpkSt7Yyoo0wEMWGWlEBGRZGg5YyY/J85MCuuRtD8Ut4Pn8dQ6rjt2FAKlGCj3sb
        EEPJaiqvvdNnys5f1elW1iOxmECbdFi3IJvzsq+A0h2GI5wayolWIt/6gvyUvcZ01/Szg72cbrPCN
        qNmqVuL9aiEVYBc2HDVNuCEJXxyCpm8znHdnG6ASXSUsHemRJz+fYGd/RxrRO30wHhzmQ+8ewNAa3
        f6A+qvxSlwXvcBAMKYxwhnw2ERDv5CBYBSAprCzOe7Y+NJNQef3YEA4wJB2dhF3pa55P9f2f8xwIL
        Xthl7C4w==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYtoF-0004fx-T9; Wed, 13 May 2020 16:00:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: clean up and streamline probe_kernel_* and friends v2
Date:   Wed, 13 May 2020 18:00:20 +0200
Message-Id: <20200513160038.2482415-1-hch@lst.de>
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
