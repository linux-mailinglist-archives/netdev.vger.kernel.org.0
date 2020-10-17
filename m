Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80492913A9
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438210AbgJQS1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437529AbgJQS1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 14:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602959266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ipkmdfb70k/cOcwmWT9n/O96aTLbUddhkjx98JA0niM=;
        b=Tf6p/50905Fd5iiz8YAvQJ07UTqBet7hmDUBQYRN76zvZoDtkWnq8xLyJPuVARDxnzwl69
        Iuf2+7D/ZHXrTGNGamgHDJ9VPFvydOwQEEOn3cGOtwJPChucCoCE0QRCJhaIGWo896rzBN
        XZHyn3WcLL01ZJ7bwup1vmaXT9pLaPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-32IS3qjJOZ-QvF5LW3i-NQ-1; Sat, 17 Oct 2020 14:27:42 -0400
X-MC-Unique: 32IS3qjJOZ-QvF5LW3i-NQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64D81107AD65;
        Sat, 17 Oct 2020 18:27:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B15355766;
        Sat, 17 Oct 2020 18:27:40 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 44D2844A4C;
        Sat, 17 Oct 2020 18:27:40 +0000 (UTC)
Date:   Sat, 17 Oct 2020 14:27:37 -0400 (EDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pabeni@redhat.com, pshelar@ovn.org, jlelli@redhat.com,
        bigeasy@linutronix.de, i maximets <i.maximets@ovn.org>
Message-ID: <1391537937.15081272.1602959257178.JavaMail.zimbra@redhat.com>
In-Reply-To: <20201016164607.4244ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160278168341.905188.913081997609088316.stgit@ebuild> <20201016164607.4244ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net v3] net: openvswitch: fix to make sure flow_lookup()
 is not preempted
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.36.112.23, 10.4.195.11]
Thread-Topic: openvswitch: fix to make sure flow_lookup() is not preempted
Thread-Index: l5zv0FcxxaVsf/wK+jPtso6JqKaHYA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "Jakub Kicinski" <kuba@kernel.org>
> To: "Eelco Chaudron" <echaudro@redhat.com>
> Cc: netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org, pabeni@redhat.com, pshelar@ovn.org,
> jlelli@redhat.com, bigeasy@linutronix.de, "i maximets" <i.maximets@ovn.org>
> Sent: Saturday, October 17, 2020 1:46:07 AM
> Subject: Re: [PATCH net v3] net: openvswitch: fix to make sure flow_lookup() is not preempted
> 
> On Thu, 15 Oct 2020 19:09:33 +0200 Eelco Chaudron wrote:
> > The flow_lookup() function uses per CPU variables, which must be called
> > with BH disabled. However, this is fine in the general NAPI use case
> > where the local BH is disabled. But, it's also called from the netlink
> > context. The below patch makes sure that even in the netlink path, the
> > BH is disabled.
> > 
> > In addition, u64_stats_update_begin() requires a lock to ensure one writer
> > which is not ensured here. Making it per-CPU and disabling NAPI (softirq)
> > ensures that there is always only one writer.
> > 
> > Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on
> > usage")
> > Reported-by: Juri Lelli <jlelli@redhat.com>
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> 
> Hi Eelco, looks like this doesn't apply after the 5.10 merges.
> 
> Please respin on top of the current net.

Done, just sent out a v4.

//Eelco

