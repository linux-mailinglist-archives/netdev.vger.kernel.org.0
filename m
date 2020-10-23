Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B29C29710C
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 16:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750250AbgJWODl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 10:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374546AbgJWODl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 10:03:41 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFCCC0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 07:03:39 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id g7so1441789ilr.12
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 07:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mRssJ8ydvqoiUM8sCx1vOe+z6Z5ELMLVEz5GB2mujoE=;
        b=qVnKKmWEAm0tfevBxG8rohkBBkyKlxmoQaS3qyQab549eqEpSl0oV7ZaCdkNsJbuE/
         kHi1jn95s1rccakqFUVXeSml70b7i34pPKIw9QgA/oAn4nwBJGMmeDt7oXiL20a25XYn
         EtpfoTrKVJV9n11Kf1pR2NaFLqFzUvUqLI95fEX7R1//3V+5RGWmgfytn3HqwL2vZHww
         s3BpqsuRXbNW36+STmgyfKDXJX08GZS3f9WAWGo2EuQVeDczmDwa04ag4Wf2De51teAf
         JcbFqXGzwjreIWBEUAyHJlhHenkH4iRRke0qo/lb/6saPU51C+Dpbv3zJ1v5iXORC307
         6S1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mRssJ8ydvqoiUM8sCx1vOe+z6Z5ELMLVEz5GB2mujoE=;
        b=m0oWfqAS8Urin8JHQReQOrba36xtt6uIly8UW44EJ/Ob+wywJlvDNXxqasGQvWIMmj
         MxbE5iXyPz+s2ZWcRJXYJZ6BiYLI4Jw65qSzM/OnoR3buh8SDGcPKxsIYMRCYMb2bvSZ
         VdijqFdxj/kCU4Z0CYAw6vyka7WTbQL1WhytnT4O9jK4sU2gRVTmFodjeVZ9s7dFokEq
         XxreP76ZDcUXqq09mAvjBJHTkEcSckifOSHAbDVh9X6HSSTlDM3M4v5/KA+qVkI3Xfju
         AiTqeopvKLvH9/oF85Mt/Q0OYudRJCL52rngKUMN0yqBvnx5p+93D4vX4lyyGQqPPGnD
         Fg3Q==
X-Gm-Message-State: AOAM531VhyRoY5hagsEkqWHkJ971bLiD8oeQ2DPE9kwmJtau01zvPXm6
        SqEt24y+hBZnB+MWEuY5rqxotOK5NX9I3vws6u8hKg==
X-Google-Smtp-Source: ABdhPJzrFPt45G3s0kkUubcqEPhNGKToH3X0KJNnX5ZYLf5G+oDxxsNkj03vFpNV0eVyJ5dgf2XfB+FJJrli479WSeQ=
X-Received: by 2002:a05:6e02:970:: with SMTP id q16mr1766465ilt.69.1603461818703;
 Fri, 23 Oct 2020 07:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201023111352.GA289522@rdias-suse-pc.lan>
In-Reply-To: <20201023111352.GA289522@rdias-suse-pc.lan>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 23 Oct 2020 16:03:27 +0200
Message-ID: <CANn89iJDt=XpUZA_uYK98cK8tctW6M=f4RFtGQpTxRaqwnnqSQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix race condition when creating child sockets from syncookies
To:     Ricardo Dias <rdias@memsql.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 1:14 PM Ricardo Dias <rdias@memsql.com> wrote:
>
> When the TCP stack is in SYN flood mode, the server child socket is
> created from the SYN cookie received in a TCP packet with the ACK flag
> set.
>
...

This patch only handles IPv4, unless I am missing something ?

It looks like the fix should be done in inet_ehash_insert(), not
adding yet another helper in TCP.
This would be family generic.

Note that normally, all packets for the same 4-tuple should be handled
by the same cpu,
so this race is quite unlikely to happen in standard setups.
