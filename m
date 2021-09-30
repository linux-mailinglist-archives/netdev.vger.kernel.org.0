Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0B741DCDB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352097AbhI3PB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352058AbhI3PBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 11:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AB3761A0C;
        Thu, 30 Sep 2021 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633014000;
        bh=p4etsQ2kxC4qWuoN+FkF9b7fYac9XCCw5/d6cLMlvjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uXC1yojC7O6Yw8BgUg9iDeuVpEYx/1MXBtVgxDx5I5IVH+gyl+W+ngl2MjOEpinGq
         UfaZ4K9AbTS8kY9XaZWwjtI+zFijMh5QEYCBtflGe5HobwMqARQf5ecCg8onXotDoO
         aWLEasbdBqcPICp4pUikR/oFyYlHH26cAYuPyJ/dgLT92TaoESi43oDJD3W/iYQeVx
         R9IJrNropbfoijKrY6dRCDzYzGWHzfc3e5A0oK16s/O+ocvJgXwlaWFd2fTA9z+Qt4
         6/rfwd829S+RSiZs9WGO/KSdHYxFmv+oZtkD213+Hfdk0EnnqFrzqROEJzEip/k8Kj
         uxJUecl2cUXgg==
Date:   Thu, 30 Sep 2021 07:59:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?= 
        <niklas.soderlund@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: bpf: Add an MTU check before offloading BPF
Message-ID: <20210930075959.587f9905@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVXNype34MW7Swu3@bismarck.dyn.berto.se>
References: <20210929152421.5232-1-simon.horman@corigine.com>
        <20210929114748.545f7328@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVXNype34MW7Swu3@bismarck.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 16:46:34 +0200 Niklas S=C3=B6derlund wrote:
> When the MTU is changed after the program is offloaded the check in=20
> nfp_bpf_check_mtu() is consulted and as it checks the MTU differently=20
> and fails the change. Maybe we should align this the other way around=20
> and update the check in nfp_bpf_check_mtu() to match the one in=20
> nfp_net_bpf_load()?

That sounds reasonable. Although I don't remember how reliable the
max_pkt_offset logic is in practice (whether it's actually capable=20
of finding the max offset for realistic programs or it's mostly going
to be set to MAX).

> On a side note the check in nfp_net_bpf_load() allows for BPF programs=20
> to be offloaded that do access data beyond the CMT size limit provided=20
> the MTU is set below the CMT threshold value.

Right, because of variable length offsets verifier will not be able to
estimate max_pkt_offset.

> There should be no real harm in this as the verifier forces bounds
> check so with a MTU small enough it should never happen. But maybe we
> should add a check for this too to prevent such a program to be
> loaded in the first place.
