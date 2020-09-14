Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07922269173
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgINQZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgINQP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:15:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5976217BA;
        Mon, 14 Sep 2020 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600100120;
        bh=mun4vOZkPy/qS1HOgsrkkRTS+Xuhp4Ctb8VYbdF3EjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LpodUA4xCERfYWcLwhSacYTOVjUS4mCUp6CtmGCd5xbaFqPjL+/zfpQakEBAyQHDu
         vmxaQvFcAypkL6R8eGuJU2YHvrQGPjmiLIVaDPpknV8YeMW76le+zBs7Px34CHE0BJ
         lloRZ8qVudVW+aZjjgPrxr5KFOODRSac8orEGcog=
Date:   Mon, 14 Sep 2020 09:15:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914091518.0bcf0d58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200912071612.cq7adzzxxgpcauux@skbuf>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911234932.ncrmapwpqjnphdv5@skbuf>
        <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200912001542.fqn2hcp35xkwqoun@skbuf>
        <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200912071612.cq7adzzxxgpcauux@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Sep 2020 10:16:12 +0300 Vladimir Oltean wrote:
> > You can still append your custom CPU port stats to ethtool -S or
> > debugfs or whatnot,  
> 
> I don't understand, so you're saying that DSA can keep pause stats
> reporting in "ethtool -S", but the rest of devices should move to
> "ethtool -a"?

I'm saying report pause stats via the new interface on normal ports
which have a netdev (external switch ports, CPU MAC).

Deal with the weird CPU port in other, correspondingly weird, ways, 
like ethtool -S :)

> You know that a typical switching chip will report the
> same statistics counters on all ports, including the ones that do have a
> net_device, right?  

I never used a DSA device. But I was under the impression they were
supposed to be modeled like separate NICs..

> So DSA gets a waiver from implementing .get_pause_stats()?
> 
> > but those are only useful for validating that the configuration of the
> > CPU port is not completely broken. Otherwise the counters are
> > symmetrical. A day-to-day user of the device doesn't need to see both
> > of them.  
> 
> A day-to-day user shouldn't need to look at ethtool -S or any other
> statistics for that matter, either. If they need to look at flow control
> on the CPU port they'd better get the full story rather than half of it.

Flow control stats are a really important piece of data on how 
the network operates. And they are part of normal operation of 
the network.

Stats on the "CPU port" should be symmetrical with the CPU MAC.

> Sorry for the non-constructive answer. Like Florian said, it would be
> nice to have some built-in mechanism for this new ndo that DSA could use
> to keep annotating its own stats.

I do sympathize with the challenges of DSA. I never had any good ideas
on how to help with it, TBH. I feel like this is a larger challenge,
adding stats to the already existing (and problematic from DSA
perspective) interface to configure pause frames is not changing the
situation all that much.
