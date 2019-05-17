Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6AC21C62
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfEQRXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:23:21 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:34527 "EHLO
        caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbfEQRXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 13:23:20 -0400
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id C53C646380B; Fri, 17 May 2019 13:23:17 -0400 (EDT)
Date:   Fri, 17 May 2019 13:23:17 -0400
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec
 packets
Message-ID: <20190517172317.amopafirjfizlgej@csclub.uwaterloo.ca>
References: <CAKgT0UcV2wCr6iUYktZ+Bju_GNpXKzR=M+NLfKhUsw4bsJSiyA@mail.gmail.com>
 <20190503205935.bg45rsso5jjj3gnx@csclub.uwaterloo.ca>
 <20190513165547.alkkgcsdelaznw6v@csclub.uwaterloo.ca>
 <CAKgT0Uf_nqZtCnHmC=-oDFz-3PuSM6=30BvJSDiAgzK062OY6w@mail.gmail.com>
 <20190514163443.glfjva3ofqcy7lbg@csclub.uwaterloo.ca>
 <CAKgT0UdPDyCBsShQVwwE5C8fBKkMcfS6_S5m3T7JP-So9fzVgA@mail.gmail.com>
 <20190516183407.qswotwyjwtjqfdqm@csclub.uwaterloo.ca>
 <20190516183705.e4zflbli7oujlbek@csclub.uwaterloo.ca>
 <CAKgT0UfSa-dM2+7xntK9tB7Zw5N8nDd3U1n4OSK0gbWbkNSKJQ@mail.gmail.com>
 <CAKgT0Ucd0s_0F5_nwqXknRngwROyuecUt+4bYzWvp1-2cNSg7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ucd0s_0F5_nwqXknRngwROyuecUt+4bYzWvp1-2cNSg7g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 09:42:19AM -0700, Alexander Duyck wrote:
> So the patch below/attached should resolve the issues you are seeing
> with your system in terms of UDPv4 RSS. What you should see with this
> patch is the first function to come up will display some "update input
> mask" messages, and then the remaining functions shouldn't make any
> noise about it since the registers being updated are global to the
> device.
> 
> If you can test this and see if it resolves the UDPv4 RSS issues I
> would appreciate it.
> 
> Thanks.
> 
> - Alex
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c
> b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 65c2b9d2652b..c0a7f66babd9 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -10998,6 +10998,58 @@ static int i40e_pf_config_rss(struct i40e_pf *pf)
>                 ((u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(1)) << 32);
>         hena |= i40e_pf_get_default_rss_hena(pf);
> 
> +       for (ret = 64; ret--;) {
> +               u64 hash_inset_orig, hash_inset_update;
> +
> +               if (!(hena & (1ull << ret)))
> +                       continue;
> +
> +               /* Read initial input set value for flow type */
> +               hash_inset_orig = i40e_read_rx_ctl(hw,
> I40E_GLQF_HASH_INSET(1, ret));
> +               hash_inset_orig <<= 32;
> +               hash_inset_orig |= i40e_read_rx_ctl(hw,
> I40E_GLQF_HASH_INSET(0, ret));
> +
> +               /* Copy value so we can compare later */
> +               hash_inset_update = hash_inset_orig;
> +
> +               /* We should be looking at either the entire IPv6 or IPv4
> +                * mask being set. If only part of the IPv6 mask is set, but
> +                * the IPv4 mask is not then we have a garbage mask value
> +                * and need to reset it.
> +                */
> +               switch (hash_inset_orig & I40E_L3_V6_SRC_MASK) {
> +               case I40E_L3_V6_SRC_MASK:
> +               case I40E_L3_SRC_MASK:
> +               case 0:
> +                       break;
> +               default:
> +                       hash_inset_update &= ~I40E_L3_V6_SRC_MASK;
> +                       hash_inset_update |= I40E_L3_SRC_MASK;
> +               }
> +
> +               switch (hash_inset_orig & I40E_L3_V6_DST_MASK) {
> +               case I40E_L3_V6_DST_MASK:
> +               case I40E_L3_DST_MASK:
> +               case 0:
> +                       break;
> +               default:
> +                       hash_inset_update &= ~I40E_L3_V6_DST_MASK;
> +                       hash_inset_update |= I40E_L3_DST_MASK;
> +               }
> +
> +               if (hash_inset_update != hash_inset_orig) {
> +                       dev_warn(&pf->pdev->dev,
> +                                "flow type: %d update input mask
> from:0x%016llx, to:0x%016llx\n",
> +                                ret,
> +                                hash_inset_orig, hash_inset_update);
> +                       i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, ret),
> +                                         (u32)hash_inset_update);
> +                       hash_inset_update >>= 32;
> +                       i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, ret),
> +                                         (u32)hash_inset_update);
> +               }
> +       }
> +
>         i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), (u32)hena);
>         i40e_write_rx_ctl(hw, I40E_PFQF_HENA(1), (u32)(hena >> 32));

> i40e: Debug hash inputs
> 
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> 
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c |   52 +++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 65c2b9d2652b..c0a7f66babd9 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -10998,6 +10998,58 @@ static int i40e_pf_config_rss(struct i40e_pf *pf)
>  		((u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(1)) << 32);
>  	hena |= i40e_pf_get_default_rss_hena(pf);
>  
> +	for (ret = 64; ret--;) {
> +		u64 hash_inset_orig, hash_inset_update;
> +
> +		if (!(hena & (1ull << ret)))
> +			continue;
> +
> +		/* Read initial input set value for flow type */
> +		hash_inset_orig = i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, ret));
> +		hash_inset_orig <<= 32;
> +		hash_inset_orig |= i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, ret));
> +
> +		/* Copy value so we can compare later */
> +		hash_inset_update = hash_inset_orig;
> +
> +		/* We should be looking at either the entire IPv6 or IPv4
> +		 * mask being set. If only part of the IPv6 mask is set, but
> +		 * the IPv4 mask is not then we have a garbage mask value
> +		 * and need to reset it.
> +		 */
> +		switch (hash_inset_orig & I40E_L3_V6_SRC_MASK) {
> +		case I40E_L3_V6_SRC_MASK:
> +		case I40E_L3_SRC_MASK:
> +		case 0:
> +			break;
> +		default:
> +			hash_inset_update &= ~I40E_L3_V6_SRC_MASK;
> +			hash_inset_update |= I40E_L3_SRC_MASK;
> +		}
> +
> +		switch (hash_inset_orig & I40E_L3_V6_DST_MASK) {
> +		case I40E_L3_V6_DST_MASK:
> +		case I40E_L3_DST_MASK:
> +		case 0:
> +			break;
> +		default:
> +			hash_inset_update &= ~I40E_L3_V6_DST_MASK;
> +			hash_inset_update |= I40E_L3_DST_MASK;
> +		}
> +
> +		if (hash_inset_update != hash_inset_orig) {
> +			dev_warn(&pf->pdev->dev,
> +				 "flow type: %d update input mask from:0x%016llx, to:0x%016llx\n",
> +				 ret,
> +				 hash_inset_orig, hash_inset_update);
> +			i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, ret),
> +					  (u32)hash_inset_update);
> +			hash_inset_update >>= 32;
> +			i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, ret),
> +					  (u32)hash_inset_update);
> +		}
> +	}
> +
>  	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), (u32)hena);
>  	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(1), (u32)(hena >> 32));
>  

OK I applied that and see this:

i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.1.7-k
i40e: Copyright (c) 2013 - 2014 Intel Corporation.
i40e 0000:3d:00.0: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
i40e 0000:3d:00.0: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
i40e 0000:3d:00.0: MAC address: a4:bf:01:4e:0c:87
i40e 0000:3d:00.0: flow type: 36 update input mask from:0x0006060000000000, to:0x0001801800000000
i40e 0000:3d:00.0: flow type: 35 update input mask from:0x0006060000000000, to:0x0001801800000000
i40e 0000:3d:00.0: flow type: 34 update input mask from:0x0006060780000000, to:0x0001801f80000000
i40e 0000:3d:00.0: flow type: 33 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: flow type: 32 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: flow type: 31 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: flow type: 30 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: flow type: 29 update input mask from:0x0006060600000000, to:0x0001801e00000000
i40e 0000:3d:00.0: Features: PF-id[0] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
i40e 0000:3d:00.1: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
i40e 0000:3d:00.1: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
i40e 0000:3d:00.1: MAC address: a4:bf:01:4e:0c:88
i40e 0000:3d:00.1: Features: PF-id[1] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
i40e 0000:3d:00.1 eth2: NIC Link is Up, 1000 Mbps Full Duplex, Flow Control: None

Unfortunately (much to my disappointment, I hoped it would work) I see
no change in behaviour.

-- 
Len Sorensen
