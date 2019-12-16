Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7364E120237
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 11:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfLPKUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 05:20:45 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:42644 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbfLPKUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 05:20:45 -0500
Received: by mail-ua1-f67.google.com with SMTP id d8so1872999uak.9
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 02:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MkbL1d/SzqUihRGV9EGxMppkoVLFMzfPIRPZl16fK20=;
        b=tHE/FqAndfXj+pF3rpKcyZB3P2mC/ivGu+RuNn7h6U8fH6CwMbbwsVUcsp/rTQHd7w
         SnHZW/qVxTnvRge2orkhtQ9Xsf73XYevjXfqvfdKDkG6TobwnqhLBRLLAqcTfYe0WEYP
         TemamdhsBonUMSlcJPhpPbtBP1PxXnbcO6gUB921WNamWplR0wZicOySkVBqhLyXZ1Yo
         5/Wicv3VUbruyGwEo/ySRP7hgpg/Rx9tzYgwHjF/x5Tt0Rb19SDBDqLbx7dadCPp/2w3
         55sfvzdVwUdtHbd82oEpCim18++9O0mztUBgkt/XgEzxg9/Ghg+3d2LhqjyhP+4MBMHG
         ziSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MkbL1d/SzqUihRGV9EGxMppkoVLFMzfPIRPZl16fK20=;
        b=kQWYcF4ElSEImk5PyfKjEokwpObsuIYlXKv7x1i1Fa3FKPv55sp+cajUASk2EPedBc
         De1ss09OuURaXExtpvhYyL8GtNmtK4tEsNvFPpP3EGE9ZqgO2V/3aTCCZCkw8PzqLVHB
         R2eBN1CXa87Fp7+GnbtPu6FzxUnXRsbm8xjQ8qh5sgC7V8HoFFHQwYs8qDNwv/B0K5qA
         94flDuMpjjfYZ24gpRIn1Bsdu2IFyUYOxxKDOKA5DueKn27Fs6J4xXYrUQMke5DPCrTb
         cmflsy4mTW+Qilve5+rnYrZj38teiAz9eVv1qo4A4ohbDgC8wq9Pc3S7R5CODuQ38/T1
         rnDg==
X-Gm-Message-State: APjAAAUSJG0HxRY+r2iHj1Ie3OfHPBgFUcvmg18D7Pjfxi9BlIPjRZHH
        TxAoczXhHrdOnJ1jnGkR6ZpocNNaVLylToJS/ofvyw==
X-Google-Smtp-Source: APXvYqytRcaEhtLm4UxsiP0XcQ5WA/lllFA43ewjb5KkmW6LveWszgSmmf6NQVq50n36TRexdsgdRA2S2NxjbZ7+23A=
X-Received: by 2002:ab0:7219:: with SMTP id u25mr23212467uao.10.1576491644556;
 Mon, 16 Dec 2019 02:20:44 -0800 (PST)
MIME-Version: 1.0
References: <20191215011045.15453-1-navid.emamdoost@gmail.com>
In-Reply-To: <20191215011045.15453-1-navid.emamdoost@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 16 Dec 2019 11:20:33 +0100
Message-ID: <CACRpkdYZDj+rO0WL3wFtVM0Kosx5LWrKDLkUvmqV4EVXtSeO-w@mail.gmail.com>
Subject: Re: [PATCH] net: gemini: Fix memory leak in gmac_setup_txqs
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        emamd001@umn.edu
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 2:11 AM Navid Emamdoost
<navid.emamdoost@gmail.com> wrote:

> In the implementation of gmac_setup_txqs() the allocated desc_ring is
> leaked if TX queue base is not aligned. Release it via
> dma_free_coherent.
>
> Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Looks correct to me,
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
