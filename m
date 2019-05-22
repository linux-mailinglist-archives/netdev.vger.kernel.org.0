Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0FC26611
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbfEVOj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 10:39:59 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58593 "EHLO
        caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728111AbfEVOj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 10:39:59 -0400
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id 76006460279; Wed, 22 May 2019 10:39:56 -0400 (EDT)
Date:   Wed, 22 May 2019 10:39:56 -0400
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        e1000-devel@lists.sourceforge.net
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec
 packets
Message-ID: <20190522143956.quskqh33ko2wuf47@csclub.uwaterloo.ca>
References: <20190516183407.qswotwyjwtjqfdqm@csclub.uwaterloo.ca>
 <20190516183705.e4zflbli7oujlbek@csclub.uwaterloo.ca>
 <CAKgT0UfSa-dM2+7xntK9tB7Zw5N8nDd3U1n4OSK0gbWbkNSKJQ@mail.gmail.com>
 <CAKgT0Ucd0s_0F5_nwqXknRngwROyuecUt+4bYzWvp1-2cNSg7g@mail.gmail.com>
 <20190517172317.amopafirjfizlgej@csclub.uwaterloo.ca>
 <CAKgT0UdM28pSTCsaT=TWqmQwCO44NswS0PqFLAzgs9pmn41VeQ@mail.gmail.com>
 <20190521151537.xga4aiq3gjtiif4j@csclub.uwaterloo.ca>
 <CAKgT0UfpZ-ve3Hx26gDkb+YTDHvN3=MJ7NZd2NE7ewF5g=kHHw@mail.gmail.com>
 <20190521175456.zlkiiov5hry2l4q2@csclub.uwaterloo.ca>
 <CAKgT0UcR3q1maBmJz7xj_i+_oux_6FQxua9DOjXQSZzyq6FhkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcR3q1maBmJz7xj_i+_oux_6FQxua9DOjXQSZzyq6FhkQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 04:22:17PM -0700, Alexander Duyck wrote:
> So we are either using 0 bits of the LUT or we are just not performing
> hashing because this is somehow being parsed into a type that doesn't
> support it.
> 
> I have attached 2 more patches we can test. The first enables hashing
> on what are called "OAM" packets, The thing is we shouldn't be
> identifying these packets as "OAM", Operations Administration &
> Management, as normally it would have to be recognized as a tunnel
> first and then have a specific flag set in either the GENEVE or
> VXLAN-GPE header. The second patch will dump the contents of the
> HREGION registers. They should all be 0, however I thought it best to
> dump the contents and verify that since I know that these registers
> can be used to change the traffic class of a given packet type and if
> we are encountering that it might be moving it to an uninitialized TC
> which would be using queue offset 0 with 0 bits of the LUT.
> 
> These last 2 patches would pretty much eliminate the entire RSS
> subsystem. If we don't see HREGION values set and the OAM flags have
> no effect I can only assume there is something going on with the
> parser in the NIC since it isn't recognizing the packet type.
> 
> Thanks.
> 
> - Alex

OK I applied those two patches and get this:

i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.1.7-k
i40e: Copyright (c) 2013 - 2014 Intel Corporation.
i40e 0000:3d:00.0: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
i40e 0000:3d:00.0: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
i40e 0000:3d:00.0: MAC address: a4:bf:01:4e:0c:87
i40e 0000:3d:00.0: PFQF_HREGION[7]: 0x00000000
i40e 0000:3d:00.0: PFQF_HREGION[6]: 0x00000000
i40e 0000:3d:00.0: PFQF_HREGION[5]: 0x00000000
i40e 0000:3d:00.0: PFQF_HREGION[4]: 0x00000000
i40e 0000:3d:00.0: PFQF_HREGION[3]: 0x00000000
i40e 0000:3d:00.0: PFQF_HREGION[2]: 0x00000000
i40e 0000:3d:00.0: PFQF_HREGION[1]: 0x00000000
i40e 0000:3d:00.0: PFQF_HREGION[0]: 0x00000000
i40e 0000:3d:00.0: flow_type: 63 input_mask:0x0000000000004000
i40e 0000:3d:00.0: flow_type: 46 input_mask:0x0007fff800000000
i40e 0000:3d:00.0: flow_type: 45 input_mask:0x0007fff800000000
i40e 0000:3d:00.0: flow_type: 44 input_mask:0x0007ffff80000000
i40e 0000:3d:00.0: flow_type: 43 input_mask:0x0007fffe00000000
i40e 0000:3d:00.0: flow_type: 42 input_mask:0x0007fffe00000000
i40e 0000:3d:00.0: flow_type: 41 input_mask:0x0007fffe00000000
i40e 0000:3d:00.0: flow_type: 40 input_mask:0x0007fffe00000000
i40e 0000:3d:00.0: flow_type: 39 input_mask:0x0007fffe00000000
i40e 0000:3d:00.0: flow_type: 36 input_mask:0x0006060000000000
i40e 0000:3d:00.0: flow_type: 35 input_mask:0x0006060000000000
i40e 0000:3d:00.0: flow_type: 34 input_mask:0x0006060780000000
i40e 0000:3d:00.0: flow_type: 33 input_mask:0x0006060600000000
i40e 0000:3d:00.0: flow_type: 32 input_mask:0x0006060600000000
i40e 0000:3d:00.0: flow_type: 31 input_mask:0x0006060600000000
i40e 0000:3d:00.0: flow_type: 30 input_mask:0x0006060600000000
i40e 0000:3d:00.0: flow_type: 29 input_mask:0x0006060600000000
i40e 0000:3d:00.0: flow_type: 27 input_mask:0x00000000002c0000
i40e 0000:3d:00.0: flow_type: 26 input_mask:0x00000000002c0000
i40e 0000:3d:00.0: flow type: 36 update input mask from:0x0006060000000000, to:0x0001801800000000
i40e 0000:3d:00.0: flow type: 35 update input mask from:0x0006060000000000, to:0x0001801800000000
i40e 0000:3d:00.0: flow type: 34 update input mask from:0x0006060780000000, to:0x0001801f80000000
i40e 0000:3d:00.0: flow type: 33 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: flow type: 32 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: flow type: 31 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: flow type: 30 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: flow type: 29 update input mask from:0x0006060600000000, to:0x0001801e00000000

So seems the regions are all 0.

All ipsec packets still hitting queue 0.

-- 
Len Sorensen
