Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1901B6E4C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 08:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgDXGno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 02:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726008AbgDXGno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 02:43:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2C3C09B045;
        Thu, 23 Apr 2020 23:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=cBz4tJHnQHNWX5/s05IRxaWmdiK710lyvwkHBVoVZ1A=; b=O5rZfLz/kA3hjQLqxThURHHFHw
        WVdVmpBegPWygKZU22Jw9l3pQ9IWS/996tNQ0C4wj38TTWNK7myf+3P6LrFcc+AZZ1lsqPYKzKqfG
        vzIzFiC+ccCq9PcH3pGYeyq5JAlL0Tsy4CyZrjfJRHRNySyHnov41WcAoZoGZlXBciOzPgBAxG++8
        FNybSovzHbahApoVHS4sp5bL/X1eeQdr7b1XitrN/2ysBS1Vl4+xx7HZ3r6Jl3ZzjTCjwZ4BPFfL4
        UER/3AcVJUKAo8h2UqFT8wUr5Z1TdIQzGfwkcfq6oWHFURm4j/w3I5c9jTHqm1ksyMV4QbNaItlTI
        9agJNzvA==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRs3o-00012a-Hd; Fri, 24 Apr 2020 06:43:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pass kernel pointers to the sysctl ->proc_handler method v3
Date:   Fri, 24 Apr 2020 08:43:33 +0200
Message-Id: <20200424064338.538313-1-hch@lst.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series changes the sysctl ->proc_handler methods to take kernel
pointers.  This simplifies some of the pointer handling in the methods
(which could probably be further simplified now), and gets rid of the
set_fs address space overrides used by bpf.

Changes since v2:
 - free the buffer modified by BPF
 - move pid_max and friends to pid.h

Changes since v1:
 - drop a patch merged by Greg
 - don't copy data out on a write
 - fix buffer allocation in bpf
