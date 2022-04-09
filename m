Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D974FA524
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 07:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiDIFcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 01:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiDIFcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 01:32:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC711EC5F;
        Fri,  8 Apr 2022 22:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uEG2MKXQ98jQrWXToE6ot4EvMQfzWhFTcG5zPELpfkw=; b=i/DfEgfFWLhtkNMcAC7OtyYMi0
        lQXlSJ9z2iM8Q3MH9/OzRDsa0nau7wmeuOmahHu9176dNhJinpDIZeOlMN+IQr834zo+bBBJ3LzS7
        ealAt3ZOfUPvDynJNB22ChhLCdg3FEWCfunBX2hX6uelUoY6ptJRqg+PYIT45pwwonHNhV1Tzo1sG
        y2Ful07FjqabyBLg/C+kZoZaM1ee/Sw3pjcAKF5aEZWAHmnsvQ7yxizu3dyVBuHqL7GR9bl36yaVn
        nMwVs40au193qTFmD5aeZ+3Ii1+DHBb6fKJXDxWRLd34YGovI3NL6yAX9Iw5av4M5xT0q0/UQQPAc
        qrZnBvMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nd3fb-002JpG-EJ; Sat, 09 Apr 2022 05:29:59 +0000
Date:   Fri, 8 Apr 2022 22:29:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, akpm@linux-foundation.org,
        rick.p.edgecombe@intel.com, hch@infradead.org,
        imbrenda@linux.ibm.com
Subject: Re: [PATCH bpf 2/2] bpf: use vmalloc with VM_ALLOW_HUGE_VMAP for
 bpf_prog_pack
Message-ID: <YlEZ1+amMITl7TaR@infradead.org>
References: <20220408223443.3303509-1-song@kernel.org>
 <20220408223443.3303509-3-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408223443.3303509-3-song@kernel.org>
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

On Fri, Apr 08, 2022 at 03:34:43PM -0700, Song Liu wrote:
> +static void *bpf_prog_pack_vmalloc(unsigned long size)
> +{
> +#if defined(MODULES_VADDR)
> +	unsigned long start = MODULES_VADDR;
> +	unsigned long end = MODULES_END;
> +#else
> +	unsigned long start = VMALLOC_START;
> +	unsigned long end = VMALLOC_END;
> +#endif
> +
> +	return __vmalloc_node_range(size, PAGE_SIZE, start, end, GFP_KERNEL, PAGE_KERNEL,
> +				    VM_DEFER_KMEMLEAK | VM_ALLOW_HUGE_VMAP,
> +				    NUMA_NO_NODE, __builtin_return_address(0));
> +}

Instead of having this magic in bpf I think a module_alloc_large would
seems like the better interface here.
