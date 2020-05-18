Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D061E1D89A3
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgERU4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERU4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 16:56:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CAC120756;
        Mon, 18 May 2020 20:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589835375;
        bh=4N2NV+A8v59EI3FlZCS7kqqVV25Ey+qrUTEoVhSLYmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z1Tje6iHHbHZzT0XFlmcj0fX1H8DWEbp7xUTTYthaiNtviiKw7AAIkWJY29a9Xy0K
         d+ZSx2mehC7iww5XjGbzRNijTBnpqKb+yz/sypmi6gF76bNrpBYjS2yr/CXEs4MnKA
         2xEtz9wJcxVd9EY7u+IqAD8d88u3TCoqv1WCLXdA=
Date:   Mon, 18 May 2020 13:56:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     David Miller <davem@davemloft.net>, olteanv@gmail.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com, po.liu@nxp.com,
        m-karicheri2@ti.com, Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
Message-ID: <20200518135613.379f6a63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87wo59oyhr.fsf@intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
        <20200516.133739.285740119627243211.davem@davemloft.net>
        <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
        <20200516.151932.575795129235955389.davem@davemloft.net>
        <87wo59oyhr.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 12:05:04 -0700 Vinicius Costa Gomes wrote:
> David Miller <davem@davemloft.net> writes:
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Date: Sun, 17 May 2020 00:03:39 +0300
> >  
> >> As to why this doesn't go to tc but to ethtool: why would it go to tc?  
> >
> > Maybe you can't %100 duplicate the on-the-wire special format and
> > whatever, but the queueing behavior ABSOLUTELY you can emulate in
> > software.  
> 
> Just saying what Vladimir said in different words: the queueing behavior
> is already implemented in software, by mqprio or taprio, for example.
> 
> That is to say, if we add frame preemption support to those qdiscs all
> they will do is pass the information to the driver, and that's it. They
> won't be able to use that information at all.
> 
> The mental model I have for this feature is that is more similar to the
> segmentation offloads, energy efficient ethernet or auto-negotiation
> than it is to a traffic shaper like CBS.

Please take a look at the example from the cover letter:

$ ethtool $ sudo ./ethtool --show-frame-preemption
enp3s0 Frame preemption settings for enp3s0:
	support: supported
	active: active
	supported queues: 0xf
	supported queues: 0xe
	minimum fragment size: 68

Reading this I have no idea what 0xe is. I have to go and query TC API
to see what priorities and queues that will be. Which IMHO is a strong
argument that this information belongs there in the first place.
