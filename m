Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3D569FFCC
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjBVXzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjBVXzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:55:13 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E171B4391C;
        Wed, 22 Feb 2023 15:55:11 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 00F8485A82;
        Thu, 23 Feb 2023 00:55:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1677110109;
        bh=TKTf73WYmzTA45thd2KHDxz2JA2t3rNMYMj2kwLqvPY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=r9SV4goeKmoqXafR4ASHPCeqg5l/F6oYu1TT0dXuTKZwwdrSAiH938pWY5WvDxUQ2
         8FryRnRp5lF9vMh7Fj2x3RwT4xz1yiGXplQ/VTPO7VuKV6Nxsv6wxm++wmUsLcJomw
         ilVNICh4QalMdJUJX5wBbDkZvnO7MOa60FCmUW/8hgTAAaMHuRV1vC4dL0V0bfNo/B
         MRtv5oq1hjVOBJm/k8yS3w36zb3yipQxpuKdbxL644fwkkwes+GWbUXyuEELimzH1k
         58Ff+DBsBPh6pCkx6ZF/vIUE7Jv4gD9HSUOQl9O0Cs6jqh/PoOF/pfyHRrZmMmyQ87
         2Gy97lBI8fmYA==
Message-ID: <35a4df8a-7178-20de-f433-e2c01e5eaaf7@denx.de>
Date:   Thu, 23 Feb 2023 00:55:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function for
 KSZ87xx
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
References: <20230222031738.189025-1-marex@denx.de>
 <20230222210853.pilycwhhwmf7csku@skbuf>
 <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
 <20230222223141.ozeis33beq5wpkfy@skbuf>
 <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
 <20230222232112.v7gokdmr34ii2lgt@skbuf>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20230222232112.v7gokdmr34ii2lgt@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/23 00:21, Vladimir Oltean wrote:

[...]

, and I really have nothing else to base my judgement
> on, than your hint that there is a bug there, and the code. But the
> driver might behave in much more subtle ways which I may be completely
> missing, and I may think that I'm fixing something when I'm not. I have
> no way to know that except by booting a board, which I do not have (but
> you do).

The old code, removed in:
c476bede4b0f0 ("net: dsa: microchip: ksz8795: use common xmii function")
used ksz_write8() (this part is important):
ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
where:
drivers/net/dsa/microchip/ksz8795_reg.h:#define REG_PORT_5_CTRL_6 
        0x56

The new code, where the relevant part is added in (see Fixes tag)
46f80fa8981bc ("net: dsa: microchip: add common gigabit set and get 
function")
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -257,6 +257,7 @@ static const u16 ksz8795_regs[] = {
+       [P_XMII_CTRL_1]                 = 0x56,
uses ksz_pwrite8() (with p in the function name, p means PORT):
ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
which per drivers/net/dsa/microchip/ksz_common.h translates to
ksz_write8(dev, dev->dev_ops->get_port_addr(port, offset), data);
and that dev->dev_ops->get_port_addr(port, offset) remapping function is 
per drivers/net/dsa/microchip/ksz8795.c really call to the following macro:
PORT_CTRL_ADDR(port, offset)
which in turn from drivers/net/dsa/microchip/ksz8795_reg.h becomes
#define PORT_CTRL_ADDR(port, addr)
((addr) + REG_PORT_1_CTRL_0 + (port) * (REG_PORT_2_CTRL_0 - 
REG_PORT_1_CTRL_0))

That means:
ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8)
writes register 0xa6 instead of register 0x56, because it calls the 
PORT_CTRL_ADDR(port, 0x56)=0xa6, but in reality it should call 
PORT_CTRL_ADDR(port, 0x06)=0x56, i.e. the remapping should happen ONCE, 
the value 0x56 is already remapped .

All the call-sites which do
ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8)
or
ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8)
are affected by this, all six, that means the ksz_[gs]et_xmii() and the 
ksz_[gs]et_gbit().

...

If all that should be changed in the commit message is "to access the 
P_GMII_1GBIT_M, i.e. Is_1Gbps, bit" to something from the 
"ksz_set_xmii()" function instead, then just say so.

[...]
