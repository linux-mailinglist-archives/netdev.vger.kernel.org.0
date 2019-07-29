Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F8C79204
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfG2RYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:24:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37020 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfG2RYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:24:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id i70so17851172pgd.4;
        Mon, 29 Jul 2019 10:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ts6M6hSea67FuVk3C4sXGDdL2yaHVXXA+9CMQ2KSBP0=;
        b=EuBo9h2tpzF5xBLUsLuqGuwzPfIrOWbdNvrR9PKZ9GeAkLVHJwX1iF3WpvI4boMbpx
         kmu0YFzVwp2eCyd4bJUNdtHwvqPm01waXWicSV/l3lgVEOcJ3uz9HKoDVv0BgOOkhiMK
         udILty0X4PJSuy1AEtNJJJGIDP72OvvIa/4kPjyk3pgNleGFClSdDDTvnW8IlbyAjrLu
         5gTUdsu3kjVmezpOiqW9y5IvWNpdpzcFXAre7nXY+HZTf6KAzmLQozlIyRBZWKRxAhdm
         5NgCGjDacSUOQvQBQRBavwVCYe1bMr2Q/tLECvWkK96adzkTcEW596wAS9OQIc63sdM3
         dzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ts6M6hSea67FuVk3C4sXGDdL2yaHVXXA+9CMQ2KSBP0=;
        b=GdkHnsFABZ57CTGQBYMp/Y5d0TVNwtYvE8kPT+JT35Cph2Z4ZaMR/tNTDZ+P/YPNi9
         lyxjESsiHUSfXbNCekvwGGtT7ln6MAWVr9yS46tpgsvRLy1U7oIDCEBX55QEeJr9ZF21
         ogJCz5gw3t89kgAgnZatB4QVkW/WUjh4WKzjBxgqb5yVH+AfJ6VJq73zKxejDFHlBbmH
         n/IFcvXzIA7CizuNugQkRVaqgFUtuOUHs8NEOH0pnmemXXUaS11JvsR1mqrQ3Vm7OuD0
         RB2ZrMChD4w1NMxTCNFNlNG/ye4WFAqcl5VZbXtkxTHYlaY5rhu7CcaU4ZTBEy0oGVXn
         bNVQ==
X-Gm-Message-State: APjAAAWV40728U/2mcsrbv6gFKFu6TzHa544Vkfz2tOqAlozuO7FWIUj
        moLPHM+de8mr568NtFx/qSZwEqFUspXTfGiXBG084kX2
X-Google-Smtp-Source: APXvYqxcsDphdpQ/WLGMiGfSzbDw4KlOpa0v9eDC59K6zgDTkxfXYPmu8CcBGms14q2J3UnPGmw3PCe/awkN/zayngo=
X-Received: by 2002:a63:36cc:: with SMTP id d195mr64093477pga.157.1564421044400;
 Mon, 29 Jul 2019 10:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190729082433.28981-1-baijiaju1990@gmail.com>
In-Reply-To: <20190729082433.28981-1-baijiaju1990@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jul 2019 10:23:53 -0700
Message-ID: <CAM_iQpU0L6hgzg1N9Ay=72Ee-2Ni-ovPJX8SyJaRDv7dbhZs_Q@mail.gmail.com>
Subject: Re: [PATCH v3] net: sched: Fix a possible null-pointer dereference in dequeue_func()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 1:24 AM Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>
> In dequeue_func(), there is an if statement on line 74 to check whether
> skb is NULL:
>     if (skb)
>
> When skb is NULL, it is used on line 77:
>     prefetch(&skb->end);
>
> Thus, a possible null-pointer dereference may occur.
>
> To fix this bug, skb->end is used when skb is not NULL.
>
> This bug is found by a static analysis tool STCheck written by us.

It doesn't dereference the pointer, it simply calculates the address
and passes it to gcc builtin prefetch. Both are fine when it is NULL,
as prefetching a NULL address should be okay for kernel.

So your changelog is misleading and it doesn't fix any bug,
although it does very slightly make the code better.
