Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE2610DE91
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 19:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfK3SgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 13:36:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33919 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfK3SgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 13:36:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id n13so16222140pff.1
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 10:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IOGRxhwR4EDYaHb8mPQ7+5JxA3rdzyET/3G6BNM/BIA=;
        b=AmkwXV3L/MfP7v4CaR18+JOS2pWJeKKLWcXwK2NU9LCNkxljLXRyg9MS6CMKCGc2+R
         rOC9dQtytRLj83DrD2cErpNx+G2f3Ou/z8df7YeznfMvJpdkex9es+QnH+5fwt1X+7xx
         aITKZoQzgiKw+Br56LlWYKIMild5LvyR0Mqmk2Z3QofHeulqPWSh97EF3oQrPYnhI7/l
         ZZXE1PiH8+jeHFLTcPSVKYDANlMiWH5/+pRtL9T2WLCYPb6tn8rtHXBLyEQW69VBlt6P
         kvd+N7ro8IotbQPTRO0ZeEWwJAWG1Yeg9lx6IOoyNXpHsaEnha5fUC7ZvKnG09atu5qw
         wiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IOGRxhwR4EDYaHb8mPQ7+5JxA3rdzyET/3G6BNM/BIA=;
        b=OVuUvgn8CrdcHL943dCwr6JZhbpMsblSddc7eRr0psMHNuVA0oSMfRMkRp1wcdKL6F
         5tzDNFTrZGFQkuvA0XI7/jrKPGhGf0UNPj5DzIGnAE5QVhWNZRR2mjh3NhBMMUhrG7RD
         SUc9yoqnXSFrnsigl1boxQM2HH/b8CHOK+LjHlBE72GlsbK2dTToh58b1Kvb8n85dtd/
         suKMqLgT75xiD1zjuIUgP5/2Y2JDwxxVcHO9/zfetHEoACwDPzsakpn6Y0FNGjNqbZA8
         TCugf5OQQMBqmnvKQIiXpnPsdr53Oqq8Eg8t7JEQQGIwsr8re6VE7rJnTif/djXPe1J2
         lBTQ==
X-Gm-Message-State: APjAAAVvXUA0Lw5a+HJsYZ+aKgXqR4BenPJMITNynXviLjQUr/d176Zy
        1GbtTIPXlVhEJl1zb3eptLoEAJoz/PFPeJeU2m93CTkk
X-Google-Smtp-Source: APXvYqyQ89l9V4opKjYubZL+88xfXW15eGkeD+trIpUYbzUworK59//vG2qIe3w/ohO+3H3p8H0K9E3sCvzuSu7JSLc=
X-Received: by 2002:a62:d415:: with SMTP id a21mr1621171pfh.242.1575138969584;
 Sat, 30 Nov 2019 10:36:09 -0800 (PST)
MIME-Version: 1.0
References: <20191130142400.3930-1-ap420073@gmail.com>
In-Reply-To: <20191130142400.3930-1-ap420073@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 30 Nov 2019 10:35:58 -0800
Message-ID: <CAM_iQpWmwreeCuOVnTTucHcXkmLP-QRtzW22_g6QWM2-QoS5WA@mail.gmail.com>
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        treeze.taeung@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 6:24 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> hsr_dev_xmit() calls hsr_port_get_hsr() to find master node and that would
> return NULL if master node is not existing in the list.
> But hsr_dev_xmit() doesn't check return pointer so a NULL dereference
> could occur.

If you look at the git history, I made a same patch but reverted it later. :)


>
> In the TX datapath, there is no rcu_read_lock() so this patch adds missing
> rcu_read_lock() in the hsr_dev_xmit() too.

This is wrong.


>
> Test commands:
>     ip netns add nst
>     ip link add v0 type veth peer name v1
>     ip link add v2 type veth peer name v3
>     ip link set v1 netns nst
>     ip link set v3 netns nst
>     ip link add hsr0 type hsr slave1 v0 slave2 v2
>     ip a a 192.168.100.1/24 dev hsr0
>     ip link set v0 up
>     ip link set v2 up
>     ip link set hsr0 up
>     ip netns exec nst ip link add hsr1 type hsr slave1 v1 slave2 v3
>     ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
>     ip netns exec nst ip link set v1 up
>     ip netns exec nst ip link set v3 up
>     ip netns exec nst ip link set hsr1 up
>     hping3 192.168.100.2 -2 --flood &
>     modprobe -rv hsr

Looks like the master port got deleted without respecting RCU
readers, let me look into it.

Thanks!
