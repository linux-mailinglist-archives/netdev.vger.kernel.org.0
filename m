Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110602508EC
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 21:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgHXTLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 15:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgHXTLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 15:11:46 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F962074D;
        Mon, 24 Aug 2020 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598296305;
        bh=RBymF6SwORNMF14zud8wnATR9iwF2EZLrKwrjnmdPq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aoVF4KkCLgMCTmgJ7T0rqng8Utv0OR5fdkq0dpFRyG8rrE2PGLyEOLUpvlkmevloD
         0zPiod9JuTDGoEAqoZDQDJbxKJ5uHWkGDfRIs36tFUNUjazB607fpGhoM8rrhGRD9Y
         MPxok+AEK5CuUlR5+VfBdxEdvjTZs+e0FwVhaok0=
Date:   Mon, 24 Aug 2020 12:11:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200824121143.3b233788@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200823070434.GA400109@shredder>
References: <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
        <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
        <20200821103021.GA331448@shredder>
        <20200821095303.75e6327b@kicinski-fedora-PC1C0HJN>
        <6030824c-02f9-8103-dae4-d336624fe425@gmail.com>
        <20200821165052.6790a7ba@kicinski-fedora-PC1C0HJN>
        <1e5cdd45-d66f-e8e0-ceb7-bf0f6f653a1c@gmail.com>
        <20200821173715.2953b164@kicinski-fedora-PC1C0HJN>
        <90b68936-88cf-4d87-55b0-acf9955ef758@gmail.com>
        <20200822092739.5ba0c099@kicinski-fedora-PC1C0HJN>
        <20200823070434.GA400109@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Aug 2020 10:04:34 +0300 Ido Schimmel wrote:
> > You seem to focus on less relevant points. I primarily care about the
> > statistics being defined and identified by Linux, not every vendor for
> > themselves.  
> 
> Trying to understand how we can move this forward. The issue is with the
> specific VXLAN metrics, but you generally agree with the need for the
> framework? See my two other examples: Cache counters and algorithmic
> TCAM counters.

Yes, we will likely need a way to report design-specific performance
counters no matter what. That said I would prefer to pave the way for
exposing standardized stats first, so the reviewers (e.g. myself) have
a clear place to point folks to. 

My last attempt was to just try to standardize the strings for the
per-netdev TLS offload stats (those are in addition to the /proc stats),
and document them in Documentation/. It turned out to have quite a
high review overhead, and the convergence is not satisfactory.

The only strong use I have right now is FEC stats, and I'm planning to
add IEEE-based counters to devlink ports. The scoping of MAC/PHY
counters to dl-port is, I hope, reasonable, although it remains to be
seen what phy folks think about it.

As I previously said - I think that protocol stats are best exported
from the protocol driver, otherwise the API may need to grow parallel
hierarchies. E.g. semantics of per-queue NIC counters get confusing
unless the are reported with the information about the queues - sadly
no API for that exists. In particular the life time of objects is hard
to match with lifetime of statistics. Similar thing with low
granularity counters related to traffic classification.

Long story short, it's a complicated topic, IDK how much of it I can
expect you to tackle. At the minimum I'd like it if we had a clear
separation between Linux/standard stats that drivers should share, 
and justifiably implementation specific values.

The DEVLINK_..GENERIC identifiers or trying to standardize on strings
are not working for me as a reviewer, and as an infrastructure engineer.
