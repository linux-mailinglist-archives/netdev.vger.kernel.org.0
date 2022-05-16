Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A1F528CDB
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344733AbiEPS0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiEPS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:26:27 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997D433A1A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:26:26 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2fee010f509so47169657b3.11
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vqz28oPOm5kqxRAz+u916rMNvSOP2zDlq24IvOghaNo=;
        b=rmijvm5pS3xWuUdIusdf8VlZu/6uKDUUEvVHLOhE+0zhG3VgvXxvR1V2NBCAFbJ+ey
         aJ8HPasDfZJfsPp+jTbn9oKy99Q9lzUXy/WzoVIX8EnDl34pMjOon3jNIbsyr90HsmNN
         GYvaEiyN0akfMPxY0/zkTbSTwMRr8LIlAtkCFEQaJEJxu+cerkJQYWu/Cc8PbPteKz8O
         7yPOeEnsHrLYVelqUkQkexvPzlJFOmokfymx4RMqQvwFXInpMiSjcqGTuVBmZNcHi63h
         64lHIY71rJe3JhhIJDLbivrnmfEHsw8+A5YzDmO1WlMvYj0cDKy8i7sjkNF1mDNmBO6V
         53jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vqz28oPOm5kqxRAz+u916rMNvSOP2zDlq24IvOghaNo=;
        b=VMx1C4kA00xlsxgJo6bNWBhsL3FcgBtVSzV/eqE5CUaYmF6g4JS0jwJmpOZzTAvuBA
         d3PYDRbj4wQN7whS5YZ9gw6N6w6dn2fs4LzrRfGtAx61vRxDrMdz841xRxJ+BmX7LUS2
         AUB0sjbgJPDmc9fqK1fDhIk/iPEOiLq/1mTXOKfOpK2rlxy67aek4a+x12NEldpozUGx
         2qaRkXwwbHX4aBPggRLFSnuR5qPqX0QmsP6KFSSzZn0Pwp4UttaK7oKHveIjhxbGXm8T
         1gX+hhQCHcuo+EwKr2D4eA6sl/dI0tM8qALV7FJKBJ6LysILm+A3qyDn2+Wu8VnGYH99
         X+Jw==
X-Gm-Message-State: AOAM532aDFYTmYe9z2FaPJ7VTlA1FwclrjU4DlCzJ3k8JYVPdlfNVP9A
        oLK01xN2IOEWQiIBRQoUXrzTBfFSugEq9tXiqsbV/A==
X-Google-Smtp-Source: ABdhPJy6wE2bzBc6VuIzpRHChEqABHYbmTgoR3ifDqrV83n3HXrln0o3AN5XqEEL2gE53wY3oFKN2oPD/0phzFSv+2Y=
X-Received: by 2002:a81:12c2:0:b0:2ff:13ba:c5aa with SMTP id
 185-20020a8112c2000000b002ff13bac5aamr3444986yws.332.1652725585109; Mon, 16
 May 2022 11:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
 <20220516042456.3014395-5-eric.dumazet@gmail.com> <20220516112140.0f088427@kernel.org>
In-Reply-To: <20220516112140.0f088427@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 May 2022 11:26:14 -0700
Message-ID: <CANn89iL9xw83hEGA4=K-F1qkjyRhvAJ85c9W5nY1Fsmq777V0A@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: call skb_defer_free_flush() before each napi_poll()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 11:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 15 May 2022 21:24:56 -0700 Eric Dumazet wrote:
> > -end:
> > -     skb_defer_free_flush(sd);
> > +end:;
>
> Sorry for the nit pick but can I remove this and just return like we
> did before f3412b3879b4? Is there a reason such "label:;}" is good?

I thought that having a return in the middle of this function would
hurt us at some point.
