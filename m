Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C841B3F5714
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhHXENh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 00:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhHXENa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 00:13:30 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BA4C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 21:12:46 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id y34so42503591lfa.8
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 21:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=mUV8aBeiGbXXyUQUEaToe8A5iWokUzPYg0JhAdxYHXU=;
        b=VADEWl9YABrZOYt1bzSXjkTOZ+RjfoRrjc0+eNgGl+5xexAjhGSeq+/fwIO2U33oay
         +wiLr4hjXViTKmu7X54D5YNdE3nbI7YltPiJMc5RiVrPkvH08AoT7KkNmx4Bpgd7Gog1
         kgo9tCkOoGGgbFc7lA7uG/f/H2BjjGZQDECdmKHRT5Fwgt+On2L3WNcwuxZWO3bCNCZZ
         cDry7ZxW4CSGpNn/kB7HtMhrcDZJl3B3/hSahQmbJzZ+ZFlTtTRhSn3vi2H7csao+YLJ
         XKyCJJ40ETwajPiXdB8jK3rT+tsWYEekKx3h6rt4/VXypsCyUf7veO/2ldK7EwQ/hnol
         7Tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=mUV8aBeiGbXXyUQUEaToe8A5iWokUzPYg0JhAdxYHXU=;
        b=YPIJ4Aj3Bv0VgX+h1GFYYypoozGA48FbXiIG/pK3lAWNWmj2aDcvxxcQnIpdIN1NX6
         3ExrE1OZPPg07HJwcmvGtQB+izDYIcrMK5G8mc0p7kMfTmIHareJXZrHOfs1HwzBld9F
         DlsydYk8LYW3hAi7sUTe/qdU1eZS1Z2WunjpA7n3Bvw1TefmrJejwbpWAmSdvvGp6tFo
         5niOuSXSiDrkOkdpTi/id7EU21kdxWV2pLz+DQLYcIJBRvI9lw6qQ/7FQxe7NPSmPdi7
         i3R3houEybQ77hbFmV7+0rGtHLoy/90ZrtqXsQ0TufARm5mn6FvwqrlPRWKjiQIgEQcp
         nmZQ==
X-Gm-Message-State: AOAM532O0b8Op15LP/pF34rsCnQFSnEbRDkbT0rbkCJuHu1ukwx9kz1e
        lCD0zuyE/rsN55M5Nh4mb5p8z/IxmHEeEgzJ667VushqzTVoAQ==
X-Google-Smtp-Source: ABdhPJy3UdlQa3i1ht8nAevp+GP+itOdrhHcDXaspRXDA7MJNEo8w0XGEi5sK18NFhxqzwtR6CsLJokN3q3ZkVlQstc=
X-Received: by 2002:a05:6512:1293:: with SMTP id u19mr27482189lfs.86.1629778364820;
 Mon, 23 Aug 2021 21:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSEk-gxY3jr-2k8+NSB0uf9H94SDQyxJFVM1LH3A+Bs+5MA@mail.gmail.com>
In-Reply-To: <CAGnHSEk-gxY3jr-2k8+NSB0uf9H94SDQyxJFVM1LH3A+Bs+5MA@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 24 Aug 2021 12:12:33 +0800
Message-ID: <CAGnHSEmeLTq6FsG18QDBmD_cHcNfTk2N6t7Nwrc53p9Ejnd5kg@mail.gmail.com>
Subject: Re: Bridged passthru MACVLAN breaks IPv6 multicast?
To:     netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've further investigated the problem:

What "walk across":
ping ff02::1%bridge and Neighbor Solicitation from this host (tcpdump
multicast on a LAN host can see them)
ping ff02::1%some_dev from a LAN host (tcpdump multicast on this host
or a bridge tap host can see them)

What do not "walk across":
Neighbor Solicitation from a LAN host (both tcpdump multicast on this
host and on a bridge tap host cannot see them)
ping ff02::1%some_dev and Neighbor Solicitation from a bridge tap host
(tcpdump multicast on this host can see them, but that on a LAN host
cannot)

There is no problem with ARP (or IPv4 multicast, apparently).

P.S. I've filed a bug report on:
https://bugzilla.kernel.org/show_bug.cgi?id=214153

Regards,
Tom

On Mon, 23 Aug 2021 at 02:07, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Hi,
>
> Normally when a NIC is (directly) enslaved as a bridge port, the NIC
> itself does not need to have a IPv6 link-local address configured on
> it for IPv6 multicast / NDP to work properly (instead the address can
> simply be configured on the bridge like IPv4 addresses).
>
> Yet it appears that if the bridge port is instead a passthru mode
> MACVLAN, IPv6 multicast traffics from (the link/"side" of) it cannot
> reach the host (as in, cannot even be captured with tcpdump) unless
> either the MACVLAN or its underlying link has a/the[1] IPv6 link-local
> address configured.
>
> Is it an expected behavior? Or is it a bug?
>
> [1]: In my configuration, the bridge, the bridged passthru MACVLAN and
> its underlying link have the same MAC address and hence (at least by
> default) their IPv6 link-local addresses are identical.
>
> Regards,
> Tom
