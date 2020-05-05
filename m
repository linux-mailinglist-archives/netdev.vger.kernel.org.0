Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D53C1C5046
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEI2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:28:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:60962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgEEI2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 04:28:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 77256AFF1;
        Tue,  5 May 2020 08:28:41 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 36B3D602B9; Tue,  5 May 2020 10:28:38 +0200 (CEST)
Date:   Tue, 5 May 2020 10:28:38 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 04/10] net: ethtool: Add attributes for cable
 test reports
Message-ID: <20200505082838.GH8237@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-5-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505001821.208534-5-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:18:15AM +0200, Andrew Lunn wrote:
> Add the attributes needed to report cable test results to userspace.
> The reports are expected to be per twisted pair. A nested property per
> pair can report the result of the cable test. A nested property can
> also report the length of the cable to any fault.
> 
> v2:
> Grammar fixes
> Change length from u16 to u32
> s/DEV/HEADER/g
> Add status attributes
> Rename pairs from numbers to letters.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  Documentation/networking/ethtool-netlink.rst | 42 +++++++++++++++
>  include/uapi/linux/ethtool_netlink.h         | 54 +++++++++++++++++++-
>  2 files changed, 95 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 72d53da2bea9..7a8a76f08bb9 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -968,6 +968,48 @@ Request contents:
>    ``ETHTOOL_A_CABLE_TEST_HEADER``       nested  request header
>    ====================================  ======  ==========================
>  
> +Notification contents:
> +
> +An Ethernet cable typically contains 1, 2 or 4 pairs. The length of
> +the pair can only be measured when there is a fault in the pair and
> +hence a reflection. Information about the fault may not be available,
> +depending on the specific hardware. Hence the contents of the notify
> +message are mostly optional. The attributes can be repeated an
> +arbitrary number of times, in an arbitrary order, for an arbitrary
> +number of pairs.
> +
> +The example shows the notification sent when the test is completed for
> +a T2 cable, i.e. two pairs. One pair is OK and hence has no length
> +information. The second pair has a fault and does have length
> +information.
> +
> + +---------------------------------------------+--------+---------------------+
> + | ``ETHTOOL_A_CABLE_TEST_HEADER``             | nested | reply header        |
> + +---------------------------------------------+--------+---------------------+
> + | ``ETHTOOL_A_CABLE_TEST_STATUS``             | u8     | completed           |
> + +---------------------------------------------+--------+---------------------+
> + | ``ETHTOOL_A_CABLE_TEST_NTF_NEST``           | nested | all the results     |
> + +-+-------------------------------------------+--------+---------------------+
> + | | ``ETHTOOL_A_CABLE_TEST_STATUS``           | u8     | completed           |
> + +-+-------------------------------------------+--------+---------------------+

You have ETHTOOL_A_CABLE_TEST_STATUS both here and on top level. AFAICS
the top level attribute is the right one - but the name is
ETHTOOL_A_CABLE_TEST_NTF_STATUS.

> + | | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test result   |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number         |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code         |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test results  |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number         |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code         |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | ``ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH`` | nested | cable length        |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR``   | u8     | pair number         |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_CM``     | u32    | length in cm        |
> + +-+-+-----------------------------------------+--------+---------------------+
>  
>  Request translation
>  ===================
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index 7e16a1cce20b..519c37e61fe8 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -75,6 +75,7 @@ enum {
>  	ETHTOOL_MSG_EEE_GET_REPLY,
>  	ETHTOOL_MSG_EEE_NTF,
>  	ETHTOOL_MSG_TSINFO_GET_REPLY,
> +	ETHTOOL_MSG_CABLE_TEST_NTF,

Please add this constant to the table in ethtool-netlink.rst.

>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_KERNEL_CNT,
> @@ -402,7 +403,6 @@ enum {
>  	/* add new constants above here */
>  	__ETHTOOL_A_TSINFO_CNT,
>  	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
> -
>  };
>  
>  /* CABLE TEST */
> @@ -416,6 +416,58 @@ enum {
>  	ETHTOOL_A_CABLE_TEST_MAX = __ETHTOOL_A_CABLE_TEST_CNT - 1
>  };
>  
> +/* CABLE TEST NOTIFY */
> +enum {
> +	ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC,
> +	ETHTOOL_A_CABLE_RESULT_CODE_OK,
> +	ETHTOOL_A_CABLE_RESULT_CODE_OPEN,
> +	ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT,
> +	ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT,
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_PAIR_A,
> +	ETHTOOL_A_CABLE_PAIR_B,
> +	ETHTOOL_A_CABLE_PAIR_C,
> +	ETHTOOL_A_CABLE_PAIR_D,
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_RESULT_UNSPEC,
> +	ETHTOOL_A_CABLE_RESULT_PAIR,		/* u8 ETHTOOL_A_CABLE_PAIR_ */
> +	ETHTOOL_A_CABLE_RESULT_CODE,		/* u8 ETHTOOL_A_CABLE_RESULT_CODE_ */
> +
> +	__ETHTOOL_A_CABLE_RESULT_CNT,
> +	ETHTOOL_A_CABLE_RESULT_MAX = (__ETHTOOL_A_CABLE_RESULT_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC,
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR,	/* u8 ETHTOOL_A_CABLE_PAIR_ */
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u32 */
> +
> +	__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT,
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_MAX = (__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED,
> +	ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_NTF_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_NTF_HEADER,	/* nest - ETHTOOL_A_HEADER_* */
> +	ETHTOOL_A_CABLE_TEST_NTF_STATUS,	/* u8 - _STARTED/_COMPLETE */
> +	ETHTOOL_A_CABLE_TEST_NTF_NEST,		/* nest - of results: */
> +	ETHTOOL_A_CABLE_TEST_NTF_RESULT,	/* nest - ETHTOOL_A_CABLE_RESULT_ */
> +	ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH,	/* nest - ETHTOOL_A_CABLE_FAULT_LENGTH_ */

I would prefer to have a separate enum for last two attributes as they
belong to a different context than the rest.

Michal

> +
> +	__ETHTOOL_A_CABLE_TEST_NTF_CNT,
> +	ETHTOOL_A_CABLE_TEST_NTF_MAX = (__ETHTOOL_A_CABLE_TEST_NTF_CNT - 1)
> +};
> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
> -- 
> 2.26.2
> 
