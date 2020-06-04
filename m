Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644841EE507
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 15:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgFDNK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 09:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgFDNKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 09:10:55 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69C7C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 06:10:55 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h39so1224821ybj.3
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 06:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bsgm/TKaQa1WLgF7Jlo3Jkj2UeTFocZUCUKf1011cuc=;
        b=dNTx6mqqy7cKYr6LeBPm8T8QMP1bWemgs9tn5LA8PwwT5b9uYGoEOO7nrOaxI8HSgF
         sEkATWLylk3rMeS/XsK4JQOIle/TBs+afxA6rQs0zIYiJ0x62J6r+GwZ2LCTYxp0BCKb
         9rt5tPJGyKGDibCWDRwcopwAeXl7sqD6BwjYGQY47CJ0L6/WdO4AHMy9r1ZUDb133Xjn
         nui8+40mbwrG5+Ol0llqxLbYmTQHQtjzRbkxRoIm0I+24yleuQpyUDGZ6vqGtTLdPtGL
         4t1QXO+QZbPsYYArVgVv0FvLy1RiB6Sph6aE7NfPVSzXPeciKWwSSTs8wAsr4xPySlWW
         ikTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bsgm/TKaQa1WLgF7Jlo3Jkj2UeTFocZUCUKf1011cuc=;
        b=bzJvyAPhD2Pj/VsRSO1HMxzaorsO9f1mMRsFX2iI22j3bHlj35GIYCTyJU9zVMS490
         3vSJYx9a2ENby3MAYUPI8BIBjDtnvvoQjV3kH24kx4IOFrtewFFE5cHaGOLCHL1r9geh
         RhxQAlteN1GDM/Vlcl8A+EC29iBtVnkb3ukp30CE8+bbxUcuuOSzRA1N4z9fRM9c2NWu
         QnCD5KkeQsw4b5O8pSeUIxwc8JwiHhQ6zMpcHVEe7oMEBtGurmvswQeU5bG2PVHs5uKq
         PdAKkQKxjJtb/NCuXEh2jEUNX80qmCUSkQNg7JyNyRfQJsP7AL8b9WGO0dElGR5+g8+O
         zjPA==
X-Gm-Message-State: AOAM5339wDtOPgrL8+FzZrb6OB6mgDU5qZPZ0Uob8ArUfeH3/tHlR3V3
        6VGubKBMFgqdqBDJJQCNu288O1vxGqdbxFsWehOQSs9+
X-Google-Smtp-Source: ABdhPJznZ4kgf3E7pVsIR+yXbd62nObH+ZoygHL56PaPVrmzBCCzB1mkH7ELrGSGj1vCTfsXKYF+txj1dTIRXd0BCe0=
X-Received: by 2002:a25:4cc4:: with SMTP id z187mr8163120yba.274.1591276254605;
 Thu, 04 Jun 2020 06:10:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com> <20200604090014.23266-1-kerneljasonxing@gmail.com>
In-Reply-To: <20200604090014.23266-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 4 Jun 2020 06:10:43 -0700
Message-ID: <CANn89iKt=3iDZM+vUbCvO_aGuedXFhzdC6OtQMeVTMDxyp9bAg@mail.gmail.com>
Subject: Re: [PATCH v2 4.19] tcp: fix TCP socks unreleased in BBR mode
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, liweishi@kuaishou.com,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 2:01 AM <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <kerneljasonxing@gmail.com>
>
> When using BBR mode, too many tcp socks cannot be released because of
> duplicate use of the sock_hold() in the manner of tcp_internal_pacing()
> when RTO happens. Therefore, this situation maddly increases the slab
> memory and then constantly triggers the OOM until crash.
>
> Besides, in addition to BBR mode, if some mode applies pacing function,
> it could trigger what we've discussed above,
>
> Reproduce procedure:
> 0) cat /proc/slabinfo | grep TCP
> 1) switch net.ipv4.tcp_congestion_control to bbr
> 2) using wrk tool something like that to send packages
> 3) using tc to increase the delay and loss to simulate the RTO case.
> 4) cat /proc/slabinfo | grep TCP
> 5) kill the wrk command and observe the number of objects and slabs in
> TCP.
> 6) at last, you could notice that the number would not decrease.
>
> v2: extend the timer which could cover all those related potential risks
> (suggested by Eric Dumazet and Neal Cardwell)
>
> Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> Signed-off-by: liweishi <liweishi@kuaishou.com>
> Signed-off-by: Shujin Li <lishujin@kuaishou.com>

That is not how things work really.

I will submit this properly so that stable teams do not have to guess
how to backport this to various kernels.

Changelog is misleading, this has nothing to do with BBR, we need to be precise.

Thank you.
