Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCE6974EE
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBODcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBODcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:32:10 -0500
X-Greylist: delayed 336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Feb 2023 19:32:09 PST
Received: from out-75.mta1.migadu.com (out-75.mta1.migadu.com [IPv6:2001:41d0:203:375::4b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ADF30EBD
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:32:09 -0800 (PST)
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676431591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XG+N5atD3rrv7wgr8NJ0OpTu4DQAngSsJs+pfFUmnvU=;
        b=bcqN3uimJ2WM7odUPXF7pnV6QmTy6rjqbf7OigFo29YUcKFP/1nBJMj7cw4vO9B4RKyETE
        VbE39ZMdjLDkw9ohdyNE5OJAcX6znFzPzWTDq+MjyVdE5wWHox88fbogF5RG89yXYwEXai
        UCeX7scQiksU4zUx+haZWNDkU6n+SPY=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
MIME-Version: 1.0
Subject: Re: linux-next: manual merge of the mm tree with the bpf-next tree
Date:   Tue, 14 Feb 2023 19:26:18 -0800
Message-Id: <99651DE3-38E2-43FA-B7F7-9B06ECDCDD34@linux.dev>
References: <20230215135734.4dffcd39@canb.auug.org.au>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>
In-Reply-To: <20230215135734.4dffcd39@canb.auug.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

the merge looks good to me. Thank you for doing this!

Roman

> On Feb 14, 2023, at 6:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote=
:
>=20
> =EF=BB=BFHi all,
>=20
> Today's linux-next merge of the mm tree got conflicts in:
>=20
>  include/linux/memcontrol.h
>  mm/memcontrol.c
>=20
> between commit:
>=20
>  b6c1a8af5b1e ("mm: memcontrol: add new kernel parameter cgroup.memory=3Dn=
obpf")
>=20
> from the bpf-next tree and commit:
>=20
>  2006d382484e ("mm: memcontrol: rename memcg_kmem_enabled()")
>=20
> from the mm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc include/linux/memcontrol.h
> index e7310363f0cb,5567319027d1..000000000000
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@@ -1776,17 -1776,11 +1776,17 @@@ struct obj_cgroup *get_obj_cgroup_from_=

>  int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
>  void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
>=20
> +extern struct static_key_false memcg_bpf_enabled_key;
> +static inline bool memcg_bpf_enabled(void)
> +{
> +    return static_branch_likely(&memcg_bpf_enabled_key);
> +}
> +
> - extern struct static_key_false memcg_kmem_enabled_key;
> + extern struct static_key_false memcg_kmem_online_key;
>=20
> - static inline bool memcg_kmem_enabled(void)
> + static inline bool memcg_kmem_online(void)
>  {
> -    return static_branch_likely(&memcg_kmem_enabled_key);
> +    return static_branch_likely(&memcg_kmem_online_key);
>  }
>=20
>  static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
> @@@ -1860,12 -1854,7 +1860,12 @@@ static inline struct obj_cgroup *get_ob
>      return NULL;
>  }
>=20
> +static inline bool memcg_bpf_enabled(void)
> +{
> +    return false;
> +}
> +
> - static inline bool memcg_kmem_enabled(void)
> + static inline bool memcg_kmem_online(void)
>  {
>      return false;
>  }
> diff --cc mm/memcontrol.c
> index 186a3a56dd7c,3e3cdb9bed95..000000000000
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@@ -348,11 -345,8 +348,11 @@@ static void memcg_reparent_objcgs(struc
>   * conditional to this static branch, we'll have to allow modules that do=
es
>   * kmem_cache_alloc and the such to see this symbol as well
>   */
> - DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
> - EXPORT_SYMBOL(memcg_kmem_enabled_key);
> + DEFINE_STATIC_KEY_FALSE(memcg_kmem_online_key);
> + EXPORT_SYMBOL(memcg_kmem_online_key);
> +
> +DEFINE_STATIC_KEY_FALSE(memcg_bpf_enabled_key);
> +EXPORT_SYMBOL(memcg_bpf_enabled_key);
>  #endif
>=20
>  /**
