Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D10336A5FB
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 11:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhDYJJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 05:09:09 -0400
Received: from regular1.263xmail.com ([211.150.70.204]:44786 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhDYJJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 05:09:08 -0400
Received: from localhost (unknown [192.168.167.172])
        by regular1.263xmail.com (Postfix) with ESMTP id 8CD8C610;
        Sun, 25 Apr 2021 17:07:52 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from [172.16.12.8] (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P18451T140670035396352S1619341670916448_;
        Sun, 25 Apr 2021 17:07:51 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <28b8855cf8005ca39a20aeebff46b6d1>
X-RL-SENDER: david.wu@rock-chips.com
X-SENDER: wdc@rock-chips.com
X-LOGIN-NAME: david.wu@rock-chips.com
X-FST-TO: kernel@collabora.com
X-RCPT-COUNT: 10
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
Subject: Re: [PATCH v2 net-next 0/3] net: stmmac: RK3566
To:     Ezequiel Garcia <ezequiel@collabora.com>, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>, kernel@collabora.com
References: <20210421203409.40717-1-ezequiel@collabora.com>
 <ae524a70-7886-27a0-1289-0c3a1c7371bb@rock-chips.com>
 <08e97e0e291aecb218b9ebb8aaa37afead504e1c.camel@collabora.com>
From:   David Wu <david.wu@rock-chips.com>
Message-ID: <84039ea3-711b-dce3-ee00-3a00b3315cf5@rock-chips.com>
Date:   Sun, 25 Apr 2021 17:07:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <08e97e0e291aecb218b9ebb8aaa37afead504e1c.camel@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ezequiel,

在 2021/4/23 下午9:57, Ezequiel Garcia 写道:
> Hi David,
> 
> Thanks a lot for reviewing.
> 
> On Fri, 2021-04-23 at 17:24 +0800, David Wu wrote:
>> Hi Ezequiel,
>>
>> 在 2021/4/22 上午4:34, Ezequiel Garcia 写道:
>>> Now that RK3568 SoC devicetree upstreaming is happening [1],
>>> here's another round for the RK3566 dwmac. There wasn't any clear
>>> consensus on how to implement the two interfaces present
>>> on RK3568, so I decided to drop that and just submit RK3566 for now.
>>>
>>> This has been tested on a Pine64 RK3566 Quartz64 Model B board,
>>> DHCP and iperf are looking good.
>>>
>>> For all the people testing, here's Quartz 64 Model B device tree
>>> snippet:
>>>
>>>           gmac1: ethernet@fe010000 {
>>>                   compatible = "rockchip,rk3566-gmac", "snps,dwmac-4.20a";
>>
>> It is better to use "rockchip,rk3568-gmac" here, "rockchip,rk3566-gmac"
>> is not compatible, 3568 has two gmacs, which are compatible with 3566.
>>
>> If there is no better way, using bus_id from alias is good, it is a
>> fixed id, and U-Boot also use the id to write MAC address into kernel DTB.
>>
>> plat->bus_id = of_alias_get_id(np, "ethernet");
>>
> 
> This was discussed, see ChenYu's reply. I think the idea
> is considered fragile:
> 
> https://lore.kernel.org/netdev/CAGb2v67ZBR=XDFPeXQc429HNu_dbY__-KN50tvBW44fXMs78_w@mail.gmail.com/
> 
> However, I agree with you about going back to just "rockchip,rk3568-gmac".
> Adding rockchip,rk3566-gmac maybe wasn't a great idea :-)
> 
> The most accepted way forward seems Heiko's proposal of hardcoding the mmio
> addresses to identify each block, as it's done in the DSI driver:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c#n1170
> 
> Would you agree with it?
> 

Yes, I agree.
I also think the alias should be rarely changed. The DSI mmio addresses 
example here can be used for reference, and it seems that it will be 
stronger than alias.

> Thanks!
> Ezequiel
>   
>>>                   reg = <0x0 0xfe010000 0x0 0x10000>;
>>>                   interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
>>>                                <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
>>>                   interrupt-names = "macirq", "eth_wake_irq";
>>>                   rockchip,grf = <&grf>;
>>>                   clocks = <&cru SCLK_GMAC1>, <&cru SCLK_GMAC1_RX_TX>,
>>>                            <&cru SCLK_GMAC1_RX_TX>, <&cru CLK_MAC1_REFOUT>,
>>>                            <&cru ACLK_GMAC1>, <&cru PCLK_GMAC1>,
>>>                            <&cru SCLK_GMAC1_RX_TX>, <&cru CLK_GMAC1_PTP_REF>;
>>>                   clock-names = "stmmaceth", "mac_clk_rx",
>>>                                 "mac_clk_tx", "clk_mac_refout",
>>>                                 "aclk_mac", "pclk_mac",
>>>                                 "clk_mac_speed", "ptp_ref";
>>>                   resets = <&cru SRST_A_GMAC1>;
>>>                   reset-names = "stmmaceth";
>>>
>>>                   snps,mixed-burst;
>>>                   snps,tso;
>>>
>>>                   snps,axi-config = <&gmac1_stmmac_axi_setup>;
>>>                   snps,mtl-rx-config = <&gmac1_mtl_rx_setup>;
>>>                   snps,mtl-tx-config = <&gmac1_mtl_tx_setup>;
>>>                   status = "disabled";
>>>
>>>                   mdio1: mdio {
>>>                           compatible = "snps,dwmac-mdio";
>>>                           #address-cells = <0x1>;
>>>                           #size-cells = <0x0>;
>>>                   };
>>>
>>>                   gmac1_stmmac_axi_setup: stmmac-axi-config {
>>>                           snps,wr_osr_lmt = <4>;
>>>                           snps,rd_osr_lmt = <8>;
>>>                           snps,blen = <0 0 0 0 16 8 4>;
>>>                   };
>>>
>>>                   gmac1_mtl_rx_setup: rx-queues-config {
>>>                           snps,rx-queues-to-use = <1>;
>>>                           queue0 {};
>>>                   };
>>>
>>>                   gmac1_mtl_tx_setup: tx-queues-config {
>>>                           snps,tx-queues-to-use = <1>;
>>>                           queue0 {};
>>>                   };
>>>           };
>>>
>>> While here, I'm adding a small patch from David Wu, for some
>>> sanity checks for dwmac-rockchip-specific non-NULL ops.
>>>
>>> Thanks!
>>>
>>> [1] http://lore.kernel.org/r/20210421065921.23917-1-cl@rock-chips.com
>>>
>>> David Wu (2):
>>>     net: stmmac: dwmac-rk: Check platform-specific ops
>>>     net: stmmac: Add RK3566 SoC support
>>>
>>> Ezequiel Garcia (1):
>>>     net: stmmac: Don't set has_gmac if has_gmac4 is set
>>>
>>>    .../bindings/net/rockchip-dwmac.txt           |   1 +
>>>    .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 126 +++++++++++++++++-
>>>    2 files changed, 124 insertions(+), 3 deletions(-)
>>>
>>
>>
> 
> 
> 
> 
> 


