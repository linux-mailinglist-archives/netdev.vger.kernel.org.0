Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFC71E3F0F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgE0KdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:33:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56944 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729062AbgE0KdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:33:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590575584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQ5vMCTpGuLoUO9qxramZARhFFOwhW/hdcqn9TYgDgw=;
        b=EPaysxWnjzeXQrNr6AsNhR1AsokTP7ljYNqvwJwQAJd+X9Mr3dI9kVXf/1Rkqy3p1rnuOT
        sls644AreEkqrN6bgzBhLDiq4OOfmoMpm+y1byo3Rr3bUmo82ECzab7dPihh9ZvaJmrYB0
        4Sv8h9Ad3vageSxsHorRZyto2nmOjfc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-3n3RAbE7OHubwCoLIG35bQ-1; Wed, 27 May 2020 06:33:00 -0400
X-MC-Unique: 3n3RAbE7OHubwCoLIG35bQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4534780183C;
        Wed, 27 May 2020 10:32:59 +0000 (UTC)
Received: from [10.36.114.137] (ovpn-114-137.ams2.redhat.com [10.36.114.137])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F25C57A1E1;
        Wed, 27 May 2020 10:32:49 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     "Hangbin Liu" <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "Jiri Benc" <jbenc@redhat.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>, ast@kernel.org,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Lorenzo Bianconi" <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Date:   Wed, 27 May 2020 12:32:47 +0200
Message-ID: <28D58684-578C-4DDF-B18D-70280B923590@redhat.com>
In-Reply-To: <87zh9t1xvh.fsf@toke.dk>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com> <87zh9t1xvh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; markup=markdown
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27 May 2020, at 12:21, Toke Høiland-Jørgensen wrote:

> Hangbin Liu <liuhangbin@gmail.com> writes:
>
>> Hi all,
>>
>> This patchset is for xdp multicast support, which has been discussed
>> before[0]. The goal is to be able to implement an OVS-like data plane 
>> in
>> XDP, i.e., a software switch that can forward XDP frames to multiple
>> ports.
>>
>> To achieve this, an application needs to specify a group of 
>> interfaces
>> to forward a packet to. It is also common to want to exclude one or 
>> more
>> physical interfaces from the forwarding operation - e.g., to forward 
>> a
>> packet to all interfaces in the multicast group except the interface 
>> it
>> arrived on. While this could be done simply by adding more groups, 
>> this
>> quickly leads to a combinatorial explosion in the number of groups an
>> application has to maintain.
>>
>> To avoid the combinatorial explosion, we propose to include the 
>> ability
>> to specify an "exclude group" as part of the forwarding operation. 
>> This
>> needs to be a group (instead of just a single port index), because a
>> physical interface can be part of a logical grouping, such as a bond
>> device.
>>
>> Thus, the logical forwarding operation becomes a "set difference"
>> operation, i.e. "forward to all ports in group A that are not also in
>> group B". This series implements such an operation using device maps 
>> to
>> represent the groups. This means that the XDP program specifies two
>> device maps, one containing the list of netdevs to redirect to, and 
>> the
>> other containing the exclude list.
>>
>> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
>> to accept two maps, the forwarding map and exclude map. If user
>> don't want to use exclude map and just want simply stop redirecting 
>> back
>> to ingress device, they can use flag BPF_F_EXCLUDE_INGRESS.
>>
>> The example in patch 2 is functional, but not a lot of effort
>> has been made on performance optimisation. I did a simple test(pkt 
>> size 64)
>> with pktgen. Here is the test result with BPF_MAP_TYPE_DEVMAP_HASH
>> arrays:
>>
>> bpf_redirect_map() with 1 ingress, 1 egress:
>> generic path: ~1600k pps
>> native path: ~980k pps
>>
>> bpf_redirect_map_multi() with 1 ingress, 3 egress:
>> generic path: ~600k pps
>> native path: ~480k pps
>>
>> bpf_redirect_map_multi() with 1 ingress, 9 egress:
>> generic path: ~125k pps
>> native path: ~100k pps
>>
>> The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we 
>> loop
>> the arrays and do clone skb/xdpf. The native path is slower than 
>> generic
>> path as we send skbs by pktgen. So the result looks reasonable.
>
> How are you running these tests? Still on virtual devices? We really
> need results from a physical setup in native mode to assess the impact
> on the native-XDP fast path. The numbers above don't tell much in this
> regard. I'd also like to see a before/after patch for straight
> bpf_redirect_map(), since you're messing with the fast path, and we 
> want
> to make sure it's not causing a performance regression for regular
> redirect.
>
> Finally, since the overhead seems to be quite substantial: A 
> comparison
> with a regular network stack bridge might make sense? After all we 
> also
> want to make sure it's a performance win over that :)

What about adding a test with only one egress port? So it compares 
better to bpf_redirect_map(), i.e. “bpf_redirect_map_multi() with 1 
ingress, 1 egress”.

