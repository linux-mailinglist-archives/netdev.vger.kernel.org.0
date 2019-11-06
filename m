Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34030F10E0
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbfKFIR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:17:58 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:46918 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729881AbfKFIR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:17:57 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iSGVn-0005sT-OM; Wed, 06 Nov 2019 09:17:55 +0100
Date:   Wed, 6 Nov 2019 08:17:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: hns: Ensure that interface teardown cannot race
 with TX interrupt
Message-ID: <20191106081748.0e21554c@why>
In-Reply-To: <aa7d625e74c74e4b9810b8ea3e437ca4@huawei.com>
References: <20191104195604.17109-1-maz@kernel.org>
        <aa7d625e74c74e4b9810b8ea3e437ca4@huawei.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: salil.mehta@huawei.com, netdev@vger.kernel.org, lipeng321@huawei.com, yisen.zhuang@huawei.com, davem@davemloft.net
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 18:41:11 +0000
Salil Mehta <salil.mehta@huawei.com> wrote:

Hi Salil,

> Hi Marc,
> I tested with the patch on D05 with the lockdep enabled kernel with below options
> and I could not reproduce the deadlock. I do not argue the issue being mentioned
> as this looks to be a clear bug which should hit while TX data-path is running
> and we try to disable the interface.

Lockdep screaming at you doesn't mean the deadly scenario happens in
practice, and I've never seen the machine hanging in these conditions.
But I've also never tried to trigger it in anger.

> Could you please help me know the exact set of steps you used to get into this
> problem. Also, are you able to re-create it easily/frequently?

I just need to issue "reboot" (which calls "ip link ... down") for this
to trigger. Here's a full splat[1], as well as my full config[2]. It is
100% repeatable.

> # Kernel Config options:
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_LOCKDEP=y

You'll need at least 

CONFIG_PROVE_LOCKING=y
CONFIG_NET_POLL_CONTROLLER=y

in order to hit it.

Thanks,

	M.

[1] https://paste.debian.net/1114451/
[2] https://paste.debian.net/1114472/
-- 
Jazz is not dead. It just smells funny...
