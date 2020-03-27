Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A57195DE3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgC0StO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:49:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:60434 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgC0StO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 14:49:14 -0400
IronPort-SDR: nAgrtefT6AjkeZOsINTX9xZEnQM4lVSJJv48uwq+BhDfKHWNyvmNhvnOWjvorD0eP5ihzppBOX
 zCTNPEmA1oOQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 11:49:14 -0700
IronPort-SDR: cQWuCk25VS05Gli9K1lZx1ao/pZaTeCMyYhTL+3GuPrjNfx+o+LASJLGHvYboquzxS/aLYZ4hL
 waNnd5UQSJug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="241031587"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.251.240.95]) ([10.251.240.95])
  by fmsmga008.fm.intel.com with ESMTP; 27 Mar 2020 11:49:11 -0700
Subject: Re: [RFC] current devlink extension plan for NICs
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326144709.GW11304@nanopsycho.orion>
 <20200326145146.GX11304@nanopsycho.orion>
 <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200327074736.GJ11304@nanopsycho.orion>
 <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <a02cf0e6-98ad-65c4-0363-8fb9d67d2c9c@intel.com>
Date:   Fri, 27 Mar 2020 11:49:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2020 9:38 AM, Jakub Kicinski wrote:
> On Fri, 27 Mar 2020 08:47:36 +0100 Jiri Pirko wrote:
>>> So the queues, interrupts, and other resources are also part
>>> of the slice then?
>>
>> Yep, that seems to make sense.
>>
>>> How do slice parameters like rate apply to NVMe?
>>
>> Not really.
>>
>>> Are ports always ethernet? and slices also cover endpoints with
>>> transport stack offloaded to the NIC?
>>
>> devlink_port now can be either "ethernet" or "infiniband". Perhaps,
>> there can be port type "nve" which would contain only some of the
>> config options and would not have a representor "netdev/ibdev" linked.
>> I don't know.
> 
> I honestly find it hard to understand what that slice abstraction is,
> and which things belong to slices and which to PCI ports (or why we even
> have them).

Looks like slice is a new term for sub function and we can consider this
as a VMDQ VSI(intel terminology) or even a Queue group of a VSI.

Today we expose VMDQ VSI via offloaded MACVLAN. This mechanism should 
allow us to expose it as a separate netdev.

> 
> With devices like NFP and Mellanox CX3 which have one PCI PF maybe it
> would have made sense to have a slice that covers multiple ports, but
> it seems the proposal is to have port to slice mapping be 1:1. And rate
> in those devices should still be per port not per slice.
> 
> But this keeps coming back, and since you guys are doing all the work,
> if you really really need it..

