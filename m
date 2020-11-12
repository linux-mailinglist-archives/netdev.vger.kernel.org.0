Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A602B12D8
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgKLXqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:46:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:27859 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKLXqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:46:14 -0500
IronPort-SDR: +F/DkG6ljCxlkONaGv0bdO7fw7M2vY01Nz+xmX+07LScRIrA2ellVFK12HYgmvX0g8M5ibQ5Hs
 KNOkC4gIujNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="170506673"
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="170506673"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 15:46:13 -0800
IronPort-SDR: jYVbLpAt3WxNi5IIIvZNfkVOuiGfuVOjBt5URs95iChHdOy3WkqwFELzs6IbfepfRv0yH2/YtA
 PKpyOq1OWRqQ==
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="542450074"
Received: from jlee24-mobl1.amr.corp.intel.com (HELO ellie) ([10.212.177.92])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 15:46:13 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201112093203.GH1559650@localhost>
References: <20201112093203.GH1559650@localhost>
Date:   Thu, 12 Nov 2020 15:46:12 -0800
Message-ID: <87pn4i6svv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miroslav Lichvar <mlichvar@redhat.com> writes:

> Considering how the existing applications work, ideally the
> measurements would be performed on demand from the ioctl to minimize
> the delay. If that's not possible, maybe it would be better to provide
> the measurements on a descriptor at their own rate, which could be
> polled by the applications, similarly to how the PTP_EXTTS_REQUEST
> ioctl works?

I wanted it so using PCIe PTM was transparent to applications, so adding
another API wouldn't be my preference.

That being said, having a trigger from the application to start/stop the
PTM cycles doesn't sound too bad an idea. So, not too opposed to this
idea.

Richard, any opinions here?

> That sounds like it could break in some specific conditions. Please
> try slightly different -R values and when it's running, try inserting
> a step with date -s '+0.1 sec' and see how reliable is the recovery.
> You can also test it with a different servo: phc2sys -E linreg.

Yeah, for some combinations, the disturbances make the recovery take
more time. So, I have to increase the frequency that the PTM cycles are
run. Thanks.

> Is that the case even when there is a PTM-enabled switch between the
> CPU and NIC? My understanding of the spec is that the switches are
> supposed to have their own clocks and have separate PTM dialogs on
> their upstream and downstream ports. In terms of PTP, are the switches
> boundary or transparent clocks?

Yeah, it seems that PCIe PTM switches are indeed more like boundary
clocks i.e. they are Requesters for the Root Complex and Responders for
the endpoints, and the Master time that they provide in their Responses
are in relation to their own clocks.

>
> Yes, I think that would work, except the delay would need to be
> doubled in the T3' calculation. The important thing is that the offset
> and delay calculated from the timestamps don't change. It might be
> better to shift the timestamps back to avoid the "post" timestamp
> coming from future, which applications could drop as invalid. To not
> shift the middlepoints in the conversion, this should work:
>
> T1' = (T2 + T3) / 2 - delay
> T2' = (T1 + T4) / 2
> T3' = (T2 + T3) / 2 + delay

Makes total sense. Thanks a lot!


Cheers,
-- 
Vinicius
