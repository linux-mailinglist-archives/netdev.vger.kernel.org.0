Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950F631ADBC
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBMTS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhBMTS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:18:56 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51243C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:18:16 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id k13so1678874pfh.13
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w6RMYkuOysANFNlLJX1VrkCH9JUKm/LqKK2l+HO84wg=;
        b=Bxncp8JpZPYmhh83pX+bbLJFR1nFPG+7uoihldadkjn+BztSQkMMvvkmt4OVCWSinI
         kXfOJqxTQqneahxLnwpvkps66gY9Z4v+Q+z5kXsx6OAO7C/YFO1t0W32itG8ET2zm7kQ
         c0y5okkq8QfAexgjAf1kdAP6pjwQzKZT9DVquEg6HMHA51jpQF8DdF1uurFYZCfdDXL4
         y2lxsMgR0RHS/1pHVBxeeo1WQTuQL+8AXCuqNJsOFcjKA6jC8phE+reCu/IsASrDCgJI
         Zydq3oKGKpgkgyo2/AAx78UJ81cwMpwCDUy9E7mVjRP8NhdToAp2ZPnu39Nllu8OBPCc
         JyFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w6RMYkuOysANFNlLJX1VrkCH9JUKm/LqKK2l+HO84wg=;
        b=JBdmP7AA5weHTJ37fvoXOUAPahCac67OWAvInxepLM+ZLb4MmeeiV/8mpQ4lQvHeVV
         X6o7k95giVykeIGmm0/iZnJEMyq12r2VCbuDk7A5OKzK+h1CE/hcS0m8ig91W6OQUQac
         qf/TVTJp3H9ivTDsXVU/M1Hb4gtDXlTBszC5UFDzIBEoNetx8x4cvOqETYxXHa+oeJB4
         VPvpiDh52b1BJOtVvyRT544kXwxCezTqDAsfRo9oA42dUaUhjZAHx1InvfrvQnPt5jej
         h9HBmy8DqeRPCcyjd+78e0j/I5cL/EBelVaXdJxwbFSwPTi64AICf7f6Hy8iWpF5j9c6
         YgGw==
X-Gm-Message-State: AOAM5323/raduYh9T2Drffk+4cCb5BZvEbCXQr/nmVQbs3farRXctA8v
        pHapr64Bc0mmob2DKctkmZTw8g+vrCTojqRaUww=
X-Google-Smtp-Source: ABdhPJyLXLs8X4p1hddyU+gSP1CsjUKPcdpCrl0M/fRWd9R4t2qPZDTCrZO0uziyFrei775vonSvYoNnaBgA+2XbbBk=
X-Received: by 2002:a63:3c4e:: with SMTP id i14mr8343024pgn.266.1613243895883;
 Sat, 13 Feb 2021 11:18:15 -0800 (PST)
MIME-Version: 1.0
References: <20210213175148.28375-1-ap420073@gmail.com>
In-Reply-To: <20210213175148.28375-1-ap420073@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 13 Feb 2021 11:18:04 -0800
Message-ID: <CAM_iQpVrD5623egpEy2BhR66smuEaTLRHgsu9YA_vrMGjacPkg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/7] mld: add a new delayed_work, mc_delrec_work
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        Marek Lindner <mareklindner@neomailbox.ch>,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 9:52 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> The goal of mc_delrec_work delayed work is to call mld_clear_delrec().
> The mld_clear_delrec() is called under both data path and control path.
> So, the context of mld_clear_delrec() can be atomic.
> But this function accesses struct ifmcaddr6 and struct ip6_sf_list.
> These structures are going to be protected by RTNL.
> So, this function should be called in a sleepable context.

Hmm, but with this patch mld_clear_delrec() is called asynchronously
without waiting, is this a problem? If not, please explain why in your
changelog.

By the way, if you do not use a delay, you can just use regular work.

Thanks.
