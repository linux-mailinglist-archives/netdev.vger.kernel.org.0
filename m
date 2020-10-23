Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D581B297469
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752186AbgJWQgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750561AbgJWQgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:36:41 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29FBC0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:36:41 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q25so2507915ioh.4
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KOj/oHfwxUuvaYgCe+uyCqY9qKTixx5oRdiXvb0Y2Lo=;
        b=Gbrae/12ltjvScvPtnck8CY8F6IEdPW8r/G5bdTru4Mr495QtvKEqkx0wCOE4lldFA
         SHWlX0VslTR9iSEUphZvQvdMtzRWnTwBUSTSOQCNJtQrWAESJzw7fIL7AJr9kGtbZ8/f
         HMM2cinNOf8VUvHb41p7hJGjHIG673cq2szUmhE3kOz3xfp1UUVPbv55iYMtLZlGbcMg
         2iheUBSAqcfjBWrv70lgwLHePg9f8H9Js/Omdq5aylRwapBb8j2dcsCtRwrhSnYCzJWN
         sta32ZfUuTVJCWy5XvjMNjk3eFd3zJKRe2SPo5ZXFGwpNAwCudtKiCk8dzg87ZaFFOIJ
         kCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KOj/oHfwxUuvaYgCe+uyCqY9qKTixx5oRdiXvb0Y2Lo=;
        b=DdQjdtQnVaK/j9ZFdbg7MhGCfpKGza8qpfeC/0HNORp1H79yIeGdfq3nkhpA4GZkhY
         HB69pUh+Gfaa2sTW4u9Gk0EaXyF4NOHqnf1fnzh+vgWMNCZ7pTkamQwR3+ryuvPwONLx
         6ZnaZ26cMzzlIcF039JdMTHSDYE5oKGmsUiqYvjDZkL6FrMo6bREuPJT4bFRgMUXIH8y
         7JhTAq2pVi32GAuVXb8PK7QfnfoRDByXfzkfuPiQUcVX2N2kLmyVImsaVmnnUQIcR9wZ
         sqT44uY9IskFBpADIBF9e0j+gQdZWoFHdIJoYFY3H+rOCM51Dnj2HPAQnqNX6fhBySTW
         1Kwg==
X-Gm-Message-State: AOAM532Mmjt2XoLmAMzXs7GE14ARY4naB4uZOaJ3fPqtPVymW65c1iK4
        mn80yhQ41eIxEJJ92EQp0+IJeTOiMw8FYz0BZ8hb4A==
X-Google-Smtp-Source: ABdhPJznzDOojs2FtX5ZA1bExkgHggY5gvxhCu5xAgM9eK5VkKYxyXwxGKhU6pI5JVBM4/sb4lnPGLtlKOILsQYlJxg=
X-Received: by 2002:a5d:8e12:: with SMTP id e18mr2043995iod.99.1603471000904;
 Fri, 23 Oct 2020 09:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <20201023111352.GA289522@rdias-suse-pc.lan> <CANn89iJDt=XpUZA_uYK98cK8tctW6M=f4RFtGQpTxRaqwnnqSQ@mail.gmail.com>
 <20201023155145.GA316015@rdias-suse-pc.lan> <CANn89iL2VOH+Mg9-U7pkpMkKykDfhoX-GMRnF-oBmZmCGohDtA@mail.gmail.com>
 <20201023160628.GA316690@rdias-suse-pc.lan>
In-Reply-To: <20201023160628.GA316690@rdias-suse-pc.lan>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 23 Oct 2020 18:36:29 +0200
Message-ID: <CANn89i+OZF2HJQYT0FGtzyFeZMdof9RAfGXQRKUVY6Hg9ZPpcg@mail.gmail.com>
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

On Fri, Oct 23, 2020 at 6:06 PM Ricardo Dias <rdias@memsql.com> wrote:

> And what about the loopback interface? Why couldn't the loopback
> interface also use a single RX queue?
>

Loopback is using a per-cpu queue, with no crossing, for efficiency.

That means : whenever a packet is sent on lo interface from CPU X, it
is put on CPU X backlog queue.

If the connect() and sendmsg() are run from different cpus, then the
ACK (from last packet of 3WH) and the data packet might land on
different queues.
