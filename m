Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84450598A5E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbiHRRZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345396AbiHRRZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:25:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274CB5303E;
        Thu, 18 Aug 2022 10:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADFB8B822AF;
        Thu, 18 Aug 2022 17:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC51C433C1;
        Thu, 18 Aug 2022 17:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660843484;
        bh=2/qTlGQln3Nv+8rAcrymTWvvaveGe+xOUXTae4CDc0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lc6jiokWVQbHT7gAI0h0qGY+PfPKmB2tBwAlvYLce0tJMtopKk6+66z/RFIxfztRo
         Q6/YwhwihLhSKRlbgtOs4o/VhAd+1nujEd9Bty8CwEBMsg7QPPY+V859CHPsOi7YrK
         LooJdkyuK52sa/pvMmywj9PazyAbJvezQQgoxdV6HjbsvM/A6be7WeUi4uOKEaB3Te
         ZuBy7dmDkFtXQEy0eYIWo2Iv4X+3c6T4vxY2soCjtFcAqwWCLzX1YOaxkaaZqaKd6j
         DUme5Wk9YFcvOicHhgBne9Q7j2ug5HfcG1SYizh7QVKevCinLpX5J/vo2Lb3eGfLJK
         c2QH91Nm1B5Dw==
Date:   Thu, 18 Aug 2022 10:24:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: phy: Warn if phy is attached when removing
Message-ID: <20220818102443.4c7c50e8@kernel.org>
In-Reply-To: <20220816163701.1578850-1-sean.anderson@seco.com>
References: <20220816163701.1578850-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 12:37:01 -0400 Sean Anderson wrote:
> netdevs using phylib can be oopsed from userspace in the following
> manner:
> 
> $ ip link set $iface up
> $ echo $(basename $(readlink /sys/class/net/$iface/phydev)) > \
>       /sys/class/net/$iface/phydev/driver/unbind
> $ ip link set $iface down
> 
> However, the traceback provided is a bit too late, since it does not
> capture the root of the problem (unbinding the driver). It's also
> possible that the memory has been reallocated if sufficient time passes
> between when the phy is detached and when the netdev touches the phy
> (which could result in silent memory corruption). Add a warning at the
> source of the problem. A future patch could make this more robust by
> calling dev_close.

Hm, so we're adding the warning to get more detailed reports "from the
field"? Guess we've all done that, so fair.

Acks? It can still make -rc2 if that matters...
