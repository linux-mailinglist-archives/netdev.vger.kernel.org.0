Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D5656ABA6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 21:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbiGGTQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 15:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiGGTQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 15:16:08 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E98F5C9D7
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 12:16:04 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id p4so1927728wms.0
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 12:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=of729cYQdZdatbdtOkxwYpHbBpVYD6mDwvI8OalqF/o=;
        b=V9nrML7ATfHvbYWklR0Oe2gzTDbjRLUtkda6dyGevx7bagNTD65ZqDTlKZirih5aQ1
         nkX0TTKbRtilcre9JSlFYoQn3qcIXVkpQdvAbeJAItCMbjV9BvZD23iO9tn/VrjBpGru
         KZFli/CXWr3kFMVrmqXy+YPpEv3+dBG02Y6iuCQ9sqm8XAx/uLSHgUEXqjDzq3oXUdbQ
         mId9ygf9HdZzddUVAEuV/UqJOTkNMagpstdk+z9MSsEAraL5XHdPvcnaYEogTvZsdLjm
         haswyT1lsFEWpC18LYFOZ0t0WcKCbZDLQKiRF/HBqnJeGP4KN6guHx1djhwXS5SfZ2Hz
         vXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=of729cYQdZdatbdtOkxwYpHbBpVYD6mDwvI8OalqF/o=;
        b=EbPIvuQLkR2fTVJe5+ijqavOjAbU9E3vjzxNIzEUquMyL3ueK6g4sBRACaCZab+D/L
         A7VmlvYVC0MeWB9w3L312PJzqBW3JeJ6ZxYNv8ajk+2SXsuNsvIhtFhUtNrMKeREWXlb
         9QtKsmAtH9RJPoFjrzVuFsrPB8BaBFHoPQBD+3IM3+Vi49orbHSwGF/kx0SEscvUWHj3
         ipfC2T9KA8Grc4xQo9Xr1skYBaukWEKp1ty5BGXT4JjntXqxb6FZDuKLGaw54QX5q8WA
         YcVRvA6KVXNHxkNNeCZ9tVzWRgfBHxvl1cvfUgHw8WY0kMYZl+IODLcSg3aylzdNF26Q
         +WMQ==
X-Gm-Message-State: AJIora9EJpFj7XMzv41zZjiZ3PM98WgxJbCphIgCytuxiR4MLlrdBXcF
        TAUo3XN7MtNXZdRBl5EP8UMc/EyMf4d7Op9hPDI/
X-Google-Smtp-Source: AGRyM1ujmYeLrS7g423s1azgK9mH3+K6H5JmKsA3Sj8Nhk0vm63Rpr3/GjZGXw6pIRtiE3dUUVQupoL7Ac9kaUGVDh0=
X-Received: by 2002:a05:600c:4f85:b0:3a1:a8e7:232a with SMTP id
 n5-20020a05600c4f8500b003a1a8e7232amr6425558wmq.158.1657221363107; Thu, 07
 Jul 2022 12:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220706234003.66760-1-kuniyu@amazon.com> <20220706234003.66760-11-kuniyu@amazon.com>
In-Reply-To: <20220706234003.66760-11-kuniyu@amazon.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 7 Jul 2022 15:15:52 -0400
Message-ID: <CAHC9VhQMigGi65-j0c9WBN+dWLjjaYqTti-eP99c1RRrQzWj5g@mail.gmail.com>
Subject: Re: [PATCH v2 net 10/12] cipso: Fix data-races around sysctl.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 6, 2022 at 7:43 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> While reading cipso sysctl variables, they can be changed concurrently.
> So, we need to add READ_ONCE() to avoid data-races.
>
> Fixes: 446fda4f2682 ("[NetLabel]: CIPSOv4 engine")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> CC: Paul Moore <paul@paul-moore.com>

Thanks for the patch, this looks good to me.  However, in the future
you should probably drop the extra "---" separator (just leave the one
before the diffstat below) and move my "Cc:" up above "Fixes:".

Acked-by: Paul Moore <paul@paul-moore.com>

> ---
>  Documentation/networking/ip-sysctl.rst |  2 +-
>  net/ipv4/cipso_ipv4.c                  | 12 +++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 9f41961d11d5..0e58001f8580 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1085,7 +1085,7 @@ cipso_cache_enable - BOOLEAN
>  cipso_cache_bucket_size - INTEGER
>         The CIPSO label cache consists of a fixed size hash table with each
>         hash bucket containing a number of cache entries.  This variable limits
> -       the number of entries in each hash bucket; the larger the value the
> +       the number of entries in each hash bucket; the larger the value is, the
>         more CIPSO label mappings that can be cached.  When the number of
>         entries in a given hash bucket reaches this limit adding new entries
>         causes the oldest entry in the bucket to be removed to make room.
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 62d5f99760aa..6cd3b6c559f0 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -239,7 +239,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
>         struct cipso_v4_map_cache_entry *prev_entry = NULL;
>         u32 hash;
>
> -       if (!cipso_v4_cache_enabled)
> +       if (!READ_ONCE(cipso_v4_cache_enabled))
>                 return -ENOENT;
>
>         hash = cipso_v4_map_cache_hash(key, key_len);
> @@ -296,13 +296,14 @@ static int cipso_v4_cache_check(const unsigned char *key,
>  int cipso_v4_cache_add(const unsigned char *cipso_ptr,
>                        const struct netlbl_lsm_secattr *secattr)
>  {
> +       int bkt_size = READ_ONCE(cipso_v4_cache_bucketsize);
>         int ret_val = -EPERM;
>         u32 bkt;
>         struct cipso_v4_map_cache_entry *entry = NULL;
>         struct cipso_v4_map_cache_entry *old_entry = NULL;
>         u32 cipso_ptr_len;
>
> -       if (!cipso_v4_cache_enabled || cipso_v4_cache_bucketsize <= 0)
> +       if (!READ_ONCE(cipso_v4_cache_enabled) || bkt_size <= 0)
>                 return 0;
>
>         cipso_ptr_len = cipso_ptr[1];
> @@ -322,7 +323,7 @@ int cipso_v4_cache_add(const unsigned char *cipso_ptr,
>
>         bkt = entry->hash & (CIPSO_V4_CACHE_BUCKETS - 1);
>         spin_lock_bh(&cipso_v4_cache[bkt].lock);
> -       if (cipso_v4_cache[bkt].size < cipso_v4_cache_bucketsize) {
> +       if (cipso_v4_cache[bkt].size < bkt_size) {
>                 list_add(&entry->list, &cipso_v4_cache[bkt].list);
>                 cipso_v4_cache[bkt].size += 1;
>         } else {
> @@ -1199,7 +1200,8 @@ static int cipso_v4_gentag_rbm(const struct cipso_v4_doi *doi_def,
>                 /* This will send packets using the "optimized" format when
>                  * possible as specified in  section 3.4.2.6 of the
>                  * CIPSO draft. */
> -               if (cipso_v4_rbm_optfmt && ret_val > 0 && ret_val <= 10)
> +               if (READ_ONCE(cipso_v4_rbm_optfmt) && ret_val > 0 &&
> +                   ret_val <= 10)
>                         tag_len = 14;
>                 else
>                         tag_len = 4 + ret_val;
> @@ -1603,7 +1605,7 @@ int cipso_v4_validate(const struct sk_buff *skb, unsigned char **option)
>                          * all the CIPSO validations here but it doesn't
>                          * really specify _exactly_ what we need to validate
>                          * ... so, just make it a sysctl tunable. */
> -                       if (cipso_v4_rbm_strictvalid) {
> +                       if (READ_ONCE(cipso_v4_rbm_strictvalid)) {
>                                 if (cipso_v4_map_lvl_valid(doi_def,
>                                                            tag[3]) < 0) {
>                                         err_offset = opt_iter + 3;
> --
> 2.30.2

-- 
paul-moore.com
