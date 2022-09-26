Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9915E9CAD
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiIZI7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbiIZI7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:59:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD14F3DBC4;
        Mon, 26 Sep 2022 01:59:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 82E8421D36;
        Mon, 26 Sep 2022 08:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664182753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Lb/jC5elVDHJVD4iZP6e8+D+hP4jLe4mPHbNOrwg2Y=;
        b=JWX1NuBwi+fFMrBUtA0Zb00NPb6CAYHpzM7/2hIUs7ghzr2e04MTjoo/o5YivNBSfp3bBZ
        q/4mPhv/F1b3+VLD0Nkp0Pf5n0sCJPNs5UqkIs8bv2cwDP7ewF/2IeXJLn3EG8gZWcjR6Y
        7NEqZSEI6NUVBN9wNUrFFKZyvWhFRLg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 620A913486;
        Mon, 26 Sep 2022 08:59:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R7icFeFpMWNCZwAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 26 Sep 2022 08:59:13 +0000
Date:   Mon, 26 Sep 2022 10:59:12 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, tgraf@suug.ch, urezki@gmail.com,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Martin Zaharinov <micron10@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
Message-ID: <YzFp4H/rbdov7iDg@dhcp22.suse.cz>
References: <20220926083139.48069-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926083139.48069-1-fw@strlen.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 26-09-22 10:31:39, Florian Westphal wrote:
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
> bucket_table_alloc uses kvzalloc(GPF_ATOMIC).  If kmalloc fails, this now
> falls through to vmalloc and hits code paths that assume GFP_KERNEL.
> 
> I sent a patch to restore GFP_ATOMIC support in kvmalloc but mm
> maintainers rejected it.
> 
> This patch is partial revert of
> commit 93f976b5190d ("lib/rhashtable: simplify bucket_table_alloc()"),
> to avoid kvmalloc for ATOMIC case.
> 
> As kvmalloc doesn't warn when used with ATOMIC, kernel will only crash
> once vmalloc fallback occurs, so we may see more crashes in other areas
> in the future.
> 
> Most other callers seem ok but kvm_mmu_topup_memory_cache looks like it
> might be affected by the same breakage, so Cc kvm@.
> 
> Reported-by: Martin Zaharinov <micron10@gmail.com>
> Fixes: a421ef303008 ("mm: allow !GFP_KERNEL allocations for kvmalloc")
> Link: https://lore.kernel.org/linux-mm/Yy3MS2uhSgjF47dy@pc636/T/#t
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Florian Westphal <fw@strlen.de>

Please continue in the original email thread until we sort out the most
reasonable solution for this.
-- 
Michal Hocko
SUSE Labs
