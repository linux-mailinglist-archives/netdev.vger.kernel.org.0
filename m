Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13E818FDCE
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgCWTjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:39:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:64455 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgCWTji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 15:39:38 -0400
IronPort-SDR: 7OJZbzBqm2O5MZGawySYx0I8DSH3/u6GLonHtPM9VcWr6Cp2yzBlzw+g3IVd4/x2LMIs2SgQxw
 odXy0oMEfgpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 12:39:37 -0700
IronPort-SDR: bLGxgqj0hhKTDkIGIglYwy9eloCW44pxeHscCj/ISAKlNrKhyU4uIU/Hee0jGJGYu3aHtHKECf
 /nXGzIZu6kGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="447497884"
Received: from damathew-mobl1.amr.corp.intel.com (HELO ellie) ([10.134.67.34])
  by fmsmga006.fm.intel.com with ESMTP; 23 Mar 2020 12:39:37 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Zh-yuan Ye <ye.zh-yuan@socionext.com>, netdev@vger.kernel.org
Cc:     okamoto.satoru@socionext.com, kojima.masahisa@socionext.com,
        Zh-yuan Ye <ye.zh-yuan@socionext.com>
Subject: Re: [PATCH net v2] net: cbs: Fix software cbs to consider packet sending time
In-Reply-To: <20200323061709.1881-1-ye.zh-yuan@socionext.com>
References: <20200323061709.1881-1-ye.zh-yuan@socionext.com>
Date:   Mon, 23 Mar 2020 12:39:37 -0700
Message-ID: <87tv2edfnq.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Zh-yuan Ye <ye.zh-yuan@socionext.com> writes:

> Currently the software CBS does not consider the packet sending time
> when depleting the credits. It caused the throughput to be
> Idleslope[kbps] * (Port transmit rate[kbps] / |Sendslope[kbps]|) where
> Idleslope * (Port transmit rate / (Idleslope + |Sendslope|)) = Idleslope
> is expected. In order to fix the issue above, this patch takes the time
> when the packet sending completes into account by moving the anchor time
> variable "last" ahead to the send completion time upon transmission and
> adding wait when the next dequeue request comes before the send
> completion time of the previous packet.

Yeah, this improves (a lot) the accuracy of the software mode when
dealing with larger packets:

| Idleslope (packet size) | Old (bps) | New (bps) |
|-------------------------+-----------+-----------|
| 500mbps (100bytes)      | 528M      | 492M      |
| 500mbps (1500bytes)     | 622M      | 499M      |
| 1mbps (100bytes)        | 1007k     | 1006k     |
| 1mbps (1500bytes)       | 1010k     | 1010k     |

(Sorry for the mess of units)

So, when the comments from Jakub are addressed:

Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius

