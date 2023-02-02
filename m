Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DE36882F1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbjBBPqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjBBPqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:46:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA92977DD9;
        Thu,  2 Feb 2023 07:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BF3GBvlC/+RSSxBp90Pqw55bNKBsJW82s0xPbbxC8Ow=; b=FR2nOapuJ0SlEF+innoLhrdDvB
        HxY/xDZyhmI9nJVlH/PGIKWzGxmQrHLpgOnNraQmbn16e2p1P3D/XoLwi07kwZxdvpbS4hPGAjVFt
        vvG7xnsqBo1uzGzUvV+fBsoTim06sW5gKBMeR3D3e2SAv/aJUSOgoCzJ7E3QGnkLra+Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNbhU-003uPH-C5; Thu, 02 Feb 2023 16:40:36 +0100
Date:   Thu, 2 Feb 2023 16:40:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 07/11] net: dsa: microchip: lan937x: update
 switch register
Message-ID: <Y9vZdMQgqhaGIcdf@lunn.ch>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-8-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-8-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:26PM +0530, Rakesh Sankaranarayanan wrote:
> Second switch in cascaded connection doesn't have port with macb
> interface. dsa_switch_register returns error if macb interface is
> not up. Due to this reason, second switch in cascaded connection will
> not report error during dsa_switch_register and mib thread work will be
> invoked even if actual switch register is not done. This will lead to
> kernel warning and it can be avoided by checking device tree setup
> status. This will return true only after actual switch register is done.

What i think you need to do is move the code into ksz_setup().

With a D in DSA setup, dsa_switch_register() adds the switch to the
list of switches, and then a check is performed to see if all switches
in the cluster have been registered. If not, it just returns. If all
switches have been registered, it then iterates over all the switches
can calls dsa_switch_ops.setup().

By moving the start of the MIB counter into setup(), it will only be
started once all the switches are present, and it means you don't need
to look at DSA core internal state.

	Andrew
