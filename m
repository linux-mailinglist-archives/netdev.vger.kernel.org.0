Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F433A5DF7
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 09:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhFNH54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 03:57:56 -0400
Received: from mail-qv1-f45.google.com ([209.85.219.45]:41552 "EHLO
        mail-qv1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhFNH5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 03:57:55 -0400
Received: by mail-qv1-f45.google.com with SMTP id x2so19300192qvo.8;
        Mon, 14 Jun 2021 00:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8IK1zU8Z+IOiLIKbr/0T//fPiEiICbobdXfTVV8G/JQ=;
        b=KTydyJtP0oLcQVezn6riIM32PXLNu2hghafwei5HJdeoM/wxJm2tmWbFAbRrWl0FX5
         A3HBD7WmCeC0XvblcDysEhz+i//kiXzF73rmHHWmUP4VONKo3+ecCFTXUubbaFCFCmGI
         W4LM+Aao8YatB/Nf9854oGAfsD90jWu2pjC9bzTQZTiUqPBarf4vrlA3iw1/1YMahcLg
         033ge8fMJ0v8mVRNWhekp97y8xfVOyddBucYgNgr5BHq/T7glBdXa10HvhC0aD7Wv8Ta
         4bOkVfsnlEYM1sBMeY1pUIrUjsHzU1Ya7NfRbcTlITYQoST6ZA4SStb95LJ+s9jU1FzE
         l2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8IK1zU8Z+IOiLIKbr/0T//fPiEiICbobdXfTVV8G/JQ=;
        b=eFSlFJBGd/wuiqTp4ElCIhrypCmg9yEOrCVEONzZX79F5vJOeI2IDHeN2Z9C4wvtGy
         eVDLUEYWVyDFblr6BNJBaZdLPNnI8zjw2jQema8vYFW4jaEFW66tNMQzMijxXduiG8Yj
         GfGiQNt537AmrmzVmAYKTwlB1gqhbPiM8ZrMesCpzs6lAnfv/huepfxsxg06kklWsOd9
         O9mXPv2uZAmcFciHv2OH1e1XyflzIsLcePkiAcRQBrq3Zr64Y1t4sLifFWDFXNBv73tA
         KAkIgtn667Qf/34JYcwO8VijIXgvuYuTkAw4EHwPx9ZlVFw+8ft3d0zAdCYxW8+oTa1m
         2lOA==
X-Gm-Message-State: AOAM530s72LuxzKL0q/lcK6Zck2EZdq2pgToJSjpvVB6INUxIyDAVIHu
        ui4IriZgT6+okZKHVj1mdMO2z+CGi9bjuDylTQ==
X-Google-Smtp-Source: ABdhPJw1ZajxfbuKXppLhGXVoCfAGFwRJ4ZDDcdj/R4a4emgrL+Kc2/R9Jk/bXUYUJD3Tph/1ognOyIexD4FrWCixTM=
X-Received: by 2002:a05:6214:1d28:: with SMTP id f8mr17418963qvd.32.1623657275881;
 Mon, 14 Jun 2021 00:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210609135537.1460244-3-joamaki@gmail.com>
 <22630.1623283469@famine>
In-Reply-To: <22630.1623283469@famine>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 14 Jun 2021 09:54:25 +0200
Message-ID: <CAHn8xcmT1nvOci_Cc0Oo49Gm9dab6B-b5B20nircCHu0jG8GRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] net: bonding: Use per-cpu rr_tx_counter
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, andy@greyhouse.net,
        vfalico@gmail.com, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 2:04 AM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jussi Maki <joamaki@gmail.com> wrote:
>
>         With the rr_tx_counter is per-cpu, each CPU is essentially doing
> its own round-robin logic, independently of other CPUs, so the resulting
> spread of transmitted packets may not be as evenly distributed (as
> multiple CPUs could select the same interface to transmit on
> approximately in lock-step).  I'm not sure if this could cause actual
> problems in practice, though, as particular flows shouldn't skip between
> CPUs (and thus rr_tx_counters) very often, and round-robin already
> shouldn't be the first choice if no packet reordering is a hard
> requirement.
>
>         I think this patch could be submitted against net-next
> independently of the rest of the series.

Yes this makes sense. I'll submit it separately against net-next today
and drop it off from this patchset.
