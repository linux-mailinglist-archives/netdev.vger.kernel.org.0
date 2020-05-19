Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6EC1D9B4D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 17:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgESPcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 11:32:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:1474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgESPcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 11:32:41 -0400
IronPort-SDR: WnHdYLnlPULpxuQk7nzd7S1pqAPGA/b2X+IZoA9Oy2QKBM6FKZJlDCsgYtQM5S+lOpjl5KBqZq
 yBA805IQ+yzg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 08:32:41 -0700
IronPort-SDR: /D8eAVIdFAdKR2ZCtY+BpIV7wTp3ROMhUFbR0tChvaBGec4BDg2JXDjaXjdhNNtswao3uiQm2d
 eZOPASOl7pog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="466165188"
Received: from stputhen-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.5.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 08:32:40 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <b33e582f-e0e6-467a-636a-674322108855@ti.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <b33e582f-e0e6-467a-636a-674322108855@ti.com>
Date:   Tue, 19 May 2020 08:32:40 -0700
Message-ID: <87v9ksndnr.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri <m-karicheri2@ti.com> writes:

>> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
>> Frame preemption settings for enp3s0:
>> 	support: supported
>> 	active: active
>> 	supported queues: 0xf
>
> I assume this is will be in sync with ethtool -L output which indicates
> how many tx h/w queues present? I mean if there are 8 h/w queues,
> supported queues will show 0xff.

In this approach, the driver builds these bitmasks, so it's responsible
to keep it consistent with the rest of the stuff that's exposed in
ethtool.

>
>> 	supported queues: 0xe
>  From the command below, it appears this is the preemptible queue mask.
> bit 0  is Q0, bit 1 Q1 and so forth. Right? In that case isn't it more
> clear to display
>          preemptible queues : 0xef
>
> In the above Q7 is express queue and Q6-Q0 are preemptible.

In my case, the controller I have here only has 4 queues, and Queue 0 is
the highest priority one, and it's marked as express.

>
> Also there is a handshake called verify that happens which initiated
> by the h/w to check the capability of peer. It looks like
> not all vendor's hardware supports it and good to have it displayed
> something like
>
>          Verify supported/{not supported}
>
> If Verify is supported, FPE is enabled only if it succeeds. So may be
> good to show a status of Verify if it is supported something like
>          Verify success/Failed
>
>> 	minimum fragment size: 68
>> 
>> 
>> $ ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68 preemptible-queues-mask 0xe
>> 
>> This is a RFC because I wanted to have feedback on some points:
>> 
>>    - The parameters added are enough for the hardware I have, is it
>>      enough in general?
>
> As described above, it would be good to add an optional parameter for
> verify
>
> ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68 
> preemptible-queues-mask 0xe verify on
>

The hardware I have do not support this, but this makes sense.


Cheers,
-- 
Vinicius
