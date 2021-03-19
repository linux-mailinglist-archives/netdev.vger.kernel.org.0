Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046E7342892
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhCSWNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:13:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231153AbhCSWNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616192022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMmDTIgSFe+cZgs0OmKvLGT5zwj3KX34p5EqaeOmfj0=;
        b=jL9hdd4Z6xa/CDtxTxr0wyhatAOR4scJDh9fAVNTdWBTNasgjpyTvudBZX3W4eHW6JmJ4N
        0Gy6MNDqqtw/avgB+YxeDLrLSzENK800cwaJPLTMA98fh6wRuuGYFL3+VaiCQBzLeh66jE
        R9rdLrvGVYOWgiUlmuinZmMILEO9GQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-3oTDUMWPNg2a691nVWOl6Q-1; Fri, 19 Mar 2021 18:13:38 -0400
X-MC-Unique: 3oTDUMWPNg2a691nVWOl6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 297BA800D53;
        Fri, 19 Mar 2021 22:13:37 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (ovpn-117-172.rdu2.redhat.com [10.10.117.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59E3110013C1;
        Fri, 19 Mar 2021 22:13:36 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, Pravin B Shelar <pshelar@ovn.org>,
        Joe Stringer <joe@cilium.io>,
        Eelco Chaudron <echaudro@redhat.com>,
        Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] openvswitch: perform refragmentation for packets which pass through conntrack
References: <20210319204307.3128280-1-aconole@redhat.com>
Date:   Fri, 19 Mar 2021 18:13:35 -0400
In-Reply-To: <20210319204307.3128280-1-aconole@redhat.com> (Aaron Conole's
        message of "Fri, 19 Mar 2021 16:43:07 -0400")
Message-ID: <f7tsg4q6bcg.fsf@dhcp-25.97.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aaron Conole <aconole@redhat.com> writes:

> When a user instructs a flow pipeline to perform connection tracking,
> there is an implicit L3 operation that occurs - namely the IP fragments
> are reassembled and then processed as a single unit.  After this, new
> fragments are generated and then transmitted, with the hint that they
> should be fragmented along the max rx unit boundary.  In general, this
> behavior works well to forward packets along when the MTUs are congruent
> across the datapath.
>
> However, if using a protocol such as UDP on a network with mismatching
> MTUs, it is possible that the refragmentation will still produce an
> invalid fragment, and that fragmented packet will not be delivered.
> Such a case shouldn't happen because the user explicitly requested a
> layer 3+4 function (conntrack), and that function generates new fragments,
> so we should perform the needed actions in that case (namely, refragment
> IPv4 along a correct boundary, or send a packet too big in the IPv6 case).
>
> Additionally, introduce a test suite for openvswitch with a test case
> that ensures this MTU behavior, with the expectation that new tests are
> added when needed.
>
> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---

Ugh, after I re-generated, I forgot to add 'net' as the target tree.

Sorry for that.

