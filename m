Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9916EE4D5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbjDYPft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbjDYPfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:35:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A79A5F5;
        Tue, 25 Apr 2023 08:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EFA462665;
        Tue, 25 Apr 2023 15:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEE2C433D2;
        Tue, 25 Apr 2023 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682436946;
        bh=hILIa7zfeQHX44WHpp5lx3LYz44LYIo0k8gq7ws9Zcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AbDep0f8nsEPf7I2neZ1pcGQ28Xvmcbo8BCOjn5/gOuRbHDPHnxOwa4ntawlUOn6k
         B+trDdCn3xuAVLnqrrJ7U4/M7Pl/xesMF2M1V+o9330bPe3Ful16dpRrH5rB4Wc5g2
         Bi5k2hX9zvXPAQMH3okBg//H4XeI/5ypSEYav9lu9QE9/bre4Jb9Bq8L5NG2b+/9zk
         j5hjVvm1+dOT2serxNr6YBU6gcBXwG+CPN7kAH4xGxFDk5G2/c1kiZPg1HLOb6gG5e
         ruw4X4kGRtdl9f2D1oOkVToEu34xxWBsud4xfyvRb82E3IagO0BU7udfn8uzwYmp95
         75o6Qrjg1Jmiw==
Date:   Tue, 25 Apr 2023 08:35:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com,
        =?UTF-8?B?QXI=?= =?UTF-8?B?xLFuw6cgw5xOQUw=?= 
        <arinc.unal@arinc9.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 00/24] net: dsa: MT7530, MT7531, and MT7988
 improvements
Message-ID: <20230425083544.537538ba@kernel.org>
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 11:29:09 +0300 arinc9.unal@gmail.com wrote:
> This patch series is focused on simplifying the code, and improving the
> logic of the support for MT7530, MT7531, and MT7988 SoC switches.
> 
> There're two fixes. One for fixing the corrupt frames using trgmii on MCM
> MT7530 with 40 MHz oscillator on certain MT7621 SoCs. The other for fixing
> the port capabilities of the switch on the MT7988 SoC.

## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.
-- 
pw-bot: defer
