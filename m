Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A48D689001
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjBCHA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjBCHA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:00:26 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4625B88F3C
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:00:25 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-4b718cab0e4so56915407b3.9
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NTb+Xvcq6Ic5EZEToCXro7A+Jx13vzlo90uTnQe1jYA=;
        b=k9JQvpWxI68o1UjRiCGqoQ1LjDz0tg4Hw10cG8JthE8kDZFi1knhwWpdeZ/df5dTUy
         wT74vu8dj9EJjDIe8fmhOb7iiV34YOxknbCzJy9hzPEYxhzdoiN5A7t7Hb6ZppvbLITX
         x0YAYP63qXZrxQ6ReeoLhFRmK+0kLDFK8eDOT5Swj+RHZFcT6a1Yx/b5qMCquaqbIiOJ
         8mKiqCRSZwYvxchvOG/05TlJT8WnhdHmulRoWAZQAVyRB7PDGr7mNtkooFWzi+XG9V9n
         TmfYFJ2AqQIM0LaBkigqeJGSIPXFECbaSHC8dM4nf/ip4i5enqE+aPEYbOaIfg+C/r71
         d3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NTb+Xvcq6Ic5EZEToCXro7A+Jx13vzlo90uTnQe1jYA=;
        b=nMtF5pnicCBbhXGVSV6vhDOAlbPDPDgZ5WIG0RlgN8/+n3hRGRF5kIDh7ENnzoNEmE
         7Jpr2HCZV0SHRVMWgOu/0dObF7W76fOFVJagMHkBgRPTTIISMYj269+fsZ2BAxxpj92J
         cha3PoAvByVLmMgw3S8rAULebx4JF+GpyHeVDXyLyuPcRFvqDTXdOUTmD2jy9o06IDdi
         PRlPzL3/g+kpg/pKbCWl2RC9scvve5ctjRQJaid8t79XHOHVGsjsdcejilNvPjeJNh6I
         A25lP1uLMuC9W85FxcDzS+R2l4hQA5NXtjmGaRR53bGGBbAJOECXyXbghVCGHWr8EHIw
         f2WQ==
X-Gm-Message-State: AO0yUKXP4v23H2fJgayYlhpFeHUOT/mAaZnbf+OsZy9am3xIVFEPd884
        wo8dqWdVH7qRfRpfBNFIRk9h2ZgeHZk+lSadfTymDg==
X-Google-Smtp-Source: AK7set/sx4Nb7rjxjo7ZNr2gSDNUOs28Ehq4Y3ZFuwNB+F84Ue9S6+WbFq2xTc9WFkyKh2wTky8yyn1CSAnC9zNHSmo=
X-Received: by 2002:a0d:df86:0:b0:36c:dd56:ce59 with SMTP id
 i128-20020a0ddf86000000b0036cdd56ce59mr1001118ywe.321.1675407624195; Thu, 02
 Feb 2023 23:00:24 -0800 (PST)
MIME-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com> <20230202185801.4179599-5-edumazet@google.com>
 <20230202211105.1ce7f83f@kernel.org>
In-Reply-To: <20230202211105.1ce7f83f@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Feb 2023 08:00:10 +0100
Message-ID: <CANn89iL+rJVTaqUL40YoP-0YGb8u0XZy+u4jKbxRxXmrgE3qJg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Alexander Duyck <alexanderduyck@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 6:11 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  2 Feb 2023 18:58:01 +0000 Eric Dumazet wrote:
> > +/* We want SKB_SMALL_HEAD_CACHE_SIZE to not be a power of two. */
>
> Why is that?  Is it to prevent potential mixing up of objects from
> the cache with objects from general slabs (since we only do a
> end_offset == SKB_SMALL_HEAD_HEADROOM check)?

Good question.

Some alloc_skb() callers use GFP_DMA (or __GFP_ACCOUNT)
we can not use the dedicated kmem_cache for them.

They could get an object of size 512 or 1024

Since I chose not adding yet another
skb->head_has_been_allocated_from_small_head_cache,
we want to make sure we will  not have issues in the future, if
SKB_HEAD_ALIGN(MAX_TCP_HEADER)
becomes a power-of-two. (for example for some of us increasing MAX_SKB_FRAGS)

Alternative would be to add a check at boot time, making sure
no standard cache has the same object size.

This might have an issue with CONFIG_SLOB=y, I wish this was gone already...
