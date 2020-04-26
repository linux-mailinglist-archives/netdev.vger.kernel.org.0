Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92081B93ED
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgDZUZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:25:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:45360 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgDZUZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 16:25:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A74AAE7B;
        Sun, 26 Apr 2020 20:25:44 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EBFDC602EE; Sun, 26 Apr 2020 22:25:43 +0200 (CEST)
Date:   Sun, 26 Apr 2020 22:25:43 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable
 test reports
Message-ID: <20200426202543.GD23225@lion.mk-sys.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-5-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425180621.1140452-5-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 08:06:16PM +0200, Andrew Lunn wrote:
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

Perhaps rather "Notification contents".

> +
> +An Ethernet cable typically contains 1, 2 or 4 pairs. The length of
> +the pair can only be measured when there is a fault in the pair and
> +hence a reflection. Information about the fault may not be available,
> +depends on the specific hardware. Hence the contents of the notify
> +message is mostly optional. The attributes can be repeated an
> +arbitrary number of times, in an arbitrary order, for an arbitrary
> +number of pairs.
> +
> +The example shows a T2 cable, i.e. two pairs. One pair is O.K, and
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

Would it be complicated to gather all information for each pair
together? I.e. to have one nest for each pair with pair number, result
code and possibly other information (if available). I believe it would
make the message easier to process.

>  
>  Request translation
>  ===================
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index 598d0b502ebd..05ef5048e4fc 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -76,6 +76,7 @@ enum {
>  	ETHTOOL_MSG_EEE_NTF,
>  	ETHTOOL_MSG_TSINFO_GET_REPLY,
>  	ETHTOOL_MSG_CABLE_TEST_ACT_REPLY,
> +	ETHTOOL_MSG_CABLE_TEST_NTF,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_KERNEL_CNT,
> @@ -403,7 +404,6 @@ enum {
>  	/* add new constants above here */
>  	__ETHTOOL_A_TSINFO_CNT,
>  	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
> -
>  };
>  
>  /* CABLE TEST */
> @@ -417,6 +417,51 @@ enum {
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
> +	ETHTOOL_A_CABLE_PAIR_0,
> +	ETHTOOL_A_CABLE_PAIR_1,
> +	ETHTOOL_A_CABLE_PAIR_2,
> +	ETHTOOL_A_CABLE_PAIR_3,
> +};

Do we really need this enum, couldn't we simply use a number (possibly
with a sanity check of maximum value)?

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
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u16 */

The example above says "u8" (which is obviously wrong). I would rather
suggest u32 here to be as future proof as possible. Using NLA_U16
doesn't save anything after all, as both NLA_U16 and NLA_U32 spend the
same space due to padding.

> +
> +	__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT,
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_MAX = (__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_NTF_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_NTF_DEV,		/* nest - ETHTOOL_A_DEV_* */

s/DEV/HEADER/g, I suppose (looks like a relic from an older version).

> +	ETHTOOL_A_CABLE_TEST_NTF_NEST,		/* nest - of results: */

This is missing in the example above.

> +	ETHTOOL_A_CABLE_TEST_NTF_RESULT,	/* nest - ETHTOOL_A_CABLE_RESULT_ */
> +	ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH,	/* nest - ETHTOOL_A_CABLE_FAULT_LENGTH_ */
> +
> +	__ETHTOOL_A_CABLE_TEST_NTF_CNT,
> +	ETHTOOL_A_CABLE_TEST_NTF_MAX = (__ETHTOOL_A_CABLE_TEST_NTF_CNT - 1)
> +};

One more idea: it would be IMHO useful to also send a notification when
the test is started. It could be distinguished by a status attribute
which would describe status of the test as a whole (not a specific
pair), e.g. started, finished, aborted.

Michal

> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
> -- 
> 2.26.1
> 
