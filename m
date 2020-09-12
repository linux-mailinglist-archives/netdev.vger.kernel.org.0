Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117B72676E0
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgILAoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgILAoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:44:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E86C061573;
        Fri, 11 Sep 2020 17:44:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 515A112354CAB;
        Fri, 11 Sep 2020 17:27:14 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:44:00 -0700 (PDT)
Message-Id: <20200911.174400.306709791543819081.davem@davemloft.net>
To:     geert@linux-m68k.org
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        kuba@kernel.org, gaku.inami.xh@renesas.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdUd4VtpOGr26KAmF22N32obNqQzq3tbcPxLJ7mxUtSyrg@mail.gmail.com>
References: <20200901150237.15302-1-geert+renesas@glider.be>
        <20200910.122033.2205909020498878557.davem@davemloft.net>
        <CAMuHMdUd4VtpOGr26KAmF22N32obNqQzq3tbcPxLJ7mxUtSyrg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:27:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 11 Sep 2020 08:32:55 +0200

> Hi David,
> 
> On Thu, Sep 10, 2020 at 9:20 PM David Miller <davem@davemloft.net> wrote:
>> From: Geert Uytterhoeven <geert+renesas@glider.be>
>> Date: Tue,  1 Sep 2020 17:02:37 +0200
>>
>> > This reverts commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c.
>> >
>> > Inami-san reported that this commit breaks bridge support in a Xen
>> > environment, and that reverting it fixes this.
>> >
>> > During system resume, bridge ports are no longer enabled, as that relies
>> > on the receipt of the NETDEV_CHANGE notification.  This notification is
>> > not sent, as netdev_state_change() is no longer called.
>> >
>> > Note that the condition this commit intended to fix never existed
>> > upstream, as the patch triggering it and referenced in the commit was
>> > never applied upstream.  Hence I can confirm s2ram on r8a73a4/ape6evm
>> > and sh73a0/kzm9g works fine before/after this revert.
>> >
>> > Reported-by Gaku Inami <gaku.inami.xh@renesas.com>
>> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>
>> Maybe you cannot reproduce it, but the problem is there and it still
>> looks very real to me.
>>
>> netdev_state_change() does two things:
>>
>> 1) Emit the NETDEV_CHANGE notification
>>
>> 2) Emit an rtmsg_ifinfo() netlink message, which in turn tries to access
>>    the device statistics via ->ndo_get_stats*().
>>
>> It is absolutely wrong to do #2 when netif_device_present() is false.
>>
>> So I cannot apply this patch as-is, sorry.
> 
> Thanks a lot for looking into this!
> 
> But doing #1 is still safe?  That is the part that calls into the bridge
> code.  So would moving the netif_device_present() check from
> linkwatch_do_dev() to netdev_state_change(), to prevent doing #2, be
> acceptable?

I have a better question.  Why is a software device like the bridge,
that wants to effectively exist and still receive netdev event
notifications, marking itself as not present?

That's seems like the real bug here.
