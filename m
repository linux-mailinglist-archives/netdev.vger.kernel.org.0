Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B322228715
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbgGURQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:16:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:23029 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730931AbgGURQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:16:33 -0400
IronPort-SDR: w3ctGzQkoat+anVBzrkesDmtycIu5WCa9cVtVjMXqQ7l9sC9lopBe3YU/l5uX++5T5CtHb5+fx
 NF+REDS1MIbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="130269564"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="130269564"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 10:16:32 -0700
IronPort-SDR: gaxZTqT29/seH7cg9037Ynv3Mr2BTGDPLmWqEKZcJnGpiWVpdvwGz4Quw4TpbdpITFaQeQYpBl
 afxTJZB1d66Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="270495651"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.252.139.199]) ([10.252.139.199])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jul 2020 10:16:32 -0700
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set of
 frequently asked questions
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
 <20200720210518.5uddqqbjuci5wxki@skbuf>
 <0fb4754b-6545-f8dc-484f-56aee25796f6@intel.com>
 <20200720221314.xkdbw25nsjsyvgbv@skbuf>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <120430f5-df77-2d56-9801-8e69bd94935a@intel.com>
Date:   Tue, 21 Jul 2020 10:16:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200720221314.xkdbw25nsjsyvgbv@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/2020 3:13 PM, Vladimir Oltean wrote:>
> Yes, indeed, a lot of them are exclusively checking
> "skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS", without any further
> verification that they have hardware timestamping enabled in the first
> place, a lot more than I remembered. Some of the occurrences are
> actually new.
> 
> I think at least part of the reason why this keeps going on is that
> there aren't any hard and fast rules that say you shouldn't do it. When
> there isn't even a convincing percentage of DSA/PHY drivers that do set
> SKBTX_HW_TSTAMP, the chances are pretty low that you'll get a stacked
> PHC driver that sets the flag, plus a MAC driver that checks for it
> incorrectly. So people tend to ignore this case. Even though, if stacked
> DSA drivers started supporting software TX timestamping (which is not
> unlikely, given the fact that this would also give you compatibility
> with PHY timestamping), I'm sure things would change, because more
> people would become aware of the issue once mv88e6xxx starts getting
> affected.
> 
> What I've been trying to do is at least try to get people (especially
> people who have a lot of XP with 1588 drivers) to agree on a common set
> of guidelines that are explicitly written down. I think that's step #1.
> 
> -Vladimir
> 

Right. I think the guideline should be:

This flag indicates to the stack whether or not a hardware Tx timestamp
has been started. It's primary purpose is to prevent sending software
timestamps if a hw timestamp is provided.

1) set the flag whenever you start a tx timestamp

2) do not assume you are the only driver that will set the flag for a
given skb. Use a separate mechanism to decide if that skb is supposed to
have a timestamp.
