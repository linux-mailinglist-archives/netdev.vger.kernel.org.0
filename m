Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD2816F51D
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgBZBhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729346AbgBZBhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:37:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A5D2082F;
        Wed, 26 Feb 2020 01:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582681070;
        bh=t0dSwe3Z461OScLyqyb/A69+seOTjZhsEnI+MACNNn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b880ooVSeZIbNfpNDdfYQPvNg1S2hnK7GQ2iuTxEzGt5dKp6mrSd6JQAbM7z9NuUQ
         wBBqXOe9j2fiNGtUOxVag6BJVuOIDXtp1zL/r8FsvnMLUPekfS3BuXvat/KWDys6BF
         Dghd6+U+WZvd5+CCCRRrXAfXT9g/MrTZZHCIXDdQ=
Date:   Tue, 25 Feb 2020 17:37:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
Message-ID: <20200225173748.7429cd8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200226005744.1623-1-dsahern@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 17:57:44 -0700 David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
> 
> virtio_net currently requires extra queues to install an XDP program,
> with the rule being twice as many queues as vcpus. From a host
> perspective this means the VM needs to have 2*vcpus vhost threads
> for each guest NIC for which XDP is to be allowed. For example, a
> 16 vcpu VM with 2 tap devices needs 64 vhost threads.
> 
> The extra queues are only needed in case an XDP program wants to
> return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
> additional queues. Relax the queue requirement and allow XDP
> functionality based on resources. If an XDP program is loaded and
> there are insufficient queues, then return a warning to the user
> and if a program returns XDP_TX just drop the packet. This allows
> the use of the rest of the XDP functionality to work without
> putting an unreasonable burden on the host.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>

The plan^W hope in my head was that Magnus will expose more info about
NIC queues. Then we can introduce a "manual queue setup" mode for XDP,
where users is responsible for making sure that the cores they care
about have TX/REDIRECT queues (with or without an XDP program attached).
Right now the XDP queues are entirely invisible.

That's just FWIW, in absence of actual code - regardless if it's an
obvious or pointless idea - it may not have much weight in this
discussion..
