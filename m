Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB201C06B1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgD3Tpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgD3Tpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 15:45:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88D9B20731;
        Thu, 30 Apr 2020 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588275951;
        bh=f30CWtOeq/YGIq1fCEJyUWgIm3FXXF4hIzQkpzlKrEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CnlQXSN8tBshqbPhBAwlx6pYCltZ+po/zgeS8oxgxpZvqxDyF0qTUnpwmTotDo49n
         iH3JS0EJZsBBrZHWpnGoam31EFTCFi3wE6+bDZLeiL1jrr4/d89PSdA4o/qzqRppP3
         SP747F9sM3vGwdomxbEVPl4g+A5Y9nIvJH8Oj3mQ=
Date:   Thu, 30 Apr 2020 12:45:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next V2] net: sched: fallback to qdisc noqueue if
 default qdisc setup fail
Message-ID: <20200430124549.3272afb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <158824694174.2180470.8094886910962590764.stgit@firesoul>
References: <158824694174.2180470.8094886910962590764.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Apr 2020 13:42:22 +0200 Jesper Dangaard Brouer wrote:
> Currently if the default qdisc setup/init fails, the device ends up with
> qdisc "noop", which causes all TX packets to get dropped.
> 
> With the introduction of sysctl net/core/default_qdisc it is possible
> to change the default qdisc to be more advanced, which opens for the
> possibility that Qdisc_ops->init() can fail.
> 
> This patch detect these kind of failures, and choose to fallback to
> qdisc "noqueue", which is so simple that its init call will not fail.
> This allows the interface to continue functioning.
> 
> V2:
> As this also captures memory failures, which are transient, the
> device is not kept in IFF_NO_QUEUE state.  This allows the net_device
> to retry to default qdisc assignment.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

I have mixed feelings about this one, I wonder if I'm the only one.
Seems like failure to allocate the default qdisc is pretty critical,
the log message may be missed, especially in the boot time noise.

I think a WARN_ON() is in order here, I'd personally just replace the
netdev_info with a WARN_ON, without the fallback.
