Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56500203391
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgFVJiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:38:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21490 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgFVJiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592818689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bmp6YBsBmz3ECygh4UjDvw9JRnqkwwGdfWIGZ8OItQw=;
        b=GGHSMKoaLMsuoXo8vt0GfYo+BWO7LeLOLN7SQSTzIbN/P8xaBMQsZRhbYWcGh61Di11G3c
        scBACkb5+tRWBct9HWe3/o/SUVMbas3GpibCDdecVLHCaAwAKXAcU5uHSAiRYwrr5yUKl8
        rdUWy0Ph/sACG0c6uu2p0SHGs0XFvI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-TUYRijvtNgSeWbbT7yH15A-1; Mon, 22 Jun 2020 05:38:08 -0400
X-MC-Unique: TUYRijvtNgSeWbbT7yH15A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D949E107ACF4;
        Mon, 22 Jun 2020 09:38:06 +0000 (UTC)
Received: from ovpn-113-146.ams2.redhat.com (ovpn-113-146.ams2.redhat.com [10.36.113.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9861B10013D7;
        Mon, 22 Jun 2020 09:38:05 +0000 (UTC)
Message-ID: <c6f642b0bf248ff108be91727e0b02bf8e974717.camel@redhat.com>
Subject: Re: [RFC PATCH] net/sched: add indirect call wrapper hint.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Date:   Mon, 22 Jun 2020 11:38:04 +0200
In-Reply-To: <0240746c-1dd1-4822-261c-03ff13854db2@gmail.com>
References: <da175b76ca89e57876cf55d3d56aef126054d12c.1592501362.git.pabeni@redhat.com>
         <0240746c-1dd1-4822-261c-03ff13854db2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-18 at 12:00 -0700, Eric Dumazet wrote:
> 
> On 6/18/20 10:31 AM, Paolo Abeni wrote:
> > The sched layer can use several indirect calls per
> > packet, with not work-conservative qdisc being
> > more affected due to the lack of the BYPASS path.
> > 
> > This change tries to improve the situation using
> > the indirect call wrappers infrastructure for the
> > qdisc enqueue end dequeue indirect calls.
> > 
> > To cope with non-trivial scenarios, a compile-time know is
> > introduced, so that the qdisc used by ICW can be different
> > from the default one.
> > 
> > Tested with pktgen over qdisc, with CONFIG_HINT_FQ_CODEL=y:
> > 
> > qdisc		threads vanilla	patched delta
> > 		nr	Kpps	Kpps	%
> > pfifo_fast	1	3300	3700	12
> > pfifo_fast	2	3940	4070	3
> > fq_codel	1	3840	4110	7
> > fq_codel	2	1920	2260	17
> > fq		1	2230	2210	-1
> > fq		2	1530	1540	1
> 
> Hi Paolo
> 
> This test is a bit misleading, pktgen has a way to bypass the qdisc.
> 
> Real numbers for more typical workloads would be more appealing,
> before we consider a quite invasive patch ?

I run several tests with netperf/UDP/small packet size and different
number of threads. I see a ~+2% delta with pfifo_fast single thread and
difference within the noise level in all others scenarios.

I'll drop this patch, thank you for the advice.

Paolo

