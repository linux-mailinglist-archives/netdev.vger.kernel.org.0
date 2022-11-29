Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9717863B88C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbiK2DID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235190AbiK2DIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:08:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BD6FAE7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 19:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEAC9B8110C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51264C433C1;
        Tue, 29 Nov 2022 03:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669691278;
        bh=Hf1dIojADPf46FAQIbUwbrpFiw4kxu8sUSY22cwuH8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u6rDnQw2/KueLTVk9PrnQb/VmaF54/KqQjAwGK+IKB+ERp86j1QHSwAdFiJF0Exhd
         cHwiHlO3cs8ElLXwQfUJohmkOTNq1vkbd2zTc5sOPB3UwUrbrTj7mAIjF0FSVma+uc
         bnwzpsK4Yk/ThrYW4uB5W/4/9oSWk/gXZfsh+dJ2C3o3AqjJuZLcvijiQgdSlhP+5Q
         QjouJ5aUS1suWUODBPCfLhw5te/0KIw8Pboz2xRJpJRUaP603dIMpjOjV1FrlD/Rqj
         56W+Kr2RjOsVenGrT+wTb6ddutTgv8yYvcbzP46ci3dI+f9r7kifzblUojvpM36ChU
         boeteyiVBLFkg==
Date:   Mon, 28 Nov 2022 19:07:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: enable GRO software interrupt
 coalescing per default
Message-ID: <20221128190757.2e4d92dc@kernel.org>
In-Reply-To: <9d94f2d8-d297-7550-2932-793a34e5efb9@gmail.com>
References: <9d94f2d8-d297-7550-2932-793a34e5efb9@gmail.com>
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

On Sat, 26 Nov 2022 15:07:07 +0100 Heiner Kallweit wrote:
> There are reports about r8169 not reaching full line speed on certain
> systems (e.g. SBC's) with a 2.5Gbps link.
> There was a time when hardware interrupt coalescing was enabled per
> default, but this was changed due to ASPM-related issues on few systems.
> 
> Meanwhile we have sysfs attributes for controlling kind of
> "software interrupt coalescing" on the GRO level. However most distros
> and users don't know about it. So lets set a conservative default for
> both involved parameters. Users can still override the defaults via
> sysfs. Don't enable these settings on the fast ethernet chip versions,
> they are slow enough.
> 
> Even with these conservative setting interrupt load on my 1Gbps test
> system reduced significantly.

Sure, why not. Could you please wrap the init into a helper?
Should help us ensure the params are not wildly different between
drivers and make any later refactoring easier.

Maybe something like:

/**
 * netdev_sw_irq_coalesce_default_on() - enable SW IRQ coalescing by default
 * @dev: netdev to enable the IRQ coalescing on
 * bla bla bla
 */
int netdev_sw_irq_coalesce_default_on(struct net_device *dev)
{
	WARN_ON(dev->reg_state != NETREG_UNREGISTERED);

	dev->gro_flush_timeout = 20000;
	dev->napi_defer_hard_irqs = 1;
}
EXPORT...
