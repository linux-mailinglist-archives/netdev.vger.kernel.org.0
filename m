Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0C337AB1F
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 17:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhEKPum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 11:50:42 -0400
Received: from gateway22.websitewelcome.com ([192.185.47.100]:21944 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231891AbhEKPul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 11:50:41 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 3CA0D412FF
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 10:49:31 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id gUdXlEd4YAEP6gUdXlEuWo; Tue, 11 May 2021 10:49:31 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=du7TLirKJwuRndTVgzHHBCMXvT6lZMGk+j6j2JK4ikk=; b=jVO4W/UG3fiHMDSm9xE8Ra87k3
        +cgQgqzxJVZdYJVsdqhpoh0FUWz2VDu+NJczDnC8WrpoxH++yGLWMSWG3vY3L4TwcEYXqt/VYGwfS
        Iq31krhyN9/zwtnmsYa6hR2l5qrGI5RbO2Mobfbn1y34LKFCKc6D5eLAQx35mV97uY/wAYMkfgXsp
        VBABL308IUxeJpnKvlfvfqVxAxxg9F58lw2s/1Y7rEoPe1aUmq+ePxI3C45k6ughER11G8y7I7zE2
        mWTQsmaxiHyhKmUDzHzrf4wrxEimMLhzUQ83BNifaZvm0BwlnDyKzNINSGViHnLXpKpL1nFECJa15
        lAWA6ndQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:59016 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lgUdS-000VgQ-Ji; Tue, 11 May 2021 10:49:26 -0500
Subject: Re: [Intel-wired-lan] [PATCH][next] ixgbe: Fix out-bounds warning in
 ixgbe_host_interface_command()
To:     "Switzer, David" <david.switzer@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
References: <20210413190345.GA304933@embeddedor>
 <MW3PR11MB47483A28574E9F2C5517D3C5EB589@MW3PR11MB4748.namprd11.prod.outlook.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <b0749fb9-ff4e-3237-e2f7-b97255545eb0@embeddedor.com>
Date:   Tue, 11 May 2021 10:49:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <MW3PR11MB47483A28574E9F2C5517D3C5EB589@MW3PR11MB4748.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lgUdS-000VgQ-Ji
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:59016
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 38
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On 5/6/21 02:25, Switzer, David wrote:
> 
>> -----Original Message-----
>> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>> Gustavo A. R. Silva
>> Sent: Tuesday, April 13, 2021 12:04 PM
>> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
>> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jakub
>> Kicinski <kuba@kernel.org>
>> Cc: Kees Cook <keescook@chromium.org>; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Gustavo A. R. Silva <gustavoars@kernel.org>; intel-
>> wired-lan@lists.osuosl.org; linux-hardening@vger.kernel.org
>> Subject: [Intel-wired-lan] [PATCH][next] ixgbe: Fix out-bounds warning in
>> ixgbe_host_interface_command()
>>
>> Replace union with a couple of pointers in order to fix the following out-of-
>> bounds warning:
>>
>>  CC [M]  drivers/net/ethernet/intel/ixgbe/ixgbe_common.o
>> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: In function
>> ‘ixgbe_host_interface_command’:
>> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3729:13: warning: array
>> subscript 1 is above array bounds of ‘u32[1]’ {aka ‘unsigned int[1]’} [-Warray-
>> bounds]
>> 3729 |   bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
>>      |   ~~~~~~~~~~^~~~
>> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3682:7: note: while
>> referencing ‘u32arr’
>> 3682 |   u32 u32arr[1];
>>      |       ^~~~~~
>>
>> This helps with the ongoing efforts to globally enable -Warray-bounds.
>>
>> Link: https://github.com/KSPP/linux/issues/109
>> Co-developed-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 16 +++++++---------
>> 1 file changed, 7 insertions(+), 9 deletions(-)
>>
> Tested-by: Dave Switzer <david.switzer@intel.com>

Thanks for this, Dave. :)

By the way, we are about to be able to globally enable -Warray-bounds and,
this is one of the last out-of-bounds warnings in linux-next.

Thanks
--
Gustavo
