Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334742623F3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgIIAVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgIIAVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:21:33 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B95DC061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:21:33 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b6so1329371iof.6
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 17:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8tybThLlRbjVkLUpKNVR8TAToijTPsCOvNfuIS/nQe4=;
        b=QnZqESsuB1xtnKr2wBGGEtm9HSR6eH4UoS3XsVWZszlNFjgNmIEoI10+ya6jXE8Kac
         0ncF2dLsd89AjLeCRkaQWwU/8HrQKfHDi1OF1aEfcRgAMaSsAnR8Sotz73iNZvjGP5BZ
         8z+u+qqjrCc3PZJWhccmJEbW/yumTy5rFeZNWVGQNHiPlgi4+GMDaUjy74Y94jnFmyX1
         LfwmSrZixq17zeKcBOP3uw6qkMwfTH0jzmgtI/pVO/SldF5C3AzKlvxsIzwh72wF6E+o
         kQ3C+Xwiqk878ETf6sj8wPOkOCM4eyHJQfpn4Cwk9J7pYNdMnsCwGhFeGc3YOwNyz53y
         enaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8tybThLlRbjVkLUpKNVR8TAToijTPsCOvNfuIS/nQe4=;
        b=qV91RpQd/BZ38OV1NPhrQGQQ/OiQ7JwxH+ilmc6YnH5JCeGRBF6/TjMKDP5G2oyPhp
         SXQVMR1o4Eo8nxzKFaIU2GEvY5pP5aSg3CWy8tXTKZeF9K6kawsA6WwlUO9mP+/ZZ9rz
         1aAz20weIjjLREr4JNDmQB4kUwsYzu81JVG9J6DQQul7174EZgPtNsPH2j59uBA+z5RL
         ynsTU7UdNLgxP7Ul+KHc8Mh0QbmZvCA0MHw7rOyNMeJxsO4oqVjmSWSi4eV7dm4natW5
         39F7hWFXI5sr7oeO5zpTxnbvE0sJzEtK/8xGgkkmfznng736zgFNtv7qjDF0BVE6yz6J
         ne3g==
X-Gm-Message-State: AOAM532HeS0U+kv65CuJN1xajdyByuOsrx4mxAWxn8W0UEMdo66ky/JL
        W0rGTBHMUdou0SVMY559yXZyOg==
X-Google-Smtp-Source: ABdhPJwsJruqibBWhLh59+eqHvJcw029rPxA1ngSj8jmGqUV0XB2L32F0MOWqPFaXUjdnHn6+X1sZQ==
X-Received: by 2002:a02:8384:: with SMTP id z4mr1577253jag.121.1599610892152;
        Tue, 08 Sep 2020 17:21:32 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f21sm457739ioh.1.2020.09.08.17.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 17:21:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: wake up system on RX available
Date:   Tue,  8 Sep 2020 19:21:22 -0500
Message-Id: <20200909002127.21089-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series arranges for the IPA driver to wake up a suspended
system if the IPA hardware has a packet to deliver to the AP.

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
system, the IPA driver starts all its channels (or for SDM845, take
its endpoints out of suspend mode).

Whenever an RX channel is started, if it has a packet ready to be
consumed, the GSI interrupt will fire.  At this point the inbound
packet that caused this wakeup activity will be received.

The first patch just checks the previous value of a reference
counter used for suspend, as precaution to catch bugs.  The next
three arrange for the IPA interrupt wake up the system.  Finally,
with this design, we no longer want the GSI interrupt to wake a
suspended system, so that is removed by the last patch.`

					-Alex

Alex Elder (5):
  net: ipa: use atomic exchange for suspend reference
  net: ipa: manage endpoints separate from clock
  net: ipa: use device_init_wakeup()
  net: ipa: enable wakeup on IPA interrupt
  net: ipa: do not enable GSI interrupt for wakeup

 drivers/net/ipa/gsi.c           | 17 +++------
 drivers/net/ipa/gsi.h           |  1 -
 drivers/net/ipa/ipa.h           |  2 --
 drivers/net/ipa/ipa_clock.c     |  4 ---
 drivers/net/ipa/ipa_interrupt.c | 14 ++++++++
 drivers/net/ipa/ipa_main.c      | 62 ++++++++++++++++++---------------
 6 files changed, 51 insertions(+), 49 deletions(-)

-- 
2.20.1

