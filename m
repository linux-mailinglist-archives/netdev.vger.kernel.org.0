Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586AF57A293
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbiGSPDt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Jul 2022 11:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbiGSPDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:03:39 -0400
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158454D167;
        Tue, 19 Jul 2022 08:03:36 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id u19so16456130lfs.0;
        Tue, 19 Jul 2022 08:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pHD6gf+jnhFiSPhKk1/yH2ypoHYFArDGaWOsXiwhDEU=;
        b=su6bX1GWseOd9wXI8avUH+WUleQDibj58RBRQIvSOTZiJBP+76hcvqsB8NtAnGzSSX
         pUKywJV6U012TuSqPvCt8ses6mIrMgesdSB+JUVCGl5afwQ+gD5Sny0Lcjafs9D/hawd
         9/ZufWjOyUQsBQs0mLkeAFlO0q9mCf2kHFIz46OTvTvnwrviEEWrdrGinZMvWadYd3NE
         /5VmhKrcLJO8orGoIsTcI9PeDrpnFoE8enqx/y4wu9GqNi4HXRyTA8vP+xGrWbhev8xN
         14f2mTWyi38zbNapnOtAq3FekM8+srnynha3HupVcbYfemWtehOoGsNT9DtOE4+hqDyV
         Cx5A==
X-Gm-Message-State: AJIora9T9pAmhsL4WlIPU0ZF1cF9u8tH93Awmu125BIQRJBtaFsClEZz
        OI2zyB+Pa0p9Cx6xmID21aWioOheX+b1N17lFVc=
X-Google-Smtp-Source: AGRyM1t+hsN65LgMItp1WDi3LIhUAr+34DRwVzbVxuawLzw9XnqW13m/odTrGhdk1cB0YVvOTDKAfLoKo9aaXYCHjyY=
X-Received: by 2002:a05:6512:1312:b0:47f:7bd3:1427 with SMTP id
 x18-20020a056512131200b0047f7bd31427mr16437493lfu.128.1658243014235; Tue, 19
 Jul 2022 08:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220718222804.21708-1-linus.luessing@c0d3.blue>
In-Reply-To: <20220718222804.21708-1-linus.luessing@c0d3.blue>
From:   Adrian Chadd <adrian@freebsd.org>
Date:   Tue, 19 Jul 2022 08:03:21 -0700
Message-ID: <CAJ-VmomaQ-ai7n5i8-8sXsgaih4vjjHXyw+JQESGMERgC8Qqdw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Fix wrong channel bandwidths reported for aggregates
To:     =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Linus_L=C3=BCssing?= <ll@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 at 15:28, Linus Lüssing <linus.luessing@c0d3.blue> wrote:
>
> From: Linus Lüssing <ll@simonwunderlich.de>
>
> AR9003 based wifi chips have a hardware bug, they always report a
> channel bandwidth of HT40 for any sub-frame of an aggregate which is
> not the last one. Only the last sub-frame has correct channel bandwidth
> information.

Hi!

It's not a hardware bug. Dating back to the original AR5416 11n chip,
most flags aren't valid for subframes in an aggregate. Only the final
frame has valid flags. This was explicitly covered internally way back
when.




-adrian
