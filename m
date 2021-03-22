Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275983449A0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCVPse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:48:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:18507 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhCVPr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 11:47:56 -0400
IronPort-SDR: 3XKcPPGksjcWB1oqEEg+CO8Pu+VWbIc8jgvw45F64/f+ipoXWJ1u9K+Kbmj2HGe22JALuLgfrA
 eZW5ocZ1p7ig==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="254295218"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="254295218"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 08:47:55 -0700
IronPort-SDR: TZEUZdZLl44sVFSK6KXCk76loEa+NgbKDVRw/xzbvUQR4XfBwfeqfKciBlZNMK76b8PUHyig5o
 HZLnuyhZheLw==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="451780716"
Received: from canguven-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.255.87.118])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 08:47:55 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201110180719.GA1559650@localhost>
References: <20201110061019.519589-1-vinicius.gomes@intel.com>
 <20201110061019.519589-4-vinicius.gomes@intel.com>
 <20201110180719.GA1559650@localhost>
Date:   Mon, 22 Mar 2021 08:47:54 -0700
Message-ID: <875z1jkx5h.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miroslav Lichvar <mlichvar@redhat.com> writes:

> On Mon, Nov 09, 2020 at 10:10:19PM -0800, Vinicius Costa Gomes wrote:
>> i225 has support for PCIe PTM, which allows us to implement support
>> for the PTP_SYS_OFFSET_PRECISE ioctl(), implemented in the driver via
>> the getcrosststamp() function.
>
> Would it be possible to provide the PTM measurements with the
> PTP_SYS_OFFSET_EXTENDED ioctl instead of PTP_SYS_OFFSET_PRECISE?

Sorry for the long delay.

About PTP_SYS_OFFSET_EXTENDED, I did play with it a bit, but I didn't
like it too much: because I don't have access to all the timestamps from
the same "cycle", I ended up having to run two cycles to retrieve all
the information.

So, the new version will expose the timestamps via
PTP_SYS_OFFSET_PRECISE, later we can think of PTP_SYS_OFFSET_EXTENDED.

>
> As I understand it, PTM is not cross timestamping. It's basically
> NTP over PCIe, which provides four timestamps with each "dialog". From
> the other constants added to the header file it looks like they could
> all be obtained and then they could be converted to the triplets
> returned by the EXTENDED ioctl.
>
> The main advantage would be that it would provide applications with
> the round trip time, which is important to estimate the maximum error
> in the measurement. As your example phc2sys output shows, with the
> PRECISE ioctl the delay is 0, which is misleading here.
>
> I suspect the estimate would be valid only when the NIC is connected
> directly to the PTM root (PCI root complex). Is it possible to get the
> timestamps or delay from PTM-capable switches on the path between CPU
> and NIC? Also, how frequent can be the PTM dialogs? Could they be
> performed synchronously in the ioctl?
>
> -- 
> Miroslav Lichvar
>


Cheers,
-- 
Vinicius
