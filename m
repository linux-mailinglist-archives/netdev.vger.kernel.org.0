Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2B02B55F0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgKQBGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:06:43 -0500
Received: from mga04.intel.com ([192.55.52.120]:44055 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKQBGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:06:40 -0500
IronPort-SDR: SE83p2291DJo2CI2wdCpAiW3qJb3kg+3T3YHdusKhmknJ5tMZHXlA2ouvTfJLBHNMgivGoPrPW
 0zKmyQG166Kg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="168264736"
X-IronPort-AV: E=Sophos;i="5.77,484,1596524400"; 
   d="scan'208";a="168264736"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 17:06:34 -0800
IronPort-SDR: 6iuQ2P5b0uYvsNEUnXl6Ocy1/RYxIywyS7fYQX2jn8o3mTTVCtMq9u54TDf4sKeBzQFv48Te3p
 75GygF6a54SA==
X-IronPort-AV: E=Sophos;i="5.77,484,1596524400"; 
   d="scan'208";a="430329490"
Received: from iansancx-mobl1.amr.corp.intel.com (HELO ellie) ([10.255.231.171])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 17:06:32 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201114025704.GA15240@hoboy.vegasvil.org>
Date:   Mon, 16 Nov 2020 17:06:30 -0800
Message-ID: <874klo7pwp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Richard Cochran <richardcochran@gmail.com> writes:

> What is a PTM?  Why does a PTM have dialogs?  Can it talk?
>
> Forgive my total ignorance!

:-)

We are talking about PCIe PTM (Precise Time Measurement), basically it's
a PTP-like protocol running on the PCIe fabric.

The PTM dialogs are a pair of messages: a Request from the endpoint (in
my case, the NIC) to the PCIe root (or switch), and a Response from the
other side (this message includes the Master Root Time, and the
calculated propagation delay).

The interface exposed by the NIC I have allows basically to start/stop
these PTM dialogs (I was calling them PTM cycles) and to configure the
interval between each cycle (~1ms - ~512ms).

I also have access to four time stamps:
 - T1, when the NIC sends the Request message;
 - T2, when the PCIe root received the Request message;
 - T3, when the PCIe root sends the Response message;
 - T4, when the NIC receives the Response message;

Actually, I have T1 (on this cycle), T2 (on this and on the previous
cycle), 'T4 - T1' (on this and on the previous cycle) and 'T3 - T2' (on
the previous cycle).

Another thing of note, is that trying to start the PTM dialogs "on
demand" syncronously with the ioctl() doesn't seem too reliable, it
seems to want to be kept running for a longer time.

I think that's it for a "PCIe PTM from a software person" overview :-)


Cheers,
-- 
Vinicius
