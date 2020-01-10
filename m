Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B82137679
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgAJS53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:57:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:5801 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbgAJS53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 13:57:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 10:57:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,418,1571727600"; 
   d="scan'208";a="224279706"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2020 10:57:29 -0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        valex@mellanox.com
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <20200110094027.GL2235@nanopsycho.orion>
 <c5fe026b-d29f-7be2-78b5-c54ec6d2f549@intel.com>
 <20200110104719.2035572d@cakuba.netronome.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e1099b1a-f1a0-4db7-9fbd-f5610e03c8b0@intel.com>
Date:   Fri, 10 Jan 2020 10:57:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110104719.2035572d@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/2020 10:47 AM, Jakub Kicinski wrote:
> On Fri, 10 Jan 2020 09:54:20 -0800, Jacob Keller wrote:
>> Mostly I wanted to make sure the direction was looking good earlier than
>> the time frame for completing that work.
> 
> As Jiri said, quite hard to tell without seeing the real user.
> 

Fair.

> I presume you take some lock to ensure the contents of the snapshot are
> atomic?  Otherwise I wonder if you wouldn't be better served by just
> allowing region read to operate directly on the data rather then going
> through the snapshot create -> read -> snapshot remove cycle. Not sure
> Jiri would agree, it require more code.
> 

Right. I saw the original devlink region commit messages indicated
possible plans to support writing to regions. There is also the question
of handling data that might want to be read sparsely, rather than
reading an entire snapshot at once. Hmm.

> For the patches themselves we may want to move the callbacks into some
> ops structure in the region.  And I don't think you need to make the
> trigger command NO_LOCK.
> 

So the reason it was made NO_LOCK right now is because the trigger ends
up calling devlink_region_snapshot_id_get and
devlink_region_snapshot_create which both take the devlink lock.

I suppose this could be simplified by having the snapshot callback take
similar parameters as the devlink_region_snapshot_create, and assume the
devlink core code does such things as generating an id and adding the
snapshot to the list all while holding the lock...

I will sort out these questions into what I think makes sense for the
use case I envision, and will submit the core devlink patches at the
same time as the driver changes.

Thanks,
Jake
