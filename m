Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4730F270881
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgIRVrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgIRVrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:47:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDE4C0613CE;
        Fri, 18 Sep 2020 14:47:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8857A15A01A79;
        Fri, 18 Sep 2020 14:30:35 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:47:21 -0700 (PDT)
Message-Id: <20200918.144721.348413288598834487.davem@davemloft.net>
To:     nikolay@nvidia.com
Cc:     geert@linux-m68k.org, andrew@lunn.ch,
        bridge@lists.linux-foundation.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com,
        gaku.inami.xh@renesas.com, roopa@nvidia.com, f.fainelli@gmail.com
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9ab2973de2c0fb32de7fbc4ae823a820cd48a769.camel@nvidia.com>
References: <20200912.183437.1205152743307947529.davem@davemloft.net>
        <CAMuHMdXGmKYKWtkFCV0WmYnY4Gn--Bbz-iSX76oc-UNNrzCMuw@mail.gmail.com>
        <9ab2973de2c0fb32de7fbc4ae823a820cd48a769.camel@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:30:36 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>
Date: Fri, 18 Sep 2020 12:35:02 +0000

> Thanks for the analysis, I don't see any issues with checking if the device
> isn't present. It will have to go through some testing, but no obvious
> objections/issues. Have you tried if it fixes your case?
> I have briefly gone over drivers' use of net_device_detach(), mostly it's used
> for suspends, but there are a few cases which use it on IO error or when a
> device is actually detaching (VF detach). The vlan port event is for vlan
> devices on top of the bridge when BROPT_VLAN_BRIDGE_BINDING is enabled and their
> carrier is changed based on vlan participating ports' state.

There are two things to resolve:

1) Why does the bridge need to get a change event for devices which have
   not fully resumed yet?

2) What kind of link state change is happening on devices which are not
   currently fully resumed yet?

Really this whole situation is still quite mysterious to me.

If the driver (or the PHY library it is using, etc.) is emitting link
state changes before it marks itself as "present", that's the real
bug.
