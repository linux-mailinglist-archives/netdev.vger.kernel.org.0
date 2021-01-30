Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0793090D8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 01:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhA3AKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 19:10:12 -0500
Received: from mga17.intel.com ([192.55.52.151]:62575 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhA3AKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 19:10:05 -0500
IronPort-SDR: sEctstXD4reieKfcMqGSbVNbMtlcpLgBsNKsv7sXcJC0fjbqFL58e8if6oM3KwpxYvZy+luAIQ
 f62LgiwXiU4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="160272535"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="160272535"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 16:09:23 -0800
IronPort-SDR: Ur2YinL2Kae0O4VJi/LCDT3E/wmwF4cSJkDk00IvEoyN+AiOj7o3Hx+p9BcuwW3OfuSB+YZarp
 hmXpK+jvGzBA==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="475642412"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.127.25]) ([10.212.127.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 16:09:23 -0800
Subject: Re: [PATCH net 4/4] i40e: Revert "i40e: don't report link up for a VF
 who hasn't enabled queues"
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
 <20210128213851.2499012-5-anthony.l.nguyen@intel.com>
 <CA+FuTScbEK+1NBUNCbHNnwOoSB0JtsEv3wEisYAbm082P+K0Rw@mail.gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e27cb35b-a413-ccdd-fa42-d65e7162747f@intel.com>
Date:   Fri, 29 Jan 2021 16:09:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTScbEK+1NBUNCbHNnwOoSB0JtsEv3wEisYAbm082P+K0Rw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2021 12:23 PM, Willem de Bruijn wrote:
> On Thu, Jan 28, 2021 at 4:45 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>>
>> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>>
>> This reverts commit 2ad1274fa35ace5c6360762ba48d33b63da2396c
>>
>> VF queues were not brought up when PF was brought up after being
>> downed if the VF driver disabled VFs queues during PF down.
>> This could happen in some older or external VF driver implementations.
>> The problem was that PF driver used vf->queues_enabled as a condition
>> to decide what link-state it would send out which caused the issue.
>>
>> Remove the check for vf->queues_enabled in the VF link notify.
>> Now VF will always be notified of the current link status.
>> Also remove the queues_enabled member from i40e_vf structure as it is
>> not used anymore. Otherwise VNF implementation was broken and caused
>> a link flap.
>>
>> Fixes: 2ad1274fa35a ("i40e: don't report link up for a VF who hasn't enabled")
>> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> Doesn't this reintroduce the bug that the original patch aimed to solve?
> 
> Commit 2ad1274fa35a itself was also a fix.
> 

Yea this might re-introduce the issue described in that commit. However
I believe the bug in question was due to very old versions of VF
drivers, (including an ancient version of FreeBSD if I recall).

Perhaps there is some better mechanism for handling this, but I think
reverting this is ok given that it causes problems in certain situations
where the link status wasn't reported properly.

Maybe there is a solution for both cases? but I would worry less about
an issue with the incredibly old VFs because we know that the issue is
fixed in newer VF code and the real problem is that the VF driver is
incorrectly assuming link up means it is ready to send.

Thus, I am comfortable with this revert: It simplifies the state for
both the PF and VF.

I would be open to alternatives as long as the issue described here is
also fixed.

Caveat: I was not involved in the decision to revert this and wasn't
aware of it until now, so I almost certainly have out of date information.

Thanks,
Jake
