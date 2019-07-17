Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125866C162
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 21:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfGQTUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 15:20:05 -0400
Received: from mail-yb1-f182.google.com ([209.85.219.182]:44142 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfGQTUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 15:20:04 -0400
Received: by mail-yb1-f182.google.com with SMTP id a14so10163082ybm.11
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 12:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EeIqmbISi6jFp7TysyaIPF8jOqaz+MPTJ0nq9+DafNw=;
        b=SaNjktB5YfxjGU4ICFzFJCiqu+dj5OxYjwX79HjlwZ1XAVzuJYb/NBzDk9g8v5P4xe
         cwOG4ipWdcrEwikagUtF4xKWu7Km9LWGh1c+4+cqp2xSETUQw5LO1icVlrerl//hU0SI
         zGd7feC/x8urkYoID5p54vUoK4ZX7GLhHd3phXF7VCvWfA2iIU0KVFgrQHzm5uJt2eYg
         GNonjjC/BzI5AEbQtXr1TH6FTckTdDFEb8335vneDMN4wuZbBQetOc3/5c+DUYNhmz6v
         rnm6q5+z07hzbarNxzp6Xkm4vI2vyJzTmt7wR2KlB3WrS8zVxAN86PionI/sNtzUfsmR
         WMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EeIqmbISi6jFp7TysyaIPF8jOqaz+MPTJ0nq9+DafNw=;
        b=KigQ5K95Uq/mBBt6QiPJGXkXe48n5oWuoiHxmMrv0B53JiTs2i0mSyqzMjYRhW/YT9
         zUKHQ1gpmX9Iy7EVi8bQzwXuNOJPJqjsk7aQdXjM9lqcd7UxkRVg6dh2m5Pa/ho0tnmA
         RwUbLPgsI9wQmSmzFzRDZUCUVWMVpDpmVnnfggQJZZ+t6Swyc58W4LSMw58Cw5AgzuEN
         B0wVRfOA1EbvRPZ4hQkasvKGGo0e9DTJCHFpPvE7ecMK2QjEfx4nRX0deEn4k62eDsTU
         Z4s6ki7huLe912gDLiqNH4stTnwXwyCe6Zj/ft2tzprzlf2BBnzzfUeavyF/ahUohI3A
         4KYw==
X-Gm-Message-State: APjAAAX/h4sEe2C/pBiceXI64uWVMN60Huyj4bt7Ik+APEj+CVXVL6Vo
        a0irTaEzbGt51+YNvHBjbqldNYPmcNtcWygQ+Nlt/Q==
X-Google-Smtp-Source: APXvYqwJzjZbNjrTCyqycxzSD3Qu9+UFwIW0ErL1f1K4vu3GuDem7HbPUFhI9H0ze3LeTZMBbvr6UY2jnWiKYJfBG9s=
X-Received: by 2002:a25:24c2:: with SMTP id k185mr24781086ybk.504.1563391203591;
 Wed, 17 Jul 2019 12:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190716205730.19675-1-xiyou.wangcong@gmail.com> <20190717.120446.101023323109287941.davem@davemloft.net>
In-Reply-To: <20190717.120446.101023323109287941.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 17 Jul 2019 21:19:51 +0200
Message-ID: <CANn89iKKidoeN8fwZLcem8BRK1FTJptwfYkO3Jn61ya7PKQLJA@mail.gmail.com>
Subject: Re: [Patch net v2] net_sched: unset TCQ_F_CAN_BYPASS when adding filters
To:     David Miller <davem@davemloft.net>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 9:04 PM David Miller <davem@davemloft.net> wrote:
>
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Tue, 16 Jul 2019 13:57:30 -0700
>
> > For qdisc's that support TC filters and set TCQ_F_CAN_BYPASS,
> > notably fq_codel, it makes no sense to let packets bypass the TC
> > filters we setup in any scenario, otherwise our packets steering
> > policy could not be enforced.
>  ...
>
> Eric I think your feedback was addressed, please review to confirm.

Yes, this seems good to me, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
