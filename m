Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4010C70955
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfGVTJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:09:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfGVTJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:09:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66B5A15258BA8;
        Mon, 22 Jul 2019 12:09:57 -0700 (PDT)
Date:   Mon, 22 Jul 2019 12:09:57 -0700 (PDT)
Message-Id: <20190722.120957.1070341687672412139.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, bjking1@us.ibm.com, pradeep@us.ibm.com,
        jarod@redhat.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net
Subject: Re: [PATCH net] bonding: Force slave speed check after link state
 recovery for 802.3ad
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563315910-25634-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1563315910-25634-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 12:09:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Tue, 16 Jul 2019 17:25:10 -0500

> The following scenario was encountered during testing of logical
> partition mobility on pseries partitions with bonded ibmvnic
> adapters in LACP mode.
> 
> 1. Driver receives a signal that the device has been
>    swapped, and it needs to reset to initialize the new
>    device.
> 
> 2. Driver reports loss of carrier and begins initialization.
> 
> 3. Bonding driver receives NETDEV_CHANGE notifier and checks
>    the slave's current speed and duplex settings. Because these
>    are unknown at the time, the bond sets its link state to
>    BOND_LINK_FAIL and handles the speed update, clearing
>    AD_PORT_LACP_ENABLE.
> 
> 4. Driver finishes recovery and reports that the carrier is on.
> 
> 5. Bond receives a new notification and checks the speed again.
>    The speeds are valid but miimon has not altered the link
>    state yet.  AD_PORT_LACP_ENABLE remains off.
> 
> Because the slave's link state is still BOND_LINK_FAIL,
> no further port checks are made when it recovers. Though
> the slave devices are operational and have valid speed
> and duplex settings, the bond will not send LACPDU's. The
> simplest fix I can see is to force another speed check
> in bond_miimon_commit. This way the bond will update
> AD_PORT_LACP_ENABLE if needed when transitioning from
> BOND_LINK_FAIL to BOND_LINK_UP.
> 
> CC: Jarod Wilson <jarod@redhat.com>
> CC: Jay Vosburgh <j.vosburgh@gmail.com>
> CC: Veaceslav Falico <vfalico@gmail.com>
> CC: Andy Gospodarek <andy@greyhouse.net>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied, thanks Thomas.
