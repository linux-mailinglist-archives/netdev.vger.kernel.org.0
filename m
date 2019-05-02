Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A39712039
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfEBQbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:31:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42883 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfEBQbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:31:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id 13so1074913pfw.9;
        Thu, 02 May 2019 09:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nlTm2t8/M3JSWr94kUm/LSoXPgG+Q//2qykizTPQyP4=;
        b=qrZ8JdvdHmg5lrmECZJSjApxSQ5/2mkDIZCaLGo9V3Z0waFznLn54w514Ej7qJlUBM
         3qH30Q7wPWmvvgUlO69fKNcEdWBu5AQQaV5VxnzFtManabp14UcqRPVQBzAjfkQDfmpR
         AAidPfrYFOXT/eQ90xDWPHO0cNNdYBHyibw33igBc+WgZ0KO1aIIHnWA//KhjkcvNZyA
         AraVUYtSWNGbWUzZcGTRayT2jkHjfKCXdSsyQK8OL4nRos8vI2tzhPDFqdzQbMn7Evel
         C9c7i0MoMH7c7fmBuyWem4f4R6L6lAnaGL++mDuDgR9Rx7QT8Q0xMioxDGPAuvKXmKby
         lOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nlTm2t8/M3JSWr94kUm/LSoXPgG+Q//2qykizTPQyP4=;
        b=jPsH7R4dCktT8KSGIbqPlpZ8Va7XQyhlMFa1Z/y6ICQ8vJUKLYRwpXKwMltfvtukXv
         xR1shpjBJ3Etxz5CYlEKN1m5tOQsRYtp45n0QlPk/YxQuiFlEFvGI9iszBWAjS3zyyCE
         a0+hkcsthX42culw1YKl6j1nUlJ0sG/Ylq5mGqJ9G9bLqS1uHUQ0on0BYU5QDPjvNT/Y
         iKmS1+AgNmkXL0/f7qq2vrPfpPRS6vkqTnbQwr3P0eCixFwxYeK72jcf0wDH5oRpYfMK
         DWOHroBNeU4LHxbMGAjK0Sw44Lb6MM2nqZK05ma2OjTfnMM3DhnABr1QIrZjFcawMZ51
         bmeg==
X-Gm-Message-State: APjAAAWuBwQxOjoXIlIhaEJZepw4ATUqsXiBGIvsZ2X8+6BZo/8dTZ/V
        aJgJt3AeW1izMe3J++vDVZ7pAYK3M5zxI8BvB4Y=
X-Google-Smtp-Source: APXvYqzhEwxvu9uDuQAEuQFBPvuIwXuY8u6vq2+dbJt69MKe9xO1mVN09DHVSvCumYS7hWRzP9e4eijiu4CyVTNl980=
X-Received: by 2002:a63:6604:: with SMTP id a4mr5037545pgc.104.1556814692368;
 Thu, 02 May 2019 09:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190502085105.2967-1-mcroce@redhat.com>
In-Reply-To: <20190502085105.2967-1-mcroce@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 2 May 2019 09:31:21 -0700
Message-ID: <CAM_iQpWu5e+0KRhPPJ_p+bnOp9RHk81uTXp21ue4QpC4wZ6J4A@mail.gmail.com>
Subject: Re: [PATCH net] cls_matchall: avoid panic when receiving a packet
 before filter set
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 1:51 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> When a matchall classifier is added, there is a small time interval in
> which tp->root is NULL. If we receive a packet in this small time slice
> a NULL pointer dereference will happen, leading to a kernel panic:
...
> Fix this by adding a NULL check in mall_classify().
>
> Fixes: ed76f5edccc9 ("net: sched: protect filter_chain list with filter_chain_lock mutex")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>


Thanks for the update!
