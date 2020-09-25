Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565682793BB
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgIYVrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgIYVra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:47:30 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCDFC0613CE;
        Fri, 25 Sep 2020 14:47:30 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id j11so657446ejk.0;
        Fri, 25 Sep 2020 14:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=LNXPPtSg3XU+Uc6GEQWdTQC/nAKU3Cd17KbO8jJq32o=;
        b=dyvxyyLUZsWO6fdd2JH0Q/fQmVb1Edha+4eI8lIYmoOjleAGTR+mVWKbNKzjLp2jN0
         2uPofKfkNE14Es3wsayFuXbBTLmYpo3rFgwgA0kwUxZXZsCi0Eiy0z7EYYeYgQMbyLLG
         jO/iotzZaMII33twByY+yP3Mm0cOXhAMQ3k2WEG8C3YD5fJ3lijdIiSm3N4gjQCj9Dxh
         +AbxQWhf+L5VaRvIcZ/DuFfyMPX4OBW8MX1fQo5hmSkgnI4CN2NL8T2+McEOl9qojdgn
         TVtPDgCFfMrmgc0eVbhcEoIQynQ3EMZ5SHiVu4i/G0M4DvoDmMARHibofmMl25OKC6xB
         O2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=LNXPPtSg3XU+Uc6GEQWdTQC/nAKU3Cd17KbO8jJq32o=;
        b=QP9lIkcDyrzUEIQxa3HZJ+jNvxEekn3cynef9CwzHeEc8+xmro++qHhCzvL9/lA5Su
         lRrJT53ahA1EUnoZlhImXo/zD6J9UgLe7KLAm1n2VVLp+6Y3Azpn7GIT037hytcgkp+A
         y2Ux5AyYMth3x7xyEj6m0n4LzDJCghRQgEUzjGUEO5AIBosXDiImSyp0J/BiulEh6pQK
         F/B504IJREe61gk/iRuqJumKUshAKZdSUikRFLZrciutCmrJJiowhc7u2NlANzqqStMP
         DNzQgZIIX2CfAo7OTgahmaw7N2OiPMdxbEkKQAxnqNJ/k1mWyP4LiYVpOMoyDb9LRytx
         0UPA==
X-Gm-Message-State: AOAM533shySm1Cz854eQIviDUR7p8BlXzdLZUH/wnfNw9A38ORkteEvU
        kA8x23EA9cighvq2LlTDxEd1V4ZBFNKS2Zp/8WV7gahys/k=
X-Google-Smtp-Source: ABdhPJxKiXd4lq3hiQ8qvxppTfVjCOebvf4SBggMcVu7nbw0kMS5ZaA3KaUQkemsta3ZLvn7wiLEWvbpmfypA+VmI0g=
X-Received: by 2002:a17:906:7b87:: with SMTP id s7mr881895ejo.328.1601070448883;
 Fri, 25 Sep 2020 14:47:28 -0700 (PDT)
MIME-Version: 1.0
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 25 Sep 2020 23:47:18 +0200
Message-ID: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
Subject: RGMII timing calibration (on 12nm Amlogic SoCs) - integration into dwmac-meson8b
To:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@armlinux.org.uk, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Amlogic's 12nm SoC generation requires some RGMII timing calibration
within the Ethernet controller glue registers.
This calibration is only needed for the RGMII modes, not for the
(internal) RMII PHY.
With "incorrect" calibration settings Ethernet speeds up to 100Mbit/s
will still work fine, but no data is flowing on 1Gbit/s connections
(similar to when RX or TX delay settings are incorrect).

A high-level description of this calibration (the full code can be
seen in [0] and [1]):
- there are sixteen possible calibration values: [0..15]
- switch the Ethernet PHY to loopback mode
- for each of the sixteen possible calibration values repeat the
following steps five times:
-- write the value to the calibration register
-- construct an Ethernet loopback test frame with protocol 0x0808
("Frame Relay ARP")
-- add 256 bytes of arbitrary data
-- use the MAC address of the controller as source and destination
-- send out this data packet
-- receive this data packet
-- compare the contents and remember if the data is valid or corrupted
- disable loopback mode on the Ethernet PHY
- find the best calibration value by getting the center point of the
"longest streak"
- write this value to the calibration register

My question is: how do I integrate this into the dwmac-meson8b (stmmac
based) driver?
I already found some interesting and relevant bits:
- stmmac_selftests.c uses phy_loopback() and also constructs data
which is sent-out in loopback mode
- there's a serdes_powerup callback in struct plat_stmmacenet_data
which is called after register_netdev()
- I'm not sure if there's any other Ethernet driver doing some similar
calibration (and therefore a way to avoid some code-duplication)


Any recommendations/suggestions/ideas/hints are welcome!
Thank you and best regards,
Martin


[0] https://github.com/khadas/u-boot/blob/4752efbb90b7d048a81760c67f8c826f14baf41c/drivers/net/designware.c#L707
[1] https://github.com/khadas/linux/blob/khadas-vims-4.9.y/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c#L466
