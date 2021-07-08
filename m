Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4743BF610
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhGHHQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhGHHQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 03:16:30 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB94C06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 00:13:49 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id y38so7413530ybi.1
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 00:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xCp82fGk6+VNqAbvEAYXk0jbIXytsU9/+KL0qkO3m+c=;
        b=jg4M1Sz5oZ8K6lzEXv0g70QLiDoJdqyp2/D3l2G7OxbcHhhy4M/pKdCEUfRCFB1Ouk
         +rw/UBk1I7VKGbtMNyuwl3KtJ4igbjBBFwR8uRh6eO3khT9Q5B1SJ/srMigYGMYTd2VB
         oxeekpxKGBRK0hPtdvQXPM7Ut784KfPTLK7SfGB4hsXw0VRfZn5GrEyspfIoCFNXcRk3
         A1avB51fKiS5Z/L1VkaNaCoQ8GdZxBZptbfFUVYDKp8gn06xHGV0BHcN7P6ZJCyn0oQd
         h8S3W83y+kRiPXm39qeEwqHm0i+Ye/3P/sr+7r6tmxN+7MFhMHyuN5T8NleFvafFwWYe
         /MSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xCp82fGk6+VNqAbvEAYXk0jbIXytsU9/+KL0qkO3m+c=;
        b=f0p4RvZyZK1EYQpMd54wXSLWp/fST0ZyVyFaEajs7OKU6nm+f/mBtPXXBaky4hDF5X
         cnFsszAUVryI8Y8+UV6aT2Mdh7Sv8pAPhuan2y7nYmrc0f/hWKWvy78bkdpzOU5rjSWi
         orYZrPTq9LEKDWZrB93Hg1xs5i0sdPSqLglC2XlcRY7kr8ZCj2hZ16ez2b8GzDeNp+3B
         1OwyAckadCFZJPGcX6kGQ/4VmD8vnrnO3GjM7p5keX57zgG1hXvGArDMeRt3Tk6nm/fC
         /d4mX6UAQLeKavYZ1PQbVrmbzuOhgX8iPdFdsQENveut/fz684lqm1ibSEoWtWNqFjWO
         psfQ==
X-Gm-Message-State: AOAM532vBfmkgiXN4b/5ObtwUQxbXPhmEBhTma+8oWYVQbanPNLzJ6Vz
        UtWChR+4qySAjNvRa7WR+ondQgiwura1aLnAsjxT7A==
X-Google-Smtp-Source: ABdhPJzNKRhHOxQDTINYnVAmBAoZeiKObrxnekHP4efE4g46pyjdN8NbLnswMZ4xTvKBjrgGllJCw+cJjCZWGJ3svlU=
X-Received: by 2002:a05:6902:4e2:: with SMTP id w2mr39354748ybs.132.1625728427975;
 Thu, 08 Jul 2021 00:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210708065001.1150422-1-eric.dumazet@gmail.com> <CANP3RGczchzUK=ZxyPXS8t0NmuBdJB8ajfQ72MnSQwKRBZKh4w@mail.gmail.com>
In-Reply-To: <CANP3RGczchzUK=ZxyPXS8t0NmuBdJB8ajfQ72MnSQwKRBZKh4w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Jul 2021 09:13:36 +0200
Message-ID: <CANn89iJTXXREs5qpvHDzb0KK1_eUD7yAyrtX2PYLJjCEcCUc7w@mail.gmail.com>
Subject: Re: [PATCH v2 net] ipv6: tcp: drop silly ICMPv6 packet too big messages
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 8:56 AM Maciej =C5=BBenczykowski <maze@google.com> w=
rote:
>
> On Wed, Jul 7, 2021 at 11:50 PM Eric Dumazet <eric.dumazet@gmail.com> wro=
te:

>
> (this looks fine)
>
> btw. is there a need/desire for a similar change for ipv4?

My understanding is that in IPv4, the relevant check is done before
the FIB lookup, we should be fine.
