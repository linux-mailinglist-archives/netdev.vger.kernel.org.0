Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AA72B8905
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgKSAWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:22:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:8363 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgKSAWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:22:38 -0500
IronPort-SDR: /gR/RQUI4w6Y5AAkrS1Wb0hVIqXu0++qQHvd3Fuh7Hgkd1C3imv/4g5mtvPIKldJsXWV9HtbW1
 wrzTLgbfWoRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="151056275"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="151056275"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:22:38 -0800
IronPort-SDR: WolBowoaeNrGJ0peStyiP01po1wnNwy2OasZK67igl9TNe+Fffxtkf9DoW7u78zFQ8bwu+eUWi
 +fCfEpL8XUDA==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="532953743"
Received: from prasadpr-mobl.amr.corp.intel.com (HELO ellie) ([10.212.21.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:22:38 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201118125451.GC23320@hoboy.vegasvil.org>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com> <20201117014926.GA26272@hoboy.vegasvil.org>
 <87d00b5uj7.fsf@intel.com> <20201118125451.GC23320@hoboy.vegasvil.org>
Date:   Wed, 18 Nov 2020 16:22:37 -0800
Message-ID: <87wnyi2o1e.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Richard Cochran <richardcochran@gmail.com> writes:

> On Tue, Nov 17, 2020 at 05:21:48PM -0800, Vinicius Costa Gomes wrote:
>> Agreed that would be easiest/simplest. But what I have in hand seems to
>> not like it, i.e. I have an earlier series implementing this "one shot" way
>> and it's not reliable over long periods of time or against having the
>> system time adjusted.
>
> Before we go inventing a new API, I think we should first understand
> why the one shot thing fails.

Talking with the hardware folks, they recommended using the periodic
method, the one shot method was implemented as a debug/evaluation aid.

The explanation I have is something along these lines: the hardware
keeps track of the "delta" between the Master Time and its own clock,
and uses it to calculate the timestamps exposed in the NIC registers. To
have a better "delta" it needs more samples. And so it has improved
stability when PTM dialogs happen more continuously, and that's the
recommended way.

The PCIe PTM specification doesn't suggest how the timestamps need to be
exposed/calculated, and how long it needs to run, and it sounded to me
that other implementations could have similar behavior.

>
> If there is problem with the system time being adjusted during PTM,
> then that needs solving in any case!

When PTM is running in the periodic mode, system clock adjustments are
handled fine.


Cheers,
-- 
Vinicius
