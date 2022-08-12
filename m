Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23796591354
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbiHLPyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiHLPym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:54:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70DA9F0CE;
        Fri, 12 Aug 2022 08:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pXdrFXjywfaStbc9howI1PB99kMV6m7M3ckGQvwmf8c=; b=mn648VQHtm3hZsyORlo/+PMv7G
        TLxeyDiskZqCB9pDQk5ZZt4adVUGmkxAs72rsysgFpzE5k7z8sxlmZnjCukcUA4C49/Fq/Ciw3AMw
        nABRfena85qrxerhmwxEK7WWNdgXR8lnWgzRjOl3wzXTQWSbLcPZja9/LQF+zLXfcbbo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oMWzZ-00D8zA-5L; Fri, 12 Aug 2022 17:54:33 +0200
Date:   Fri, 12 Aug 2022 17:54:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kishon@ti.com,
        vigneshr@ti.com
Subject: Re: [PATCH v2 net-next] net: ethernet: ti: davinci_mdio: Add
 workaround for errata i2329
Message-ID: <YvZ3uc0xi18C1g5t@lunn.ch>
References: <20220810111345.31200-1-r-gunasekaran@ti.com>
 <YvRNpAdG7/edUEc+@lunn.ch>
 <9d17ab9f-1679-4af1-f85c-a538cb330d7b@ti.com>
 <YvT8ovgHz2j7yOQP@lunn.ch>
 <ed3554bc-af62-78ce-a3eb-ff5f27ade6a2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed3554bc-af62-78ce-a3eb-ff5f27ade6a2@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> sh_eth is not configured for autosuspend and uses only pm_runtime_put().

I don't know the runtime power management code very well. We should
probably ask somebody how does. However:

https://elixir.bootlin.com/linux/latest/source/drivers/base/power/runtime.c#L168

This suggests it should be safe to perform an auto suspend on a device
which is not configured for auto suspend. To me, it looks like is
should directly suspend.

Devices are in a tree. If you suspend a leaf, you can walk up the tree
and suspend its parent as well, if it is not needed. Similarly, if you
wake a leaf, you need its parents awake as well, so you need to walk
up the tree and wake them. In order for this to work reliably, i
expect runtime PM to be very tolerant. If a device is not configured
for runtime PM, actions should be a NOP. If it is not configured for
auto suspend, and you ask it to auto suspend, to me, it would make
sense for it to immediately suspend, etc.

> Please provide your views on this. Your inputs on the next course of action
> would be helpful.

I would suggest you talk to somebody who knows about runtime PM.

  Andrew
