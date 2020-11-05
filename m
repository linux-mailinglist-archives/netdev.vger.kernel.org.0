Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6533D2A85ED
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731591AbgKESOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKESOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:14 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D6CC0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:12 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id p10so2220567ile.3
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8fUu2nSRz/rQdKPD/n7O1Q6q1SAGSyes98Tm7yI3SBM=;
        b=BLAJm2ZsjEld2uw0/svOVf7hWTZnSLqt8ZRThDTVJz+n7r8ye/EGkj/7FccKP18OjR
         gnNqeJ/r+q2c7tG23y3bqMd6Y4SoiTesKM+xkTP+ICMYSS9pBw2ZC6mvYOXjzifvw3uL
         N+0c33H4OkI0PxY1voOMVnYkC6iTBUzDR3yawNyhwQJ8gXBz4Ri/PRu8NyTpW9iXAJXF
         XmmH13CXteHxEnHkCApQLkS+xlenZaZ80UEa/kaPTFtWLiwrhHmdLut5rYqdkysp790Y
         DGbb6Emxh9ZZwygaxxYRPVFCkgrELn5ZrzzbMHGsLG3d2z2vpqD949wGClwzdHvzJbOA
         GN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8fUu2nSRz/rQdKPD/n7O1Q6q1SAGSyes98Tm7yI3SBM=;
        b=UPM0+9MUjYogyWT+2yW68QsPI/EsCyp+Gvt4OHImFWhWXTd1B+1TVuFbgkP4MfZoO3
         uM+LYTeglHaY1VnJ1lzYfMpQoCU4Ngl9Pn7M4ldwztjZCWYWq3BsjBtYBpdwWtlcF8AA
         7RdNIzyCGevHFSPuSWcdHLEi2kYwm63glRwQ/yb11bhOjLGNJLqGhB5tKytaMZCCns2B
         6N3HszMFjoyqWTay5gaIAoH6rfj3kv9tOuVrD6euVua4OTSVCH8ixPpV6wPtVf/37sRY
         rkt2XLKgxKGyQb9DgNkGEfAoVnpFTsoGVEqU2oLhukZz1mW/Fez+b09KFiuGE1U9HT0z
         FeeQ==
X-Gm-Message-State: AOAM531FOPqJdABAAYmKAigzApQkpB8o22vYYz1Fd0hYQuKbw2OrbFuI
        QOpc7kzauo5IbhfPM4Db+SgyYQ==
X-Google-Smtp-Source: ABdhPJwfPfeclJ6Osaq8WyAre/vaZ8nlCm2Fy6ydBB9gjro2ggyY3g+kGjyjXjkSlJ8odvN/omSIhw==
X-Received: by 2002:a92:a182:: with SMTP id b2mr2779229ill.148.1604600051791;
        Thu, 05 Nov 2020 10:14:11 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:10 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/13] net: ipa: constrain GSI interrupts
Date:   Thu,  5 Nov 2020 12:13:54 -0600
Message-Id: <20201105181407.8006-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this series is to more tightly control when GSI
interrupts are enabled.  This is a long-ish series, so I'll
describe it in parts.

The first patch is actually unrelated...  I forgot to include
it in my previous series (which exposed the GSI layer to the
IPA version).  It is a trivial comments-only update patch.

The second patch defers registering the GSI interrupt handler
until *after* all of the resources that handler touches have
been initialized.  In practice, we don't see this interrupt
that early, but this precludes an obvious problem.

The next two patches are simple changes.  The first just
trivially renames a field.  The second switches from using
constant mask values to using an enumerated type of bit
positions to represent each GSI interrupt type.

The rest implement the "real work."  First, all interrupts
are disabled at initialization time.  Next, we keep track of
a bitmask of enabled GSI interrupt types, updating it each
time we enable or disable one of them.  From there we have
a set of patches that one-by-one enable each interrupt type
only during the period it is required.  This includes allowing
a channel to generate IEOB interrupts only when it has been
enabled.  And finally, the last patch simplifies some code
now that all GSI interrupt types are handled uniformly.

					-Alex

Alex Elder (13):
  net: ipa: refer to IPA versions, not GSI

  net: ipa: request GSI IRQ later

  net: ipa: rename gsi->event_enable_bitmap
  net: ipa: define GSI interrupt types with an enum

  net: ipa: disable all GSI interrupt types initially
  net: ipa: cache last-saved GSI IRQ enabled type
  net: ipa: only enable GSI channel control IRQs when needed
  net: ipa: only enable GSI event control IRQs when needed
  net: ipa: only enable generic command completion IRQ when needed
  net: ipa: only enable GSI IEOB IRQs when needed
  net: ipa: explicitly disallow inter-EE interrupts
  net: ipa: only enable GSI general IRQs when needed
  net: ipa: pass a value to gsi_irq_type_update()

 drivers/net/ipa/gsi.c     | 257 +++++++++++++++++++++++++++-----------
 drivers/net/ipa/gsi.h     |   7 +-
 drivers/net/ipa/gsi_reg.h |  31 +++--
 3 files changed, 205 insertions(+), 90 deletions(-)

-- 
2.20.1

