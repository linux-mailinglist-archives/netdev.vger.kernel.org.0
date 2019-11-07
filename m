Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50C0F35AA
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbfKGR0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:26:19 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36255 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKGR0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:26:19 -0500
Received: by mail-io1-f68.google.com with SMTP id s3so3188926ioe.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 09:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eKbKLf96PTi9o6uCQvk8b1LNqM0zHkMN3+hma2ueTAI=;
        b=McKuEPIg4/oTeI8kTvzT/IWOv9vAfVLNsEqbNDD9zalQE7axRrxr08lCnmnbc44iaV
         ofy2DzD0urYFLZ+GCXe3V4qJe1aFcDcYp8YeLFGGgfNQLaUi/0T5YbNJJAVSpyP3siK0
         RiHi6vEUNLznRz/80ciV5VKs/GyFqOH+tZYv3cs86uVlT1TCiGRf/S+gNNtcD5IMQYiD
         kggQQN+o1za0iU4yKoo9FsCHN3JK+e0qgbGMslJVk7Rl2wDH+6Xv4dP83gfSJdvC8eyD
         1eh44SClrDN7C7QTn1cReN6cnE6yFa8cpc2yGAJ9hlOftuaYCixICm4rMOsVJghY7fMw
         blLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eKbKLf96PTi9o6uCQvk8b1LNqM0zHkMN3+hma2ueTAI=;
        b=YS3nSX/eHdyO98AwLMoldcCrwdP36aF4GRO6eBi2AwtrFYxA/AivAPH7IVy0bwlcyA
         2n9lXI1j3cnyTuPau8AcROVyNuvyqteNd6w5stndF2RbHXJ0uUS3XGfBLcQTcP8vOl1t
         aUNz4FWe7lfdF4XrQNPeswmwd7Zi9e9mx60EpGWlPV9uTgVgD9XgBkl1/TwRTGkp3kWk
         U/vP374ulKJ1Vd1NgsdnII9wQCOgo45f8jrPkgX3SGdlfgcWKldTZAi+pT+TzMHl5oS9
         qRdR8y9pQHTnYLXaN4w8PA4AkN+SKcjeTheywk2S7pcCU3q4YUUGnX2zf6KJ+tjteP6e
         7/aw==
X-Gm-Message-State: APjAAAXbxLJafcZXN7kEtbskh7mFEO8A9Yu9f+aysUNNy8WUjAhPnxdZ
        EmZYwhcL/nQUhGPTCzbLJ0P5zHkxq+znsOrzAFUFQw==
X-Google-Smtp-Source: APXvYqy8ftQkwLEprEf1XMpEHQAfGzp7n+jQyC4pVww74PPWXrPMvY57Y3gl9EMgk6BIRUsb97yl2kH1GgR/vlhNqF4=
X-Received: by 2002:a05:6638:a27:: with SMTP id 7mr5184853jao.114.1573147577355;
 Thu, 07 Nov 2019 09:26:17 -0800 (PST)
MIME-Version: 1.0
References: <20191107024509.87121-1-edumazet@google.com> <094aedc7-3303-7f27-25eb-a32523faa5b7@gmail.com>
 <CANn89iJbwZ9TqC_ry2O9QCzp3SJtUcXept_SkKY=DEMTP61zwg@mail.gmail.com> <aa337d1c-28cb-6e63-6603-f9d54b51d2c9@gmail.com>
In-Reply-To: <aa337d1c-28cb-6e63-6603-f9d54b51d2c9@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Nov 2019 09:26:06 -0800
Message-ID: <CANn89iJMn7+AHXCRPD_1E-PwFnkwLSqGTALfR8EyU5OwVjxFDw@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fixes rt6_probe() and fib6_nh->last_probe init
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 8:50 AM David Ahern <dsahern@gmail.com> wrote:
>

> Reviewed-by: David Ahern <dsahern@gmail.com>

Great, I 'll send a V2 for David Miller convenience (I do not believe
additional Fixes: tag are taken by patchwork)
