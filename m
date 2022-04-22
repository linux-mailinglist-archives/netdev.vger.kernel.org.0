Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A456B50BEB6
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiDVRcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiDVRcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:32:48 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F30FCD5
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 10:29:52 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ef4a241cc5so92604157b3.2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 10:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MKrsVGBE/lGfTJMJjj2crl/hzViGD7tKL0/pCKrasqw=;
        b=egAIgAltKgI+qsrpaS1eFZgw/RCNbuUTD0NRa2K2bqatalOWeKsmBUAZh5b37TOu2b
         o29ifWG797lT9CvJO+necWKpqx9mt4yAQ1kDsvdZKez7S+hUZUsYMrgVvw1ZLmsrVVNs
         y9HrPW6IDt1xmz+t8WqXHusvtVzDNx5wwt5HOrYFIpb3XYRz3WynzkPBe6ldnbO/XPLx
         1csuwd9xHXQtb2A0JBpEZXOwcRod30/PAvQWGQn9GAXUNRsYt5l9glT+0zNpf/s4dVyH
         +vTagxtagCwuxR4wlc21lNt3mXanKVoTIq+dXxqMsrLvuLNNfxHEBh/6HwqgLkBb/+PC
         Vu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MKrsVGBE/lGfTJMJjj2crl/hzViGD7tKL0/pCKrasqw=;
        b=Nyv9xGT3PQOlkWjLMbo57SdJk+S++BS11wcGiFrgmQb79vxNWSzdZ2EB8o3/KdlwYZ
         2clw1G1yUHVxqoh9r+zt+l+h/nKHGMob6FS7jrIrKQ//KUjus0TSWHIfCrzdb59VER9w
         PR4bfrErs3IZK+4Zx6raZ7QXHUB1mvbcFnmXezSwQC7WTCG/TeB5GzcsIBhoihZFXIYr
         81r8Pfg33/yTq+pRzlMa7Dnm0NwoJfPPEWskNLpSZ1D6WTffE3oFFodEKvXK+wygbj9G
         yRBzjE3kFn6/zn8MhWFcai7xoXEHrsYz4Z2MmROh4tXxKJe3nDMLvMLsTwYmG7MdH/RN
         DCAw==
X-Gm-Message-State: AOAM5330IyHdsOmarU+CRhQdThh7wtTuDPS5hJxn/bxsws+GOo5/aqed
        pI9GETeCx4U7ww/zW2trUQb/jbGYORabTXM+KXMmLA==
X-Google-Smtp-Source: ABdhPJy11Z9eszbFipBKxkc/F4TEjGKrbONhOlxkEHauoI4LBiqgi7unle8n+YSHEB9YhKy5EGK2W4SYslP5A/oKFcM=
X-Received: by 2002:a81:753:0:b0:2eb:ebe9:ff4f with SMTP id
 80-20020a810753000000b002ebebe9ff4fmr5619274ywh.255.1650648351081; Fri, 22
 Apr 2022 10:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220421153920.3637792-1-eric.dumazet@gmail.com>
 <20220422094014.1bcf78d5@kernel.org> <CANn89iLK5i9y5=iAHS=8+SinGkmGgEXR=xk=ATpnXPakD1j-vQ@mail.gmail.com>
In-Reply-To: <CANn89iLK5i9y5=iAHS=8+SinGkmGgEXR=xk=ATpnXPakD1j-vQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Apr 2022 10:25:40 -0700
Message-ID: <CANn89iKqLtyz5H6D1e9Yxd30FTJvbASfNckMAq63UJ+gvauu-Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: generalize skb freeing deferral to per-cpu lists
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
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

On Fri, Apr 22, 2022 at 9:50 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Apr 22, 2022 at 9:40 AM Jakub Kicinski <kuba@kernel.org> wrote:

> >
> > If so maybe we can avoid some dirtying and use a single-linked list?
> > No point modifying the cache line of the skb already on the list.
>
> Good idea, I can think about it.
>


My first implementation was using an llist (as current per-socket llist),
but then I needed the count as well, so I converted to standard sk_buff_head

It seems we can hand code to:

     spinlock_t  lock;
     struct sk_buff *skb_head;
     int count;

We also could keep an llist,  and an atomic_t for the count, but that
would require two atomic ops, so no good.
