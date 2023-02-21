Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C8369D7AF
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjBUAry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbjBUArx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:47:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FA159F1
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 16:47:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9066B8085C
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 00:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E808C4339B;
        Tue, 21 Feb 2023 00:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940468;
        bh=KYdvlnanYiyHjZjpIlq6zF7WfZGeB9v3Fm9Kwwq3k/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fruFGj7c9twEgximtIRHYx7zZ8xwsbhX0jCjrqXM5ZmWu2hizA5YHdLkwWuDSFfGE
         +FWVbbTeZhh9eafRoJX+F7Hd8L/a/oI2OMU0Tf+b7scorDLIpwu2y5RCWCtCNrAqLx
         t3QWUVLDqTjVp+seEEk1Kqll/uiM+8I8pMzlB6H9/O6Te7+Xf8yd60j9QOd8235Nwu
         Y8iNFLFoU3bC2HSa9wKpGgLAoTPmkQcuR4SFH0cP1rZhxYqyJJ+kiguUHELKZ0scV/
         TXLJkwbYD432ha6MzjKc0TGAQ8fVKuYHJcBLPXRP6Sj8o7IDhredxJEU0ez/GaYAYu
         wRxIAp6jdfDSA==
Date:   Mon, 20 Feb 2023 16:47:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        pabeni@redhat.com, robh+dt@kernel.org, krzk+dt@kernel.org,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v3] net: dsa: realtek: rtl8365mb: add
 change_mtu
Message-ID: <20230220164746.7764ec33@kernel.org>
In-Reply-To: <20230218230636.5528-1-luizluca@gmail.com>
References: <20230218230636.5528-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Feb 2023 20:06:37 -0300 Luiz Angelo Daros de Luca wrote:
> The rtl8365mb was using a fixed MTU size of 1536, which was probably
> inspired by the rtl8366rb's initial packet size. However, unlike that
> family, the rtl8365mb family can specify the max packet size in bytes,
> rather than in fixed steps. The max packet size now defaults to
> VLAN_ETH_HLEN+ETH_DATA_LEN+ETH_FCS_LEN, which is 1522 bytes.
> 
> DSA calls change_mtu for the CPU port once the max MTU value among the
> ports changes. As the max packet size is defined globally, the switch
> is configured only when the call affects the CPU port.
> 
> The available specifications do not directly define the max supported
> packet size, but it mentions a 16k limit. This driver will use the 0x3FFF
> limit as it is used in the vendor API code. However, the switch sets the
> max packet size to 16368 bytes (0x3FF0) after it resets.
> 
> change_mtu uses MTU size, or ethernet payload size, while the switch
> works with frame size. The frame size is calculated considering the
> ethernet header (14 bytes), a possible 802.1Q tag (4 bytes), the payload
> size (MTU), and the Ethernet FCS (4 bytes). The CPU tag (8 bytes) is
> consumed before the switch enforces the limit.
> 
> MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
> (where rtl8367s is stacked) can go. The register was manually
> manipulated byte-by-byte to ensure the MTU to frame size conversion was
> correct. For frames without 802.1Q tag, the frame size limit will be 4
> bytes over the required size.
> 
> There is a jumbo register, enabled by default at 6k packet size.
> However, the jumbo settings do not seem to limit nor expand the maximum
> tested MTU (2018), even when jumbo is disabled. More tests are needed
> with a device that can handle larger frames.

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.
