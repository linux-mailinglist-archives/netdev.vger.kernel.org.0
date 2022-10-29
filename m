Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5CB61243E
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 17:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJ2Pf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 11:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJ2Pf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 11:35:26 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10F1537CE
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:35:23 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3321c2a8d4cso72113807b3.5
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3QP4217XSjoncNxKCXGdWbVRVoESiLKewNNuCw3oEtE=;
        b=pI/f+rGf1YDYc/SB/OUG57K1gfvv4X2Oo/LV65R9kv7k+cLqt9SOZistj/MT9Wl66u
         Pud7z41bc7lP4OM9Cpa6JvffQM9RKyLOMBBuUYTKxPP8RA3MMZS+32zpeIX4sAirzUrL
         kg4Ys213X3XmsFnY+gIB824KRn/VxibdKJXJYFtYbfoN+iTVb+FGpKhwyE74fHckqN72
         92QS6yCisNlp8EpKux+Z2KC1GU+6subMxxuajBtJO0jJVw3Ht4/wHmoC9x1SiteY+UIX
         8lgfvEjvsu/2Tk8n1UcfdgXj7GL+HNK+YBY+IGoq9VZE/EMYSpEuSTyijBE5tsffC8Xz
         yyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3QP4217XSjoncNxKCXGdWbVRVoESiLKewNNuCw3oEtE=;
        b=l4N+Gwtk4OwB5LESu4OW7nA0FEzZaM303XJesbUX+l/4oGBwt7cUR+3qH0wkR8WjEP
         T8An/27U7T05KseHm04BAJ+n/y2dq0NsvpeSiySBIj2RFuFPYek07MvS0kAfOzfXvKRw
         sx0B0IVzd5OOOepdfUnxM+RO/Ai+zplwFv/lpGZYXnAdRsYpgEdwZQm3IQquHQyIv1xx
         UZGHcU2tVijKz1IX68kUvKn2abD2kDCnWrHc7vEt+jyAuYAo4OHn4vHCbfU+wtEJcVvZ
         jle/owUwrIWzueURUoDXO10UUpI6SmI0pkngYRgk7dCOjmpREY0VlGotqrqMmtIPw5dx
         cs+w==
X-Gm-Message-State: ACrzQf2m4aeGPJX7bfUZSBDMrhM27gA3AkJc4YB35tg6bXEDa1YKF5FD
        H5BkRKKqq6ilLuFkX/yScYCXtWlUhR3egqJlIipLIw==
X-Google-Smtp-Source: AMsMyM6BhDtwkYoV19AEZO/TQebKprOzjsAvSkxnWrqwGJZrcG9QB0+KQ01/NOdAwgh346RAoTEzFS5JEZ7EAtL4pFM=
X-Received: by 2002:a81:7585:0:b0:368:28bd:9932 with SMTP id
 q127-20020a817585000000b0036828bd9932mr4360717ywc.332.1667057722785; Sat, 29
 Oct 2022 08:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221029094101.1653855-1-william.xuanziyang@huawei.com>
In-Reply-To: <20221029094101.1653855-1-william.xuanziyang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 29 Oct 2022 08:35:11 -0700
Message-ID: <CANn89iKYgg6o5wQQ+QrKUU6jv7FBejU=xg+jxkTVZb_9CCxReg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: tun: fix bugs for oversize packet when napi
 frags enabled
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterpenkov96@gmail.com, maheshb@google.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com
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

On Sat, Oct 29, 2022 at 2:41 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Recently, we got two syzkaller problems because of oversize packet
> when napi frags enabled.
>
> One of the problems is because the first seg size of the iov_iter
> from user space is very big, it is 2147479538 which is bigger than
> the threshold value for bail out early in __alloc_pages(). And
> skb->pfmemalloc is true, __kmalloc_reserve() would use pfmemalloc
> reserves without __GFP_NOWARN flag. Thus we got a warning as following:
>
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
