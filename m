Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3C744006C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJ2Qhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:37:43 -0400
Received: from mail-yb1-f171.google.com ([209.85.219.171]:34350 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhJ2Qhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 12:37:41 -0400
Received: by mail-yb1-f171.google.com with SMTP id o12so25704277ybk.1;
        Fri, 29 Oct 2021 09:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t7EbXoQnrBFVmC/CEdkKdyC1qllJNo666H7Pkno2xpg=;
        b=OAxTsAdLjzEjsnLboXyYhiYOOUCkBCnbHFQhDjHXF/6zhQz016Kw/xa+fCDu2QQ79S
         Bnj2NXpEcccI0fsR0VOGzgPiFK/TqmO2U2g5k5GQIui7VG/do636PGzVwqo//T3KOPkq
         4XXYaSbw+rAOeQFo+d0WtJf25VKODKO+R9h6+FhXlFQwH38AFTDQLfwe0Rphvsf+OElB
         aKVa0ynklDatUjwHJY4MPKUu1yHoEnB1yBRuYbo4osW549lE1Emfg5iIqvB9D7sYxNKB
         Thm6Zyz8yqj9BNDe5g5fILP0Zaops/hzRMhye/tRvXl8qzZl9otU4bhsePkNkd19N9Ir
         FGJQ==
X-Gm-Message-State: AOAM533jetbuMTS1bpbulRlSOxnZeGuhjJUrW+9CYF8VLxL5giuq4X+E
        +kn5wjnHPLMrhwo5MDDKSJD7twNLEtbmlDD5sb5XXzohqM8=
X-Google-Smtp-Source: ABdhPJxDGUr6UmNyi4rJyvuoUs2oesl4vhS8oM6dXBrefwQEywjHKoDXAtiOHVuSjt++3PF0bniK92jrKlFP87G2pco=
X-Received: by 2002:a25:820b:: with SMTP id q11mr12743500ybk.536.1635525312325;
 Fri, 29 Oct 2021 09:35:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211026180909.1953355-1-mailhol.vincent@wanadoo.fr> <20211029113405.hbqcu6chf5e3olrm@pengutronix.de>
In-Reply-To: <20211029113405.hbqcu6chf5e3olrm@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 30 Oct 2021 01:35:01 +0900
Message-ID: <CAMZ6RqJ1CtphrUxRDWOKEsJF_uzoPbYD2mPiD56VvJ9qB7oxow@mail.gmail.com>
Subject: Re: [RFC PATCH v1] can: m_can: m_can_read_fifo: fix memory leak in
 error branch
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Matt Kline <matt@bitbashing.io>,
        Sean Nyekjaer <sean@geanix.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 29 Oct 2021 at 20:34, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 27.10.2021 03:09:09, Vincent Mailhol wrote:
> > In m_can_read_fifo(), if the second call to m_can_fifo_read() fails,
> > the function jump to the out_fail label and returns without calling
> > m_can_receive_skb(). This means that the skb previously allocated by
> > alloc_can_skb() is not freed. In other terms, this is a memory leak.
> >
> > This patch adds a new goto statement: out_receive_skb and do some
> > small code refactoring to fix the issue.
>
> This means we pass a skb to the user space, which contains wrong data.
> Probably 0x0, but if the CAN frame doesn't contain 0x0, it's wrong. That
> doesn't look like a good idea. If the CAN frame broke due to a CRC issue
> on the wire it is not received. IMHO it's best to discard the skb and
> return the error.

Arg... Guess I made the right choice to tag the patch as RFC...

Just one question, what is the correct function to discard the
skb? The driver uses the napi polling system (which I am not
entirely familiar with). Does it mean that the rx is not done in
IRQ context and that we can simply use kfree_skb() instead of
dev_kfree_skb_irq()?


Yours sincerely,
Vincent Mailhol
