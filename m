Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4143B50CB15
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbiDWOK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiDWOK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:10:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A7864EC;
        Sat, 23 Apr 2022 07:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K1RdN0IHw/hgnmVi3+t0E+vBxXu9gcHVwhe48+n+33w=; b=d2BJ9BzoDtMN8UqfRDHRhhSH+H
        sfBXMYuckP30oHkWAlDAybkQPYarztSGoGdduxeuFPE/Hp3pg2H/sgEKrnxKMuJt3XIWv5b8fqcYu
        HCUTh5eMwePkaSVSt56dEc+8GKkKi0nLBBNOUc3l6DhNFjEpyvQWja4kfT3HIzYS+EmI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1niGQ1-00H946-Iz; Sat, 23 Apr 2022 16:07:25 +0200
Date:   Sat, 23 Apr 2022 16:07:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Handle single-chip-address OF
 property
Message-ID: <YmQIHWL4iTS5qVIz@lunn.ch>
References: <20220423131427.237160-1-nathan@nathanrossi.com>
 <20220423131427.237160-2-nathan@nathanrossi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423131427.237160-2-nathan@nathanrossi.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 01:14:27PM +0000, Nathan Rossi wrote:
> Handle the parsing and use of single chip addressing when the switch has
> the single-chip-address property defined. This allows for specifying the
> switch as using single chip addressing even when mdio address 0 is used
> by another device on the bus. This is a feature of some switches (e.g.
> the MV88E6341/MV88E6141) where the switch shares the bus only responding
> to the higher 16 addresses.

Hi Nathan

I think i'm missing something in this explanation:

smi.c says:

/* The switch ADDR[4:1] configuration pins define the chip SMI device address
 * (ADDR[0] is always zero, thus only even SMI addresses can be strapped).
 *
 * When ADDR is all zero, the chip uses Single-chip Addressing Mode, assuming it
 * is the only device connected to the SMI master. In this mode it responds to
 * all 32 possible SMI addresses, and thus maps directly the internal devices.
 *
 * When ADDR is non-zero, the chip uses Multi-chip Addressing Mode, allowing
 * multiple devices to share the SMI interface. In this mode it responds to only
 * 2 registers, used to indirectly access the internal SMI devices.
 *
 * Some chips use a different scheme: Only the ADDR4 pin is used for
 * configuration, and the device responds to 16 of the 32 SMI
 * addresses, allowing two to coexist on the same SMI interface.
 */

So if ADDR = 0, it takes up the whole bus. And in this case reg = 0.
If ADDR != 0, it is in multi chip mode, and DT reg = ADDR.

int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
                       struct mii_bus *bus, int sw_addr)
{
        if (chip->info->dual_chip)
                chip->smi_ops = &mv88e6xxx_smi_dual_direct_ops;
        else if (sw_addr == 0)
                chip->smi_ops = &mv88e6xxx_smi_direct_ops;
        else if (chip->info->multi_chip)
                chip->smi_ops = &mv88e6xxx_smi_indirect_ops;
        else
                return -EINVAL;

This seems to implement what is above. smi_direct_ops == whole bus,
smi_indirect_ops == multi-chip mode.

In what situation do you see this not working? What device are you
using, what does you DT look like, and what at the ADDR value?

Thanks
	Andrew
