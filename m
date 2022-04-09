Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B7F4FA51E
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 07:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiDIFaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 01:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiDIFaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 01:30:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0696826544;
        Fri,  8 Apr 2022 22:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UELACyVvvsv7I05n9+vrbyhbff2QK+RQVjTLcZ7BmLg=; b=yjRyUNNZJ+QcVl6cC7NuMHkkWo
        s0/WGg7fW8quqrK5WTwAxvCspJlWPhWh44WOnhXrUs6Xj9sc4KmSWjbFQvLmqLuDYlrXkfni5q9nc
        IX7lbqve87N0Wlia2y6UmXmDfnF5/aZ7W2DmAvELSS1I7W6UMjD9Aii0ET81eszLt80eQMGz0VPKT
        0X715mDCiAtLZFok6yq8NE1kX7ORTM2aySTyp6Zg6sy59MUm61MITFQ4DlOmrpEA0nW8A9e0Q+m/W
        Nq7p0DjvUlc6TBotYnplOKXKIBP7sIzbqgKKmC/PooxRmDPdope8lHBakiuly2QhtoUedRmzaSmiG
        ZNKutwGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nd3dq-002IuG-Ht; Sat, 09 Apr 2022 05:28:10 +0000
Date:   Fri, 8 Apr 2022 22:28:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, akpm@linux-foundation.org,
        rick.p.edgecombe@intel.com, hch@infradead.org,
        imbrenda@linux.ibm.com
Subject: Re: [PATCH bpf 1/2] vmalloc: replace VM_NO_HUGE_VMAP with
 VM_ALLOW_HUGE_VMAP
Message-ID: <YlEZahPCTI/qh/6u@infradead.org>
References: <20220408223443.3303509-1-song@kernel.org>
 <20220408223443.3303509-2-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408223443.3303509-2-song@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 03:34:42PM -0700, Song Liu wrote:
> Huge page backed vmalloc memory could benefit performance in many cases.
> Since some users of vmalloc may not be ready to handle huge pages,
> VM_NO_HUGE_VMAP was introduced to allow vmalloc users to opt-out huge
> pages. However, it is not easy to add VM_NO_HUGE_VMAP to all the users
> that may try to allocate >= PMD_SIZE pages, but are not ready to handle
> huge pages properly.
> 
> Replace VM_NO_HUGE_VMAP with an opt-in flag, VM_ALLOW_HUGE_VMAP, so that
> users that benefit from huge pages could ask specificially.

Given that the huge page backing was added explicitly for some big boot
time allocated hashed,those should probably have the VM_ALLOW_HUGE_VMAP
added from the start (maybe not in this patch, but certainly in this
series).  We'll probably also need a vmalloc_huge interface for those.
