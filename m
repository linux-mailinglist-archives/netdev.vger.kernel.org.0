Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B822E1B8930
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 22:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgDYUAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 16:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgDYUAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 16:00:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F38C09B04D
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 13:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=oqorickqa2e6r0bz1s0KbH5qi7NHu9py66tws9CVE6o=; b=RcCVy+w6qrj7ITJhI7DxRx8p1A
        UaP0WmixSVuPyjc85Jp0+pQ/tWtPnWksG1qQJNRfr/3sNFFeO+AHYcUPp0mSnHt9SNI/8teCx7+Zf
        ApfMkdm0MVpA9bV/L+UaV7NqIZwtZJl4lRuErFedGt9Xvn7mR2VoeC8WknADu390WE5muiQ1xiRew
        UFfmFGzQUyrgWxAqS8LY3O4W9jRexpcaB1+HK1MWJ43aA0jN6Wtn1ZQ3V6SgpBXcQXB6x/VDCsQq3
        pOLPdpgUUik5h5FecCtkE8WMVwNPabLa/DST5IVSbopuArn4SOc5dSwlLtMBArU5zPrBYMLCZGeDK
        7/GSHWkA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSQy7-00079U-JZ; Sat, 25 Apr 2020 20:00:07 +0000
Subject: Re: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable
 test reports
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-5-andrew@lunn.ch>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7a0430f6-7303-55fd-93f5-a16add08bbc9@infradead.org>
Date:   Sat, 25 Apr 2020 13:00:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200425180621.1140452-5-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Here are a few edit comments for you to consider:

On 4/25/20 11:06 AM, Andrew Lunn wrote:
> Add the attributes needed to report cable test results to userspace.
> The reports are expected to be per twisted pair. A nested property per
> pair can report the result of the cable test. A nested property can
> also report the length of the cable to any fault.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  Documentation/networking/ethtool-netlink.rst | 35 +++++++++++++++
>  include/uapi/linux/ethtool_netlink.h         | 47 +++++++++++++++++++-
>  2 files changed, 81 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 0c354567e991..89fd321b0e29 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -967,6 +967,41 @@ Request contents:
>    ``ETHTOOL_A_CABLE_TEST_HEADER``       nested  request header
>    ====================================  ======  ==========================
>  
> +Notify contents:
> +
> +An Ethernet cable typically contains 1, 2 or 4 pairs. The length of
> +the pair can only be measured when there is a fault in the pair and
> +hence a reflection. Information about the fault may not be available,
> +depends on the specific hardware. Hence the contents of the notify

   depending on

> +message is mostly optional. The attributes can be repeated an

           are

> +arbitrary number of times, in an arbitrary order, for an arbitrary
> +number of pairs.
> +
> +The example shows a T2 cable, i.e. two pairs. One pair is O.K, and

                                                             OK and

> +hence has no length information. The second pair has a fault and does
> +have length information.
> +
> + +-------------------------------------------+--------+-----------------------+
> + | ``ETHTOOL_A_CABLE_TEST_HEADER``           | nested | reply header          |
> + +-------------------------------------------+--------+-----------------------+
> + | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test result     |
> + +-+-----------------------------------------+--------+-----------------------+
> + | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number           |
> + +-+-----------------------------------------+--------+-----------------------+
> + | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code           |
> + +-+-----------------------------------------+--------+-----------------------+
> + | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test results    |
> + +-+-----------------------------------------+--------+-----------------------+
> + | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number           |
> + +-+-----------------------------------------+--------+-----------------------+
> + | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code           |
> + +-+-----------------------------------------+--------+-----------------------+
> + | ``ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH`` | nested | cable length          |
> + +-+-----------------------------------------+--------+-----------------------+
> + | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR``   | u8     | pair number           |
> + +-+-----------------------------------------+--------+-----------------------+
> + | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_CM``     | u8     | length in cm          |
> + +-+-----------------------------------------+--------+-----------------------+
>  
>  Request translation
>  ===================



-- 
~Randy

