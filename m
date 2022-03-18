Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F244DE08E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 18:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiCRRye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 13:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiCRRye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 13:54:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34D62B1BE;
        Fri, 18 Mar 2022 10:53:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D218B824F0;
        Fri, 18 Mar 2022 17:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FB1C340E8;
        Fri, 18 Mar 2022 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647625992;
        bh=I2UsjvUo2CeZUeiqhFvaJS3x664V3c+cCz4CwC+YlE8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nXV9aU4i30VpemfnJBdp5nzU3C2FeJ7hE4PljYNf4aRDTREc+dwh/h3wFIwPuHl9V
         h3dMZWHynmyyDaCzWnsSMAHLmb/I/TGQ7oSOBALVVnBkFes03q36ZElMZn+N28zKU+
         RQpkTQUdualqzot7AXhNZQaUFhARWfsaeVf2W/usR1m1mr5d8sp/bdmJzsOLgddNOF
         C3y+uw8gnKBDBL4sTVO8wOlissH6vP7X2/4/OlqRxIYYPVWa6XQNYMmNpD3Wq423Ds
         7O7y6s5agnNALIZ8SotNGzRhwotFRBuGH2LqPVeOOuelPItPW1fXru9SR385n36uQM
         aX5V/pSQOzmBw==
Date:   Fri, 18 Mar 2022 10:53:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <sakiwit@gmail.com>,
        <sainath.grandhi@intel.com>, <maheshb@google.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/3] net: ipvlan: fix potential UAF problem
 for phy_dev
Message-ID: <20220318105311.21ca32bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <83116bde1ddf39420e24466684c9488bff46f43c.1647568181.git.william.xuanziyang@huawei.com>
References: <cover.1647568181.git.william.xuanziyang@huawei.com>
        <83116bde1ddf39420e24466684c9488bff46f43c.1647568181.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 09:57:47 +0800 Ziyang Xuan wrote:
> Add the reference operation to phy_dev of ipvlan to avoid
> the potential UAF problem under the following known scenario:
> 
> Someone module puts the NETDEV_UNREGISTER event handler to a
> work, and phy_dev is accessed in the work handler. But when
> the work is excuted, phy_dev has been destroyed because upper
> ipvlan did not get reference to phy_dev correctly.
> 
> That likes as the scenario occurred by
> commit 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()").

There is no equivalent of vlan_dev_real_dev() for ipvlan, AFAICT.
The definition of struct ipvl_dev is private to the driver. I don't 
see how a UAF can happen here.

You should either clearly explain how the bug could happen or clearly
state that there is no possibility of the bug for this driver, and the
patch is just future proofing.

If the latter is the case we should drop the Fixes tag and prevent this
patch from getting backported into stable.

> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
