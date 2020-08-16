Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25404245734
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 12:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgHPK0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 06:26:22 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:17323 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgHPK0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 06:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597573578; x=1629109578;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=WHBq5dCsYow0KmrNsclDpfutbdII4ik+kZyKtOpv8RY=;
  b=AQ+gKcFln4WsGy0fYF8btbQ8AlLH6Af4RBkW7yyTXHnnBsN23OowBWMW
   JYWFYP8Z4FVUH2REjY5yanPJ1Nkn3+jCChDKFcTp6Bp1jy7Qo+XwtlXEX
   WUwNPzx5EbALqQb17cNmqZxyI2bT57fG+bcWu4FZcYSNcl2yNggUfQhaf
   c=;
X-IronPort-AV: E=Sophos;i="5.76,319,1592870400"; 
   d="scan'208";a="47941306"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 16 Aug 2020 10:26:15 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 6AFBDA1CB6;
        Sun, 16 Aug 2020 10:26:14 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 16 Aug 2020 10:26:13 +0000
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.244) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 16 Aug 2020 10:26:05 +0000
References: <20200812101059.5501-1-shayagr@amazon.com> <20200812101059.5501-2-shayagr@amazon.com> <20200812105219.4c4e3e3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <pj41zleeoapv31.fsf@u4b1e9be9d67d5a.ant.amazon.com> <20200813134111.3d22b6ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
In-Reply-To: <20200813134111.3d22b6ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sun, 16 Aug 2020 13:25:45 +0300
Message-ID: <pj41zlft8mc2fq.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D04UWB003.ant.amazon.com (10.43.161.231) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 13 Aug 2020 15:51:46 +0300 Shay Agroskin wrote:
>> Long answer:
>> The ena_destroy_device() function is called with rtnl_lock() 
>> held, 
>> so it cannot run in parallel with the reset function. Also the 
>> destroy function clears the bit ENA_FLAG_TRIGGER_RESET without 
>> which the reset function just exits without doing anything.
>> 
>> A problem can then only happen when some routine sets the 
>> ENA_FLAG_TRIGGER_RESET bit before the reset function is 
>> executed, 
>> the following describes all functions from which this bit can 
>> be 
>> set:
>
> ena_fw_reset_device() runs from a workqueue, it can be preempted 
> right
> before it tries to take the rtnl_lock. Then after arbitrarily 
> long
> delay it will start again, take the lock, and dereference
> adapter->flags. But adapter could have been long freed at this 
> point.

Missed that the check for the 'flags' field also requires that 
netdev_priv field (adapter variable) would be allocated. Thank you 
for pointing that out, this indeed needs to be fixed. I'll add 
reset work destruction in next patchset.

Thank you for reviewing it
>
> Unless you flush a workqueue or cancel_work_sync() you can never 
> be
> sure it's not scheduled. And I can only see a flush when module 
> is
> unloaded now.

