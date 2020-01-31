Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E3414F203
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgAaSRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:17:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:1261 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgAaSQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:16:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:16:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="377417417"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 10:16:59 -0800
Subject: Re: [PATCH 08/15] devlink: add devres managed devlinkm_alloc and
 devlinkm_free
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-9-jacob.e.keller@intel.com>
 <20200131100718.6c8471f0@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b7481d02-1635-9855-13a6-97016eaf4004@intel.com>
Date:   Fri, 31 Jan 2020 10:16:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131100718.6c8471f0@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2020 10:07 AM, Jakub Kicinski wrote:
> On Thu, 30 Jan 2020 14:59:03 -0800, Jacob Keller wrote:
>> Add devres managed allocation functions for allocating a devlink
>> instance. These can be used by device drivers based on the devres
>> framework which want to allocate a devlink instance.
>>
>> For simplicity and to reduce churn in the devlink core code, the devres
>> management works by creating a node with a double-pointer. The devlink
>> instance is allocated using the normal devlink_alloc and released using
>> the normal devlink_free.
>>
>> An alternative solution where the raw memory for devlink is allocated
>> directly via devres_alloc could be done. Such an implementation would
>> either significantly increase code duplication or code churn in order to
>> refactor the setup from the allocation.
>>
>> The new devres managed allocation function will be used by the ice
>> driver in a following change to implement initial devlink support.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> How much are you actually going to gain by doing this given you still
> have to deal with registering an unregistering all devlink things...
> 

So, the main problem is that the ice driver's private PF structure is
allocated using devm_alloc.. and if we switch to using devlink_alloc
then that memory is no longer managed by devres and it becomes more
difficult to manage...

That being said, after looking at exactly how the ice driver uses devres
and managing things.. Probably not much gain in general. The ice driver
could implement its own call for this if we still need it.

In theory the register/unregister of devlink resources could be managed
by using devres_add_action to handle the teardown.. but that's a fairly
major refactor to get everything working.
