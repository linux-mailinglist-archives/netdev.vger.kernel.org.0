Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F6625F76C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgIGKMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728317AbgIGKMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:12:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E2BC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:12:18 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k15so15146240wrn.10
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PBxR7VXw1aCwGqAer2nypCWPiQAb9G0RtyHZQZJdCRg=;
        b=MTg1jv/PcT+WkbTKr0byANaiGd9ZA++tTpUhQukRNvDDvP7itswio8VFDmqlWIWboy
         elpop8aKCnsIkQOom83iMKfI5twvJSdIEp43TAP9ar9lOH2qgFl9P1lViv8Wuu8ZGXmg
         TT/Zkrj0n8QAKslB/bqy+uFKParOVEciLsFgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PBxR7VXw1aCwGqAer2nypCWPiQAb9G0RtyHZQZJdCRg=;
        b=r7eocApA4HrSZVUMJPB/oUBzF6l1o9itAGovCofDgSnnB52WQjSGM3b2odB0y9BBZp
         gF1DHBGNCnSAIVwAELKfnphNm3nlDvmu8SR6OQe0+Yl/18rRZtHdHBw6ILMWxdGIZxfd
         XMMn32T0ohERwD/ggVWVbBwUry2/xPfInpn4Jw4JW9Ut9ShZCAq36y8kDyOUAMcERfYN
         8MwuxiiF01zfAYzljJeRx+EUjeySVWwC2BaPzTzzOogl1mOZyG5mL2qd7cB5yXbmayc9
         mYJhzgt741qFxoqar+WIb5M87tOE5NMC9BL4tTuMUhzET5hX5u91wOPerxyJW/CVzF5o
         i19Q==
X-Gm-Message-State: AOAM530uB63Fbh+f+FZ0jVEFkzn+FuRW2OJ6lRY1NTn2E8k2rXOnSgsj
        P97iw9yKaY1+95y+TYu12WRxPO7ashHPnA==
X-Google-Smtp-Source: ABdhPJzIWjdF/pkB3TO8X5R0jCeUfBvOhZIOTUdvFBseDW7Q/WduDnbpqvt1COUiNZQ8ES/0MuLt+w==
X-Received: by 2002:adf:c3cc:: with SMTP id d12mr21177181wrg.399.1599473536870;
        Mon, 07 Sep 2020 03:12:16 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id i16sm24173748wrq.73.2020.09.07.03.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:12:16 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v2 0/4] ksz9477 dsa switch driver improvements
Date:   Mon,  7 Sep 2020 11:12:04 +0100
Message-Id: <20200907101208.1223-1-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These changes were made while debugging the ksz9477 driver for use on a
custom board which uses the ksz9893 switch supported by this driver. The
patches have been runtime tested on top of Linux 5.8.4, I couldn't
runtime test them on top of 5.9-rc3 due to unrelated issues. They have
been build tested on top of net-next.

Changes from v1:

  * Rebased onto net-next.

  * Dropped unnecessary `#include <linux/printk.h>`.

  * Instead of printing the phy mode in `ksz9477_port_setup()`, modify
    the existing print in `ksz9477_config_cpu_port()` to always produce
    output and to be more clear.

  * Include Reviewed-by tag from v1 series so it isn't lost (is this
    correct?).

Paul Barker (4):
  net: dsa: microchip: Make switch detection more informative
  net: dsa: microchip: Improve phy mode message
  net: dsa: microchip: Disable RGMII in-band status on KSZ9893
  net: dsa: microchip: Implement recommended reset timing

 drivers/net/dsa/microchip/ksz9477.c    | 25 ++++++++++++++++++++-----
 drivers/net/dsa/microchip/ksz_common.c |  3 ++-
 2 files changed, 22 insertions(+), 6 deletions(-)

-- 
2.28.0

