Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98FB2113C7
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgGAToY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAToX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:44:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61C9C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 12:44:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 523E8139F3BBB;
        Wed,  1 Jul 2020 12:44:23 -0700 (PDT)
Date:   Wed, 01 Jul 2020 12:44:22 -0700 (PDT)
Message-Id: <20200701.124422.999920966272100417.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     ecree@solarflare.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 12/15] sfc_ef100: add EF100 to NIC-revision
 enumeration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701121131.56e456c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
        <f03e0e84-4c8f-8e1e-a0c4-d8454daf9813@solarflare.com>
        <20200701121131.56e456c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 12:44:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 1 Jul 2020 12:11:31 -0700

> On Wed, 1 Jul 2020 15:55:10 +0100 Edward Cree wrote:
>> Also, condition on revision in ethtool drvinfo: if rev is EF100, then
>>  we must be the sfc_ef100 driver.  (We can't rely on KBUILD_MODNAME
>>  any more, because ethtool_common.o gets linked into both drivers.)
>> 
>> Signed-off-by: Edward Cree <ecree@solarflare.com>
>> ---
>>  drivers/net/ethernet/sfc/ethtool_common.c | 5 ++++-
>>  drivers/net/ethernet/sfc/nic_common.h     | 1 +
>>  2 files changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
>> index 37a4409e759e..926deb22ee67 100644
>> --- a/drivers/net/ethernet/sfc/ethtool_common.c
>> +++ b/drivers/net/ethernet/sfc/ethtool_common.c
>> @@ -104,7 +104,10 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
>>  {
>>  	struct efx_nic *efx = netdev_priv(net_dev);
>>  
>> -	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
>> +	if (efx->type->revision == EFX_REV_EF100)
>> +		strlcpy(info->driver, "sfc_ef100", sizeof(info->driver));
>> +	else
>> +		strlcpy(info->driver, "sfc", sizeof(info->driver));
> 
> ethtool info -> driver does not seem like an appropriate place to
> report hardware version.

Agreed.

Or is this code used as a library by two "drivers"?  In that case it's fine.

