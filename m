Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4566935F45F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 14:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345898AbhDNM5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 08:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbhDNM5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 08:57:00 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E99C061574;
        Wed, 14 Apr 2021 05:56:38 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E331F22236;
        Wed, 14 Apr 2021 14:56:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618404993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nIqcTyZ0aGklq+mdSHotuPklBOhZa+ud8+bN5Q5+CPw=;
        b=VZL40Qx/ZFqrvlYpNa+CpUnri3A5IcdLrj+2SxpxVHAI8fYpizPcSIOU0o4IGsNgU2L8zb
        buzdqfa91h/T+Kc3jCccsyXkXKwvO0deOpvm1xgmDARKkJkG9wKdcW8QSFZ/zWqZRgSGou
        k2tTqyTzN0TuoPWxydGMvbSU0aMYGjo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 14 Apr 2021 14:56:30 +0200
From:   Michael Walle <michael@walle.cc>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, ath9k-devel@qca.qualcomm.com,
        UNGLinuxDriver@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org, lkp@intel.com,
        kbuild-all@lists.01.org
Subject: Re: [PATCH net-next v2 1/2] of: net: pass the dst buffer to
 of_get_mac_address()
In-Reply-To: <20210414053336.GQ6021@kadam>
References: <20210414053336.GQ6021@kadam>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <cf5c86dd6492b9c1907ea69e2d660eb2@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

Am 2021-04-14 07:33, schrieb Dan Carpenter:
> url:
> https://github.com/0day-ci/linux/commits/Michael-Walle/of-net-support-non-platform-devices-in-of_get_mac_address/20210406-234030
> base:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> cc0626c2aaed8e475efdd85fa374b497a7192e35
> config: x86_64-randconfig-m001-20210406 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:2069 axienet_probe()
> warn: passing a valid pointer to 'PTR_ERR'
> 
> vim +/PTR_ERR +2069 drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> 
> 522856cefaf09d Robert Hancock      2019-06-06  2060  	/* Check for
> Ethernet core IRQ (optional) */
> 522856cefaf09d Robert Hancock      2019-06-06  2061  	if (lp->eth_irq 
> <= 0)
> 522856cefaf09d Robert Hancock      2019-06-06  2062
> 		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
> 522856cefaf09d Robert Hancock      2019-06-06  2063
> 8a3b7a252dca9f Daniel Borkmann     2012-01-19  2064  	/* Retrieve the
> MAC address */
> 411b125c6ace1f Michael Walle       2021-04-06  2065  	ret =
> of_get_mac_address(pdev->dev.of_node, mac_addr);
> 411b125c6ace1f Michael Walle       2021-04-06  2066  	if (!ret) {
> 411b125c6ace1f Michael Walle       2021-04-06  2067
> 		axienet_set_mac_address(ndev, mac_addr);
> 411b125c6ace1f Michael Walle       2021-04-06  2068  	} else {
> d05a9ed5c3a773 Robert Hancock      2019-06-06 @2069
> 		dev_warn(&pdev->dev, "could not find MAC address property: %ld\n",
> d05a9ed5c3a773 Robert Hancock      2019-06-06  2070  			 
> PTR_ERR(mac_addr));
> 
>   ^^^^^^^^^^^^^^^^^
> This should print "ret".

Thanks, this was fixed (in the now merged) v4. I forgot
to add you to that huge CC list. Sorry for that.

-michael
