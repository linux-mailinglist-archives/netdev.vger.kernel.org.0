Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6A324C8ED
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 02:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgHUAAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 20:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgHTX74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:59:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D234C06135B;
        Thu, 20 Aug 2020 16:52:46 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7485128809A4;
        Thu, 20 Aug 2020 16:35:59 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:52:44 -0700 (PDT)
Message-Id: <20200820.165244.540878641387937530.davem@davemloft.net>
To:     ashiduka@fujitsu.com
Cc:     sergei.shtylyov@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3] ravb: Fixed to be able to unload modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820094307.3977-1-ashiduka@fujitsu.com>
References: <20200820094307.3977-1-ashiduka@fujitsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 16:36:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuusuke Ashizuka <ashiduka@fujitsu.com>
Date: Thu, 20 Aug 2020 18:43:07 +0900

> When this driver is built as a module, I cannot rmmod it after insmoding
> it.
> This is because that this driver calls ravb_mdio_init() at the time of
> probe, and module->refcnt is incremented by alloc_mdio_bitbang() called
> after that.
> Therefore, even if ifup is not performed, the driver is in use and rmmod
> cannot be performed.
> 
> $ lsmod
> Module                  Size  Used by
> ravb                   40960  1
> $ rmmod ravb
> rmmod: ERROR: Module ravb is in use
> 
> Call ravb_mdio_init() at open and free_mdio_bitbang() at close, thereby
> rmmod is possible in the ifdown state.
> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
> ---
> Changes in v3:
>  - Update the commit subject and description.
>  - Add Fixes c156633f1353.
>  - Add Reviewed-by Sergei.
>  https://patchwork.kernel.org/patch/11692719/
> 
> Changes in v2:
>  - Fix build error

This is OK as a short term bug fix for sure.

But longer term, we should always be able to rmmod a networking
device driver even if it is UP.

Supplementary references from MDIO make this not possible.

What would need to happen is that MDIO would stop taking references to
the network device driver module, and it would register a netdevice
notifier that would do the necessary detachmentand resource release
during an unregister attempt.

That's how ipv4, ipv6, etc. deal with references to the device via
routes, assigned protocol addresses, etc.
