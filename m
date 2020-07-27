Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A3E22F8E4
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgG0TTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:19:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:58316 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728707AbgG0TTO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 15:19:14 -0400
IronPort-SDR: A+5ulwWiaWy4gWzLkJ+Y23ujmtpo4Li+wp2g3tBUQmE/dkUN4zkIfq0qWBC93wGVJe7p9MD7gC
 dXQ4a9t6p5ow==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130661254"
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="130661254"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 12:19:14 -0700
IronPort-SDR: c0RTdc2/aPDL1Knrtaw33gaQXGgmddeYH99UPQVILbwzHJgkmmiSrkf87p5uYLvu47RtBK6/zr
 XgD8qFlqDp7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="303572979"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.56.18]) ([10.212.56.18])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 12:19:14 -0700
Subject: Re: Broken link partner advertised reporting in ethtool
To:     Jamie Gloudon <jamie.gloudon@gmx.fr>, netdev@vger.kernel.org
References: <20200727154715.GA1901@gmx.fr>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
Date:   Mon, 27 Jul 2020 12:19:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200727154715.GA1901@gmx.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 8:47 AM, Jamie Gloudon wrote:
> Hey,
> 
> While having a discussion with Sasha from Intel. I noticed link partner
> advertised support is broken in ethtool 5.7. Sasha hinted to me, the
> new API that ethtool is using.
> 
> I see the actual cause in dump_peer_modes() in netlink/settings.c, that
> the mask parameter is set to false for dump_link_modes, dump_pause and
> bitset_get_bit.
> 
> Regards,
> Jamie Gloudon
> 

Hi,

Seems like more detail here would be useful. This is about the ethtool
application.

Answering the following questions would help:

 - what you wanted to achieve;

 - what you did (including what versions of software and the command
   sequence to reproduce the behavior);

 - what you saw happen;

 - what you expected to see; and

 - how the last two are different.

The mask parameter for dump_link_modes is used to select between
displaying the mask and the value for a bitset.

According to the source in filling the LINKMODES_PEER, we actually don't
send a mask at all with this setting, so using true for the mask in
dump_link_modes here seems like it would be wrong.

It appears that to get link partner settings your driver must fill in
lp_advertising. If you're referring to an Intel driver, a quick search
over drivers/net/ethernet/intel shows that only the ice driver currently
supports reporting this information.

Given this, I am not convinced there is a bug in ethtool.

Thanks,
Jake
