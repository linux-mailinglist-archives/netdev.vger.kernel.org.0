Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7113A426C30
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhJHOAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:00:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhJHOAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:00:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=M6hWnj+uhcpajBrcSjCeOIuPqgZh5B6D6Y/tykCXlnQ=; b=updv8nC8I8VkyVi9weeHWWNjRX
        RvHsdtPel08EtfKe3pHrZ8Vztr6SwN2J3Y1hXvanndW6zi+O5uMQUQmpjCp6qUY9pikxzV/7yAh74
        nhzXVcqgpmJTfP8Rq3vMhKjNj9k8hVruE86uNxTBCsKW6DA7/N4C6IfkubnEhIDxUNcM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYqO8-00A3tO-Op; Fri, 08 Oct 2021 15:58:16 +0200
Date:   Fri, 8 Oct 2021 15:58:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net] net: dsa: microchip: Added the condition for
 scheduling ksz_mib_read_work
Message-ID: <YWBOeP3dHFbEdg8w@lunn.ch>
References: <20211008084348.7306-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008084348.7306-1-arun.ramadoss@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:13:48PM +0530, Arun Ramadoss wrote:
> When the ksz module is installed and removed using rmmod, kernel crashes
> with null pointer dereferrence error. During rmmod, ksz_switch_remove
> function tries to cancel the mib_read_workqueue using
> cancel_delayed_work_sync routine.
> 
> At the end of  mib_read_workqueue execution, it again reschedule the
> workqueue unconditionally. Due to which queue rescheduled after
> mib_interval, during this execution it tries to access dp->slave. But
> the slave is unregistered in the ksz_switch_remove function. Hence
> kernel crashes.

Something not correct here.

https://www.kernel.org/doc/html/latest/core-api/workqueue.html?highlight=delayed_work#c.cancel_delayed_work_sync

This is cancel_work_sync() for delayed works.

and

https://www.kernel.org/doc/html/latest/core-api/workqueue.html?highlight=delayed_work#c.cancel_work_sync

This function can be used even if the work re-queues itself or
migrates to another workqueue.

Maybe the real problem is a missing call to destroy_worker()?

      Andrew
