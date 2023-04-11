Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78D86DD780
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDKKIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKKIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:08:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804162D67;
        Tue, 11 Apr 2023 03:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681207730; x=1712743730;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qtxsNuJQDSUF/7fTFYabGmqvbQYKyMolYaV1bWaTZt8=;
  b=dWDyrjxTPJ8T8itafRhXct8N4DQkGkEKXbzk+8S3iqv3u2ZptHldnTg9
   Oodc6AsTKL8plGqIjVHiO7hJigad+xAGm/gM3PZGOxX/9IYwY8Bc5liTG
   1LdJ7BS/U+IFqLtDZ/rlBBnpTMrm48moZrMLbzUrDCKL2dite/ESvufZ9
   VylL7YlwK3Md8Gz16omu2HczSM7gT0i7awol9oONeRpB8xYCChZKBn58v
   IBlb3Hfdk1ima4rAk3ZOnNK0yTHzE+7qwEkQj5nUxOX+VQ4KDkrDE00UC
   WIBiqtkC5Fb6zmhi4tsfBFrzQ6hijxnZIWQORkKESJ8h0m0GxGa/Y2R42
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="341069789"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="341069789"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 03:08:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="721154904"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="721154904"
Received: from unknown (HELO [10.237.72.51]) ([10.237.72.51])
  by orsmga001.jf.intel.com with ESMTP; 11 Apr 2023 03:08:47 -0700
Message-ID: <09dc3146-a1c6-e1a3-c8bd-e9fe547f9b99@linux.intel.com>
Date:   Tue, 11 Apr 2023 13:08:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 2/6] net: txgbe: Implement I2C bus master
 driver
Content-Language: en-US
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
 <20230411092725.104992-3-jiawenwu@trustnetic.com>
 <00cf01d96c58$8d3e9130$a7bbb390$@trustnetic.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <00cf01d96c58$8d3e9130$a7bbb390$@trustnetic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 4/11/23 12:32, Jiawen Wu wrote:
> +Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> 
>> -----Original Message-----
>> From: Jiawen Wu <jiawenwu@trustnetic.com>
>> Sent: Tuesday, April 11, 2023 5:27 PM
>> To: netdev@vger.kernel.org; linux@armlinux.org.uk
>> Cc: linux-i2c@vger.kernel.org; linux-gpio@vger.kernel.org;
>> mengyuanlou@net-swift.com; Jiawen Wu <jiawenwu@trustnetic.com>
>> Subject: [PATCH net-next v2 2/6] net: txgbe: Implement I2C bus master
>> driver
>>
>> Implement I2C bus driver to send and receive I2C messages.
>>
>> This I2C license the IP of Synopsys Designware, but without interrupt
>> support on the hardware design. It seems that polling mode needs to be
>> added in Synopsys Designware I2C driver. But currently it can only be
>> driven by this I2C bus master driver.
>>
>> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
>> ---
>>   drivers/net/ethernet/wangxun/Kconfig          |   1 +
>>   .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 153
>> ++++++++++++++++++
>>   .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  23 +++
>>   3 files changed, 177 insertions(+)
>>
Looks like your use case has similarities with the commit 17631e8ca2d3 
("i2c: designware: Add driver support for AMD NAVI GPU").
