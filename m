Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F27D27C0D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 13:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfEWLqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 07:46:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35714 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbfEWLqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 07:46:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so2676405plo.2
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 04:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wCUem1x/ylV1bJblqN5DyUuj9iRlSTgirM+Nihz6Yc0=;
        b=kBRcan3ex7if0+/zQ6bxlRiznWrjYUd+Ho3MCpSpAJ3oI1kOro4TWWVqTr4YjeoAKQ
         m6ousfyZQWk4f6F4ysIa/GCw5se1GTJWlIALfspm0wUD1QUCHZXLy40cP8cfZ3DsG8VX
         hYFTF+SAT4gQfiK+oF7F+JIEHF0DEotkzap6a2rIfoVmGpS4dyltZJ6/WP67CY1GJjTu
         WxOBsrcRA1jE5vQMuCZnAFTY5P3MKkGvN3AiL+YK++gwzVpeaaY0fo7RzBQJoQWi2RJh
         dts2N4sCqCe/yvCxlveHNdRP/FsbOaqNx5W1AOp2mJ3BEZBZVXFTOkxn8AP5WETImJ8b
         VmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wCUem1x/ylV1bJblqN5DyUuj9iRlSTgirM+Nihz6Yc0=;
        b=gK5sf3M38nLnbHOkbYJGKsJHAvgU3/VJ37SNlRlIzOP0PeFAMvTALPmV9D2g9YZyKw
         yALBAbRTqrtYv6vDuO5Plr1jaeDFxjOI1koHetqfUiClk7K8aa6yaCI3MUHI22iWgRcW
         hYpgTvYXwbACZIOh0z8X8NxQm7ADbxz9iLpL90f/a+jPoaQXBN3Fxwg6pUok77Co6MSt
         3Apkk4tIcZ53lJODVL0v/jOkxTkndPYqJiwq+1FSvODDRu6k2zQ9Y56xwQFlfBnnf9+d
         bRDNOwN/MTfp7T6pwCq50mRobJ965fLzun5KRoUCv8iAapDhtUErRPcZhjkK9UiXCQZ2
         rwgg==
X-Gm-Message-State: APjAAAVGrYRMAkgUvgkL4p9OzyA5H8xAMRMlxSbsd5woMTWfkNyo0EZg
        bWJ/ZmMqMBu7jJjSOdmZrETDJA==
X-Google-Smtp-Source: APXvYqxVNdT42fnzi2SZEZYBxORLSTPqXLfNElPuLBHxSdMY7xWL/p1mDc4dwYQBFNxX2+n1KhaIwg==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr95930813plr.223.1558611982802;
        Thu, 23 May 2019 04:46:22 -0700 (PDT)
Received: from buildserver-90.open-silicon.com ([114.143.65.226])
        by smtp.googlemail.com with ESMTPSA id l43sm565045pjb.7.2019.05.23.04.46.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 May 2019 04:46:21 -0700 (PDT)
From:   Yash Shah <yash.shah@sifive.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, ynezz@true.cz, paul.walmsley@sifive.com,
        sachin.ghadi@sifive.com, Yash Shah <yash.shah@sifive.com>
Subject: [PATCH 0/2] net: macb: Add support for SiFive FU540-C000
Date:   Thu, 23 May 2019 17:15:50 +0530
Message-Id: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On FU540, the management IP block is tightly coupled with the Cadence
MACB IP block. It manages many of the boundary signals from the MACB IP
This patchset controls the tx_clk input signal to the MACB IP. It
switches between the local TX clock (125MHz) and PHY TX clocks. This
is necessary to toggle between 1Gb and 100/10Mb speeds.

Future patches may add support for monitoring or controlling other IP
boundary signals.

This patchset is mostly based on work done by
Wesley Terpstra <wesley@sifive.com>

This patchset is based on Linux v5.2-rc1 and tested on HiFive Unleashed
board with additional board related patches needed for testing can be
found at dev/yashs/ethernet branch of:
https://github.com/yashshah7/riscv-linux.git

Yash Shah (2):
  net/macb: bindings doc: add sifive fu540-c000 binding
  net: macb: Add support for SiFive FU540-C000

 Documentation/devicetree/bindings/net/macb.txt |   3 +
 drivers/net/ethernet/cadence/macb_main.c       | 118 +++++++++++++++++++++++++
 2 files changed, 121 insertions(+)

-- 
1.9.1

