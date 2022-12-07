Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB37F645654
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiLGJTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLGJTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:19:08 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38978293;
        Wed,  7 Dec 2022 01:19:06 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D08EF1FDBC;
        Wed,  7 Dec 2022 09:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670404744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijRcVYqPEjBAfgioAlVUgPdPwzo/HNYZ8f5vv1ik9Sk=;
        b=0aPcXOex+E1M4o5no6RISe8VqofletEFf1ZLxOzclSAm166hTjcp044ed4Rk8MMu10x/ZH
        znpNvLXbFsWDBTpxbzJ++83/YyeTTFyQgugQNowkuppSWZYwXP+8Zl51tBMActTQWYjsPN
        roICipK+C606GpImLgg2eO9107E39AI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670404744;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijRcVYqPEjBAfgioAlVUgPdPwzo/HNYZ8f5vv1ik9Sk=;
        b=wXLCuKSsXGXdou8O/5nq6Vbdd4/23AOh0ptXIuoTwKXjGMkUD4Qo0FU5yWrazDnWuGDPxv
        8nRPcyblUsJPCeAQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 63842136B4;
        Wed,  7 Dec 2022 09:19:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id EnylF4hakGOjZgAAGKfGzw
        (envelope-from <vbabka@suse.cz>); Wed, 07 Dec 2022 09:19:04 +0000
Message-ID: <ef7c0afb-cc93-e171-d439-bf2a7b960db4@suse.cz>
Date:   Wed, 7 Dec 2022 10:19:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] skbuff: Reallocate to ksize() in __build_skb_around()
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        pepsipu <soopthegoop@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Andrii Nakryiko <andrii@kernel.org>, ast@kernel.org,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, martin.lau@linux.dev,
        Stanislav Fomichev <sdf@google.com>, song@kernel.org,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Richard Gobert <richardbgobert@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        David Rientjes <rientjes@google.com>,
        linux-hardening@vger.kernel.org
References: <20221206231659.never.929-kees@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20221206231659.never.929-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/22 00:17, Kees Cook wrote:
> When build_skb() is passed a frag_size of 0, it means the buffer came
> from kmalloc. In these cases, ksize() is used to find its actual size,
> but since the allocation may not have been made to that size, actually
> perform the krealloc() call so that all the associated buffer size
> checking will be correctly notified. For example, syzkaller reported:
> 
>   BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x235/0x340 net/core/skbuff.c:294
>   Write of size 32 at addr ffff88802aa172c0 by task syz-executor413/5295
> 
> For bpf_prog_test_run_skb(), which uses a kmalloc()ed buffer passed to
> build_skb().

Weren't all such kmalloc() users converted to kmalloc_size_roundup() to
prevent this?

> Reported-by: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
> Link: https://groups.google.com/g/syzkaller-bugs/c/UnIKxTtU5-0/m/-wbXinkgAQAJ
> Fixes: 38931d8989b5 ("mm: Make ksize() a reporting-only function")
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: pepsipu <soopthegoop@gmail.com>
> Cc: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: kasan-dev <kasan-dev@googlegroups.com>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: ast@kernel.org
> Cc: bpf <bpf@vger.kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: jolsa@kernel.org
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: martin.lau@linux.dev
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: song@kernel.org
> Cc: Yonghong Song <yhs@fb.com>
> Cc: netdev@vger.kernel.org
> Cc: LKML <linux-kernel@vger.kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/core/skbuff.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1d9719e72f9d..b55d061ed8b4 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -274,7 +274,23 @@ static void __build_skb_around(struct sk_buff *skb, void *data,
>  			       unsigned int frag_size)
>  {
>  	struct skb_shared_info *shinfo;
> -	unsigned int size = frag_size ? : ksize(data);
> +	unsigned int size = frag_size;
> +
> +	/* When frag_size == 0, the buffer came from kmalloc, so we
> +	 * must find its true allocation size (and grow it to match).
> +	 */
> +	if (unlikely(size == 0)) {
> +		void *resized;
> +
> +		size = ksize(data);
> +		/* krealloc() will immediate return "data" when
> +		 * "ksize(data)" is requested: it is the existing upper
> +		 * bounds. As a result, GFP_ATOMIC will be ignored.
> +		 */
> +		resized = krealloc(data, size, GFP_ATOMIC);
> +		if (WARN_ON(resized != data))

WARN_ON_ONCE() could be sufficient as either this is impossible to hit by
definition, or something went very wrong (a patch screwed ksize/krealloc?)
and it can be hit many times?

> +			data = resized;

In that "impossible" case, this could also end up as NULL due to GFP_ATOMIC
allocation failure, but maybe it's really impractical to do anything about it...

> +	}
>  
>  	size -= SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  

