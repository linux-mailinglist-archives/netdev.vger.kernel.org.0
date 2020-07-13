Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E8621DAE9
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgGMP5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:57:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729027AbgGMP5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594655838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9agit9Hk8Ibvc41tafUahWhQoZ1IHe/7Cad1XBFMFPw=;
        b=M9sd3YL0jwbA5G5NBvfq/LE8Jlydarz7aCJW2T6x8/FehItClpEbSuqY/tV5nX1jtBakhC
        +U5Ot9YSi/S5DnR+DFMYGuQzwl9L8tVssXlEJ1+Ltr/zNL7UjFnku4LjR7zSAltALAnd7T
        Q2UGKeW3Vrn3DZluZFhGYQYECDR6iZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-hTI4dtDmM7Ss70xHD-wUqQ-1; Mon, 13 Jul 2020 11:57:15 -0400
X-MC-Unique: hTI4dtDmM7Ss70xHD-wUqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5C871085;
        Mon, 13 Jul 2020 15:57:14 +0000 (UTC)
Received: from localhost (unknown [10.36.110.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6889E6FEDF;
        Mon, 13 Jul 2020 15:57:13 +0000 (UTC)
Date:   Mon, 13 Jul 2020 17:57:09 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200713175709.2a547d7c@redhat.com>
In-Reply-To: <20200713145911.GN32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
        <20200713003813.01f2d5d3@elisabeth>
        <20200713080413.GL32005@breakpoint.cc>
        <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
        <20200713140219.GM32005@breakpoint.cc>
        <a6821eac-82f8-0d9e-6388-ea6c9f5535d1@gmail.com>
        <20200713145911.GN32005@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 16:59:11 +0200
Florian Westphal <fw@strlen.de> wrote:

> Its configured properly:
> 
> ovs bridge mtu: 1450
> vxlan device mtu: 1450
> physical link: 1500

Okay, so my proposal to reflect the discovered PMTU on the MTU of the
VXLAN device won't help in your case.

In the test case I drafted, configuring bridge and VXLAN with those
MTUs (by means of PMTU discovery) is enough for the sender to adjust
packet size and MTU-sized packets go through. I guess the OVS case is
not equivalent to it, then.

> so, packets coming in on the bridge (local tx or from remote bridge port)
> can have the enap header (50 bytes) prepended without exceeding the
> physical link mtu.
> 
> When the vxlan driver calls the ip output path, this line:
> 
>         mtu = ip_skb_dst_mtu(sk, skb);
> 
> in __ip_finish_output() will fetch the MTU based of the encap socket,
> which will now be 1450 due to that route exception.
> 
> So this will behave as if someone had lowered the physical link mtu to 1450:
> IP stack drops the packet and sends an icmp error (fragmentation needed,
> MTU 1450).  The MTU of the VXLAN port is already at 1450.

It's not clear to me why the behaviour on this path is different from
routed traffic. I understand the impact of bridged traffic on error
reporting, but not here.

Does it have something to do with metadata-based tunnels? Should we omit
the call to skb_tunnel_check_pmtu() call in vxlan_xmit_one() in that
case (if (info)) because the dst is not the same dst?

> [...]
>
> I don't think this patch is enough to resolve PMTU in general of course,
> after all the VXLAN peer might be unable to receive packets larger than
> what the ICMP error announces.  But I do not know how to resolve this
> in the general case as everyone has a differnt opinion on how (and where)
> this needs to be handled.

The sender here is sending packets matching the MTU, interface MTUs are
correct, so we wouldn't benefit from "extending" PMTU discovery for
this specific problem and we can let that topic aside for now, correct?

-- 
Stefano

