Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA876B1BBD
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 07:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCIGqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 01:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjCIGqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 01:46:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FCADAB87
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 22:46:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E99DB81269
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE81BC4339B;
        Thu,  9 Mar 2023 06:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678344330;
        bh=XDIh6d1QlVKe6a79qx6VXbfXzGLJYEfIeATjFdSlvHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vHmfxW00retHhM4xn7xuozVq4Qqath8vSShYvRUPnsGqv5C3XOfnrC4t9JQ51/Fvy
         TVYJ78rYRY9SXRei091oUuh27OPfC5jHUIeYFOsmzB/8jKiOsQXcaQfu/pRHB5Amvj
         uxivRI8W9o+Y92bXGXcOMZb3Q4bgLpW2faC6V9t80fF0r3nCPrScuVRKHMVgwYEFL6
         Egav00GQY1HO4b6jjge1RriWZjIBLcDcEQLyyyCcGafYhO9O5aWT+Sc6aldROPNOPG
         GOeZd1Rzj6/EuBfuzEW4PHnCtzy0fH8OiNKjd8O5NfYQXzKc8hq68eBHuPsZi5RIxG
         RcmCjft0+wgWQ==
Date:   Wed, 8 Mar 2023 22:45:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net-next v4] net: dsa: realtek: rtl8365mb: add
 change_mtu
Message-ID: <20230308224529.10674df1@kernel.org>
In-Reply-To: <CAJq09z7U75Qe_oW3vbNmG=QaKFQW_zuFyNqjg0HAPPHh3t71Qg@mail.gmail.com>
References: <20230307210245.542-1-luizluca@gmail.com>
        <ZAh5ocHELAK9PSux@corigine.com>
        <CAJq09z7U75Qe_oW3vbNmG=QaKFQW_zuFyNqjg0HAPPHh3t71Qg@mail.gmail.com>
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

On Wed, 8 Mar 2023 14:10:59 -0300 Luiz Angelo Daros de Luca wrote:
> > Perhaps I am misreading this, perhaps it was discussed elsewhere (I did
> > look), and perhaps it's not important. But prior to this
> > patch a value of 1536 is used. Whereas with this patch the
> > value, calculated in rtl8365mb_port_change_mtu, is
> > ETH_DATA_LEN + VLAN_ETH_HLEN + ETH_FCS_LEN = 1500 + 18 + 4 = 1522.  
> 
> That value, as mentioned in the commit message, probably came from
> rtl8366rb driver jumbo frame settings.
> The "rtl8366rb family" has 4 levels of jumbo frame size:
> 
> #define RTL8366RB_SGCR_MAX_LENGTH_1522          RTL8366RB_SGCR_MAX_LENGTH(0x0)
> #define RTL8366RB_SGCR_MAX_LENGTH_1536          RTL8366RB_SGCR_MAX_LENGTH(0x1)
> #define RTL8366RB_SGCR_MAX_LENGTH_1552          RTL8366RB_SGCR_MAX_LENGTH(0x2)
> #define RTL8366RB_SGCR_MAX_LENGTH_16000         RTL8366RB_SGCR_MAX_LENGTH(0x3)
> 
> The first one might be the sum you did. I don't know what 1536 and
> 1552 are for. However, if those cases increase the MTU as well, the
> code will handle it.
> During my tests, changing those similar values or disabling jumbo
> frames wasn't enough to change the switch behavior. As "rtl8365mb
> family" can control frame size byte by byte, I believe it ignores the
> old jumbo registers.
> 
> The 1522 size is already in use by other drivers. If there is
> something that requires more room without increasing the MTU, like
> QinQ, we would need to add that extra length to the
> rtl8365mb_port_change_mtu formula and not the initial value. If not,
> the switch will have different frame limits when the user leaves the
> default 1500 MTU or when it changes and reverts the MTU size.

Could I trouble you for v5 with some form of this explanation in the
commit message?
