Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD574FB431
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 08:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244992AbiDKG7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 02:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245124AbiDKG73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 02:59:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702B03D1FF;
        Sun, 10 Apr 2022 23:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BIRXrN6U5qu+MwEdPXUm3GcxOrtCsXQHomxMeDQj4iI=; b=cMqfbqPJ0PKcvMP2vBeOyQMy5M
        TJThlzGiOpD1xmxcofK4jvuO59I/BHGIexRKdZZhzlDw75gAhlLFe02EXS2k/fW7Qkk8BkbkaAP9p
        1PiQIO8vPxJzSAZsCZ1H6cK4y9rBr1gSbYp7juhcHtSQVDbZUizws3gjKEommOF7lChe4sCVLrqEf
        VMY2SMl10YM145qLj9PamyqzKsZ+COY5SOtm6F0/BfB4TSLZ8cBxxYKPYM+DWVvhhNU/QZQXal5dc
        RduDnXNwHifDYR17YM9uC11abcyYPdSyBYla9PYFn5Bneskvcq/clp22VG6d0bsn5Zb101dIUpRHG
        mt3o/gHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndnyn-007123-1p; Mon, 11 Apr 2022 06:56:53 +0000
Date:   Sun, 10 Apr 2022 23:56:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Christoph Hellwig <hch@infradead.org>, Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH bpf 2/2] bpf: use vmalloc with VM_ALLOW_HUGE_VMAP for
 bpf_prog_pack
Message-ID: <YlPRNFpT1BF0+fB4@infradead.org>
References: <20220408223443.3303509-1-song@kernel.org>
 <20220408223443.3303509-3-song@kernel.org>
 <YlEZ1+amMITl7TaR@infradead.org>
 <B9CEF760-23C2-489A-8510-2CC6F6C3ECB8@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B9CEF760-23C2-489A-8510-2CC6F6C3ECB8@fb.com>
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

On Sun, Apr 10, 2022 at 01:34:50AM +0000, Song Liu wrote:
> OTOH, it is probably beneficial for the modules to use something 
> similar to bpf_prog_pack, i.e., put text from multiple modules to a 
> single huge page. Of course, this requires non-trivial work in both 
> mm code and module code.
> 
> Given that 1) modules cannot use huge pages yet, and 2) module may
> use differently (with sharing), I think adding module_alloc_large()
> doesn't add much value at the moment. So we can just keep this logic
> in BPF for now. 
> 
> Does this make sense?

I'm not intending to say modules should use the new helper.  But I'd much
prefer to keep all the MODULES_VADDR related bits self-contained in the
modules code and not splatter it over random other subsystems.
