Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8707F2B3BCF
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 04:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgKPDXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 22:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgKPDXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 22:23:08 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5428EC061A04
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 19:23:08 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id ek7so8154517qvb.6
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 19:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6MgyIFK5sgjDUOBdkYvh5ws77hLBd0bcSe8iradi5UM=;
        b=iY3T3tKgfXq9/5XzmY8MwbNc4dTm5NHOzihNAA0nmTdZrubxZZz38qA6wNFY1OITe7
         owHnMHUFyeKnP/mRWnQ/iNbuzRjgkrCnZ/E+mG28PmPgzLXoZwAYl+2rcOED6Dr4HG0G
         JUUmEOyybN7/+qrdbS/rJkpXeOGjBSRyPrQbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6MgyIFK5sgjDUOBdkYvh5ws77hLBd0bcSe8iradi5UM=;
        b=joLBT6Qkd+G9RS8XzFhCozO+LEdhIOLPiWLiqKMBRs1VHcV7vCsA3m1vcWt5j2Rrjr
         0Kvh3Zk7JSnfMTwXqtp20ZhwsXYzWkHFO39dpT5rFSnIanjcrDaJvnkTClmUg8jmiHL9
         aUE6Ful51/3robHicqy+SBHP2tw4FH9agz9juUsPUOiNt4URTKIi+9X2Cs3SLdb82vcZ
         lyeEpJf1fEqKfgcgmhQN+rbezzKa6KjIvUmg7F7mVjSEY95ePcoOClZ+MrWJkXtSYclG
         0lJ5/HQH1NwqIeTXdR0C06rRK1TLB3y0cDcPfGtR/zzEFcgXPjHzow7gE/CpjVCaJ4XI
         99eg==
X-Gm-Message-State: AOAM530KoYZxf26hUisUtfIXJLGBazNYF6WtAnsKp9eVOErxoAJYIiOu
        V6p7H9hr0K2a3P6nZ4DYbfvHs+/BZikl13aFbTY=
X-Google-Smtp-Source: ABdhPJzZtdAcOQ4ZVRRg6lZ9ZatdTVodb0lJl5sAtWovpGP9MVd5BiUiIWNyJUq0b9Ksx4ipL77LkAHEiwRd2hy8Tig=
X-Received: by 2002:a0c:c984:: with SMTP id b4mr13673242qvk.10.1605496987454;
 Sun, 15 Nov 2020 19:23:07 -0800 (PST)
MIME-Version: 1.0
References: <20201112003145.831169-1-joel@jms.id.au> <20201112152241.7a3acaca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112152241.7a3acaca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 16 Nov 2020 03:22:54 +0000
Message-ID: <CACPK8XdW14+6p9nxmc9wrgqo2H3VBWqJRSS53qzn6-nXpCg0rQ@mail.gmail.com>
Subject: Re: [PATCH] net: ftgmac100: Fix crash when removing driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 at 23:22, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 12 Nov 2020 11:01:45 +1030 Joel Stanley wrote:
> > When removing the driver we would hit BUG_ON(!list_empty(&dev->ptype_specific))
> > in net/core/dev.c due to still having the NC-SI packet handler
> > registered.
>
> > Fixes: bd466c3fb5a4 ("net/faraday: Support NCSI mode")
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
>
> Thanks for the fix, I think there is another one of those missing in
> the error path of ftgmac100_probe(), right?  Under err_ncsi_dev?

You're correct, I'll send a v2.
