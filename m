Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B5547376
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 11:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiFKJ6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 05:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiFKJ6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 05:58:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF2AB845;
        Sat, 11 Jun 2022 02:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654941531; x=1686477531;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LoUQFEJVS8iKP4KHv45pEyco3cBp3wRIOlEANLpEqfM=;
  b=bgqfdzNy1BveqUBhjYb6qcGV+ohpGMNQ46SREXJwgR9RUHpNzE2Ow7hG
   URzohwV8QilFj0qNop1kR2MKQB/6VW2ZeeIOyDhXp8dTGWp1Jhs3Au2X3
   m0ok7U9ptNXNrs/AaxrKA8xH5Oy86aeXbLXxN7qBsCLMu2yUyymDPufrE
   JnbmCd1ySdNk9tvJX7YkQHvrv5e50aa+dwnSPz3AwrtbL/dP+PA8L9Da7
   8+thFf7xqYYz1Q9tgCAnmwN67ZuBEtHDy2JzZh76mWTNWSrksEX3pRc+s
   R4GIO4QpKT5vh3UEgeCW5KemWxH96VDQBeaiBlei1S+0QAG93VJ0fOhE9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="257694015"
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="257694015"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 02:58:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="638638184"
Received: from jiaqingz-mobl.ccr.corp.intel.com (HELO [10.255.31.17]) ([10.255.31.17])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 02:58:49 -0700
Message-ID: <bf66a840-594a-d90a-2ca6-595e95c09514@linux.intel.com>
Date:   Sat, 11 Jun 2022 17:58:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/6] Configurable VLAN mode for NCSI driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
 <20220610130903.0386c0d9@kernel.org>
 <3c9fa928-f416-3526-be23-12644d18db3b@linux.intel.com>
 <20220610214506.74c3f89c@kernel.org>
 <6f067302-74a8-702f-bf38-4477a805a528@linux.intel.com>
 <20220610224407.4e58dc5a@kernel.org>
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <20220610224407.4e58dc5a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022-06-11 13:44, Jakub Kicinski wrote:
> On Sat, 11 Jun 2022 13:18:51 +0800 Jiaqing Zhao wrote:
>> All ncsi devices uses the same driver as they uses same command set,
>> so the driver doesn't know what modes are supported. And in current
>> driver, the vlan related parameters are configured when registering
>> the device, adding an ncsi-netlink command to do so seems to be
>> unsuitable.
> 
> Maybe you could draw a diagram? NC-SI is a bit confusing.

Yes I admit NC-SI is confusing as its design is not as straightforward
as the MAC-PHY structure. In NC-SI, there are two macs like below.

        Packets + NCSI commands                        Packets
    MAC-------------------------External controller MAC---------PHY

The NCSI commands are used to set the behavior of the External controller
MAC, like it's MAC address filter, VLAN filters. Those filtered packets
will be transferred back to the MAC.

Unlike PHY has standard registers to determine its model and capabilities,
NC-SI seems does not have such way.
>> And adding a netlink command requires extra application in userspace
>> to switch the mode. In my opinion, it would be more user-friendly to
>> make it usable on boot.
> 
> Unfortunately convenience is not reason to start adding system config
> into DT.

Currently there is already a DT config "use-ncsi" is used to choose using
MDIO PHY or NCSI stack in the MAC driver with NCSI support like ftgmac100.
That's why I choose adding another DT option here.

>> Netdev also does not work as the ncsi device itself does not have
>> its own netdev, the netdev comes from the mac device. For different
>> vlan modes, the netdev feature set of its parent mac device are the
>> same.
> 
> You say that, yet the command handling already takes into account the
> VLAN list:
> 
> 	if (list_empty(&ndp->vlan_vids)) {
> 
> which come from the MAC netdev. What's wrong with setting the filtering
> mode based on NETIF_F_HW_VLAN_CTAG_FILTER ?

When configuring the mac driver, there might be two net_device_ops sets
for MDIO or NC-SI. When using NC-SI, some features need to be delegated
to the external controller MAC, like VLAN hardware filtering, different
ndo_vlan_rx_{add,kill}_vid callbacks need to be assigned.

The filtering mode is an optional mode defined in NC-SI spec, some
devices does not support it. In this case, to support VLAN, I would
personally in favor of using the "Any VLAN" mode to let the external
MAC pass all packets to the internal one, and let the internal MAC
handle it either with its own hardware filter or software filter. In
this case, the VLAN list in NC-SI driver (used for setting the external
MAC filter) is not used.
