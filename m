Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D738F49B96
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 09:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbfFRH6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 03:58:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41487 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRH6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 03:58:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id 83so7218836pgg.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 00:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bxoc5/YWGBSJZWeOJnUb4ABn8p6gJT0nStCBWSa2eA4=;
        b=ngLBMMPw8YFffR+8THORT8LivSqIKXuvMWgEh1bCZb5ASHThP8ifiVQ6GzM9xKwr5k
         gJKt8WKUo1+ReF+bXeawLiDxNZoizIU1MlzklfUyZexrj5DvjcyB5Gkt6SLITCqfq0w+
         iYyrOFndZb3g2KH23GJOQZGa18+JsA9VHIuNdATXs3tvaU7IZPXAIe8fUQ6A0bJaEgFU
         35LQbWYuNSZPjQ2RRXnbbkMypJ/63njJCnm2RhsAvKZroy1QRGs4E10wH8TnGiaQdh71
         NO9mO/MrvrowbLlz4zm3GCQlI6qpZ662yWwA+iIljNm3AnMLpImXOzep1Sov08WO+Y7f
         HK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bxoc5/YWGBSJZWeOJnUb4ABn8p6gJT0nStCBWSa2eA4=;
        b=PIUfuAFwDuejRCncD47J6/l8G4SJoFahtMFbG8wGhmFJA1cUariEDqErYTRfcZUfEX
         9Hj2kgfvZ7UQGYIDefmxR3PaF2o+c3UHy00+Lgcc/ZbTDDKuLVN4ZiBzpRzE+Kvmk7/r
         aRjv/9wAMZxYrN5XYDS2GjwVE4RQAaADslVP3WLfksUw+EFmminf9YaLRSEN5jPXDY0n
         1xFzMDqwV8eoebs0AftvpnxzstVy6/kNJvccGhOLwcU/sQQsuHzorgoRyOhjvVAZ1+OO
         VSZnelRfarQZ2ilc+0D8nHXo2hkQ6cbBQNbVDRf1BVZpZ6pJ++h9TuMpU3+2snwPTJA4
         SaxQ==
X-Gm-Message-State: APjAAAVSy2mjdvbvvwxtZ5ppTUth9v5Frgf5pP5PHE3eDfh+/TEh6h1X
        S4PdhxfV0Rsm6f9ldkQ58ZmlOQ==
X-Google-Smtp-Source: APXvYqz/EVWywUMWL2SlfXAU0IwdSy+Z2HHT9wFgROaskaDuM2vV5C7vCPyzsyqhoQhb1O8tRVNfLw==
X-Received: by 2002:a63:a044:: with SMTP id u4mr1461003pgn.316.1560844717487;
        Tue, 18 Jun 2019 00:58:37 -0700 (PDT)
Received: from buildserver-90.open-silicon.com ([114.143.65.226])
        by smtp.googlemail.com with ESMTPSA id b23sm15780499pfi.6.2019.06.18.00.58.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 18 Jun 2019 00:58:36 -0700 (PDT)
From:   Yash Shah <yash.shah@sifive.com>
To:     davem@davemloft.net, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, paul.walmsley@sifive.com, ynezz@true.cz,
        sachin.ghadi@sifive.com, Yash Shah <yash.shah@sifive.com>
Subject: [PATCH v3 0/2] Add macb support for SiFive FU540-C000
Date:   Tue, 18 Jun 2019 13:26:06 +0530
Message-Id: <1560844568-4746-1-git-send-email-yash.shah@sifive.com>
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
found at dev/yashs/ethernet_v3 branch of:
https://github.com/yashshah7/riscv-linux.git

Change History:
V3:
- Revert "MACB_SIFIVE_FU540" config changes in Kconfig and driver code.
  The driver does not depend on SiFive GPIO driver.

V2:
- Change compatible string from "cdns,fu540-macb" to "sifive,fu540-macb"
- Add "MACB_SIFIVE_FU540" in Kconfig to support SiFive FU540 in macb
  driver. This is needed because on FU540, the macb driver depends on
  SiFive GPIO driver.
- Avoid writing the result of a comparison to a register.
- Fix the issue of probe fail on reloading the module reported by:
  Andreas Schwab <schwab@suse.de>

Yash Shah (2):
  macb: bindings doc: add sifive fu540-c000 binding
  macb: Add support for SiFive FU540-C000

 Documentation/devicetree/bindings/net/macb.txt |   3 +
 drivers/net/ethernet/cadence/macb_main.c       | 123 +++++++++++++++++++++++++
 2 files changed, 126 insertions(+)

-- 
1.9.1

