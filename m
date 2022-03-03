Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126A94CC207
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 16:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiCCP63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 10:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiCCP61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 10:58:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546186A01F;
        Thu,  3 Mar 2022 07:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6F3F60B72;
        Thu,  3 Mar 2022 15:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA0BC004E1;
        Thu,  3 Mar 2022 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646323060;
        bh=AGTqhOR2k6S5BrHAXZy3xKDnEl+hWFEWK+v445W6Owg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K5k9cHSZwbuC0NR2NKY97Z2+kJvNh5Ckm5ZnO/Yj+Nw8YDaRpzPDE/HaO1o7m9rmx
         R0PrUrLC6kYG8o0P+Kkyv/2rUq1k4wOZg5+5GY2jBauV2Q7tVzuaLR2JVyv3NAtZBj
         tvLl3ROKh13tM8g6iZflYU+1ZAXHABQas3bQEwV1goQU+M/GsZxn0AC923FcBHBhf7
         YAICgnZ/ZeYD5JTIu+35b9GIGaTUjBFQnDX1qRJI8NSSdIVwTjb2TdwhUgQRvxhm/A
         G0JWBzn+fIj5RyCE2CpVfcrbyMcpEijIulIS5DfYiFq4G0StWbmoGRP/LOI8IN3YQr
         v21Zw5lOtMdcA==
Date:   Thu, 3 Mar 2022 07:57:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] net: macb: Use-After-Free when removing the module
Message-ID: <20220303075738.56a90b79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAMhUBjkt1E4gQ5-sgAfPvKqNrfXBFUQ14zRP=MWPwfhZJu3QPA@mail.gmail.com>
References: <CAMhUBjkt1E4gQ5-sgAfPvKqNrfXBFUQ14zRP=MWPwfhZJu3QPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Mar 2022 20:24:53 +0800 Zheyu Ma wrote:
> When removing the macb_pci module, the driver will cause a UAF bug.
> 
> Commit d82d5303c4c5 ("net: macb: fix use after free on rmmod") moves
> the platform_device_unregister() after clk_unregister(), but this
> introduces another UAF bug.

The layering is all weird here. macb_probe() should allocate a private
structure for the _PCI driver_ which it can then attach to 
struct pci_dev *pdev as driver data. Then free it in remove.
It shouldn't stuff its information into the platform device.

Are you willing to send a fix like that?
