Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBC95EA9DC
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 17:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbiIZPMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 11:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbiIZPMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 11:12:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8A1647FC;
        Mon, 26 Sep 2022 06:50:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BD2191F381;
        Mon, 26 Sep 2022 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1664200244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4+nnignD8u93QTMbO+4vxufOtmSDjzXgxDuRW+9Vc+Y=;
        b=wXNPeKYY807oTGOEqp5VUsWItY4N/bf2FG0PYuKf/76ya/XWXoSBlutnZ1v4V7ZTVE24Jq
        kcDNiVz+QDDTZinU63vcP0aQKnt9DxgJ/Il0N5ifhw8+wIaLXqfcS4eEjoUOz7O6KuQRXh
        6XNfMe0qLNWn1mp8715x1o53Ql+qjsY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1664200244;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4+nnignD8u93QTMbO+4vxufOtmSDjzXgxDuRW+9Vc+Y=;
        b=HGu2wC9OaQUC3t9QLyIF5OanWAJ3MVeu2wqtrCmlnZR0Vt3rj6ay/cPA71LiUBug2kTQ26
        BQkvYbGQFVWjp7Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 275AE139BD;
        Mon, 26 Sep 2022 13:50:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cuKbCDSuMWOIeAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 26 Sep 2022 13:50:44 +0000
Message-ID: <f4fc52c4-7c18-1d76-0c7a-4058ea2486b9@suse.cz>
Date:   Mon, 26 Sep 2022 15:50:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 13/16] mempool: Use kmalloc_size_roundup() to match
 ksize() usage
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-14-keescook@chromium.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20220923202822.2667581-14-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/22 22:28, Kees Cook wrote:
> Round up allocations with kmalloc_size_roundup() so that mempool's use
> of ksize() is always accurate and no special handling of the memory is
> needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   mm/mempool.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 96488b13a1ef..0f3107b28e6b 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -526,7 +526,7 @@ EXPORT_SYMBOL(mempool_free_slab);
>    */
>   void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
>   {
> -	size_t size = (size_t)pool_data;
> +	size_t size = kmalloc_size_roundup((size_t)pool_data);

Hm it is kinda wasteful to call into kmalloc_size_roundup for every 
allocation that has the same input. We could do it just once in 
mempool_init_node() for adjusting pool->pool_data ?

But looking more closely, I wonder why poison_element() and 
kasan_unpoison_element() in mm/mempool.c even have to use 
ksize()/__ksize() and not just operate on the requested size (again, 
pool->pool_data). If no kmalloc mempool's users use ksize() to write 
beyond requested size, then we don't have to unpoison/poison that area 
either?

>   	return kmalloc(size, gfp_mask);
>   }
>   EXPORT_SYMBOL(mempool_kmalloc);

