Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3799C146557
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWKES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:04:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgAWKER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:04:17 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07AEE153D60B9;
        Thu, 23 Jan 2020 02:04:05 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:03:59 +0100 (CET)
Message-Id: <20200123.110359.298672160291065670.davem@davemloft.net>
To:     mpe@ellerman.id.au
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        security@kernel.org, ivansprundel@ioactive.com
Subject: Re: [PATCH 2/2] airo: Add missing CAP_NET_ADMIN check in
 AIROOLDIOCTL/SIOCDEVPRIVATE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122040728.8437-2-mpe@ellerman.id.au>
References: <20200122040728.8437-1-mpe@ellerman.id.au>
        <20200122040728.8437-2-mpe@ellerman.id.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 02:04:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>
Date: Wed, 22 Jan 2020 15:07:28 +1100

> The driver for Cisco Aironet 4500 and 4800 series cards (airo.c),
> implements AIROOLDIOCTL/SIOCDEVPRIVATE in airo_ioctl().
> 
> The ioctl handler copies an aironet_ioctl struct from userspace, which
> includes a command. Some of the commands are handled in readrids(),
> where the user controlled command is converted into a driver-internal
> value called "ridcode".
> 
> There are two command values, AIROGWEPKTMP and AIROGWEPKNV, which
> correspond to ridcode values of RID_WEP_TEMP and RID_WEP_PERM
> respectively. These commands both have checks that the user has
> CAP_NET_ADMIN, with the comment that "Only super-user can read WEP
> keys", otherwise they return -EPERM.
> 
> However there is another command value, AIRORRID, that lets the user
> specify the ridcode value directly, with no other checks. This means
> the user can bypass the CAP_NET_ADMIN check on AIROGWEPKTMP and
> AIROGWEPKNV.
> 
> Fix it by moving the CAP_NET_ADMIN check out of the command handling
> and instead do it later based on the ridcode. That way regardless of
> whether the ridcode is set via AIROGWEPKTMP or AIROGWEPKNV, or passed
> in using AIRORID, we always do the CAP_NET_ADMIN check.
> 
> Found by Ilja by code inspection, not tested as I don't have the
> required hardware.
> 
> Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Applied and queued up for -stable.
