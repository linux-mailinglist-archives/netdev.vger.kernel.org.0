Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2103A152D2
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 19:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfEFRel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 13:34:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44121 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfEFRel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 13:34:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id d3so2693504plj.11;
        Mon, 06 May 2019 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YtGgQTFrjUq15UlrAoYcNo+HOJDXzqrzDoFc3h7pRGk=;
        b=ZAWOFPuKDlkjRAuEb/dJdftNQKx0V9IcOP8S0NUi1lKR4+wpJ0pt7ED5mDfreV5hE1
         tJ5cVfCT409UGQBESXQYkqZuPZYVKmZbG1mU2jqrgW7Tf1E5BOWIOq6ZUNHn1axkYRtf
         L8FqfoYBWl/SS/E5JRZThbLsy1noid1XKzXb81cXhpX/MJSPNIHfXTioWFjgAK9XPbzE
         1U3wAOdeN6j/xZX7/tNG026Kxkju026TqpQag7wRIO3t+N0zKW0wesEzH0B6UtZEpcuK
         5fUrSypMnfIcz9bXv4LE6gNGPxeFepptDHkM6B7wV+pQAdLdwsklWXcX8MiCT7JSkb3e
         GtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YtGgQTFrjUq15UlrAoYcNo+HOJDXzqrzDoFc3h7pRGk=;
        b=TBjmbtRE5uK2heWi5nu/ys64FBTY1/HZSauRnXWJL9ARNTGPO988uy2xp65jbkAVAU
         zaoAemymDoJ33Diwy7kcgEShrcmbXdl2tJS8lS0Y7qe9iyJ9aRu5mh9+R3AR21x/ngF4
         2iqgS/JubLj9RF1iT2fWmc8QxdO4waV2IhcLmOFoeZDjTWikfwu3Hz6BLEUbIUPlFc2q
         MUFrx14gbh/EAGZpKIHUkDigV/RjUhsfw8cPO9K6e83PImZVRYIG8OBTFA/pwz0a9swP
         A3t3+czZWSh83PELQRjQX2V4vNysI6qWoxlulOastnZxmhoymtIRW1SqgZzJn/6bVMo/
         a21A==
X-Gm-Message-State: APjAAAWK/holmRROSawiiCl7obz0rN3Ud3OXPR3nIZSYhA5ivt5T2O4m
        zzR89oqCUrHrebezK6QWukUV6e7ILcVKaWwsnRHCRqc9
X-Google-Smtp-Source: APXvYqzo8JEaPsCeNsXQ0JBGS4xPvJn5avMCXX4yO0yUY2oI8aPUWz6F7xiWVbje9DN/esQJWNfb/AAHnmuydi59kug=
X-Received: by 2002:a17:902:9b83:: with SMTP id y3mr33755491plp.165.1557164080340;
 Mon, 06 May 2019 10:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190505215019.4639-1-colin.king@canonical.com>
In-Reply-To: <20190505215019.4639-1-colin.king@canonical.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 6 May 2019 10:34:28 -0700
Message-ID: <CAM_iQpWZUjJS31cmW81C34DTfy1SV6ajBxFyo-yAmGppksKrHA@mail.gmail.com>
Subject: Re: [PATCH][next] taprio: add null check on sched_nest to avoid
 potential null pointer dereference
To:     Colin King <colin.king@canonical.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 5, 2019 at 2:50 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The call to nla_nest_start_noflag can return a null pointer and currently
> this is not being checked and this can lead to a null pointer dereference
> when the null pointer sched_nest is passed to function nla_nest_end. Fix
> this by adding in a null pointer check.
>
> Addresses-Coverity: ("Dereference null return value")
> Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
