Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8BC4FC15
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 16:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfFWOxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 10:53:50 -0400
Received: from www1102.sakura.ne.jp ([219.94.129.142]:14766 "EHLO
        www1102.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWOxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 10:53:50 -0400
X-Greylist: delayed 2309 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2019 10:53:49 EDT
Received: from fsav305.sakura.ne.jp (fsav305.sakura.ne.jp [153.120.85.136])
        by www1102.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x5NEEuE2037688;
        Sun, 23 Jun 2019 23:14:56 +0900 (JST)
        (envelope-from katsuhiro@katsuster.net)
Received: from www1102.sakura.ne.jp (219.94.129.142)
 by fsav305.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav305.sakura.ne.jp);
 Sun, 23 Jun 2019 23:14:55 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav305.sakura.ne.jp)
Received: from [192.168.1.2] (118.153.231.153.ap.dti.ne.jp [153.231.153.118])
        (authenticated bits=0)
        by www1102.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x5NEEtSo037679
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Sun, 23 Jun 2019 23:14:55 +0900 (JST)
        (envelope-from katsuhiro@katsuster.net)
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From:   Katsuhiro Suzuki <katsuhiro@katsuster.net>
Subject: stmmac regression on ASUS TinkerBoard
Message-ID: <8fa9ce79-6aa2-d44d-e24d-09cc1b2b70a3@katsuster.net>
Date:   Sun, 23 Jun 2019 23:14:55 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello stmmac maintainers,

I found this commit and that has some regressions:
   74371272f97f net: stmmac: Convert to phylink and remove phylib logic


My environment is:
   - ASUS TinkerBoard
   - SoC is RK3288
   - Using STMMAC driver
     drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
   - Using this device-tree
     arch/arm/boot/dts/rk3288.dtsi ('gmac: ethernet@ff290000' node)

Current linux-next on my environment, 'ifconfig eth0 up' does not work
correctly with following message...

-----
root@linaro-alip:~# ifconfig eth0 up
[  105.028916] rk_gmac-dwmac ff290000.ethernet eth0: stmmac_open: Cannot 
attach to PHY (error: -19)
SIOCSIFFLAGS: No such device
-----

I checked drivers/net/ethernet/stmicro/stmmac/stmmac_main.c and found
stmmac_init_phy() is going to fail if ethernet device node does not
have following property:
   - phy-handle
   - phy
   - phy-device

This commit broke the device-trees such as TinkerBoard. The mdio
subnode creating a mdio bus is changed to required or still optional?


Best Regards,
Katsuhiro Suzuki
