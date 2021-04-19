Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB36363F46
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbhDSKBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 06:01:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232560AbhDSKBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 06:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618826452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/fezfV6/x50p9OCJJBi7oi74MDNFu3Fp1LlKYETvFPA=;
        b=R+Lnto27DlZ/U8JtEvYylBZR4nWEP9Tbd76JIpGFymWE5kPhH1xrdwsVhK6di2V7MIbGJL
        y6Aqm9G4+WA4KbR6Z+hld9wU7I04vbUGAKIFk88PZAZzxWHUK4xUWHmn8Vu7t9Ijb/ugWi
        zbjQdNZ1poSBBrTQ9WtnPW82B3OTOsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-egJJqfb7O-61GFqWZFy4Tg-1; Mon, 19 Apr 2021 06:00:47 -0400
X-MC-Unique: egJJqfb7O-61GFqWZFy4Tg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42466108C2A0;
        Mon, 19 Apr 2021 10:00:45 +0000 (UTC)
Received: from [10.40.195.0] (unknown [10.40.195.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E03D60937;
        Mon, 19 Apr 2021 10:00:42 +0000 (UTC)
Message-ID: <1646191a31be339c81f8b335ff40876145a05908.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: sch_frag: fix OOB read while processing
 IPv4 fragments
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Shuang Li <shuali@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org
Cc:     "echaudro@redhat.com" <echaudro@redhat.com>
In-Reply-To: <29c95029f83aa44bcbdb5a314cb700e077df2291.1618604533.git.dcaratti@redhat.com>
References: <29c95029f83aa44bcbdb5a314cb700e077df2291.1618604533.git.dcaratti@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 19 Apr 2021 12:00:41 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-16 at 22:29 +0200, Davide Caratti wrote:

[...]
> 
> for IPv4 packets, sch_fragment() uses a temporary struct dst_entry. Then,
> in the following call graph:
> 
>   ip_fragment()

^^ the above line is a typo,

>     ip_do_fragment()
>       ip_skb_dst_mtu()
>         ip_dst_mtu_maybe_forward()
>           ip_mtu_locked()
> 
> a pointer to that struct is casted as pointer to struct rtable, hence the
> OOB stack access. Fix this, changing the temporary variable used for IPv4
> packets in sch_fragment(), similarly to what is done for IPv6 in the same
> function.

and thanks to Eelco's help I just reproduced a similar splat with
openvswitch. Indeed, ovs_fragment() seems to have the same problem [1];
I will follow-up with a series that fixes both data-paths.

-- 
davide

[1] https://elixir.bootlin.com/linux/v5.12-rc8/source/net/openvswitch/actions.c#L813


