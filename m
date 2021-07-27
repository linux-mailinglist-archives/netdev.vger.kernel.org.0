Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047E43D7058
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 09:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbhG0HY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 03:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbhG0HY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 03:24:57 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9DAC061757;
        Tue, 27 Jul 2021 00:24:57 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id r23so11538892lji.3;
        Tue, 27 Jul 2021 00:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=806cL16Fyf0R0k5TtItiv7yjEE5s8rfxhJRcoiiIZI8=;
        b=IlLAneyGPnlS2hQN1TxR9M7nnWMmWAD1IoNw4jgl31gbP7Gl190ID+c/vecid0UgVP
         rHuV3s+pQbmbdofWpD0qZIuRom+AAe+awhfC+K3B3VW1jB8gMqWNetalT7HHDphLFSvQ
         vIS9uVGw1quoLziome9XnRNyemE0hh5rOW9MjS4/sdmNr+tkeGsPKnev0k/Lw5G8izg+
         +XeM49Q+bfViNvVissj0Hc5lmsUP/6hrKt8peDfVsCVTsDaUBBlZw1z+nsT2KjiExem9
         KIKhqmX+v9Us//v6HnxqfgyraGbxeHA4LP5iKeXuBfJPW8Ka8whi9dpsTv/0/+iw2z7j
         6epA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=806cL16Fyf0R0k5TtItiv7yjEE5s8rfxhJRcoiiIZI8=;
        b=rYbyEyb9V5NvVUvQK7Es3pzKsJhCMspPaSxX5cTI0gaM/2v3eoU5AzSLAcRz2IwMby
         QOk/2ldeaxddNX1JgQK1afPx2I3FVQtdBsgtkAGsFsUeQaoJhzaFmmyygPOv3Mz2E1PP
         inYxXeMSOJIeKls7aJcnYLkqmNMYYifktZXFbP1WfLiwWWNtpvzJWo5ndG8N7GSyPPbi
         cu2oUHJZ1QZU6yzlY5UqEs6hbaAAAdw3ngAK5q0j4vG5bGmcCi/nRNft8K/yrJWoSeKo
         lyJLGx6zEWxr8g/5GPtfdpaWyG9zol3ZqSHrOuTxPZb/fw955ygf1vAOaEemBIE0XeVu
         aQ5g==
X-Gm-Message-State: AOAM532UBcHMl78AFhMTgg90Oq0GeYZzCcGXH/AoPiMJWlc5lmeqdgdu
        9uSRBT/jBHs0JdjYsEgFVxjAdaSN4WEdupG7u90=
X-Google-Smtp-Source: ABdhPJz4WJIBAWirCiA0eXtKDaYKDtSOS2yB31Q6aqWl9Xz4r7OCQJKBWBs1xFcyQImVOBYnnwsWdGlPFN0dMI7PEW4=
X-Received: by 2002:a2e:901a:: with SMTP id h26mr14390354ljg.218.1627370695895;
 Tue, 27 Jul 2021 00:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210709084351.2087311-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210709084351.2087311-1-mudongliangabcd@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 27 Jul 2021 17:24:44 +1000
Message-ID: <CAGRGNgUNnf=62xnFE4zUiVJ+n6NyGjFUmdR2JChbRkhsDSy0Yw@mail.gmail.com>
Subject: Re: [PATCH] ath9k: hif_usb: fix memory leak in ath9k_hif_usb_firmware_cb
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brooke Basile <brookebasile@gmail.com>,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dongliang,

(Drive-by review, I know almost nothing about the code in question)

On Fri, Jul 9, 2021 at 6:47 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> The commit 03fb92a432ea ("ath9k: hif_usb: fix race condition between
> usb_get_urb() and usb_kill_anchored_urbs()") adds three usb_get_urb
> in ath9k_hif_usb_dealloc_tx_urbs and usb_free_urb.
>
> Fix this bug by adding corresponding usb_free_urb in
> ath9k_hif_usb_dealloc_tx_urbs other and hif_usb_stop.
>
> Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
> Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 860da13bfb6a..bda91ff3289b 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -457,6 +457,7 @@ static void hif_usb_stop(void *hif_handle)
>                 usb_kill_urb(tx_buf->urb);
>                 list_del(&tx_buf->list);
>                 usb_free_urb(tx_buf->urb);
> +               usb_free_urb(tx_buf->urb);

Ok, so if I'm reading this correctly, before the first usb_free_urb()
call, we have two references to the urb at tx_buf->urb.

Why?

Isn't the better fix here to detangle why there's more than one
reference to it and resolve it that way? This looks like a hack to fix
something much more fundamentally broken.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
