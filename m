Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D7B74FF
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388079AbfISIUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:20:17 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36020 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387581AbfISIUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:20:17 -0400
Received: by mail-ed1-f66.google.com with SMTP id h2so2387789edn.3;
        Thu, 19 Sep 2019 01:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DIjC86Ii4KsbkS8eTIPnEq2D8sVnXy/7hZpoMJXse74=;
        b=XspEhnDiZYjUHScXvRrQYaOoqkttp3WHmWMbRGRag+fbX8nHQSaKs7mQoSk9TwAPuH
         C+p7LH7/Dax1N2ydNhPL1R0IweJrVCRjjHBPMV95d+Yggk6zliEGKS0dCLsPN8Lnnxqe
         mcnrBURdJzbN99YTdOxu3X9ZuRshelOBAEpQ6kbj9h2AzUbbxQY0pG73cNIQYs24G9Eu
         WJGEWDpm5/7m6t6IH0o5E8PygdUWJEw+F7sy40aNWw+ZKLSYeUeCWUzTuDUVVcOG/Smn
         3JdcZq/6Zgofre8ATzIkXX9LWkpA8ysfNEbZjfwZ5mPQoD2volG3yR0K7BY9diQ3/VO5
         YuVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DIjC86Ii4KsbkS8eTIPnEq2D8sVnXy/7hZpoMJXse74=;
        b=AhczJwEx2WEXYtuQ8nLDdE9l2OAzyTlRU6oogXQo0k+STO2sEk4DVi4akL5yTLVCu8
         YAJTSGeT3MgkFQ8Ksrw/k1ma7RnklWs/lFLrM7cvV4ocDNlwaFWuUDV5SwNn1No2El5s
         socO3M1H+PrfdHNd69g2VxOC1lZhcDGxX5IAXlyn8/j632JYZ9tAvo4VhUhueyAajeUH
         5IHWch24ND0M7bTlKLh45qnw4DKUP8MnQii0ia6p7AGjuIUjGv8TSMKRVZgZcYqFSJWb
         K6sQnfaH25kWoheSDtQ8ic8Dm0VfPThbLRj5tn3wFpfM6/I9mwq1RThj4qqBjfaIt5XL
         9ImA==
X-Gm-Message-State: APjAAAV9AszetHAdi3AVdNPFYaURDbfXRZEEDgHUPByLf9PaNCKKlCaR
        knmeUAfJ3XKzmb/eO1UPWx5IHfh017u4ames+WA=
X-Google-Smtp-Source: APXvYqzLEjmwjFGA0fOI8+ymfYiL1C3PMql4lxAa4Log1CCWsdwRJD9Y8Zci3lVmWs5UWc1aZXnEOMVUhcXmMOH1PT4=
X-Received: by 2002:a17:906:400c:: with SMTP id v12mr12911025ejj.15.1568881215131;
 Thu, 19 Sep 2019 01:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190918172106.GN9591@lunn.ch> <20190918180439.12441-1-navid.emamdoost@gmail.com>
 <8d6f6c54-1758-7d98-c9b5-5c16b171c885@gmail.com> <20190919.101059.1330167782179062709.davem@davemloft.net>
In-Reply-To: <20190919.101059.1330167782179062709.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 19 Sep 2019 11:20:04 +0300
Message-ID: <CA+h21hpDAkJw1qs6pkb1hz3pej8XbEkpEueCbjBEOLZ3bDkLDA@mail.gmail.com>
Subject: Re: [PATCH v2] net: dsa: sja1105: prevent leaking memory
To:     David Miller <davem@davemloft.net>
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>, kjlu@umn.edu,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Sep 2019 at 11:11, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Wed, 18 Sep 2019 23:00:20 +0300
>
> > Hi Navid,
> >
> > Thanks for the patch.
> >
> > On 9/18/19 9:04 PM, Navid Emamdoost wrote:
> >> In sja1105_static_config_upload, in two cases memory is leaked: when
> >> static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
> >> fails. In both cases config_buf should be released.
> >> Fixes: 8aa9ebccae876 (avoid leaking config_buf)
> >> Fixes: 1a4c69406cc1c (avoid leaking config_buf)
> >>
> >
> > You're not supposed to add a short description of the patch here, but
> > rather the commit message of the patch you're fixing.
> > Add this to your ~/.gitconfig:
> >
> > [pretty]
> >       fixes = Fixes: %h (\"%s\")
> >
> > And then run:
> > git show --pretty=fixes 8aa9ebccae87621d997707e4f25e53fddd7e30e4
> >
> > Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105
> > 5-port L2 switch")
> >
> > git show --pretty=fixes 1a4c69406cc1c3c42bb7391c8eb544e93fe9b320
> >
> > Fixes: 1a4c69406cc1 ("net: dsa: sja1105: Prevent PHY jabbering during
> > switch reset")
>
> However the Fixes: line should not be broken up like this with newlines.

Sorry, my mail client did that automatically.

-Vladimir
