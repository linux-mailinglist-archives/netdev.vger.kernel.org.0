Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C1A5E7BD9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiIWN3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiIWN3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:29:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D249BCA;
        Fri, 23 Sep 2022 06:29:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A7AB7219E6;
        Fri, 23 Sep 2022 13:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663939767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KqOhL/1z0xmD9tmZdAbP8D5T9tbMxBqnVFjN6bOd52Y=;
        b=t1wXI75qPHFYyyrgOy5ZtEpsPNBiaYev8rXnj8rKmvvaEowfT3MXeP/3yiFsINP9FFvWez
        ARDju94gr8OvkDFRDqJbJipNYF4ATFKW1b6S42k2DY/Dedi2Rr2WfsaW1D4DJKvIPiJPB6
        w7l/0M/k990+KWal4v93jTr+0c/xdhs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8D5C213AA5;
        Fri, 23 Sep 2022 13:29:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kyeBH7e0LWPHDgAAMHmgww
        (envelope-from <mhocko@suse.com>); Fri, 23 Sep 2022 13:29:27 +0000
Date:   Fri, 23 Sep 2022 15:29:26 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <Yy20toVrIktiMSvH@dhcp22.suse.cz>
References: <20220923103858.26729-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923103858.26729-1-fw@strlen.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 23-09-22 12:38:58, Florian Westphal wrote:
> Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
>  kernel BUG at mm/vmalloc.c:2437!
>  invalid opcode: 0000 [#1] SMP
>  CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
>  [..]
>  RIP: 0010:__get_vm_area_node+0x120/0x130
>   __vmalloc_node_range+0x96/0x1e0
>   kvmalloc_node+0x92/0xb0
>   bucket_table_alloc.isra.0+0x47/0x140
>   rhashtable_try_insert+0x3a4/0x440
>   rhashtable_insert_slow+0x1b/0x30
>  [..]
> 
> bucket_table_alloc uses kvzallocGPF_ATOMIC).  If kmalloc fails, this now
> falls through to vmalloc and hits code paths that assume GFP_KERNEL.
> 
> Revert the problematic change and stay with slab allocator.

Why don't you simply fix the caller?
-- 
Michal Hocko
SUSE Labs
