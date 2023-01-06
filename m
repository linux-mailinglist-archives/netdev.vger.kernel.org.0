Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC15665FD4B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjAFJHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 04:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjAFJHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 04:07:30 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5581C42E;
        Fri,  6 Jan 2023 01:07:29 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id BD12C11FB;
        Fri,  6 Jan 2023 10:07:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672996047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/N9bFhFvobzsxRElHamLqc2QSzr6u1r8qJYQ1cDHWs=;
        b=OODeHX4+Fne2I9M3Ccj5dHUWATFgG/aLXyDmh8ECSxscD0O8FfLYSvxDCuqmtctdZlZfrI
        l0u0Y/l4eTU06lHziwX9q2KsUqecQPdMUtji3mWNP8QosRd3AfdjcoN2Rp5vrPksMI8TJX
        +k7sBr/igIPm0iigwUsrhKUwsKXKaTBFgFeo/9gJFXOsBHAjBMB9zxB/MYZVNDJXY2DqZ7
        Vo9CycD6DWFT4/0fvertQrb/KY9cMfFA1gNyGrS1UGgiR7Y4haw+//eqLA6kcNRIaYuhC3
        QObe1TMR3iyumZpXOREXMU9vPiqWYpP3KPt/VlXLUKeXvenE6BH+elLE1oM3WQ==
MIME-Version: 1.0
Date:   Fri, 06 Jan 2023 10:07:27 +0100
From:   Michael Walle <michael@walle.cc>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net-next v2 0/8] Add support for two classes of VCAP rules
In-Reply-To: <20230106085317.1720282-1-steen.hegelund@microchip.com>
References: <20230106085317.1720282-1-steen.hegelund@microchip.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <35a9ff9fa0980e1e8542d338c6bf1e0c@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

thanks for adding me on CC :) I was just about to reply on your v1.

Am 2023-01-06 09:53, schrieb Steen Hegelund:
> This adds support for two classes of VCAP rules:
> 
> - Permanent rules (added e.g. for PTP support)
> - TC user rules (added by the TC userspace tool)
> 
> For this to work the VCAP Loopups must be enabled from boot, so that 
> the
> "internal" clients like PTP can add rules that are always active.
> 
> When the TC tool add a flower filter the VCAP rule corresponding to 
> this
> filter will be disabled (kept in memory) until a TC matchall filter 
> creates
> a link from chain 0 to the chain (lookup) where the flower filter was
> added.
> 
> When the flower filter is enabled it will be written to the appropriate
> VCAP lookup and become active in HW.
> 
> Likewise the flower filter will be disabled if there is no link from 
> chain
> 0 to the chain of the filter (lookup), and when that happens the
> corresponding VCAP rule will be read from the VCAP instance and stored 
> in
> memory until it is deleted or enabled again.

I've just done a very quick smoke test and looked at my lan9668 board
that the following error isn't printed anymore. No functional testing.
   vcap_val_rule:1678: keyset was not updated: -22

And it is indeed gone. But I have a few questions regarding how these
patches are applied. They were first sent for net, but now due to
a remark that they are too invasive they are targeted at net-next.
But they have a Fixes: tag. Won't they be eventually backported to
later kernels in any case? What's the difference between net and
net-next then?

Also patches 3-8 (the one with the fixes tags) don't apply without
patch 1-2 (which don't have fixes tags). IMHO they should be
reordered.

Wouldn't it make more sense, to fix the regression via net (and
a Fixes: tag) and then make that stuff work without tc? Maybe
the fix is just reverting the commits.

-michael
