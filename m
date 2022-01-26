Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F73549D5FB
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiAZXM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiAZXMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 18:12:54 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EACC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:12:53 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o12so1769654lfg.12
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=ZtG5rcMwTCdvSvc+/u2GmsqqrQUO1YFuxGatNd1Nbt0=;
        b=ySLQ/jUtJVDZ1wL2cyYXgJztXezCOaS7TBGUa9oV6EYwwqWFapVgfRiIaR79YqruI4
         89q2g/qhoIXYHm5xVpgZUoGXztDJfYLXfL3ZRwzK/ooF26ILijDHlJriY8jD0XOniHXy
         6MNdRvDD1UQJpOIC1mklroZMnAmD7Rn28pPCRMYQR35MXxUcfLaXA8sPRZYyoDkCBdm0
         BUSvVwhs1Maoea2wPwjLQZbnm8XyM0LBSZmEiauia/spCIUa+33gE7D+OAJaGuadzIzv
         598b1kKxTKRMGnmitNhDJgZmshopX/OldHAKIyRjJGH+/KgRJonq21eSAtxlJDZCWoE6
         w7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=ZtG5rcMwTCdvSvc+/u2GmsqqrQUO1YFuxGatNd1Nbt0=;
        b=qBcurIA87+cITJKGZEIxBb+K9V8RMI3X0UoqfOSffW6yx1WBmP7cCuDHob7k6mEQJo
         PZguoEocjzGqlTFBK9Mmp/b3dL8YhcTnL0a/r3Iexl29UYyTEZTg4g2/PJUEWbqhF0Jn
         wjYZ5AeQb4cYfaLnG5r8MKXWMoZx95uGcodz0hH+38ZZ1B8RHlgVId4Y5GJqlN+0/ii6
         I4o39+tiBibyRJCq6kzeCfBMt/u1jedEyTCEJHFjBW4QCx6BKngGQK0D5EIRde94aj3P
         eczY9Tz7WUUWFlkJpeiVnVZpUqYmqLo5yaLF97bPL/KAzMcWw1pZ7IuRIhINW2I1ltzc
         tJUg==
X-Gm-Message-State: AOAM530EFTzLAXVhFlWKb9u8xGvSRW4Gnl1QmCsk0sb0hRb8SpesDzQ8
        PmB+Cd4hww2iMAevbbIJ47m4EYtJKz06GA==
X-Google-Smtp-Source: ABdhPJwnL/wvubh7F/p5BsZiZQ9dzSM9hPXlE5C/E8W8b8uxpdvYtRvEy0sd9wHL34/0OUzlpEsQFA==
X-Received: by 2002:a05:6512:31cf:: with SMTP id j15mr924326lfe.670.1643238771597;
        Wed, 26 Jan 2022 15:12:51 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p28sm1529335lfo.79.2022.01.26.15.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 15:12:49 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: dsa: mv88e6xxx: Improve indirect addressing performance
Date:   Thu, 27 Jan 2022 00:12:37 +0100
Message-Id: <20220126231239.1443128-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The individual patches have all the details. This work was triggered
by recent work on a platform that took 16s (sic) to load the mv88e6xxx
module.

The first patch gets rid of most of that time by replacing a very long
delay with a tighter poll loop to wait for the busy bit to clear.

The second patch shaves off some more time by avoiding redundant
busy-bit-checks, saving 1 out of 4 MDIO operations for every register
read/write in the optimal case.

Tobias Waldekranz (2):
  net: dsa: mv88e6xxx: Improve performance of busy bit polling
  net: dsa: mv88e6xxx: Improve indirect addressing performance

 drivers/net/dsa/mv88e6xxx/chip.c |  8 ++++----
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/smi.c  | 32 ++++++++++++++++++--------------
 3 files changed, 23 insertions(+), 18 deletions(-)

-- 
2.25.1

