Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2181514F57D
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 01:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBAAvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 19:51:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:41133 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgBAAvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 19:51:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 16:51:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,387,1574150400"; 
   d="scan'208";a="377505423"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 16:51:10 -0800
Subject: Re: [PATCH 08/15] devlink: add devres managed devlinkm_alloc and
 devlinkm_free
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-9-jacob.e.keller@intel.com>
 <20200131100723.0d6893fa@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <78e85b70-41f3-d2fa-1227-dea732dea116@intel.com>
Date:   Fri, 31 Jan 2020 16:51:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131100723.0d6893fa@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2020 10:07 AM, Jakub Kicinski wrote:
> On Thu, 30 Jan 2020 14:59:03 -0800, Jacob Keller wrote:
> Ugh. The devlink instance sharing/aliasing is something that needs to
> be solved at some point. But the problem likely exists elsewhere
> already. Do you have global ASIC resources?
> 

We do have some global resources on the device. This is somewhat managed
by firmware, but not everything is managed, and there's often little to
no visibility even at the driver layer let alone a system administrator.

Things like flash_update and flash regions also only make sense device
wide, and it's a little silly to expose them for multiple functions.

Unfortunately, we *do* have separate PCIe functions, and I wasn't able
to come up with a good (safe) method for managing something like this
that crosses the function boundary.

I noticed that the mlx4 and mlx5 drivers appear to create one devlink
per PF as well, but the mlxsw driver appears to have a single function
for the whole device.

I'm not sure about other drivers, but I do think this is a common
problem, and would benefit from some core code.

One possibility that I've tossed around in my head is some sort of
subordinate PCI bus driver that loads once for the device before the
function drivers load... But I really am not sure where to begin with
that. This also represents a fairly significant device driver model change.

Beyond just having the devlink is some capability to add per-port
configuration as well.

TL;DR; Yes, I'd like to have a single devlink for the device, but no, I
don't have a good answer for how to do it sanely.

Thanks,
Jake
