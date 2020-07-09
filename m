Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42661219BF8
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 11:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgGIJVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 05:21:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26638 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726122AbgGIJVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 05:21:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594286467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fpT1tlU+FAIRvHikZIQn2nvVl9NUNq40o1v5G/MxGTw=;
        b=S0FIwz36oVS/P+UUik7Zoi+d3nBSYGS311tvJ3B49x4WS4NuQeF2Ka9xmBXfA027YEIrTE
        2mZp7RGUyzwZgOIiY+qSbXpv5zvF2X6873SfFZYLmthbECJeu6Gp55cMm9z5hiHGvvM0rV
        yd3IcWGaMPYAk7aQmlKo36C76+AgNT4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-S4HiYPomPzuTzsOAv4VZxQ-1; Thu, 09 Jul 2020 05:21:03 -0400
X-MC-Unique: S4HiYPomPzuTzsOAv4VZxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA0AD107ACF7;
        Thu,  9 Jul 2020 09:21:01 +0000 (UTC)
Received: from ovpn-113-239.ams2.redhat.com (ovpn-113-239.ams2.redhat.com [10.36.113.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CA7F6106A;
        Thu,  9 Jul 2020 09:20:59 +0000 (UTC)
Message-ID: <9dbb08f05890cc4130b54c80e4f4072b49d9f0ed.camel@redhat.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
From:   Paolo Abeni <pabeni@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Date:   Thu, 09 Jul 2020 11:20:58 +0200
In-Reply-To: <CAM_iQpVZ4_AEV6JR__u-ooF7-=ozABVr_XPXGqwj2AK-VM1U5w@mail.gmail.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
         <20200623134259.8197-1-mzhivich@akamai.com>
         <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
         <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
         <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
         <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
         <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
         <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
         <e54b0fe2ab12f6d078cdc6540f03478c32fe5735.camel@redhat.com>
         <CAM_iQpVZ4_AEV6JR__u-ooF7-=ozABVr_XPXGqwj2AK-VM1U5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-08 at 13:16 -0700, Cong Wang wrote:
> On Tue, Jul 7, 2020 at 7:18 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > So the regression with 2 pktgen threads is still relevant. 'perf' shows
> > relevant time spent into net_tx_action() and __netif_schedule().
> 
> So, touching the __QDISC_STATE_SCHED bit in __dev_xmit_skb() is
> not a good idea.
> 
> Let me see if there is any other way to fix this.

Thank you very much for the effort! I'm personally out of ideas for a
real fix that would avoid regressions. 

To be more exaustive this are the sources of overhead, as far as I can
observe them with perf:

- contention on q->state, in __netif_schedule()
- execution of net_tx_action() when there are no packet to be served

Cheers,

Paolo

