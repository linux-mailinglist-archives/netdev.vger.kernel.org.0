Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75EA4ED993
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiCaMZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiCaMZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:25:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAA78C7D5;
        Thu, 31 Mar 2022 05:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=t/pDfVdBP51wnZQEqqpGRta5mhjv+I7iVpOcUcPD2ys=; b=vBN/3vt+eEBql6Z2bDC3M6Rh3g
        yJPDUf7/N/zXsoVwph9mNilZXpN1bzAtMJ/cIbx+zyxzzX14P2HyW3wjc1naaMzWHQZb3YEQI/uVN
        Yu8pLB3UqDqzSNjl+Rb+vTzMEFTcFB4YrUi3Ty7DVtioZizIkOM7WNoVF/XfJ+ZU0Rug=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZtq2-00DSVt-H7; Thu, 31 Mar 2022 14:23:42 +0200
Date:   Thu, 31 Mar 2022 14:23:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, o.rempel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when
 speed is unknown
Message-ID: <YkWdTpCsO8JhiSaT@lunn.ch>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331114819.14929-1-huangguangbin2@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 07:48:19PM +0800, Guangbin Huang wrote:
> If phy link status is down because link partner goes down, the phy speed
> will be updated to SPEED_UNKNOWN when autoneg on with general phy driver.
> If test loopback in this case, the phy speed will be set to 10M. However,
> the speed of mac may not be 10M, it causes loopback test failed.
> 
> To fix this problem, if speed is SPEED_UNKNOWN, don't configure link speed.

I don't think this explanation is correct.

If speed is UNKNOWN, ctl is just going to have BMCR_LOOPBACK set. That
is very similar to what you are doing. The code then waits for the
link to establish. This is where i guess your problem is. Are you
seeing ETIMEDOUT? Does the link not establish?

Thanks
	Andrew	
