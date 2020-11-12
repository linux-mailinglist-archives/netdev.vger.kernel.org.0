Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABADF2AFD01
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgKLBca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:30 -0500
Received: from mga05.intel.com ([192.55.52.43]:60195 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbgKLAiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 19:38:25 -0500
IronPort-SDR: vImSEVmcTe9YKHK2cb+/gs7wRxf3u/cR3l+uhXCTLUcUkC3rtviYlJIpuzM/cwBOQTpkfpBa3Q
 N2rX3SPfelaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="254947228"
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="254947228"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 16:38:20 -0800
IronPort-SDR: +jynYNDeVo568Z4aC+hqE2ol7auSkKODpbRi6TeOFSWCcCCjnkWVKFbIQ17I7Lk0cNihWWJbkZ
 TXid8ZgaxYWw==
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="328306845"
Received: from fgueva1x-mobl.amr.corp.intel.com (HELO ellie) ([10.212.101.141])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 16:38:18 -0800
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
Date:   Wed, 11 Nov 2020 16:38:16 -0800
Message-ID: <87imab8l53.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Miroslav Lichvar <mlichvar@redhat.com> writes:

> On Mon, Nov 09, 2020 at 10:10:19PM -0800, Vinicius Costa Gomes wrote:
>> i225 has support for PCIe PTM, which allows us to implement support
>> for the PTP_SYS_OFFSET_PRECISE ioctl(), implemented in the driver via
>> the getcrosststamp() function.
>
> Would it be possible to provide the PTM measurements with the
> PTP_SYS_OFFSET_EXTENDED ioctl instead of PTP_SYS_OFFSET_PRECISE?
>
> As I understand it, PTM is not cross timestamping. It's basically
> NTP over PCIe, which provides four timestamps with each "dialog". From
> the other constants added to the header file it looks like they could
> all be obtained and then they could be converted to the triplets
> returned by the EXTENDED ioctl.
>

There might be a problem, the PTM dialogs start from the device, the
protocol is more or less this:

 1. NIC sends "Request" message, takes T1 timestamp;
 2. Host receives "Request" message, takes T2 timestamp;
 3. Host sends "Response" message, takes T3 timestamp;
 4. NIC receives "Response" message, takes T4 timestamp;

So, T2 and T3 are "host" timestamps and T1 and T4 are NIC timestamps.

That means that the timestamps I have "as is" are a bit different than
the expectations of the EXTENDED ioctl().

Of course I could use T3 (as the "pre" timestamp), T4 as the device
timestamp, and calculate the delay[1], apply it to T3 and get something
T3' as the "post" timestamp (T3' = T3 + delay). But I feel that this
"massaging" would defeat the purpose of using the EXTENDED variant.

Does it make sense? Am I worrying too much?

[1] 
	delay = ((T4 - T1) - (T3 - T2)) / 2



Cheers,
-- 
Vinicius
