Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CF46754C8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjATMk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjATMku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:40:50 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F22BC8AE
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:40:37 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-4d19b2686a9so70196937b3.6
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KZ7F+HD6II9J6twi4bv/6uSeBKfltGWETopxffqbCGE=;
        b=nxauZMPCVg0SoFK0Mpyz8j7nqsyrt8WXeKP8kF3HhDLBAa9d8wb9zTjA6qJJXVeCo4
         mOAUufBwA3Zn3RarkTPEUAl9un5EOmJYVNFrsOCHN3UkCCbSwJjNpMbPPiv80vrSia+I
         RQ0iDb0hb6MHElgZp/cAcayYyx/lkktjHDFDUCRxzKJvIL3W4X7Tr+VlLDNlBlU1lxho
         qtBlYIaR1By6r7+mGkYWqLTlptvvrxvgvlZdJRft80++0PtVrEpi6bnrcwqZKwkSGh7n
         9eWtFjHMp62NC40O9bloSEL+pmdB1cnETxsg9GanwVj44cJx1pLXWp7IcZs0bF66BJxA
         amfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZ7F+HD6II9J6twi4bv/6uSeBKfltGWETopxffqbCGE=;
        b=iWN50inwitlEWOD9I+RgirEUm2oJssrJLFvFaVGRdblzUJmseuoA1lK7XsPLy6eduO
         8W/tmUPJXwbjI6hrUfg/3gZB+RcIEjRW82j3BMIhYJecK23bYBnjLMLh6JAA37d68QHl
         d0on1LdsLvn6nCY/nfblwuxES+uAztWY3dV8aTNfwx8rcNnYMN9NIKg65vTdCXrADKMB
         CR1e09LPPY6GU/OpVFHkoL6DtHnTuWY2QM/TytkFlUaZjy47WA62LTxTzIOYsfA9QulU
         6/FEvf2EiLH2CBujSTBCJUxVYjCku15rI6qHnHVY7nzMooSyKTnmxDIahhIjsHZ204nk
         sekg==
X-Gm-Message-State: AFqh2kq/4bdQWkO8H/RC4CcAm5J5Pm1jy87/iJG/ikksNMM9Wwa4jSox
        DK58TsKTdWr/JSxP+I9Brxzf71OwS1gk3XfePfmtJg==
X-Google-Smtp-Source: AMrXdXteSawgnTeRNgzQijXURXk7jm+WhZKvriX4helWXKYj4Ylyct9NEv6IBmW0OodfNs+CRsbkQSYaPpfvmhDBvhM=
X-Received: by 2002:a81:351:0:b0:36c:aaa6:e571 with SMTP id
 78-20020a810351000000b0036caaa6e571mr1309045ywd.467.1674218434373; Fri, 20
 Jan 2023 04:40:34 -0800 (PST)
MIME-Version: 1.0
References: <167421088417.1125894.9761158218878962159.stgit@firesoul>
In-Reply-To: <167421088417.1125894.9761158218878962159.stgit@firesoul>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 20 Jan 2023 13:40:23 +0100
Message-ID: <CANn89iKqOj6Zxt38WDyXZvFSi6oBQpXFoYwZYh7Uqk27evVybg@mail.gmail.com>
Subject: Re: [PATCH net-next V2] net: fix kfree_skb_list use of skb_mark_not_on_list
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
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

On Fri, Jan 20, 2023 at 11:34 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> A bug was introduced by commit eedade12f4cb ("net: kfree_skb_list use
> kmem_cache_free_bulk"). It unconditionally unlinked the SKB list via
> invoking skb_mark_not_on_list().
>
> In this patch we choose to remove the skb_mark_not_on_list() call as it
> isn't necessary. It would be possible and correct to call
> skb_mark_not_on_list() only when __kfree_skb_reason() returns true,
> meaning the SKB is ready to be free'ed, as it calls/check skb_unref().
>
> This fix is needed as kfree_skb_list() is also invoked on skb_shared_info
> frag_list (skb_drop_fraglist() calling kfree_skb_list()). A frag_list can
> have SKBs with elevated refcnt due to cloning via skb_clone_fraglist(),
> which takes a reference on all SKBs in the list. This implies the
> invariant that all SKBs in the list must have the same refcnt, when using
> kfree_skb_list().
>
> Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
> Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
