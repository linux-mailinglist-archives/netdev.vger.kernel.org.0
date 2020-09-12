Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848392676E4
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgILAps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgILApg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:45:36 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CCEC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:36 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b17so10621338ilh.4
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=laHvaXjgDiZ7hT5VZ2zTC9kT0HDWw1Q17DerbeIXeaM=;
        b=u1Mc7+BPZIBIkMQnutAq0+Oa7sZELfd5vjBj8TZxt/U7zC9Gj4Nnnc1ZEYO7vpZVWf
         p4sDCuFTsM3iTH2ZeD2sRqnG7mmP99zrdPSHphFhEv+ne6g6AIEFKNWpE1tfMynSLNGY
         n9Zm22IgbSSif+M2gouohzHumRkvT8XclDq9QGn0RKtDvSgT1GGkTmftM/SPf9n2lqY9
         P4QuRKgKejGZu6NdmNP3vR4Ejf1b0zY4kkLJf/7dhXfjqBotQ2F2xGFLg4ps55UznGo/
         s8WejFl6U/SIywBzyYRQWm8VQd8JlMUH2UMIF2Oy2YfuKUQMzWXZ63ORQM1pds5KLNEE
         JWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=laHvaXjgDiZ7hT5VZ2zTC9kT0HDWw1Q17DerbeIXeaM=;
        b=p7MlLtXJ1bVxuzEx/tiQYLsYYDsbgSna23+x03tlUGgR9lRml306iniKM4SkrFIVA6
         J/4R9sQ/MorX4RiaVFyaRUa6N+phw6IHgD7g0Dzb04IreX5KGjoTgj6LB/icx8/pnKix
         ud9vKeFE8zUFvIjakUHUBDgh2cmywOEFN9YMYab83g8vS4wyAdUluMPtA5/y2C+6VZYC
         Kq6NBaTJBDYVlkEAX/OECDq2PNwHEFGq+L+61ciC+6qvSYn5mHg6C4a/jaKtG3yapr6M
         wQdJpZ7WdTO7bjw6QaSmMsOQSlyAm1aL/HicUDg7BJAUOjVIAJaHDAsaRfgokqsjOpRP
         TNHg==
X-Gm-Message-State: AOAM532IbztKxsTTHwnisHp7wor+Pmz8/Ws/v0SEGZrLZBPXYBMtnXaU
        kBl94+JuR2WnmleU7vJ1C9VihA==
X-Google-Smtp-Source: ABdhPJwp0HbDuoYG2SlrAI0iObOIlLfk30jinTftPG9j5f6HU/O6lVPMrPomRAB7v+1vVNGUNt05Ug==
X-Received: by 2002:a92:7706:: with SMTP id s6mr3754047ilc.90.1599871535728;
        Fri, 11 Sep 2020 17:45:35 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z4sm2107807ilh.45.2020.09.11.17.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 17:45:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/7] net: ipa: wake up system on RX available
Date:   Fri, 11 Sep 2020 19:45:25 -0500
Message-Id: <20200912004532.1386-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series arranges for the IPA driver to wake up a suspended
system if the IPA hardware has a packet to deliver to the AP.
Version 2 replaces the first patch from version 1 with three
patches, in response to David Miller's feedback.

Specifically:
  - The first patch now replaces an atomic_t field with a
    refcount_t.  The affected field is not the one David
    commented on, but this fix is consistent with what he
    asked for.
  - The second patch replaces the atomic_t field David *did*
    comment on with a single bit in a new bitmap field;
    ultimately what's needed there is a Boolean flag anyway.
  - The third patch is renamed, but basically does the same
    thing the first patch did in version 1.  It now operates
    on a bit in a bitmap rather than on an atomic variable.

Currently, the GSI interrupt is set up to be a waking interrupt.
But the GSI interrupt won't actually fire for a stopped channel (or
a channel that underlies a suspended endpoint).  The fix involves
having the IPA rather than GSI interrupt wake up the AP.

The IPA hardware clock is managed by both the modem and the AP.
Even if the AP is in a fully-suspended state, the modem can clock
the IPA hardware, and can send a packet through IPA that is destined
for an endpoint on the AP.

When the IPA hardware finds a packet's destination is stopped or
suspended, it sends an *IPA interrupt* to the destination "execution
environment" (EE--in this case, the AP).  The desired behavior is
for the EE (even if suspended) to be able to handle the incoming
packet.

To do this, we arrange for the IPA interrupt to be a wakeup
interrupt.  And if the system is suspended when that interrupt
fires, we trigger a system resume operation.  While resuming the
system, the IPA driver starts all its channels (or for SDM845,
takes its endpoints out of suspend mode).

Whenever an RX channel is started, if it has a packet ready to be
consumed, the GSI interrupt will fire.  At this point the inbound
packet that caused this wakeup activity will be received.

The first three patches in the series were described above.  The
next three arrange for the IPA interrupt wake up the system.
Finally, with this design, we no longer want the GSI interrupt to
wake a suspended system, so that is removed by the last patch.

					-Alex


Alex Elder (7):
  net: ipa: use refcount_t for IPA clock reference count
  net: ipa: replace ipa->suspend_ref with a flag bit
  net: ipa: verify reference flag values
  net: ipa: manage endpoints separate from clock
  net: ipa: use device_init_wakeup()
  net: ipa: enable wakeup on IPA interrupt
  net: ipa: do not enable GSI interrupt for wakeup

 drivers/net/ipa/gsi.c           | 17 ++------
 drivers/net/ipa/gsi.h           |  1 -
 drivers/net/ipa/ipa.h           | 16 +++++--
 drivers/net/ipa/ipa_clock.c     | 28 +++++-------
 drivers/net/ipa/ipa_interrupt.c | 14 ++++++
 drivers/net/ipa/ipa_main.c      | 76 +++++++++++++++++++--------------
 6 files changed, 84 insertions(+), 68 deletions(-)

-- 
2.20.1

