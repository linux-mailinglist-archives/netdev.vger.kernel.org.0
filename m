Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DCC690F87
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjBIRsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjBIRsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:48:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB1A5ACD7;
        Thu,  9 Feb 2023 09:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75539B82276;
        Thu,  9 Feb 2023 17:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0166C433D2;
        Thu,  9 Feb 2023 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675964907;
        bh=poOKlX4MbdF6+3xNT4GvSbOQWpeoN76zsGscqHu3gkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ATH7FtfQPfkq6DisDg9o044zT/5LdCby6q0kDxXHByIQsdQlAzn6lKKDhCn2bMw7K
         Qrpm1za+VDUR+KChDmNZjBesVO75nZBwmET+pCw4N5Iyh+XAkTjt9Z5EGzdYySaMcv
         UdffDldmpC7lbPsm8TlOCdNgdEgujITWPqMEvlEAJ1YHEspgwf1Uh5H3zei+S1h478
         gsRpYdP/xxJHTlEdYYvRGXG6/L3pv2d0/Nc9zeTX8k6P+nRXCjeGe1HmkXGAqpSsp0
         ndN6gkAOM2oW5xPhes367IrFAYwg0/3bqIvsNAdvdHH8kGGk55MD5IWJ0OEBD3bIjR
         LY5jjlce6Pf3w==
Date:   Thu, 9 Feb 2023 09:48:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <heiko.thiery@gmail.com>, <Claudiu.Beznea@microchip.com>,
        <kvalo@kernel.org>, <linux-wireless@vger.kernel.org>,
        <michael@walle.cc>, <netdev@vger.kernel.org>,
        <Amisha.Patel@microchip.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
Message-ID: <20230209094825.49f59208@kernel.org>
In-Reply-To: <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
        <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Feb 2023 17:15:38 +0000 Ajay.Kathat@microchip.com wrote:
> IIUC network manager(NM) is trying to read the MAC address and write the
> same back to wilc1000 module without making the wlan0 interface up. right?
> 
> Not sure about the requirement but if NM has a valid MAC address to
> assign to the wlan0 interface, it can be configured without making
> interface up("wlan0 up"). "ip link set dev wlan0 address XX:XX:XX:XX:XX"
> command should allow to set the mac address without making the interface
> up.
> Once the mac address is set, the wilc1000 will use that mac address [1]
> instead of the one from wilc1000 NV memory until reboot. However, after
> a reboot, if no MAC address is configured from application then wilc1000
> will use the address from its NV memory.

netdev should be created with a valid lladdr, is there something
wifi-specific here that'd prevalent that? The canonical flow is
to this before registering the netdev:

  err = read_mac_from_nv();
  if (err || !is_valid_ether_addr())
    eth_hw_addr_random()
