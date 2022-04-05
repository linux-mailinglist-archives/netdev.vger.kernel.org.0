Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D04F23EC
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 09:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiDEHJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 03:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiDEHJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 03:09:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3119313E90;
        Tue,  5 Apr 2022 00:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mb8LxTS7N1wZA6PGLOAHodUliQGXD2Gj4fJDPq7BY7I=; b=3vvYnrIhGjhGuytIlX1R63z5oZ
        8HJzAlppnlhvbkRKwmatxzikLyz9TZOkhfA28ZKt/Gs2YURxe9o5MXYoIDosXLJAqXJo5/flGm66/
        Yrpoxjf8eDN6iOgG8ODT+Bb5xtjO+HyjtLbPufSo37UVL6pKRATfVvAbh7mNJqhkcC+u3ZzKbUGI3
        1FFD4vq1YsRD6Sb5ZAGaUdHXph/RR1nOeS/OsAz4D9q3/O8QHTiE66dIA3GSGLXTafFssuFeuhOWW
        E+yHFYMYCPzCeEKQVkwEueBksfkUyIUmnW6M9Fu2bW6aSBntwJyDaAF6gaYmwpDLu0SZ9G/rNgtU/
        YvXyjZhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nbdHq-00HOmb-7S; Tue, 05 Apr 2022 07:07:34 +0000
Date:   Tue, 5 Apr 2022 00:07:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Message-ID: <YkvqtvNFtzDNkEhy@infradead.org>
References: <20220330225642.1163897-1-song@kernel.org>
 <YkU+ADIeWACbgFNA@infradead.org>
 <F3447905-8D42-46C0-B324-988A0E4E52E7@fb.com>
 <6AA91984-7DF3-4820-91DF-DD6CA251B638@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6AA91984-7DF3-4820-91DF-DD6CA251B638@fb.com>
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

On Fri, Apr 01, 2022 at 10:22:00PM +0000, Song Liu wrote:
> >> Please fix the underlying issues instead of papering over them and
> >> creating a huge maintainance burden for others.
> 
> After reading the code a little more, I wonder what would be best strategy. 
> IIUC, most of the kernel is not ready for huge page backed vmalloc memory.
> For example, all the module_alloc cannot work with huge pages at the moment.
> And the error Paul Menzel reported in drm_fb_helper.c will probably hit 
> powerpc with 5.17 kernel as-is? (trace attached below) 
> 
> Right now, we have VM_NO_HUGE_VMAP to let a user to opt out of huge pages. 
> However, given there are so many users of vmalloc, vzalloc, etc., we 
> probably do need a flag for the user to opt-in? 
> 
> Does this make sense? Any recommendations are really appreciated. 

I think there is multiple aspects here:

 - if we think that the kernel is not ready for hugepage backed vmalloc
   in general we need to disable it in powerpc for now.
 - if we think even in the longer run only some users can cope with
   hugepage backed vmalloc we need to turn it into an opt-in in
   general and not just for x86
 - there still to appear various unresolved underlying x86 specific
   issues that need to be fixed either way
