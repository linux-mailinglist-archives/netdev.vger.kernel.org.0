Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6661D226E92
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgGTSxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:53:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:12948 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgGTSxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 14:53:01 -0400
IronPort-SDR: ZxW2PBFkWuve1WYXFdD5NTHW49TbbvsudlbtG1uRrL83k6stMUoSH648aHS/r0/l6fd+TLvRD6
 PHwP2ppoRAXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="138087494"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="138087494"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 11:52:59 -0700
IronPort-SDR: cCTUhMqP00i9hnWU91Bqxzc5NEFWmXBZ1a2mvaZAcfV7VCaTlU0Gen9vHJ8vlfhsLLGhX3neyi
 x0b7YA9H7dtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="309951073"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.252.137.6]) ([10.252.137.6])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jul 2020 11:52:58 -0700
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
To:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <078815e8-637c-10d0-b4ec-9485b1be5df0@intel.com>
Date:   Mon, 20 Jul 2020 11:52:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/2020 8:51 AM, Jakub Kicinski wrote:
> On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:
>> This looks odd. You have a single image yet you somehow divide it
>> into "program" and "config" areas. We already have infra in place to
>> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
>> You should have 2 components:
>> 1) "program"
>> 2) "config"
>>

First off, unfortunately at least for ice, the "main" section of NVM
contains both the management firmware as well as config settings. I
don't really have a way to split it up.

This series includes support for updating the main NVM section
containing the management firmware (and some config) "fw.mgmt", as well
as "fw.undi" which contains the OptionROM, and "fw.netlist" which
contains additional configuration TLVs.

The firmware interface allows me to separate the three components, but
does not let me separate the "fw binary" from the "config settings" that
are stored within the main NVM bank. (These fields include other data
like the device MAC address and VPD area of the device too, so using
"config" is a bit of a misnomer).

>> Then it is up to the user what he decides to flash.
> 
> 99.9% of the time users want to flash "all". To achieve "don't flash
> config" with current infra users would have to flash each component 
> one by one and then omit the one(s) which is config (guessing which 
> one that is based on the name).
> 
> Wouldn't this be quite inconvenient?
> 

I also agree here, I'd like to be able to make the "update with the
complete file" just work in the most straight forward  way (i.e. without
erasing stuff by accident) be the default.

The option I'm proposing here is to enable allowing tools to optionally
specify handling this type of overwrite. The goal is to support these
use cases:

a) (default) just update the image, but keep the config and vital data
the same as before the update.

b) overwrite config fields, but keep vital fields the same. Intended to
allow returning configuration to "image defaults". This mostly is
intended in case regular update caused some issues like if somehow the
config preservation didn't work properly.

c) overwrite all fields. The intention here is to allow programming a
customized image during initial setup that would contain new IDs etc. It
is not expected to be used in general, as this does overwrite vital data
like the MAC addresses and such.

So the problem is that the vital data, config data, and firmware
binaries are stored in the same section, without a good way to separate
between them. We program all of these together as one chunk to the
"secondary NVM bank"  and then ask firmware to update. It reads through
and based on our "preservation" setting will update the binaries and
merge the configuration sections.

> In case of MLX is PSID considered config?
> 
