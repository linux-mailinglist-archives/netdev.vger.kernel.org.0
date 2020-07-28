Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15BB231007
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731486AbgG1QoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:44:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:40860 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgG1QoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:44:00 -0400
IronPort-SDR: aYIfmOwNLnspu+cwPFWw4tSAtHI3OjITTfLE/XxPGKEY/WFyBljtMH4KUsJNK1u6URbRhbyVaD
 fz1mv46IDxsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="151241941"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="151241941"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 09:43:58 -0700
IronPort-SDR: K+XeOAXfUmRMKHtJD04fv2VCeyuciQ/yKEwKCkzRr1Ch2lCU04wwHp8AZumnz9kNs9FQkpwoH0
 aBsVPY8VLLbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="434381608"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.199]) ([10.212.32.199])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2020 09:43:58 -0700
Subject: Re: [PATCH net-next RFC 00/13] Add devlink reload level option
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <CAACQVJqNXh0B=oe5W7psiMGc6LzNPujNe2sypWi_SvH5sY=F3Q@mail.gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <a3e20b44-9399-93c1-210f-e3c1172bf60d@intel.com>
Date:   Tue, 28 Jul 2020 09:43:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <CAACQVJqNXh0B=oe5W7psiMGc6LzNPujNe2sypWi_SvH5sY=F3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 10:25 PM, Vasundhara Volam wrote:
> On Mon, Jul 27, 2020 at 4:36 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>>
>> Introduce new option on devlink reload API to enable the user to select the
>> reload level required. Complete support for all levels in mlx5.
>> The following reload levels are supported:
>>   driver: Driver entities re-instantiation only.
>>   fw_reset: Firmware reset and driver entities re-instantiation.
> The Name is a little confusing. I think it should be renamed to
> fw_live_reset (in which both firmware and driver entities are
> re-instantiated).  For only fw_reset, the driver should not undergo
> reset (it requires a driver reload for firmware to undergo reset).
> 

So, I think the differentiation here is that "live_patch" doesn't reset
anything.

>>   fw_live_patch: Firmware live patching only.
> This level is not clear. Is this similar to flashing??
> 
> Also I have a basic query. The reload command is split into
> reload_up/reload_down handlers (Please correct me if this behaviour is
> changed with this patchset). What if the vendor specific driver does
> not support up/down and needs only a single handler to fire a firmware
> reset or firmware live reset command?

In the "reload_down" handler, they would trigger the appropriate reset,
and quiesce anything that needs to be done. Then on reload up, it would
restore and bring up anything quiesced in the first stage.
