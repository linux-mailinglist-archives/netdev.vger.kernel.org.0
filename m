Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F44625E2E8
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 22:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgIDUh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 16:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgIDUh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 16:37:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA60208C7;
        Fri,  4 Sep 2020 20:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599251876;
        bh=3Gc2DiIZI38/XDiSpM58Ie/d4zUcgHiZJLYp3Y5V8uI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PtrF8Dehi8jFSvoMCnBmUx0R56IAJtZMrgbpZ12veC7hBtHDyTJQY4SY0fiydLL8M
         28OrIMpdtHQ4tJ/8ehylaESio8Smz9MdSYHWJvuWwEA/OiLfPCeu7Ie2Z0mCxV74VV
         mgoE0ROse0jiPrk6uTFU1j5XK9fL/LyCbutwC75M=
Date:   Fri, 4 Sep 2020 13:37:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri Goutham <sgoutham@marvell.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "sundeep.lkml@gmail.com" <sundeep.lkml@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Message-ID: <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
        <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
        <20200904083709.GF2997@nanopsycho.orion>
        <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
        <20200904121126.GI2997@nanopsycho.orion>
        <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 12:29:04 +0000 Sunil Kovvuri Goutham wrote:
> > >No, there are 3 drivers registering to 3 PCI device IDs and there can
> > >be many instances of the same devices. So there can be 10's of instances of  
> > AF, PF and VFs.
> > 
> > So you can still have per-pci device devlink instance and use the tracepoint
> > Jakub suggested.
> >   
> 
> Two things
> - As I mentioned above, there is a Crypto driver which uses the same mbox APIs
>   which is in the process of upstreaming. There also we would need trace points.
>   Not sure registering to devlink just for the sake of tracepoint is proper. 
> 
> - The devlink trace message is like this
> 
>    TRACE_EVENT(devlink_hwmsg,
>      . . .
>         TP_printk("bus_name=%s dev_name=%s driver_name=%s incoming=%d type=%lu buf=0x[%*phD] len=%zu",
>                   __get_str(bus_name), __get_str(dev_name),
>                   __get_str(driver_name), __entry->incoming, __entry->type,
>                   (int) __entry->len, __get_dynamic_array(buf), __entry->len)
>    );
> 
>    Whatever debug message we want as output doesn't fit into this.

Make use of the standard devlink tracepoint wherever applicable, and you
can keep your extra ones if you want (as long as Jiri don't object).
