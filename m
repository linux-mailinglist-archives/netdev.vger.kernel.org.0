Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A9D3C7FF0
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhGNIYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbhGNIYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:24:04 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3313DC061760;
        Wed, 14 Jul 2021 01:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nzsplCvQ+cF/ppxUb65LEoPjQpMcxc9NYIBsyj3BvMU=; b=c/c2ZXqEuU+hWvW0hbbHOQpZou
        UtLjeCalmcgs6VEwTg0g3eH2C0QaDE2BbOrwVninvDD3L0YBDq3NzY1Rk3IQBMS2o7fxaeuFnugkQ
        7ook/JviJRqjcBZzXokVB7U6YGbBQWtMMsNir8yxwI7sVMNXFjo6FTz17vhyJtgn9vcU=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3a8j-0000xF-Hj; Wed, 14 Jul 2021 10:21:09 +0200
Subject: Re: [RFC 3/7] net: ethernet: mtk_eth_soc: implement flow offloading
 to WED devices
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ryder.lee@mediatek.com
References: <20210713160745.59707-1-nbd@nbd.name>
 <20210713160745.59707-4-nbd@nbd.name> <20210713184002.GA26070@salvia>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <544dcb50-a661-f230-5149-ec1a356b7665@nbd.name>
Date:   Wed, 14 Jul 2021 10:21:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713184002.GA26070@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-07-13 20:40, Pablo Neira Ayuso wrote:
> On Tue, Jul 13, 2021 at 06:07:41PM +0200, Felix Fietkau wrote:
> [...]
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index c253c2aafe97..7ea6a1db0338 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -885,6 +885,10 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
>>  		if (WARN_ON_ONCE(last_dev == ctx.dev))
>>  			return -1;
>>  	}
>> +
>> +	if (!ctx.dev)
>> +		return ret;
> 
> This is not a safety check, right? After this update ctx.dev might be NULL?
Right. I added this check to be able to prevent dev_fill_forward_path
from adding an extra DEV_PATH_ETHERNET entry, which is not applicable
for wlan devices.

- Felix
