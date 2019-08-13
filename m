Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4E8BE9E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfHMQbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:31:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:49367 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfHMQbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 12:31:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 09:31:22 -0700
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="170447589"
Received: from tsduncan-ubuntu.jf.intel.com (HELO [10.7.169.130]) ([10.7.169.130])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 13 Aug 2019 09:31:22 -0700
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
From:   Terry Duncan <terry.s.duncan@linux.intel.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S.Miller" <davem@davemloft.net>,
        William Kennington <wak@google.com>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
 <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
 <20190808133209.GB32706@lunn.ch>
 <77762b10-b8e7-b8a4-3fc0-e901707a1d54@fb.com>
 <20190808211629.GQ27917@lunn.ch>
 <ac22bbe0-36ca-b4b9-7ea7-7b1741c2070d@fb.com>
 <20190808230312.GS27917@lunn.ch>
 <f1519844-4e21-a9a4-1a69-60c37bd07f75@fb.com>
 <10079A1AC4244A41BC7939A794B72C238FCE0E03@fmsmsx104.amr.corp.intel.com>
 <bc9da695-3fd3-6643-8e06-562cc08fbc62@linux.intel.com>
To:     Tao Ren <taoren@fb.com>
Message-ID: <dc0382c9-7995-edf5-ee1c-508b0f759c3d@linux.intel.com>
Date:   Tue, 13 Aug 2019 09:31:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <bc9da695-3fd3-6643-8e06-562cc08fbc62@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tao, in your new patch will it be possible to disable the setting of the 
BMC MAC?  I would like to be able to send NCSI_OEM_GET_MAC perhaps with 
netlink (TBD) to get the system address without it affecting the BMC 
address.

I was about to send patches to add support for the Intel adapters when I 
saw this thread.

Thanks,

Terry

>>> 	After giving it more thought, I'm thinking about adding ncsi dt node
>>> with following structure (mac/ncsi similar to mac/mdio/phy):
>>>
>>> &mac0 {
>>>      /* MAC properties... */
>>>
>>>      use-ncsi;
>> This property seems to be specific to Faraday FTGMAC100. Are you going
>> to make it more generic?
> I'm also using ftgmac100 on my platform, and I don't have plan to change this property.
>
>>>      ncsi {
>>>          /* ncsi level properties if any */
>>>
>>>          package@0 {
>> You should get Rob Herring involved. This is not really describing
>> hardware, so it might get rejected by the device tree maintainer.
> Got it. Thank you for the sharing, and let me think it over :-)
>
>>> 1) mac driver doesn't need to parse "mac-offset" stuff: these
>>> ncsi-network-controller specific settings should be parsed in ncsi
>>> stack.
>>> 2) get_bmc_mac_address command is a channel specific command, and
>>> technically people can configure different offset/formula for
>>> different channels.
>> Does that mean the NCSA code puts the interface into promiscuous mode?
>> Or at least adds these unicast MAC addresses to the MAC receive
>> filter? Humm, ftgmac100 only seems to support multicast address
>> filtering, not unicast filters, so it must be using promisc mode, if
>> you expect to receive frames using this MAC address.
> Uhh, I actually didn't think too much about this: basically it's how to configure frame filtering when there are multiple packages/channels active: single BMC MAC or multiple BMC MAC is also allowed?
> I don't have the answer yet, but will talk to NCSI expert and figure it out.
>
>
> Thanks,
>
> Tao
>
>
