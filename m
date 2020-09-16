Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6611326CD54
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgIPU6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgIPQwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 12:52:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36ED3222EA;
        Wed, 16 Sep 2020 16:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600274322;
        bh=rflpX5n+9OObJA8GzIUK1V/BxsZIGf+Dt4zGo4jzs5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=feZ82ZrsZ+ZgI7uB+wqDcLOBx6pjp6unANhcnBAzF9+sdsU3ARzjL9H7JLe9QGque
         +wuBy8qGITyz3UwWl3YRcdpq6I1S62IGvfKL+NpNxFtqQTCNWSPPmiWOohbKSHGMbg
         e1uVVBB8xaUDjBGEwRq5hxKzu0uzlfudWwfFS5/8=
Date:   Wed, 16 Sep 2020 09:38:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Omer Shpigelman <oshpigelman@habana.ai>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
Message-ID: <20200916093840.27112c98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFCwf12o71waoJ9T5kL=M-re8+LzRk+EuzbJARB22wk6+ypQdw@mail.gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
        <20200910161126.30948-13-oded.gabbay@gmail.com>
        <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf113A_=da2fGxgMbq_V0OcHsxdp5MpfHiUfeew+gEdnjaQ@mail.gmail.com>
        <20200910131629.65b3e02c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf10XdCDhLeyiArc29PAJ_7=BGpdiUvFRotvFHieiaRn=aA@mail.gmail.com>
        <20200910133058.0fe0f5e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR02MB552316B9A1635C18F8464116B8230@AM0PR02MB5523.eurprd02.prod.outlook.com>
        <20200914095018.21808fae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf12o71waoJ9T5kL=M-re8+LzRk+EuzbJARB22wk6+ypQdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 15:57:16 +0300 Oded Gabbay wrote:
> On Mon, Sep 14, 2020 at 7:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > What's the use for a networking device which only communicates with
> > itself, other than testing?  
> 
> No use, and we do have a suite of tests that runs from user-space on
> the device after we move the interfaces to loopback mode.
> The main problem, as Omer said, is that we have two H/W bugs:
> 
> 1. Where you need to reset the entire SoC in case you want to move a
> single interface into (or out of) loopback mode. So doing it via
> ethtool will cause a reset to the entire SoC, and if you want to move
> all 10 ports to loopback mode, you need to reset the device 10 times
> before you can actually use that.
> 
> 2. Our 10 ports are divided into 5 groups of 2 ports each, from H/W
> POV. That means if you move port 0 to loopback mode, it will affect
> port 1 (and vice-versa). I don't think we want that behavior.
> 
> That's why we need this specific exception to the rule and do it via
> debugfs. I understand it is not common practice, but due to H/W bugs
> we can't workaround, we ask this exception.

Are those tests open source?

Are you sure you need this upstream? Are your users going to run those
tests?
