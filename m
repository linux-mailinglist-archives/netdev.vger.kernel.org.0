Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB6820ECEE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgF3EvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbgF3EvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:51:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3327C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 21:51:11 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id r22so17425788qke.13
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 21:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zCaps0loQaEmR/b2P5B3LXujzdso5k67v4HcTYc+GR8=;
        b=SzPJFfIcOzkcEYGA5v9ELeSfWERhjHPdjUj+Nvn1dSi0ZNyXp3B5TJjdq6S8/qq6NM
         MObyQPupwPQ94gzOYT3piiHl/suxo+twRdybak+evrIGY2afwXFKaJg0T2TdJa+QWGbY
         Tu2zbOgHLVwAHmYeDTm8zzrCFZrA+V8rG9G3dt53CdRnL+F/ou52CAMIEjcJUMMgW2uY
         AFXgTEzAQdXPos6Zngn1kQjD4qX+FMMb6JQnuN4azoc5ArC5CeKxSSbXcAWfkFeU3xeY
         7BfZKszqNNDiHTTGuFHPDefnVeq2lygo+b/kAKQuh6Yl4yTwamXJwBfOOOHKISJdJKTZ
         jA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zCaps0loQaEmR/b2P5B3LXujzdso5k67v4HcTYc+GR8=;
        b=fiLv+rXVxSIinvF6uDHmaR6Yra/efa7miPMX6Zu3lh5uuU+kdGgf624kFKKztg4osE
         n5TpYi1Z/8AjM2Psko7zo3XtBpw6g5KrbtA8aHrnT1Bq+T+/nUqncLcP0E4MxMyGVw9Z
         RD9/O76tyukRxkvWPhrp2G+/7R8dKj7ZbzxUVq0Km9jsiT8Fj7nW9QxS8V4w1RXIMvSF
         ITbBx51Py0HTI9dVv/PWW08Ain9JWD589868dsTWnREHQG3LPH2p6bIqLoL7zvaMLkZJ
         L0H+bHeA8hQOm0cUaWr+WAc7qn45ZUvyUVaL2vPeAYrTCk9PK5ct9s/QvRBZwFnXiGFF
         qbNA==
X-Gm-Message-State: AOAM530gL47GJhWYSvxUdtDf5TqAuIRJ3F0L0WF+Twp20Xzt3I7MfJ5Y
        RuEfbuhBpW+MskaKBklJWttpDbmiIwD0lLiXYUzI1g==
X-Google-Smtp-Source: ABdhPJw17VDeB/8CSFZtI1dZDGngtZx5LKNRhxlkstFd7Z07UhFZgOrAGsTMwXB66P4UhkkHf9YFAHtAUqayNpl+n6Q=
X-Received: by 2002:a05:620a:1273:: with SMTP id b19mr18111737qkl.10.1593492670843;
 Mon, 29 Jun 2020 21:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200629211801.C3D7095C0900@us180.sjc.aristanetworks.com> <20200629171612.49efbdaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629171612.49efbdaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Mon, 29 Jun 2020 21:50:59 -0700
Message-ID: <CA+HUmGjHQPUh1frfy5E28Om9WTVr0W+UQVDsm99beC_mbTeMog@mail.gmail.com>
Subject: Re: [PATCH] igb: reinit_locked() should be called with rtnl_lock
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Would you mind adding a fixes tag here? Probably:
>
> Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")

That seems to be the commit that introduced the driver in 2.6.25.
I am not familiar with the history of the driver to tell if this was a day 1
problem or if it became an issue later.

>
> And as a matter of fact it looks like e1000e and e1000 have the same
> bug :/ Would you mind checking all Intel driver producing matches for
> all the affected ones?

Do you mean identify all Intel drivers that may have the same issue?

Francesco
