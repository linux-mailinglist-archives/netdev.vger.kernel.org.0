Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCA226921A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgINQvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgINQuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:50:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F0D20829;
        Mon, 14 Sep 2020 16:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600102221;
        bh=fjDVxTT4iFv5fMkMhLJSlhBi4P9qMYMhYAv6LFdtSMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GRiu9srCw2nY3msEykEVdDAyg8cDJ6cMq0JmZgQgyoNESbX9zG0L0POfmo77QK/ra
         OAw7ypT9ACL+QIZLoVu2FUDc9o87C7oHNPEmjYqGcxkls9xkrtvSCuMLw+G5wLSW15
         G5tRpPKd/7AQK3ei2W/csQSFAuvdNUFKvdgw6jRo=
Date:   Mon, 14 Sep 2020 09:50:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Omer Shpigelman <oshpigelman@habana.ai>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
Message-ID: <20200914095018.21808fae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM0PR02MB552316B9A1635C18F8464116B8230@AM0PR02MB5523.eurprd02.prod.outlook.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
        <20200910161126.30948-13-oded.gabbay@gmail.com>
        <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf113A_=da2fGxgMbq_V0OcHsxdp5MpfHiUfeew+gEdnjaQ@mail.gmail.com>
        <20200910131629.65b3e02c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf10XdCDhLeyiArc29PAJ_7=BGpdiUvFRotvFHieiaRn=aA@mail.gmail.com>
        <20200910133058.0fe0f5e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR02MB552316B9A1635C18F8464116B8230@AM0PR02MB5523.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 13:48:14 +0000 Omer Shpigelman wrote:
> On Thu, Sep 10, 2020 at 11:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 10 Sep 2020 23:17:59 +0300 Oded Gabbay wrote:  
> > > > Doesn't seem like this one shows any more information than can be
> > > > queried with ethtool, right?  
> > > correct, it just displays it in a format that is much more readable  
> > 
> > You can cat /sys/class/net/$ifc/carrier if you want 0/1.
> >   
> > > > > nic_mac_loopback
> > > > > is to set a port to loopback mode and out of it. It's not really
> > > > > configuration but rather a mode change.  
> > > >
> > > > What is this loopback for? Testing?  
> > >
> > > Correct.  
> > 
> > Loopback test is commonly implemented via ethtool -t  
> 
> This debugfs entry is only to set the port to loopback mode, not running a loopback test.
> Hence IMO adding a private flag is more suitable here and please correct me if I'm wrong.
> But either way, doing that from ethtool instead of debugfs is not a good practice in our case.
> Due to HW limitations, when we switch a port to/from loopback mode, we need to reset the device.
> Since ethtool works on specific interface rather than an entire device, we'll need to reset the device 10 times in order to switch the entire device to loopback mode.
> Moreover, running this command for one interface affects other interfaces which is not desirable when using ethtool AFAIK.
> Is there any other acceptable debugfs-like mechanism for that?

What's the use for a networking device which only communicates with
itself, other than testing?
