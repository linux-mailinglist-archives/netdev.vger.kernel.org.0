Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CBA48DB7F
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbiAMQRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiAMQRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:17:12 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3F5C061574;
        Thu, 13 Jan 2022 08:17:12 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id g81so16402099ybg.10;
        Thu, 13 Jan 2022 08:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hTifkHX6mOkv/0AvycMRIn0YzCqQ7Sa1l4npCtuLpc=;
        b=l+2GOZ0zcgeMhURmXHh/D2UpibaYlPat2bypbf+mRemc42p5JPxHTCVD7uaKyTfgEv
         FO3vfT+Ylq4Tl0iN+S0eExStEYXAyc3JDCV1+IluOD/O0knAd+ZUEIBx79HKkTbFVIuj
         LaLkneiw2+fxXBRd5sYEwAdbK1SPj6DZ3U995Db4FHSbJAcprrwFEGWwe/YK66T8f8cO
         xRbIKIFWwMntAkzcxknHtjeJbtEQW3EWUFK8+IMls5dWklTXgN4mtFvupUgNGqf3qZ3C
         uOYyM9xpDO2UTtD9p8eoXKTHRoG7nXpoTdnI3tRE8BZybNl0t5vs/uAjlKahp02TAiK7
         IBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hTifkHX6mOkv/0AvycMRIn0YzCqQ7Sa1l4npCtuLpc=;
        b=iRiv1hmxINiAaZx266EPXyo/BN2SgukoYE8evVySr2bYuNf35dlcLNptGas0m+e0oL
         2zQkOJtWwbN2okb3jLjbqr51UaxP8666PIvWOnBNdiPzDTa7+SeV/7EhoqI80DvMjU8d
         c5U1fwmfMwp4ED55NK+yKaVig7Nnw/P8pmenYNpD/AmLlBLk28s6k9u/H6PhXt2ttKWE
         +71LN2bgu5rzFRk54R7kD4UT6LM5EjDAnMEES8Udlq5N9T+onhaahy5/vyM3DssOIbVd
         wZglgN27XGlQEpGMTT4uU127h/7OJI1I1MJlGxg/7bqKdxFnD11WcNwTVpxb1hMh7NAC
         949g==
X-Gm-Message-State: AOAM5324Ifmw8xtQ1lHmF2Gc09RykQOOZ9t1VIr573QQPp43yUl2ZvO9
        /PFd0xYGvIlz9lRmGdIpv71SWPetC4anqmzMH3o=
X-Google-Smtp-Source: ABdhPJyUYY//oYtgD+zn1KYyqHXryEUD+NGX/O5mA1FGa1TVnZADw12okU4izkVWZ3mZCq+6yVUNDoBE0Unaepb6WJU=
X-Received: by 2002:a25:c41:: with SMTP id 62mr6976501ybm.284.1642090631759;
 Thu, 13 Jan 2022 08:17:11 -0800 (PST)
MIME-Version: 1.0
References: <20220113150846.1570738-1-rad@semihalf.ocm>
In-Reply-To: <20220113150846.1570738-1-rad@semihalf.ocm>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 13 Jan 2022 08:17:01 -0800
Message-ID: <CABBYNZJn1ej18ERtgnF_wvbvBEm0N=cBRHHtr8bu+nfAotjg2Q@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Fix skb allocation in mgmt_remote_name()
To:     Radoslaw Biernacki <rad@semihalf.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        upstream@semihalf.com, Angela Czubak <acz@semihalf.com>,
        Marek Maslanka <mm@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Radoslaw,

On Thu, Jan 13, 2022 at 7:09 AM Radoslaw Biernacki <rad@semihalf.com> wrote:
>
> From: Radoslaw Biernacki <rad@semihalf.com>
>
> This patch fixes skb allocation, as lack of space for ev might push skb
> tail beyond its end.
> Also introduce eir_precalc_len() that can be used instead of magic
> numbers for similar eir operations on skb.
>
> Fixes: cf1bce1de7eeb ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_FOUND")
> Signed-off-by: Angela Czubak <acz@semihalf.com>
> Signed-off-by: Marek Maslanka <mm@semihalf.com>
> Signed-off-by: Radoslaw Biernacki <rad@semihalf.com>
> ---
>  net/bluetooth/eir.h  |  5 +++++
>  net/bluetooth/mgmt.c | 12 ++++--------
>  2 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/net/bluetooth/eir.h b/net/bluetooth/eir.h
> index 05e2e917fc25..e5876751f07e 100644
> --- a/net/bluetooth/eir.h
> +++ b/net/bluetooth/eir.h
> @@ -15,6 +15,11 @@ u8 eir_create_scan_rsp(struct hci_dev *hdev, u8 instance, u8 *ptr);
>  u8 eir_append_local_name(struct hci_dev *hdev, u8 *eir, u8 ad_len);
>  u8 eir_append_appearance(struct hci_dev *hdev, u8 *ptr, u8 ad_len);
>
> +static inline u16 eir_precalc_len(u8 data_len)
> +{
> +       return sizeof(u8) * 2 + data_len;
> +}
> +
>  static inline u16 eir_append_data(u8 *eir, u16 eir_len, u8 type,
>                                   u8 *data, u8 data_len)
>  {
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 37087cf7dc5a..d517fd847730 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -9680,13 +9680,11 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>  {
>         struct sk_buff *skb;
>         struct mgmt_ev_device_found *ev;
> -       u16 eir_len;
> -       u32 flags;
> +       u16 eir_len = 0;
> +       u32 flags = 0;
>
> -       if (name_len)
> -               skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, 2 + name_len);
> -       else
> -               skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, 0);
> +       skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
> +                            sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0));

Looks like mgmt_device_connected also has a similar problem.

>         ev = skb_put(skb, sizeof(*ev));
>         bacpy(&ev->addr.bdaddr, bdaddr);
> @@ -9696,10 +9694,8 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>         if (name) {
>                 eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
>                                           name_len);
> -               flags = 0;
>                 skb_put(skb, eir_len);
>         } else {
> -               eir_len = 0;
>                 flags = MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
>         }

These changes would leave flags and eir_len uninitialized.

> --
> 2.34.1.703.g22d0c6ccf7-goog
>


-- 
Luiz Augusto von Dentz
