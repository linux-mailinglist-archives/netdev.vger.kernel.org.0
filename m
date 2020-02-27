Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083C0170F9F
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgB0EX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:23:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36922 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgB0EX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:23:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AB5315B4632B;
        Wed, 26 Feb 2020 20:23:27 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:23:26 -0800 (PST)
Message-Id: <20200226.202326.295871777946911500.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     socketcan@hartkopp.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com,
        dvyukov@google.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stable@vger.kernel.org
Subject: Re: [PATCH] bonding: do not enslave CAN devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <767580d8-1c93-907b-609c-4c1c049b7c42@pengutronix.de>
References: <20200130133046.2047-1-socketcan@hartkopp.net>
        <767580d8-1c93-907b-609c-4c1c049b7c42@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:23:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue, 25 Feb 2020 21:32:41 +0100

> On 1/30/20 2:30 PM, Oliver Hartkopp wrote:
>> Since commit 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
>> device struct can_dev_rcv_lists") the device specific CAN receive filter lists
>> are stored in netdev_priv() and dev->ml_priv points to these filters.
>> 
>> In the bug report Syzkaller enslaved a vxcan1 CAN device and accessed the
>> bonding device with a PF_CAN socket which lead to a crash due to an access of
>> an unhandled bond_dev->ml_priv pointer.
>> 
>> Deny to enslave CAN devices by the bonding driver as the resulting bond_dev
>> pretends to be a CAN device by copying dev->type without really being one.
>> 
>> Reported-by: syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com
>> Fixes: 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
>> device struct can_dev_rcv_lists")
>> Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> What's the preferred to upstream this? I could take this via the
> linux-can tree.

What I don't get is why the PF_CAN is blindly dereferencing a device
assuming what is behind bond_dev->ml_priv.

If it assumes a device it access is CAN then it should check the
device by comparing the netdev_ops or via some other means.

This restriction seems arbitrary.
