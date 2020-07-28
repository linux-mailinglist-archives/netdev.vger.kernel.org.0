Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB32231257
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbgG1TSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:18:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:53302 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbgG1TSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:18:32 -0400
IronPort-SDR: ZZlEO0E+JxFAqsVlcV+OcvCDJn9KaIxf/RDJkrqca1gNVKzTV3u03BsLcwDUoTr7c7oAq2bRZM
 MeUAY6HRQMdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="152543409"
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="152543409"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 12:18:31 -0700
IronPort-SDR: A/LWYGtLiV2xMqj0KUz5tLFZ4cw8jmEEYYnpArz/u1f3jU63qCmvONl7hgH20Uj7HbCKKG4IEb
 8OjH9NNg4MOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="434434628"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.199]) ([10.212.32.199])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2020 12:18:30 -0700
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-2-git-send-email-moshe@mellanox.com>
 <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200728135808.GC2207@nanopsycho>
 <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
 <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
Date:   Tue, 28 Jul 2020 12:18:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 11:44 AM, Jakub Kicinski wrote:
> On Tue, 28 Jul 2020 09:47:00 -0700 Jacob Keller wrote:
>> On 7/28/2020 6:58 AM, Jiri Pirko wrote:
>>> But this is needed to maintain the existing behaviour which is different
>>> for different drivers.
>>
>> Which drivers behave differently here?
> 
> I think Jiri refers to mlxsw vs mlx5.
> 
> mlxsw loads firmware on probe, by default at least. So reloading the
> driver implies a FW reset. NIC drivers OTOH don't generally load FW
> so they didn't reset FW.
> 

Ok.

> Now since we're redefining the API from "do a reload so that driverinit
> params are applied" (or "so that all netdevs get spawned in a new
> netns") to "do a reset of depth X" we have to change the paradigm.
> 
> What I was trying to suggest is that we should not have to re-define
> the API like this.

Ok.

> 
> From user perspective what's important is what the reset achieves (and
> perhaps how destructive it is). We can define the reset levels as:
> 
> $ devlink dev reload pci/0000:82:00.0 net-ns-respawn
> $ devlink dev reload pci/0000:82:00.0 driver-param-init
> $ devlink dev reload pci/0000:82:00.0 fw-activate
> 
> combining should be possible when user wants multiple things to happen:
> 
> $ devlink dev reload pci/0000:82:00.0 fw-activate driver-param-init
> 

Where today "driver-param-init" is the default behavior. But didn't we
just say that mlxsw also does the equivalent of fw-activate?

> 
> Then we have the use case of a "live reset" which is slightly
> under-defined right now IMHO, but we can extend it as:
> 
> $ devlink dev reload pci/0000:82:00.0 fw-activate --live
> 

Yea, I think live fw patching things aren't quite as defined yet.

> 
> We can also add the "reset level" specifier - for the cases where
> device is misbehaving:
> 
> $ devlink dev reload pci/0000:82:00.0 level [driver|fw|hardware]
> 

I guess I don't quite see how level fits in? This is orthogonal to the
other settings?

> 
> But I don't think that we can go from the current reload command
> cleanly to just a level reset. The driver-specific default is a bad
> smell which indicates we're changing semantics from what user wants 
> to what the reset depth is. Our semantics with the patch as it stands
> are in fact:
>  - if you want to load new params or change netns, don't pass the level
>    - the "driver default" workaround dictates the right reset level for
>    param init;
>  - if you want to activate new firmware - select the reset level you'd
>    like from the reset level options.
> 

I think I agree, having the "what gets reloaded" as a separate vector
makes sense and avoids confusion. For example for ice hardware,
"fw-activate" really does mean "Do an EMP reset" rather than just a
"device reset" which could be interpreted differently. ice can do
function level reset, or core device reset also. Neither of those two
resets activates firmware.

Additionally the current function load process in ice doesn't support
driver-init at all. That's something I'd like to see happen but is quite
a significant refactor for how the driver loads. We need to refactor
everything out so that devlink is created early on and factor out
load/unload into handlers that can be called by the devlink reload. As I
have primarily been focused on flash update I sort of left that for the
future because it was a huge task to solve.
