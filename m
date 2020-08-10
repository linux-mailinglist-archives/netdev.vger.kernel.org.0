Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B66240BA1
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 19:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgHJRJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 13:09:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:8667 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgHJRJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 13:09:23 -0400
IronPort-SDR: PvpUiRzV0oek/zZzDMAl9MAty/tX1LyOs1iSCpTqBV41zmnFPMr6yM0gIi1fkWTIKQinbBAPpu
 qWFnJM3e6AaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="133630811"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="133630811"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 10:09:21 -0700
IronPort-SDR: iZut7GBHlDeMafCg7UvFI04A5jv8ZrPZPJUM6AMxaU1Mr5anJx9COND9DWsou8bk3tJfGbFJei
 2MOCfEDLIQMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="469112050"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.12.231]) ([10.212.12.231])
  by orsmga005.jf.intel.com with ESMTP; 10 Aug 2020 10:09:21 -0700
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
References: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
 <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
 <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
 <20200803141442.GB2290@nanopsycho>
 <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200804100418.GA2210@nanopsycho>
 <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200805110258.GA2169@nanopsycho>
 <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8b06ade2-dfbe-8894-0d6a-afe9c2f41b4e@mellanox.com>
 <20200810095305.0b9661ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <4c25811f-e571-e39d-f25c-59b821264b3f@intel.com>
Date:   Mon, 10 Aug 2020 10:09:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <20200810095305.0b9661ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/2020 9:53 AM, Jakub Kicinski wrote:
> On Sun, 9 Aug 2020 16:21:29 +0300 Moshe Shemesh wrote:
>> Okay, so devlink reload default for mlx5 will include also fw-activate 
>> to align with mlxsw default.
>>
>> Meaning drivers that supports fw-activate will add it to the default.
> 
> No per-driver default.
> 
> Maybe the difference between mlxsw and mlx5 can be simply explained by
> the fact that mlxsw loads firmware from /lib/firmware on every probe
> (more or less).
> 
> It's only natural for a driver which loads FW from disk to load it on
> driver reload.
> 

This seems reasonable to me as long as the drivers document this
behavior in their devlink/<driver>.rst. We shouldn't change existing
behavior. One could argue that this difference in behavior amounts to a
"driver default"... but I agree that we shouldn't enshrine that in the
interface.


>> The flow of devlink reload default on mlx5 will be:
>>
>> If there is FW image pending and live patch is suitable to apply, do 
>> live patch and driver re-initialization.
>>
>> If there is FW image pending but live patch doesn't fit do fw-reset and 
>> driver-initialization.
>>
>> If no FW image pending just do driver-initialization.
> 
> This sounds too complicated. Don't try to guess what the user wants.
> >> I still think I should on top of that add the level option to be
>> selected by the user if he prefers a specific action, so the uAPI would be:
>>
>> devlink dev reload [ netns { PID | NAME | ID } ] [ level { fw-live-patch 
>> | driver-reinit |fw-activate } ]
> 
> I'm all for the level/action.
> 

Yep, same here.

>> But I am still missing something: fw-activate implies that it will 
>> activate a new FW image stored on flash, pending activation. What if the 
>> user wants to reset and reload the FW if no new FW pending ? Should we 
>> add --force option to fw-activate level ?
> 
> Since reload does not check today if anything changed - i.e. if reload
> is actually needed, neither should fw-activate, IMO. I'd expect the
> "--force behavior" to be the default.
> 

Yep. What about if there is HW/FW that can't initiate the fw-activate
reset unless there is a pending update? I think ice firmware might
respond to the "please reset/activate" command with a specific status
code indicating that no update was pending.

I think the simplest solution is to just interpret this as a success.
Alternatively we could report a specific error to inform user that no
activation took place?
