Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48ABB22468C
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 01:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGQXIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 19:08:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:33038 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgGQXIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 19:08:05 -0400
IronPort-SDR: IVXIFoOMSuqwZs9qLYkvP7mA4paEdtIu4IDbn3bi33WuZmSlf4N/DNfGEH8voexYsYSkR8v/Zx
 erhzW/fe8VFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="234542782"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="234542782"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 16:08:04 -0700
IronPort-SDR: 1yCt1rrbbjMv7Ef2PgYN3ZDfY4r2zmViMvlLBfHHGKChYWaz/fRXrLpylfCG1KxkzVXVF6cJTO
 0L5io5tS2vtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="461013747"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.94.160]) ([10.212.94.160])
  by orsmga005.jf.intel.com with ESMTP; 17 Jul 2020 16:08:04 -0700
Subject: Re: [PATCH net-next 2/3] docs: networking: timestamping: add one more
 known issue
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-3-olteanv@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <5af0fd85-9e09-e5a2-fc99-d72b8a31cc0d@intel.com>
Date:   Fri, 17 Jul 2020 16:08:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717161027.1408240-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
> Document the fact that Ethernet PHY timestamping has a fundamentally
> flawed corner case (which in fact hits the majority of networking
> drivers): a PHY for which its host MAC driver doesn't forward the
> phy_mii_ioctl for timestamping is still going to be presented to user
> space as functional.
> 
> Fixing this inconsistency would require moving the phy_has_tsinfo()
> check inside all MAC drivers which are capable of PHY timestamping, to
> be in harmony with the existing design for phy_has_hwtstamp() checks.
> Instead of doing that, document the preferable solution which is that
> offending MAC drivers be fixed instead.

This statement feels weird. Aren't you documenting that the preferable
solution is? I.e. "Document this preferable solution: Fix the offending
MAC driver"

Or am I misunderstanding what the issue is here?

> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  Documentation/networking/timestamping.rst | 37 +++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> index 9a1f4cb4ce9e..4004c5d2771d 100644
> --- a/Documentation/networking/timestamping.rst
> +++ b/Documentation/networking/timestamping.rst
> @@ -754,3 +754,40 @@ check in their "TX confirmation" portion, not only for
>  that PTP timestamping is not enabled for anything other than the outermost PHC,
>  this enhanced check will avoid delivering a duplicated TX timestamp to user
>  space.
> +
> +Another known limitation is the design of the ``__ethtool_get_ts_info``
> +function::
> +
> +  int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
> +  {
> +          const struct ethtool_ops *ops = dev->ethtool_ops;
> +          struct phy_device *phydev = dev->phydev;
> +
> +          memset(info, 0, sizeof(*info));
> +          info->cmd = ETHTOOL_GET_TS_INFO;
> +
> +          if (phy_has_tsinfo(phydev))
> +                  return phy_ts_info(phydev, info);
> +          if (ops->get_ts_info)
> +                  return ops->get_ts_info(dev, info);
> +
> +          info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
> +                                  SOF_TIMESTAMPING_SOFTWARE;
> +          info->phc_index = -1;
> +
> +          return 0;
> +  }
> +
> +Because the generic function searches first for the timestamping capabilities
> +of the attached PHY, and returns them directly without consulting the MAC
> +driver, no checking is being done whether the requirements described in `3.2.2
> +Ethernet PHYs`_ are implemented or not. Therefore, if the MAC driver does not
> +satisfy the requirements for PHY timestamping, and
> +``CONFIG_NETWORK_PHY_TIMESTAMPING`` is enabled, then a non-functional PHC index
> +(the one corresponding to the PHY) will be reported to user space, via
> +``ethtool -T``.
> +
> +The correct solution to this problem is to implement the PHY timestamping
> +requirements in the MAC driver found broken, and submit as a bug fix patch to
> +netdev@vger.kernel.org. See :ref:`Documentation/process/stable-kernel-rules.rst
> +<stable_kernel_rules>` for more details.
> 
