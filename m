Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1016243A52
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 14:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHMMw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 08:52:28 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:36781 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgHMMw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 08:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597323146; x=1628859146;
  h=references:from:to:cc:subject:in-reply-to:message-id:
   date:mime-version;
  bh=r0DcpExpJa6djEv/ubJy4Hbk7Y2MtNDr+HK/Q6Qm+D8=;
  b=ujlwx57hHJZnUzdEyGs58PkclfyvGnCJYMmbkIkK5eIlPsjW0a5WMnX8
   ZFh13aXXADalcv+vfxxdVPEGXmPNlrQbnLv+eEarunUzEH8QF6YHYnlEM
   nyE8TV3HqnTefwgxqfCH4NQVpPDINIRGBQCZc/eDMGelC8yZHG2WENk3Q
   c=;
IronPort-SDR: 5H1YQ3RPaKv9DxuyBELs6GcZfRRhaPsy2UwJ+1Ai1bKOVt1F922McyNjLfs4juYQW1u0T+EPaj
 8Wihn9ugYyew==
X-IronPort-AV: E=Sophos;i="5.76,308,1592870400"; 
   d="scan'208";a="47756868"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 13 Aug 2020 12:52:10 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 4B7B1A18C0;
        Thu, 13 Aug 2020 12:52:09 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 13 Aug 2020 12:52:08 +0000
Received: from u4b1e9be9d67d5a.ant.amazon.com.amazon.com (10.43.162.248) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 13 Aug 2020 12:51:59 +0000
References: <20200812101059.5501-1-shayagr@amazon.com> <20200812101059.5501-2-shayagr@amazon.com> <20200812105219.4c4e3e3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: Re: [PATCH V1 net 1/3] net: ena: Prevent reset after device destruction
In-Reply-To: <20200812105219.4c4e3e3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <pj41zleeoapv31.fsf@u4b1e9be9d67d5a.ant.amazon.com>
Date:   Thu, 13 Aug 2020 15:51:46 +0300
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13D10UWA004.ant.amazon.com (10.43.160.64) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 12 Aug 2020 13:10:57 +0300 Shay Agroskin wrote:
>> This patch also removes the destruction of the timer and reset 
>> services
>> from ena_remove() since the timer is destroyed by the 
>> destruction
>> routine and the reset work is handled by this patch.
>
> You'd still have a use after free if the work runs after the 
> device is
> removed. I think cancel_work_sync() gotta stay.

Hi, thank you for reviewing the patch. Short answer: I verified 
that the ENA_FLAG_TRIGGER_RESET flag cannot be set after 
ena_destroy_device() finishes its execution.

Long answer:
The ena_destroy_device() function is called with rtnl_lock() held, 
so it cannot run in parallel with the reset function. Also the 
destroy function clears the bit ENA_FLAG_TRIGGER_RESET without 
which the reset function just exits without doing anything.

A problem can then only happen when some routine sets the 
ENA_FLAG_TRIGGER_RESET bit before the reset function is executed, 
the following describes all functions from which this bit can be 
set:

- check_* functions: these function are called from the timer 
  routine which is destroyed in ena_destroy_device(), so by the 
  time the rtnl_lock() released, the bit is cleared

- napi related functions (io_poll, xdp_io_poll, validate_rx_req_id 
  etc.): the napi is de-registered in ena_destroy_device(), so 
  none of these functions is called after destroying the device.

- xmit functions (ena_xmit_common, ena_tx_timeout): the device is 
  brought down and all its RX/TX resources are freed before 
  releasing the lock.

These are all the occurrences I found. Without this bit set, the 
reset function would fail the 'if' check in this patch, and exit 
without doing anything. Destroying the reset function explicitly 
won't help since by the time we do it, the function can already be 
executed.
