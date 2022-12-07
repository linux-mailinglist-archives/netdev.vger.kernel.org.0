Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC176452A4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiLGDrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLGDrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:47:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D508B57;
        Tue,  6 Dec 2022 19:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 194A7B81CB6;
        Wed,  7 Dec 2022 03:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A349AC433C1;
        Wed,  7 Dec 2022 03:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670384834;
        bh=FhD1qk9K8yePWo5SGyPjxKqDUjkOZgMvody+RDCvRlw=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=Q0fQujpVK68aD55F3z9XIUae6c0CiM/t7DaaUIf2dZnBsYqV/NtKcjZXL5coc4ZmW
         ONosLDm76QCgc67KeuQLQwBjDXLP/0sbVNQM/Dzz1y9tRfqbYNwxeHs6Vv1E+oWGkC
         W9C/9yzbT4Fyu10g6GxajCWCMeDboz2/PHmJo1iMGi4wnG1LW5n7cLqzU2UXXmMDrU
         BjC9i2DoJ7o5jzZMkKj4h0RfSMUX3UaBB0Pccf6iqhaycIgEOyos5p1Cq8YitBKiAf
         OY/Z0VGwB9EdirNFmikmjRSHYoczvpn+HudiKZuEg755Ai7z+XeDNp25GCjEl0vPHK
         mGvyY2Gkf9WvQ==
Date:   Tue, 06 Dec 2022 19:47:13 -0800
From:   Kees Cook <kees@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Kees Cook <keescook@chromium.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        pepsipu <soopthegoop@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
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
Subject: Re: [PATCH] skbuff: Reallocate to ksize() in __build_skb_around()
User-Agent: K-9 Mail for Android
In-Reply-To: <20221206175557.1cbd3baa@kernel.org>
References: <20221206231659.never.929-kees@kernel.org> <20221206175557.1cbd3baa@kernel.org>
Message-ID: <67D5F9F1-3416-4E08-9D5A-369ED5B4EA95@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On December 6, 2022 5:55:57 PM PST, Jakub Kicinski <kuba@kernel=2Eorg> wrot=
e:
>On Tue,  6 Dec 2022 15:17:14 -0800 Kees Cook wrote:
>> -	unsigned int size =3D frag_size ? : ksize(data);
>> +	unsigned int size =3D frag_size;
>> +
>> +	/* When frag_size =3D=3D 0, the buffer came from kmalloc, so we
>> +	 * must find its true allocation size (and grow it to match)=2E
>> +	 */
>> +	if (unlikely(size =3D=3D 0)) {
>> +		void *resized;
>> +
>> +		size =3D ksize(data);
>> +		/* krealloc() will immediate return "data" when
>> +		 * "ksize(data)" is requested: it is the existing upper
>> +		 * bounds=2E As a result, GFP_ATOMIC will be ignored=2E
>> +		 */
>> +		resized =3D krealloc(data, size, GFP_ATOMIC);
>> +		if (WARN_ON(resized !=3D data))
>> +			data =3D resized;
>> +	}
>> =20
>
>Aammgh=2E build_skb(0) is plain silly, AFAIK=2E The performance hit of
>using kmalloc()'ed heads is large because GRO can't free the metadata=2E
>So we end up carrying per-MTU skbs across to the application and then
>freeing them one by one=2E With pages we just aggregate up to 64k of data
>in a single skb=2E

This isn't changed by this patch, though? The users of kmalloc+build_skb a=
re pre-existing=2E

>I can only grep out 3 cases of build_skb(=2E=2E 0), could we instead
>convert them into a new build_skb_slab(), and handle all the silliness
>in such a new helper? That'd be a win both for the memory safety and one
>fewer branch for the fast path=2E

When I went through callers, it was many more than 3=2E Regardless, I don'=
t see the point: my patch has no more branches than the original code (in f=
act, it may actually be faster because I made the initial assignment uncond=
itional, and zero-test-after-assign is almost free, where as before it test=
ed before the assign=2E And now it's marked as unlikely to keep it out-of-l=
ine=2E

>I think it's worth doing, so LMK if you're okay to do this extra work,
>otherwise I can help (unless e=2Eg=2E Eric tells me I'm wrong=2E=2E)=2E

I had been changing callers to round up (e=2Eg=2E bnx2), but it seemed lik=
e centralizing this makes more sense=2E I don't think a different helper wi=
ll clean this up=2E

-Kees


--=20
Kees Cook
