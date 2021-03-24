Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B396348280
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbhCXUEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237868AbhCXUE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:04:28 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACAFC061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 13:04:28 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w3so34946605ejc.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 13:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=f74HNcHRhdgUXrYcTsacIN2RB2E4rsiI9WAkUXIOsI4=;
        b=KhguD0taY3vnKMMiV7v1FoS2kEBDRYsh2XeaVj0u7vwEt7MumcsiKsERrwxgF9Wu8G
         TGRCoekLXzK9+5s3X7InTdjKhJZoaFW9C7QrDxIzejpoyJRvjMmZh5eXBPlxqbca6vA/
         h05SigHWNQ4z2SjZN8qoU1YVXt7P+gxH4OcPYew5CdkLVzcCVefpLomVD99Kpvvfrfyi
         QDBFAnfFHD3g3dTsx8Whpn9so1076mzWznirbhurSdtVdb3mDGo41uOcesxcYNg77wsS
         Tl+hhF9On6F3W3HbCliZ4gUXSEHu46eusyId+sbNgxmKb9zWcJ61iaZ7ist8LBoNep88
         VPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=f74HNcHRhdgUXrYcTsacIN2RB2E4rsiI9WAkUXIOsI4=;
        b=ZRbRAxXyJbsA2bL6Zatea0D5OqwWiqQtfOpeONPd6J5+8aHk7JqMJfbVFxsUr1DO48
         e2T3nPU63Jxw6x+T5ZmS4ev5xjOfuyDjscNiJFIfxfPWByHUBob5Za44zdy6AQGGOvSv
         1e+KD6NzrfZ/DgAtOh5ACEuEngPYbtq9CAPrBp/e9YlvMFVqVUmEnDwWHfaeaC1ABo5E
         j/VPV54ToFVRAfarDlIJrkK7tr8H0FsrbUtGp6F59z5o/PbmOB9vILQFOEsh8YSZsvCB
         ig6g3EEyPXNm4aDV3BBVKjCbrC+zwhygpgHzuwT0ScaRNeITKijqtu6iVKLDhAg8I6Jn
         wN+A==
X-Gm-Message-State: AOAM532SCtKZIbvYjPJiCxMHsayL0NG+auaIMEOBROT2S1ahQ8UtQcY2
        GJ+PLblTSr156XWQkqOJ1AIgUpTvPqK3Tz4ZvqiF2AWYl6c=
X-Google-Smtp-Source: ABdhPJyLKm4/kzeaZ87b73LMa0jUy8nUmUXEx0pmVYld89iV/lLitipxnLNClif2AVqvWDDy3PVobMqYkG15peujSvs=
X-Received: by 2002:a17:907:e87:: with SMTP id ho7mr5542274ejc.2.1616616266726;
 Wed, 24 Mar 2021 13:04:26 -0700 (PDT)
MIME-Version: 1.0
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 24 Mar 2021 21:04:16 +0100
Message-ID: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
Subject: lantiq_xrx200: Ethernet MAC with multiple TX queues
To:     netdev@vger.kernel.org
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

the PMAC (Ethernet MAC) IP built into the Lantiq xRX200 SoCs has
support for multiple (TX) queues.
This MAC is connected to the SoC's built-in switch IP (called GSWIP).

Right now the lantiq_xrx200 driver only uses one TX and one RX queue.
The vendor driver (which mixes DSA/switch and MAC functionality in one
driver) uses the following approach:
- eth0 ("lan") uses the first TX queue
- eth1 ("wan") uses the second TX queue

With the current (mainline) lantiq_xrx200 driver some users are able
to fill up the first (and only) queue.
This is why I am thinking about adding support for the second queue to
the lantiq_xrx200 driver.

My main question is: how do I do it properly?
Initializing the second TX queue seems simple (calling
netif_tx_napi_add for a second time).
But how do I choose the "right" TX queue in xrx200_start_xmit then?

If my description is too vague then please let me know about any
specific questions you have.
Also if there's an existing driver that "does things right" I am happy
to look at that one.


Thank you and best regards,
Martin
