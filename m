Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348BD21CBEE
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGLWjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:39:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32362 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727795AbgGLWjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594593587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LFfzGviOYxW9rceC8tkrnK7xNZwZvK4+TkMyAjQ4oe0=;
        b=VVM3P9nILTX7SI46lvsO2OuquVHaF01LxX/wFr38YXJeDMqxVuvLKZ+qvtDIC1RRBxooJT
        4UE2X8ermhAl6lNW5gL9DIW/KUjNQWgd7uKt7jAfc0YTdKUXzCkuz02gCyXN4ErGemYCcf
        d79M4Rjkm2SY7HAP8IoDm73MnglHuc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-Yr4dUYENPUCUTdUGJNsLJw-1; Sun, 12 Jul 2020 18:39:45 -0400
X-MC-Unique: Yr4dUYENPUCUTdUGJNsLJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 304F6106B242;
        Sun, 12 Jul 2020 22:39:44 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0386724D1;
        Sun, 12 Jul 2020 22:39:41 +0000 (UTC)
Date:   Mon, 13 Jul 2020 00:39:33 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, aconole@redhat.com
Subject: Re: [PATCH net-next 0/3] vxlan, geneve: allow to turn off PMTU
 updates on encap socket
Message-ID: <20200713003933.292755b4@elisabeth>
In-Reply-To: <20200712200705.9796-1-fw@strlen.de>
References: <20200712200705.9796-1-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jul 2020 22:07:02 +0200
Florian Westphal <fw@strlen.de> wrote:

> There are existing deployments where a vxlan or geneve interface is part
> of a bridge.
> 
> In this case, MTU may look like this:
> 
> bridge mtu: 1450
> vxlan (bridge port) mtu: 1450
> other bridge ports: 1450
> 
> physical link (used by vxlan) mtu: 1500.
> 
> This makes sure that vxlan overhead (50 bytes) doesn't bring packets over the
> 1500 MTU of the physical link.
> 
> Unfortunately, in some cases, PMTU updates on the encap socket
> can bring such setups into a non-working state: no traffic will pass
> over the vxlan port (physical link) anymore.
> Because of the bridge-based usage of the vxlan interface, the original
> sender never learns of the change in path mtu and TCP clients will retransmit
> the over-sized packets until timeout.
> 
> 
> When this happens, a 'ip route flush cache' in the netns holding
> the vxlan interface resolves the problem, i.e. the network is capable
> of transporting the packets and the PMTU update is bogus.
> 
> Another workaround is to enable 'net.ipv4.tcp_mtu_probing'.
> 
> This patch series allows to configure vxlan and geneve interfaces
> to ignore path mtu updates.

Regardless of the comments to 1/3, I don't have any problem with this
(didn't review yet) if it's the only way to currently work around the
issue (of course :)).

I think we should eventually fix PMTU discovery for bridged setups, but
perhaps it's more complicated than that.

I wonder, though:

- wouldn't setting /proc/sys/net/ipv4/ip_no_pmtu_disc have the same
  effect?

- does it really make sense to have this configurable for IPv6?

-- 
Stefano

