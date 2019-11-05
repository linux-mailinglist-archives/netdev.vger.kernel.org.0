Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1348F0369
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390262AbfKEQvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:51:14 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:32780 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbfKEQvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:51:13 -0500
Received: by mail-io1-f65.google.com with SMTP id j13so6972355ioe.0
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 08:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wU1CtI99CKpZkbpTgydrsHWGzBA4dT3HJGgZFnX/mKw=;
        b=CLEEeoSmzEtgDkIQ618MylNXnt0zXAvFQT3IWIZ2BNMb3b0BvH/l1W+6jxzUyVs/I4
         Aap7k4++8/mFG4ZrjHvy4vBXgV8uTmbrJjbQtnbm1vWqdSTN4QkRu+CCQ7AJYky4p172
         UCa5uzWv1CCUXpQJucUCXHs0fewRqANDxkdMz92j77asnr5lGZg4jn7wzx5e7xB/VtUM
         kRpF1aWtz77FNSdWMFhg6UfpS72dM/FzklBheHcxHcqbokJcpdWY7784U1oMdX7UqhVm
         flPFfLu+YsaQ0FQZsme+jjeJ6qrKWaY7LtYAy6DHJS9ylr06TyrxlzQ9vHwRImH7g8fV
         Grgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wU1CtI99CKpZkbpTgydrsHWGzBA4dT3HJGgZFnX/mKw=;
        b=TquiMc0g6J2pckYWSZDhNQwF7C3TYRYlVMW0fVq0FrzHv/390GxtZUfLart0ghoAdW
         QATj/haHkCA7OPbuwJyHg5essp/+yGZdLGqkY9DA2N2BUsR4+G8vx1xaIntFG8wtkJ0E
         2qgXs1PEdMAvMcIdvWmQIfh6ensUviZ3HdDLj+Y0n63DhWwSRj2eyZ6sJB/srMJoO00H
         gZkG6BEoULycAeLxfSX01HCogZQJm4Ufc2vBncsuJoan17UCHanpUHOtrwh9OSsMQQMH
         ucv1W7ZP1sYn9+QzFVkXBwMSO6k3yjgIP1XkAsza71qJQKUkmalbv6STsoq3+1a9MRFo
         s4aA==
X-Gm-Message-State: APjAAAUIYlwU0cDce/oyZI1/WMuHz61LoQG7PpoUyRVz81LxQQUawhKH
        o4/jKrTlHqRMl3hoOUhuMqglu9UiIEpyWoIrTtks1A==
X-Google-Smtp-Source: APXvYqxYkGc0MC8s7KXAu4OmmAZT3HUSZ/W8pwr4nDz+xvpkGISx8NsIQl6P1oqF6Giw+PIuIOBLRZNccFAUnXcfE34=
X-Received: by 2002:a5e:8e02:: with SMTP id a2mr3673663ion.269.1572972672175;
 Tue, 05 Nov 2019 08:51:12 -0800 (PST)
MIME-Version: 1.0
References: <20191105053843.181176-1-edumazet@google.com> <CABeXuvqRoAYKn6vg7t7O6nA4BCEHjkMwYp9EvVGEEkFV_EonsA@mail.gmail.com>
In-Reply-To: <CABeXuvqRoAYKn6vg7t7O6nA4BCEHjkMwYp9EvVGEEkFV_EonsA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 5 Nov 2019 08:50:55 -0800
Message-ID: <CANn89i+dqWytEiB+CTsF2drNN3Jg7DY7rbhjTDiiVDWizY3jCQ@mail.gmail.com>
Subject: Re: [PATCH net] net: prevent load/store tearing on sk->sk_stamp
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 8:25 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:

> I do not see any harm with this. Does it cause performance degradation?
>

It does not change compiler output, at least for common GCC versions.

It would change things if a hypothetical caller would do for example :

ktime_t res;

res = sock_read_timestamp(sk);
res = sock_read_timestamp(sk);

Since without  the READ_ONCE(), compiler could remove the first instance.

> Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
>
> -Deepa
