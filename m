Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DA72A7691
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgKEEsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 23:48:05 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35759 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730497AbgKEEsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:48:04 -0500
Received: by mail-yb1-f196.google.com with SMTP id m188so225253ybf.2;
        Wed, 04 Nov 2020 20:48:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wB2b/r7dgRZxbZt4PlWrfyH3nOLSlGXHJIyVgaDqTM=;
        b=Zfw2hXcm5w01zJ0ibFB8FvxE4JqdPUCbotFqx6XGxs8tPmWK26cLqCVhQNX18DVpsv
         UWy+k/BgMOwMtDHg2B691xYdGJixhK8Xtv3SV13dDzHuvVgxiVFRr8O72KQEoUDF5EN/
         Yiqoon8EOSPQMm2Vze8J0c2M9gJqSgTuTg5gW2NbhotcxDvKvt9zgQxxy3hsjPLSDHDz
         svD48Eg7w5qm3+qaeaSZAxET1uhTaUvvm6m/gzsfi7zRt6zkXD8JbsBVFsxfGgPVA+zR
         2edmWjfbZGIpxgAMcBB2a6Z4xXXXMZ5yOjK8hpUEjhzwFjCWR8I+tzU84ZUvSIr7H28a
         pxSQ==
X-Gm-Message-State: AOAM533WY+83jkqkMY73FoLsRwru+7F5kjODAd09/od91V4l8uDamYfb
        tXCcbTuIb5tmlROZuTEBPiFjzbjlVL5tov2mxFAkqR200+AmAg==
X-Google-Smtp-Source: ABdhPJxGisx4EgH6crQuSHCu5Cu0I9k4PZRlumt1YdXuQLae+BqhrT+FlSwsRIn1avaPqPXPMP2aFEif1vw9zfaDTYM=
X-Received: by 2002:a5b:f4f:: with SMTP id y15mr1268688ybr.226.1604551684103;
 Wed, 04 Nov 2020 20:48:04 -0800 (PST)
MIME-Version: 1.0
References: <20201103220636.972106-1-mkl@pengutronix.de> <20201103220636.972106-6-mkl@pengutronix.de>
 <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK5xqYmLT=DZk0S15pRObSJbo2-zrO7_A0Q46Ujg1RxYg@mail.gmail.com>
 <988aea6a-c6b6-5d58-3a8e-604a52df0320@hartkopp.net> <20201104080237.4d6605ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <550bf8d4-bf4c-b1ef-cd41-78c2b71514e3@hartkopp.net>
In-Reply-To: <550bf8d4-bf4c-b1ef-cd41-78c2b71514e3@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 5 Nov 2020 13:47:53 +0900
Message-ID: <CAMZ6RqK=oEn3pgHb2byMC_SOVdG3Bbsfzssu9Fd-jDpSzEbrwQ@mail.gmail.com>
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-can <linux-can@vger.kernel.org>, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Nov 2020 02:46, Oliver Hartkopp wrote:
> On 04.11.20 17:02, Jakub Kicinski wrote:
>> On Wed, 4 Nov 2020 15:59:25 +0100 Oliver Hartkopp wrote:
>>> On 04.11.20 09:16, Eric Dumazet wrote:
>
>>>> So skb_orphan(skb) in CAN before calling netif_rx() is better IMO.
>>>>
>>>
>>> Unfortunately you missed the answer from Vincent, why skb_orphan() does
>>> not work here:

Hope that my answer did not go to the spam box.

>>> https://lore.kernel.org/linux-can/CAMZ6RqJyZTcqZcq6jEzm5LLM_MMe=dYDbwvv=Y+dBR0drWuFmw@mail.gmail.com/
>>
>> Okay, we can take this as a quick fix but to me it seems a little
>> strange to be dropping what is effectively locally generated frames.

For those who are not familiar with SocketCAN and to make sure that we
are all aligned here, let me give a bit of context of how the echo on CAN
skbs is usually implement in the drivers:
 * In the xmit() branch, the driver would queue the skb using
   can_put_echo_skb().
 * Whenever the driver gets notified of a successful TX, it will loopback
   the skb using can_get_echo_skb().

This is why the loopback is usually done in hardware IRQ context (but
drivers are also free to skip the second step and directly loopback the
skb in the xmit() branch).

> Thanks! So this patch doesn't hinder Marc's PR :-)
>
>> Can we use a NAPI poll model here and back pressure TX if the echo
>> is not keeping up?
>
> Some of the CAN network drivers already support NAPI.

I had a quick look at NAPI in the past and my understanding is that it
requires the ability to turn off hardware interrupts meaning that it can
be only used on some NIC, not but not, for example, on USB devices.

It would be nice to extend the NAPI with skb loopback for drivers which
already supports it but I am not sure how to include the other drivers.

> @Marc: Can we also use NAPI for echo'ing the skbs?


Yours sincerely,
Vincent Mailhol
