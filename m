Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8A429C6B1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827182AbgJ0SV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:21:59 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:40648 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1826994AbgJ0SVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 14:21:18 -0400
Received: by mail-il1-f195.google.com with SMTP id n5so2385136ile.7
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 11:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qoRvzD68ixDCbL8VtZKOQyWUlz6TED0ppZzKkSjUE8w=;
        b=Cn3hYWOSowfmLy5QdXoS5AJ9RXR8Vx3ALygSQcj4pHJQjTkDCvfzl7XuOyBXO7cRR3
         buFj+qAh03JCn4f0gOBOu1mc6PFNRJDARoRwsjkyThw6+H8en4IDYVLVJbcq4R30574S
         fLx8E/gtg05TtOu0ESD8q4D0MiCdSlvLN+DQVdISVuxnu+JMPz1NEggDBxCAoq/YnfNI
         nakxkmzI0swa76IGPxtyOlZvl2fu/pjvEvInyX4N1gTrSivDiKTnqSvdq9i3Z9sCFJHi
         LTYt6j/srQDgp3IvyyQYMJtUHb59ZQIC8ibMyFDYZcn++YAJX9mNeUdi6VDrCHMfEOWy
         yOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qoRvzD68ixDCbL8VtZKOQyWUlz6TED0ppZzKkSjUE8w=;
        b=R46OY+xyZeYG6Ui7SC12IB7+NqboshGKEgcWfZIWtsB1aaBFUPjDSsjl8GLihFxh8/
         XlJCp8/TkHcBPBxqg7ifD0UuD5HUro8OIDQZmVen+jJlf3g8nOHYQ6DCLEceWhvyzIvW
         heIlYdKffMqk1hArXLQpqOTAPSbm4QNIz8MO+fbgez/PfGMVDJf0SNCTqQB6jtGRvtyd
         sDbUSnyXK8zAvGyZ9mmNnBb8shLTiblIqZTu/nNeTC8sGG2CXhEQEx7IwR2rc2YFsh/m
         /1nc+rssu4aGHIiQeoZcelyotbTh7vCxSso87ovKc2YFJKfRdYLITlzsyKD/s+SV0M2F
         R7EA==
X-Gm-Message-State: AOAM532hpa0E63vfHK4xYRpqGNjzm1XCk3g6CUe50npkrvrQQ7LQgb8s
        8rnP6sCqI7VPFqfcO9NxoscR3CcColCk8l0Z8HXvDHe9ZfgE6Q==
X-Google-Smtp-Source: ABdhPJyl8erBopjQ1gL7uqsCr0yMUoGC1EWmlnEgN2qwTliM2VH1VJZmqGT203+atVFoP9SLZABNmqpGWBk6I7A0Y4E=
X-Received: by 2002:a05:6e02:ea8:: with SMTP id u8mr3019655ilj.305.1603822876197;
 Tue, 27 Oct 2020 11:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201026104333.13008-1-tung.q.nguyen@dektech.com.au>
In-Reply-To: <20201026104333.13008-1-tung.q.nguyen@dektech.com.au>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 27 Oct 2020 11:21:05 -0700
Message-ID: <CAM_iQpXnsiGP_x-D5YEWbVmqzP2ZhRdtG1ReDQq2wr6YUs2J0w@mail.gmail.com>
Subject: Re: [tipc-discussion] [net v2 1/1] tipc: fix memory leak caused by tipc_buf_append()
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 3:46 AM Tung Nguyen
<tung.q.nguyen@dektech.com.au> wrote:
>
> Commit ed42989eab57 ("fix the skb_unshare() in tipc_buf_append()")
> replaced skb_unshare() with skb_copy() to not reduce the data reference
> counter of the original skb intentionally. This is not the correct
> way to handle the cloned skb because it causes memory leak in 2
> following cases:
>  1/ Sending multicast messages via broadcast link
>   The original skb list is cloned to the local skb list for local
>   destination. After that, the data reference counter of each skb
>   in the original list has the value of 2. This causes each skb not
>   to be freed after receiving ACK:

Interesting, I can not immediately see how tipc_link_advance_transmq()
clones the skb. You point out how it is freed but not cloned.

It looks really odd to see the skb is held by some caller, then expected
to be released by the unshare in tipc_buf_append(). IMHO, the refcnt
should be released where it is held.

Can you be more specific here?

Thanks.
