Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3C85A2C2B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344461AbiHZQTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344433AbiHZQTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:19:11 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCEAD91D9
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:19:10 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-33dce2d4bc8so48248187b3.4
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1in29G4BteIRakRuuoxRuXqGQ7UlsROlnjbxci51a0M=;
        b=Ww6/9i888Lv4eGNktEUK6+TxKPacYVk3H/C7dNHJ56y1BH3v6MQCLDSPE04XHWr8sp
         gfOx4tjbfxgTjEFyHXEvXEXvmrejVTr5plM2OxR7bg3cUblbu8/v9vgfu3tGGbqR/522
         oGc0PKLc2p3B3SsdGldQyG3PeznGcPIppvgu0yz81NnCwtJfQNKdl/riHC8N414nBg7V
         LRZQPmbFP2/8fgbZZb5c1lD9MhGZ1lchKh4KHbAiDrWFRVZwVT2JMS5npB6g5l88iTcb
         IeYTBrqXY5dTlEpYbnhn/Iw7UmFJPKVnHojLZlTladmMPYXHzSiLmFZzgZg6TRF/vJR6
         YFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1in29G4BteIRakRuuoxRuXqGQ7UlsROlnjbxci51a0M=;
        b=JhiytvSeWFEF+ncgFpGpjXFY2jgV/8E1KkMw6aOP9WKjH905EtJrsf2lBze5RWzF7d
         6yhL3RWdG5v9B1SUxLa251h1Fo4EXNedetvqQ8yJAYXOahGCHeaQucGav9SPjV8/dkeQ
         QEZ4jdJzgv/ROb4Vg0+cyeCcJ52flX5ryrrA2N7uzgKvW+hFuPWZpAU9McdOtiY808Nb
         /0ijsg181pII0mK2JgyUEH0fyRkuUMQ21vmrWVTrfXZwcUA6O2zqOpPAhdjKKyZPnNGX
         K3P4oc+Mh4RLAQMi7Dnq/tqTjcdJXLZN4NzTmxjPQE0z/k2oYIEmerLNVMoNHv27m6um
         nmOQ==
X-Gm-Message-State: ACgBeo04QGofO7Sg3HlZDcwD/erxFMP8OsE5tSNmCmXQozsjxn9N/XYY
        7ZhFSoaM622zqBEgVWFdjdR8t/6hV44pQznYI8UoOA==
X-Google-Smtp-Source: AA6agR7JXQUVq2bDVZImv8O/NZfpAP3Xcm8rxZX7womrZYkhqV4Zhy3N7W7G0t4ASCauxPm8JFeNcxZqtrjCHzPHfro=
X-Received: by 2002:a25:b083:0:b0:695:9a91:317d with SMTP id
 f3-20020a25b083000000b006959a91317dmr370577ybj.387.1661530749022; Fri, 26 Aug
 2022 09:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220826002530.1153296-1-kai.heng.feng@canonical.com>
In-Reply-To: <20220826002530.1153296-1-kai.heng.feng@canonical.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 09:18:58 -0700
Message-ID: <CANn89i+hm1MmbQQRtPg7CbCihfYfoNjDt6ZJKRyNpJHAENp8oQ@mail.gmail.com>
Subject: Re: [PATCH v2] tg3: Disable tg3 device on system reboot to avoid
 triggering AER
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, Josef Bacik <josef@toxicpanda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 5:25 PM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> Commit d60cd06331a3 ("PM: ACPI: reboot: Use S5 for reboot") caused a
> reboot hang on one Dell servers so the commit was reverted.
>
> Someone managed to collect the AER log and it's caused by MSI:
> [ 148.762067] ACPI: Preparing to enter system sleep state S5
> [ 148.794638] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 5
> [ 148.803731] {1}[Hardware Error]: event severity: recoverable
> [ 148.810191] {1}[Hardware Error]: Error 0, type: fatal
> [ 148.816088] {1}[Hardware Error]: section_type: PCIe error
> [ 148.822391] {1}[Hardware Error]: port_type: 0, PCIe end point
> [ 148.829026] {1}[Hardware Error]: version: 3.0
> [ 148.834266] {1}[Hardware Error]: command: 0x0006, status: 0x0010
> [ 148.841140] {1}[Hardware Error]: device_id: 0000:04:00.0
> [ 148.847309] {1}[Hardware Error]: slot: 0
> [ 148.852077] {1}[Hardware Error]: secondary_bus: 0x00
> [ 148.857876] {1}[Hardware Error]: vendor_id: 0x14e4, device_id: 0x165f
> [ 148.865145] {1}[Hardware Error]: class_code: 020000
> [ 148.870845] {1}[Hardware Error]: aer_uncor_status: 0x00100000, aer_uncor_mask: 0x00010000
> [ 148.879842] {1}[Hardware Error]: aer_uncor_severity: 0x000ef030
> [ 148.886575] {1}[Hardware Error]: TLP Header: 40000001 0000030f 90028090 00000000
> [ 148.894823] tg3 0000:04:00.0: AER: aer_status: 0x00100000, aer_mask: 0x00010000
> [ 148.902795] tg3 0000:04:00.0: AER: [20] UnsupReq (First)
> [ 148.910234] tg3 0000:04:00.0: AER: aer_layer=Transaction Layer, aer_agent=Requester ID
> [ 148.918806] tg3 0000:04:00.0: AER: aer_uncor_severity: 0x000ef030
> [ 148.925558] tg3 0000:04:00.0: AER: TLP Header: 40000001 0000030f 90028090 00000000
>
> The MSI is probably raised by incoming packets, so power down the device
> and disable bus mastering to stop the traffic, as user confirmed this
> approach works.
>
> In addition to that, be extra safe and cancel reset task if it's running.
>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Link: https://lore.kernel.org/all/b8db79e6857c41dab4ef08bdf826ea7c47e3bafc.1615947283.git.josef@toxicpanda.com/
> BugLink: https://bugs.launchpad.net/bugs/1917471
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
>  - Move tg3_reset_task_cancel() outside of rtnl_lock() to prevent
>    deadlock.
>

It seems tg3_reset_task_cancel() is already called while rtnl is held/owned.
Should we worry about that ?

>  drivers/net/ethernet/broadcom/tg3.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index db1e9d810b416..89889d8150da1 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -18076,16 +18076,20 @@ static void tg3_shutdown(struct pci_dev *pdev)
>         struct net_device *dev = pci_get_drvdata(pdev);
>         struct tg3 *tp = netdev_priv(dev);
>
> +       tg3_reset_task_cancel(tp);
> +
>         rtnl_lock();
> +
>         netif_device_detach(dev);
>
>         if (netif_running(dev))
>                 dev_close(dev);
>
> -       if (system_state == SYSTEM_POWER_OFF)
> -               tg3_power_down(tp);
> +       tg3_power_down(tp);
>
>         rtnl_unlock();
> +
> +       pci_disable_device(pdev);
>  }
>
>  /**
> --
> 2.36.1
>
