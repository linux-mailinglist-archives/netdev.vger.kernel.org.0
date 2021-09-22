Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BB4414431
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhIVIuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbhIVIuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 04:50:17 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB834C061756
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 01:48:47 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id n18so1901812pgm.12
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 01:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=YUrpmzlgkZmRjfgqSKrun8uN8jVS5tbkXdhkEL7e6oA=;
        b=Ke1gkSTuRKJSIanNwZdzAUIw1NS2ztnfcenfMWbQZM8JQ4waOjPTl+RDO7iWs16eUU
         LsvXacv4q+jSnssH3fBjBCqniFgheBWbYrt3+XDiQbAkDSjlC8dWwCtcCWmI7rTxI/pC
         LJM8Xcv+MuY970uSCvWjJQE8LxUJohbQ0j9JaWMnaUut7K8x9SHLa23jF/MIodACbSCT
         kahLAnNPw9DHDHEht7qzyWBDBV8QPi+FQ74FBUa5ijjCKrXkZAmrnOz9GGCsL9SDnm1/
         bD84akfwj5HYgMdYC4JXOgmrBJw1F54F+M5KaBkDS2ZfGsEhnKwGgHN6zsY8Zr4NvUjC
         K3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YUrpmzlgkZmRjfgqSKrun8uN8jVS5tbkXdhkEL7e6oA=;
        b=t/pfFyXQc3ep1oKVhd8OUtNxUqpOOnaaT6biBsZKm0pTPIUnnwZ1aqTwW5hfYKsgX/
         5g7ZjyXcf9JOuhRkgvwNcUzO898R+0XfOAiSQrdgJ2uJdkDJbeP4EkICGVSviGvkSJVj
         50smXZPps1kr2fvMw9xintXyEYcMsKOaevC1ah1rPhJtRKMhNsJ4RTI9bJ/nyCyhp+Vw
         Ph8jgbvBDiCnjacDpbU29w60TKNl0t9cZBaYDo0J/Ujb5XuVm9/KGBN57q3GlLEstGgJ
         evpeU69+QwPYN3WrO0kx468nu0p5HaxlPYFP+2CR78RCwHpDjsf6mHq1zhYbHeVCjHNv
         0M3A==
X-Gm-Message-State: AOAM530C56/FaXzDshfnbA2xt96DRvlXlGqZuGRBBoZzlfgJ9m2Ua3lK
        C+oyZkNYovn1z4B0LBSCqJn0Aoh/UkYL33vFRSFXSmf/Owc=
X-Google-Smtp-Source: ABdhPJzxmfukZQrTtvt+0rfGDH81DCtP5djxrBN4FPjin0PogjpPPxHcjuonkpdRZANrztXB8TZ/zxFDwOZgDI5qBVQ=
X-Received: by 2002:a63:9546:: with SMTP id t6mr32118372pgn.260.1632300526952;
 Wed, 22 Sep 2021 01:48:46 -0700 (PDT)
MIME-Version: 1.0
From:   John Smith <4eur0pe2006@gmail.com>
Date:   Wed, 22 Sep 2021 01:48:36 -0700
Message-ID: <CADZJnBbMmE-zktRyq-gZWPuEOHRLyuQRmheqKP1_HWuHRymK0g@mail.gmail.com>
Subject: stmmac: Disappointing or normal DMA performance?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a one-way 300Mbs traffic RGMII arriving at a stmmac version
3.7, in the form of 30000 1280-byte frames per second, evenly spread.

In NAPI poll mode, at each DMA interrupt, I get around 10 frames. More
precisely:

In stmmac_rx of stmmac_main.c:

static int stmmac_rx(struct stmmac_priv *priv, int limit) {
...
while (count < limit)

count is around 10 when NAPI limit/weight is 64. It means that I get
3000 DMA IRQs per second for my 30000 packets.

I have tried different settings but I can't do anything better.
"Better" meaning that I would like to have fewer interrupts per
second, so a higher number of frames on each interrupt in order to
minimize the load transferred to my CPU.

Everything else being the same, if I send 10000 1280x3=3840-byte
frames per second, I get around 3 or 4 frames per interrupt.

Is there a way to increase the ratio of packets / IRQs? I want fewer
IRQs with more packets as the current performance overloads my
embedded chip,

John
