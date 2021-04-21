Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0972A3667FE
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbhDUJ2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:28:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230516AbhDUJ2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618997291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koLisk6SX7FmrTDba5lKCo3w2wDBed6q1YMsOPtWkOc=;
        b=gKrMj0a67joeKYZVBrQ2zERTElfE6iW2yLntyUYVpA+8AOngLPSkwDID7p27bNvqEScJXW
        fSMAKWiA94EPw3bYuLxuGLZv7NsAJfVeqha04kF7K12WrsON2Gzv1VN7Yx45UPDuZ0jHoH
        Rs98zninBo3sx3eRxvDun3ZSLYuRRzU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-2EmJtXA2N7SKx9n0D4ZX4w-1; Wed, 21 Apr 2021 05:27:27 -0400
X-MC-Unique: 2EmJtXA2N7SKx9n0D4ZX4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFEAB1008063;
        Wed, 21 Apr 2021 09:27:26 +0000 (UTC)
Received: from [10.36.113.98] (ovpn-113-98.ams2.redhat.com [10.36.113.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49DAB60C5F;
        Wed, 21 Apr 2021 09:27:25 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Davide Caratti" <dcaratti@redhat.com>
Cc:     "Pravin B Shelar" <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Sabrina Dubroca" <sd@queasysnail.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] openvswitch: fix stack OOB read while fragmenting
 IPv4 packets
Date:   Wed, 21 Apr 2021 11:27:21 +0200
Message-ID: <1097839A-30AD-4AE9-859A-4B7C6A3EFA40@redhat.com>
In-Reply-To: <94839fa9e7995afa6139b4f65c12ac15c1a8dc2f.1618844973.git.dcaratti@redhat.com>
References: <cover.1618844973.git.dcaratti@redhat.com>
 <94839fa9e7995afa6139b4f65c12ac15c1a8dc2f.1618844973.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19 Apr 2021, at 17:23, Davide Caratti wrote:

> running openvswitch on kernels built with KASAN, it's possible to see 
> the
> following splat while testing fragmentation of IPv4 packets:

<SNIP>

> for IPv4 packets, ovs_fragment() uses a temporary struct dst_entry. 
> Then,
> in the following call graph:
>
>   ip_do_fragment()
>     ip_skb_dst_mtu()
>       ip_dst_mtu_maybe_forward()
>         ip_mtu_locked()
>
> the pointer to struct dst_entry is used as pointer to struct rtable: 
> this
> turns the access to struct members like rt_mtu_locked into an OOB read 
> in
> the stack. Fix this changing the temporary variable used for IPv4 
> packets
> in ovs_fragment(), similarly to what is done for IPv6 few lines below.
>
> Fixes: d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received PMTU < 
> net.ipv4.route.min_pmt")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

The fix looks good to me, however isn’t the real root cause 
ip_mtu_locked() who casts struct dst_entry to struct rtable (not even 
using container_of())?

I do not know details in this area of the code, so maybe it’s just 
fine to always assume dst_entry is part of a rtable struct, as I see 
other core functions do the same 
ipv4_neigh_lookup()/ipv4_confirm_neigh().


Acked-by: Eelco Chaudron <echaudro@redhat.com>

