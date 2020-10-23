Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFD9297558
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461384AbgJWQyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S461382AbgJWQyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:54:39 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F50BC0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:54:39 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id w23so1253892wmi.4
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=memsql.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K/qAKVNNr7wl3mXeW+C/WxE4lTp0V1uMbin6dmRbxag=;
        b=XouObT07eojqBuUiHvYdvMokjC72+Z+smBHV6j4LW5+m7y/km3e8ZUPzd7IDCXwXnh
         G8U2HJ/l+KsuHo2YciqnELix1fTIGXembfvZHz1B3klCGnR4oUWM9UBhKA1gcE7p2Lhg
         VaMrH7UYS8nDV5HwdKpjEx/tc0XdM2CKKVWiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K/qAKVNNr7wl3mXeW+C/WxE4lTp0V1uMbin6dmRbxag=;
        b=CcVlo/wLA8dQNv3RbqfGWjmxWp9YVj8CaGVyar59SzAvllQQwzdqJEhX56xG4sIgY3
         Qr4e+fzsTqpUO3ll5pRpmOeykoMWaK9x7+eKS/t4CoQLEfZl8LqTFzZ3p7fYGee7ND/G
         OQ/QvgvKrUcDqhuoQDpLH1DZ3TxtNx8nNJQzYzT0fvtll80Zg2XVZRZS5mKLcF/iLGNP
         VC+AGhLFRf3eYvTUlBnLB945FCsgh+c8x7eVnx5gS+Cw+vFivheQGU/4WHLNYYMt/Lc9
         H8ASz59SxC+3gVgInRHykph1oToPpztERQVwYl1pb4wJbiJfcZYnBwUzWcttoUuQRKNp
         sUPA==
X-Gm-Message-State: AOAM530M1FWJLNNuauHbcoJ2jK2jBNLn12t2jDiqw9iOkmWzFiZNVeno
        lQG/a1WLYdBckM/pxlPEvZQIdw==
X-Google-Smtp-Source: ABdhPJyNrgrau3DojAcnXmQFDdSfdeIgU0ugIkZlGccaI9B0TbblNh6PPdoIjAl/fR7Y6IOufJYoXw==
X-Received: by 2002:a7b:c349:: with SMTP id l9mr3235560wmj.148.1603472077767;
        Fri, 23 Oct 2020 09:54:37 -0700 (PDT)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id c18sm4063228wmk.36.2020.10.23.09.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 09:54:37 -0700 (PDT)
Date:   Fri, 23 Oct 2020 17:54:35 +0100
From:   Ricardo Dias <rdias@memsql.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp: fix race condition when creating child sockets from
 syncookies
Message-ID: <20201023165435.GA322147@rdias-suse-pc.lan>
References: <20201023111352.GA289522@rdias-suse-pc.lan>
 <CANn89iJDt=XpUZA_uYK98cK8tctW6M=f4RFtGQpTxRaqwnnqSQ@mail.gmail.com>
 <20201023155145.GA316015@rdias-suse-pc.lan>
 <CANn89iL2VOH+Mg9-U7pkpMkKykDfhoX-GMRnF-oBmZmCGohDtA@mail.gmail.com>
 <20201023160628.GA316690@rdias-suse-pc.lan>
 <CANn89i+OZF2HJQYT0FGtzyFeZMdof9RAfGXQRKUVY6Hg9ZPpcg@mail.gmail.com>
 <20201023164825.GA321826@rdias-suse-pc.lan>
 <CANn89iKOiAp96yu=7OVn72R8EMukErBSXeWURJp3qTqrurtt0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKOiAp96yu=7OVn72R8EMukErBSXeWURJp3qTqrurtt0Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 06:51:05PM +0200, Eric Dumazet wrote:
> On Fri, Oct 23, 2020 at 6:48 PM Ricardo Dias <rdias@memsql.com> wrote:
> >
> 
> > In that case, I can change the patch to only iterate the ehash bucket
> > only when the listening socket is using the loopback interface, correct?
> 
> No, the fix should be generic.
> 
> We could still have bad NIC, or bad configuration, spreading packets
> on random cpus ;)

Ah, got it!

