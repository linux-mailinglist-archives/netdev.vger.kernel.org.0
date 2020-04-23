Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569761B6481
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgDWTd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728308AbgDWTd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:33:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB80C09B042;
        Thu, 23 Apr 2020 12:33:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA79412776892;
        Thu, 23 Apr 2020 12:33:55 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:33:55 -0700 (PDT)
Message-Id: <20200423.123355.1116107619410931438.davem@davemloft.net>
To:     bloodyreaper@yandex.ru
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, hauke@hauke-m.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, sean.wang@mediatek.com,
        matthias.bgg@gmail.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, linus.walleij@linaro.org,
        p.zabel@pengutronix.de, linux@armlinux.org.uk,
        linux@rempel-privat.de, maowenan@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 net-next] net: dsa: add GRO support via gro_cells
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421134108.167646-1-bloodyreaper@yandex.ru>
References: <20200421134108.167646-1-bloodyreaper@yandex.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:33:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <bloodyreaper@yandex.ru>
Date: Tue, 21 Apr 2020 16:41:08 +0300

> gro_cells lib is used by different encapsulating netdevices, such as
> geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
> CPU tag is a sort of "encapsulation", and we can use the same mechs to
> greatly improve overall DSA performance.
> skbs are passed to the GRO layer after removing CPU tags, so we don't
> need any new packet offload types as it was firstly proposed by me in
> the first GRO-over-DSA variant [1].
> 
> The size of struct gro_cells is sizeof(void *), so hot struct
> dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
> remain in one 32-byte cacheline.
> The other positive side effect is that drivers for network devices
> that can be shipped as CPU ports of DSA-driven switches can now use
> napi_gro_frags() to pass skbs to kernel. Packets built that way are
> completely non-linear and are likely being dropped without GRO.
> 
> This was tested on to-be-mainlined-soon Ethernet driver that uses
> napi_gro_frags(), and the overall performance was on par with the
> variant from [1], sometimes even better due to minimal overhead.
> net.core.gro_normal_batch tuning may help to push it to the limit
> on particular setups and platforms.
> 
> iperf3 IPoE VLAN NAT TCP forwarding (port1.218 -> port0) setup
> on 1.2 GHz MIPS board:
 ...
> v2:
>  - Add some performance examples in the commit message;
>  - No functional changes.
> 
> [1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/
> 
> Signed-off-by: Alexander Lobakin <bloodyreaper@yandex.ru>

Applied, thank you.
