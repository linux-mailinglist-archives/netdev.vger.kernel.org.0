Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B2729CA9A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 21:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373327AbgJ0Uuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 16:50:37 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33314 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373322AbgJ0Uug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 16:50:36 -0400
Received: by mail-io1-f65.google.com with SMTP id p15so3078921ioh.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 13:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/WlVAvrRzwvSMfBLCz6hxhE3zrD/1tBJxa1OdJARRCE=;
        b=GSIqil1ZfGN78OR6PaGlRDSmdSOUnRHY+cO5dHJ+oAkhHXs3uPiY+DMSNMrmEBOyWl
         IucQ5aCp6486j28qZcVCge5fjSoTW3RF3JK5xA4BStM8JcuKzfRixqV4+AbreSAJVbCI
         95mZ5H4/Z2ArQTooDPkC4ihBpImuGnfWyJEBRgCX7gZ8ciQNyw4geyrb5RtvBHD/nRVu
         QfWDnJ+t/5B1Io9xrqhZy9U+qWMU0I2VyhK7pjM8rNRndkEcUvP30joR2I+qEsYg4HhM
         FV0gnN8+4DjAyiwyzmVnuprVB6zbOCJHmPkgat9yVy3k1AST9bInAI+5YDVV5HOOWHQq
         uRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/WlVAvrRzwvSMfBLCz6hxhE3zrD/1tBJxa1OdJARRCE=;
        b=efjo0oUcMvfj5cC2pNfE6aCPQbpYBSA/Tbzeh3Ff7xScx3Y1guhk2Fi/tu3q5WyfEs
         WanK28tW4vpMKBhu6K8jB2A8ftA/dwRCaFhvgscIHYRiIZ8vIb5YZ7xfvVIzhAlLYkAf
         Isg1E4J8d5Jf59sSfLW+s1G4MZ6XOaseu6WA0eews9qJzQyLVQYrXv9WElJXzj5yA4+i
         NaWQuw1kz9oougXPKNomIQ1ijd12iQhArP54crYYhC50iyBoyBQc+FNVlmzk4TG2DoyU
         3XKd9XKH6Zz9I3DqHjAGh033alNgUBKG2JWwlZsovV4TCIjpFTiKkpWKTa78O2kME9zF
         yikw==
X-Gm-Message-State: AOAM530JKBxg0XzKKgGyzyKNKWUhZX9pqllhRr3F9wJ9CZJpgg4FmtvG
        9FATH08QWhIafviEe8vfyjqXUqUw6lDaJfkMPnhvvA0ueOg=
X-Google-Smtp-Source: ABdhPJyikaIl3oIF+0QsXDZ/zHbAfHJjf9IOjkjahkYRM/J2wPuWFVjofpY+tadG6g57TbMfb/Fb/cZ6BwkM68aXbmQ=
X-Received: by 2002:a02:95ea:: with SMTP id b97mr4175651jai.16.1603831834070;
 Tue, 27 Oct 2020 13:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
In-Reply-To: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 27 Oct 2020 13:50:23 -0700
Message-ID: <CAM_iQpWsUyxSni9+4Khuu28jvski+vfphjJSVgXJH+xS_NWsUQ@mail.gmail.com>
Subject: Re: [tipc-discussion] [net v3 1/1] tipc: fix memory leak caused by tipc_buf_append()
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 1:09 PM Tung Nguyen
<tung.q.nguyen@dektech.com.au> wrote:
>
> Commit ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
> replaced skb_unshare() with skb_copy() to not reduce the data reference
> counter of the original skb intentionally. This is not the correct
> way to handle the cloned skb because it causes memory leak in 2
> following cases:
>  1/ Sending multicast messages via broadcast link
>   The original skb list is cloned to the local skb list for local
>   destination. After that, the data reference counter of each skb
>   in the original list has the value of 2. This causes each skb not
>   to be freed after receiving ACK:

This does not make sense at all.

skb_unclone() expects refcnt == 1, as stated in the comments
above pskb_expand_head(). skb_unclone() was used prior to
Xin Long's commit.

So either the above is wrong, or something important is still missing
in your changelog. None of them is addressed in your V3.

I also asked you two questions before you sent V3, you seem to
intentionally ignore them. This is not how we collaborate.

Thanks.
