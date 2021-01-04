Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E06D2E9E04
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 20:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbhADTO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 14:14:56 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:38679 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbhADTOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 14:14:55 -0500
Received: by mail-ot1-f43.google.com with SMTP id j20so27064479otq.5;
        Mon, 04 Jan 2021 11:14:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+0EffT5SyTJC0KyGrlbx0ghNmKVpPcPl3Tu10rcGlQ0=;
        b=k6Atfuoc6OKgmhQcq/rZOkZcb+sg97LhGoqGXHf8z9a2NvvEy4tIIFpQ6O7SyNVcpU
         T5tiXhLPNA7DCGYA35gzcFbUu5mtOMEgcDh4PFJOqslNxxB06CmWAd4/aOXM5jw1AD+x
         ucniraxe/zzQuE5fQ+QMoeR8xjUgtAe4V5lM9TyMx13fgboLVRU5KuUBk7V8QpihxERj
         jw/G4PQ+IIpgMW1f5fkfxRNJfJnQ8uaGlVjoewl2LL+WI5MLuG9aTMKowktzymWouQ9a
         rV9EvB3KjGrdx2hnjDv47I3hyoIvoZA99m9e1iwlMD65F9MQTc1bHUHxPgjXuHmk47o5
         9mqA==
X-Gm-Message-State: AOAM530H9Q0d157yWPlY+kfybvvfZOfqJnHZOqg7lrhy9n8JCVTdNiq9
        eb4nbfIOSspCxa9LNXG7lcGwdTDKq4XE028pwG1mJepgQXLn8A==
X-Google-Smtp-Source: ABdhPJxb+NNWo6ZyBMHz/fz11AKZkzmUYcwBf/aRRzh4aRbnh90E4Eh8jmP8adiK/F8LZiV1PQAC6w4/J0+m8bMHSr8=
X-Received: by 2002:a05:6830:578:: with SMTP id f24mr50683409otc.7.1609787655075;
 Mon, 04 Jan 2021 11:14:15 -0800 (PST)
MIME-Version: 1.0
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224032116.2453938-1-roland@kernel.org> <X+RJEI+1AR5E0z3z@kroah.com>
 <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com>
 <24c6faa2a4f91c721d9a7f14bb7b641b89ae987d.camel@neukum.org>
 <CAG4TOxOc2OJnzJg9mwd2h+k0mj250S6NdNQmhK7BbHhT4_KdVA@mail.gmail.com>
 <12f345107c0832a00c43767ac6bb3aeda4241d4e.camel@suse.com> <CAG4TOxOOPgAqUtX14V7k-qPCbOm7+5gaHOqBvgWBYQwJkO6v8g@mail.gmail.com>
 <cebe1c1bf2fcbb6c39fd297e4a4a0ca52642fe18.camel@suse.com>
In-Reply-To: <cebe1c1bf2fcbb6c39fd297e4a4a0ca52642fe18.camel@suse.com>
From:   Roland Dreier <roland@kernel.org>
Date:   Mon, 4 Jan 2021 11:13:56 -0800
Message-ID: <CAG4TOxM_Mq-Rcdi-pbY-KCMqqS5LmRD=PJszYkAjt7XGm8mc5Q@mail.gmail.com>
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > to preserve the legacy behavior rather than changing the behavior of
> > every usbnet driver all at once?  Like make a new
> > usbnet_get_link_ksettings_nonmdio and update only cdc_ncm to use it?
>
> Then I would have to touch them all. The problem is that the MDIO
> stuff really is pretty much a layering violation. It should never
> have been default. But now it is.

I don't understand this.  Your 0001 patch changes the behavior of
usbnet_get_link_ksettings() and you have to touch all of the 8 drivers
that use it if you don't want to change their behavior.  If you keep
the old usbnet_get_link_ksettings() and add
usbnet_get_link_ksettings_nonmdio() then you can just update cdc_ncm
to start with, and then gradually migrate other drivers.  And
eventually fix the layering violation and get rid of the legacy
function when the whole transition is done.

 - R.
