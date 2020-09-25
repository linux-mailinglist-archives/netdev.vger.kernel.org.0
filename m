Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1424E2786E3
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgIYMTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbgIYMTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 08:19:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907ADC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 05:19:20 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n22so2276088edt.4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 05:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8mYTYvgAGN5rXMPjP45VOj57djCVoQRxxBLf/gVxFuI=;
        b=UB/Z5h72QUQYaaNnHzOmm/m19gTHVcGHKy4Vr+sYDrTn6SoThgVNTrIg1umK8w+8TU
         aPNpSQZk7oBoDx8GYxJOLz57PZLe5m5UwTEXFnH4Ty+vbeS273svcH0xZPB8Hh08i2ca
         UW3Zv15i9PlxMCQI9RbgprBJCC8ToG7ua5/oql6Ti+Hy07o8u3/3VJotf40TQPhYdN0a
         Y5r6woUHtQ/hErgic3n/U3R40AJ38qD44U1tWhp/nSkjq0O3QonqrGUndhEVrDuRZKXs
         2W3vVDB4psha6Ulf5piQ4BVaQJcmlvTOEp1wOsZFLAzPM7as7h9NHwXbOtQjwk95xAwO
         KZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8mYTYvgAGN5rXMPjP45VOj57djCVoQRxxBLf/gVxFuI=;
        b=SjIDsTnzYduF/2wW9QjPADY56a/X9ZEu2PPt4Fav0YYUvBoMjX3oXs3QbO4Um8UupK
         lOa4/G+FP7fUZ6SIkeiBrETbCq4DpvTG0mE3TbJDvCiiCUrgQoEduGesg0a9HdLxkBJA
         cRFS2TYNZpKr2bunCmLxITXWWJPTf74xnz3RiShmF1Fzq21U2GgVbrMgPscV3mQHDaHB
         4s+UWRK3CiygQfZ8w/hvP+Mkqn5Lw5x8XHb59W3PNxVBhgZ5DUzUm7ky+H4k0nqA9mKC
         VlDscdfRH9MhxCM1MtCBXvuhnHJUGkGT7rf13AweAXkzf22WBvVA9VI/EgwwSHmIdwiG
         d9+Q==
X-Gm-Message-State: AOAM530GZ0Q924/9wkMRG7oYE1DXbPVYyfhn/LZdtjfbzsntpLulg+6J
        S7+Jfg0TddJWY6V75HYLxM5CQGb4/70Q8koYU0xX5SwbSQg=
X-Google-Smtp-Source: ABdhPJwbUFoj9fjQVtwO8QuNJoIgF9SzWViLzlY9Eobt2z9kRsEj73tX7kLeubS5qGxe3Z5hiPSgnyO1E98K269cbeE=
X-Received: by 2002:aa7:d58e:: with SMTP id r14mr1074820edq.52.1601036359227;
 Fri, 25 Sep 2020 05:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200922214112.19591-1-hauke@hauke-m.de> <20200923.180140.957870805702877808.davem@davemloft.net>
In-Reply-To: <20200923.180140.957870805702877808.davem@davemloft.net>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 25 Sep 2020 14:19:08 +0200
Message-ID: <CAFBinCBQ1mx-Pg6kzZoHLp4i_Te5_i5NZWMTF_VqF90LGRWOfA@mail.gmail.com>
Subject: Re: [PATCH v2] net: lantiq: Add locking for TX DMA channel
To:     David Miller <davem@davemloft.net>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, kuba@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 3:01 AM David Miller <davem@davemloft.net> wrote:
>
> From: Hauke Mehrtens <hauke@hauke-m.de>
> Date: Tue, 22 Sep 2020 23:41:12 +0200
>
> > The TX DMA channel data is accessed by the xrx200_start_xmit() and the
> > xrx200_tx_housekeeping() function from different threads. Make sure the
> > accesses are synchronized by acquiring the netif_tx_lock() in the
> > xrx200_tx_housekeeping() function too. This lock is acquired by the
> > kernel before calling xrx200_start_xmit().
> >
> > Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

> Applied, but...
>
> You posted this really fast after my feedback, so I have to ask if you
> actually functionally tested this patch?
it fixes the following crash for me: [0]


Best regards,
Martin


[0] https://pastebin.com/t1SLz9PH
