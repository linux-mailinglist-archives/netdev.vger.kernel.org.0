Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5871FD38A
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgFQRbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:31:20 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12320 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgFQRbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592415079; x=1623951079;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=OM6axmQ3Y7wpPN2+W/tJEyq6eZpGAQXID7u+0+rJwys=;
  b=FQGFaMBoXTzk1F+TbLWCCzNuplOTDmP9GZzTu7opE44vSnePJyX4xxD1
   tEAJrfC+wi2w7BKvvL8zgffAY1O5BbkrT8+BqVzyCfgUn2mMblQWQsKGr
   rl65KCvzgrFogsia/3W/lO99E3gr1GYIdRH5PqJuGSqp7mATB2s1o3zd2
   kHen/mxITOGXdvH6JUb7BdhJJV24K1nwh5ba3BHNm9KVonEWLnAIRwQNR
   xwpxWdvd8VsypE0Q67wbVlMpZbebQvR0qlfnQBbB1JcsrXoEAUKkfDB5H
   OHvwM+xgDKLE74nC56mY3n2kOcW/4GzxSd4rjgeN2PZYj2uA7KTSbLfV+
   w==;
IronPort-SDR: tDf5rt3WZ359d84RruxG0xFqoomjLnn7oUYTMNnFz1jTUCH3vRLn6KhM7744ruAkcuBq20//Ag
 cd2tDnzv/ronCnFkoIG/xEa8/DTrQgM+oiBzbXxzUDPmMmNjEFOHV1q8lFnSIa90b0bTQ20Ayi
 xNVBMuE8XR08ZmyKYnSrMFLvLnAfpvBJlEF8c360LafHqvFmra24weZn4tXNJq9U9yFrM+b2gD
 BMrHusqFJZs5azDooyBUSKwZo8H/kLf7EA3jkxIr1OI7++TNz6I+vUvoExgzbuBv7JFUP8Ub19
 m5w=
X-IronPort-AV: E=Sophos;i="5.73,523,1583218800"; 
   d="scan'208";a="84030284"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2020 10:31:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Jun 2020 10:31:19 -0700
Received: from [10.171.246.62] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Jun 2020 10:31:16 -0700
Subject: Re: [PATCH] net: macb: undo operations in case of failure
To:     Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <antoine.tenart@bootlin.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1592400235-11833-1-git-send-email-claudiu.beznea@microchip.com>
 <20200617092935.4e3616c1@kicinski-fedora-PC1C0HJN>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <89e629e3-6fe7-3e9e-0800-0ca97a9217ce@microchip.com>
Date:   Wed, 17 Jun 2020 19:31:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617092935.4e3616c1@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/06/2020 at 18:29, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Wed, 17 Jun 2020 16:23:55 +0300 Claudiu Beznea wrote:
>> Undo previously done operation in case macb_phylink_connect()
>> fails. Since macb_reset_hw() is the 1st undo operation the
>> napi_exit label was renamed to reset_hw.
>>
>> Fixes: b2b041417299 ("net: macb: convert to phylink")
>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> 
> Fixes tag: Fixes: b2b041417299 ("net: macb: convert to phylink")
> Has these problem(s):
>          - Target SHA1 does not exist

It must be:
Fixes: 7897b071ac3b ("net: macb: convert to phylink")


-- 
Nicolas Ferre
