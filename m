Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9E6552326
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244188AbiFTRxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244458AbiFTRxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:53:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA586562;
        Mon, 20 Jun 2022 10:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655747610; x=1687283610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/+QB7wKKf+PzCyErClLrgMfiB/sn39TsUcGrynH5XII=;
  b=XJO2XgO26UobleP/yTIZ9AyIn5lmBqyKJYi730O0TwNpxqkJOk1AsQ3T
   0QpnsNpRnAt9xC2Z7M4bf6UvY9GM6v9J791IGhH03/3xn1iho/YRVmbXa
   c3XU7OljcOHqKUdGIqGZTIPxyE3gLdXHZHpNjJQCiuUTHYu3w2/nfpgxL
   BQfwXNo/WfywphMhlOTVzfa1eQU7uV313RfO5L5kq+7daWEKyROOXb0np
   L+7PWHVnMAm3w2rsFuaLpIuyCR7S/uzpDj4uMjgSRWauNRFWOP2K701dy
   2+IXq4luulBBisVNwPiRtcDrmOJsOHcM+6l16VCUgN3ZkVkIs41+oHxo4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="343943504"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="343943504"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:53:17 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="689558765"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:53:12 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3LaH-000kaZ-Hn;
        Mon, 20 Jun 2022 20:53:09 +0300
Date:   Mon, 20 Jun 2022 20:53:09 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, gjb@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration
 of MDIO bus children
Message-ID: <YrC0BSeUJaBkhEop@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-9-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-9-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:21PM +0200, Marcin Wojtas wrote:
> The MDIO bus is responsible for probing and registering its respective
> children, such as PHYs or other kind of devices.
> 
> It is required that ACPI scan code should not enumerate such
> devices, leaving this task for the generic MDIO bus routines,
> which are initiated by the controller driver.
> 
> This patch prevents unwanted enumeration of the devices by setting
> 'enumeration_by_parent' flag, depending on whether their parent
> device is a member of a known list of MDIO controllers. For now,
> the Marvell MDIO controllers' IDs are added.

This flag is used for serial buses that are not self-discoverable. Not sure
about MDIO, but the current usage has a relation to the _CRS. Have you
considered to propose the MdioSerialBus() resource type to ACPI specification?

-- 
With Best Regards,
Andy Shevchenko


