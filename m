Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55515213A58
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 14:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGCMyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 08:54:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27067 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726772AbgGCMyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 08:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593780845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+k8RkC7JKMZr+sP+ag5DuGVQOXCROYbmnKZSv7DDXPs=;
        b=HQxdmQhbSwsxsLxD7kbv2H4Tali2leFKEtynD52ToI68LsTn/Qd2LeT2UMP9hJigAgEVu1
        DqVPpOTA9tQ/bX4qAY8SNr5F6QCe5A6nedWqvZPSwhhslTEnr+yyQo6USfXKPW7iEXLD/B
        SZbD8p+QRUmvFGMKuH0v5o4Nmhx3GnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-RIHTo6adNXWL7f36P0xS5A-1; Fri, 03 Jul 2020 08:53:59 -0400
X-MC-Unique: RIHTo6adNXWL7f36P0xS5A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ED861052510;
        Fri,  3 Jul 2020 12:53:57 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 478C21972A;
        Fri,  3 Jul 2020 12:53:51 +0000 (UTC)
Message-ID: <4297936b4cc7d6cdcb51ccc10331467f39978795.camel@redhat.com>
Subject: Re: [PATCH net] sched: consistently handle layer3 header accesses
 in the presence of VLANs
From:   Davide Caratti <dcaratti@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <20200703120523.465334-1-toke@redhat.com>
References: <20200703120523.465334-1-toke@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 03 Jul 2020 14:53:50 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Toke,

thanks for answering!

On Fri, 2020-07-03 at 14:05 +0200, Toke Høiland-Jørgensen wrote:
>   while (proto == htons(ETH_P_8021Q) || proto == htons(ETH_P_8021AD)) {

maybe this line be shortened, since if_vlan.h has [1]:

while (eth_type_vlan(proto)) {
 	...
}

If I read well, the biggest change from functional point of view is that
now qdiscs can set the ECN bit also on non-accelerated VLAN packets and
QinQ-tagged packets, if the IP header is the outer-most header after VLAN;
and the same applies to almost all net/sched former users of skb->protocol 
or tc_skb_protocol().

Question (sorry in advance because it might be a dumb one :) ):

do you know why cls_flower, act_ct, act_mpls and act_connmark keep reading
skb->protocol? is that intentional?

(for act_mpls that doesn't look intentional, and probably the result is
that the BOS bit is not set correctly if someone tries to push/pop a label
for a non-accelerated or QinQ packet. But I didn't try it experimentally
:) )

[1] https://elixir.bootlin.com/linux/latest/source/include/linux/if_vlan.h#L300

-- 
davide


