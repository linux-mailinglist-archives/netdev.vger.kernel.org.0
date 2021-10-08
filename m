Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235504270D4
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 20:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbhJHSgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231331AbhJHSgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0A260F02;
        Fri,  8 Oct 2021 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633718044;
        bh=C4XM+njwVMoHFFJegGCYRKChHz3qHUyW7keg/w0pheQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t0bPM0GkOpN5fUxuvJOnQFcKVnfpFqDgYTusEKRJEbkaJ/FQfOnkV9EHZiK2NHrHB
         VdGi+zKqZNdB/DmRtDkbBB1uObcJYx+OfdUTMWGdfoZ2+6uxXQbA5jodsg170UIJSo
         sR6viD0ybRqH8TDvaM5/T/qqKfx9761izwA4qcdkqTaFsqUwK08rBIejGxloLbOHyt
         i9ZSKIMRPH96+ih+QSJv2zYmbfD8crxie34ayRGApkYpS5DIt6OHyoxEntfoiRQXu5
         XDynVjiLWEizb7IX848RdCCcgWSTjlCW/JOIBXmdkT6Oyj/TPISmp1yIPhq1al3G+i
         FSRSIKs2LSyhg==
Date:   Fri, 8 Oct 2021 11:34:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net] net: dsa: microchip: Added the condition for
 scheduling ksz_mib_read_work
Message-ID: <20211008113402.0aed1d2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YWBOeP3dHFbEdg8w@lunn.ch>
References: <20211008084348.7306-1-arun.ramadoss@microchip.com>
        <YWBOeP3dHFbEdg8w@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 15:58:16 +0200 Andrew Lunn wrote:
> On Fri, Oct 08, 2021 at 02:13:48PM +0530, Arun Ramadoss wrote:
> > When the ksz module is installed and removed using rmmod, kernel crashes
> > with null pointer dereferrence error. During rmmod, ksz_switch_remove
> > function tries to cancel the mib_read_workqueue using
> > cancel_delayed_work_sync routine.
> > 
> > At the end of  mib_read_workqueue execution, it again reschedule the
> > workqueue unconditionally. Due to which queue rescheduled after
> > mib_interval, during this execution it tries to access dp->slave. But
> > the slave is unregistered in the ksz_switch_remove function. Hence
> > kernel crashes.  
> 
> Something not correct here.
> 
> https://www.kernel.org/doc/html/latest/core-api/workqueue.html?highlight=delayed_work#c.cancel_delayed_work_sync
> 
> This is cancel_work_sync() for delayed works.
> 
> and
> 
> https://www.kernel.org/doc/html/latest/core-api/workqueue.html?highlight=delayed_work#c.cancel_work_sync
> 
> This function can be used even if the work re-queues itself or
> migrates to another workqueue.
> 
> Maybe the real problem is a missing call to destroy_worker()?

Also the cancel_delayed_work_sync() is suspiciously early in the remove
flow. There is a schedule_work call in ksz_mac_link_down() which may 
schedule the work back in. That'd also explain why the patch helps since
ksz_mac_link_down() only schedules if (dev->mib_read_interval).
