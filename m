Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD822428E79
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhJKNrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhJKNrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 09:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10E6060E8B;
        Mon, 11 Oct 2021 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633959940;
        bh=0WcCw9f2VehodFi62DgP5LsC7sX0VGHD14Z0bkkKFcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FYnD39fMdIttB5fmStGu2gnl4BPbuIe7gxpshI6HXiEApVCjQEji7l8oiuvdx/U7k
         G+sKTcs9RJBl5rS+eGuvmbNxJXwilygoHrkz4jBYxz14Xo3YpTtvwimsSMsnpXKaYq
         K3BY6mDLaTL2p03TlMpAi+t98AZTYC8KKhGF4NgIJb5yziit8e5fIf2bXD1c+GcinY
         HnWDH8VG0QRQ2CU1cxMdBgkeC6TKeuZ0LljmCki1LHb+BUwua5PXw6zMtKdFRXrBjN
         6tGKwVxEg6aORiuHGpOcGVF9p/NcNaQ0kkYZeqywzsTy0S+ns6EZYIMXgfStZ3r7Rr
         SDQ/fSc1bDeEg==
Date:   Mon, 11 Oct 2021 06:45:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Arun.Ramadoss@microchip.com>
Cc:     <andrew@lunn.ch>, <olteanv@gmail.com>,
        <linux-kernel@vger.kernel.org>, <george.mccollister@gmail.com>,
        <vivien.didelot@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [PATCH net] net: dsa: microchip: Added the condition for
 scheduling ksz_mib_read_work
Message-ID: <20211011064538.7fabf949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <601a427d9d73ef7aa85e50770cce38ecd6e84463.camel@microchip.com>
References: <20211008084348.7306-1-arun.ramadoss@microchip.com>
        <YWBOeP3dHFbEdg8w@lunn.ch>
        <20211008113402.0aed1d2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <601a427d9d73ef7aa85e50770cce38ecd6e84463.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:41:55 +0000 Arun.Ramadoss@microchip.com wrote:
> On Fri, 2021-10-08 at 11:34 -0700, Jakub Kicinski wrote:
> > Also the cancel_delayed_work_sync() is suspiciously early in the
> > remove
> > flow. There is a schedule_work call in ksz_mac_link_down() which may
> > schedule the work back in. That'd also explain why the patch helps
> > since
> > ksz_mac_link_down() only schedules if (dev->mib_read_interval).  
> In this patch, I did two things. Added the if condition for
> rescheduling the queue and other is resetted the mib_read_interval to
> zero.
> As per the cancel_delayed_queue_sync() functionality, Now I tried rmod
> after removing the if condition for resheduling the queue,kernel didn't
> crash. So, concluded that it is not rearm in ksz_mib_read_work  is
> causing the problem but it is due to scheduling in the
> ksz_mac_link_down function. This function is called due to the
> dsa_unregister_switch. Due to resetting of the mib_read_interval to
> zero in switch_remove, the queue is not scheduled in mac_link_down, so
> kernel didn't crash.
> 
> And also, as per suggestion on cancel_delayed_work_sync() is
> suspiciously placed in switch_remove. I undo this patch, and tried just
> by moving the canceling of delayed_work after the dsa_unregister_switch
> function. As expected dsa_unregister_switch calls the
> ksz_mac_link_down, which schedules the mib_read_work. Now, when
> cancel_delayed_work_sync is called, it cancels all the workqueue. As a
> result, module is removed successfully without kernel crash.
> 
> Can I send the updated patch as v1 or new patch with updated commit
> message and description.

Please send a patch with just the second chunk (zeroing
mib_read_interval), you can mark it as v2.
