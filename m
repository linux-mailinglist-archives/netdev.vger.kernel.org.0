Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237482DDA1E
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 21:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbgLQUeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 15:34:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730858AbgLQUeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 15:34:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608237158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nIZRdPQ/6TNiOyhL6oXTVvh6+0XuH7pk34EE7SrJ7EU=;
        b=DIZYl/O9DazIcIAxY+PRFkQiGavh7n2rTNwjGUnPxjv7o0BHQdShObK0KNsycviERUtRw5
        8auFdXI+bo0uanvCKMm+TseSRTj984WMf/DFNNEd33y+/x96oOswWm3qOQadNIkrNZTR0A
        QrBVIkVkFziVhImV+LnsORYPXWPM/MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-FItkl6xsOJiI2DNo0mK3nQ-1; Thu, 17 Dec 2020 15:32:35 -0500
X-MC-Unique: FItkl6xsOJiI2DNo0mK3nQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 205A9801817;
        Thu, 17 Dec 2020 20:32:33 +0000 (UTC)
Received: from [10.40.194.68] (unknown [10.40.194.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 841F45D9D2;
        Thu, 17 Dec 2020 20:32:30 +0000 (UTC)
Message-ID: <786e7a967a73f29995107412bc3506daf657c29a.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: reset child qdiscs before
 freeing them
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
In-Reply-To: <20201217110531.6fd60fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
         <20201217110531.6fd60fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 17 Dec 2020 21:32:29 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Jakub, and thanks for checking!

On Thu, 2020-12-17 at 11:05 -0800, Jakub Kicinski wrote:
> On Wed, 16 Dec 2020 19:33:29 +0100 Davide Caratti wrote:
> > +	if (q->qdiscs) {
> > +		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
> > +			qdisc_reset(q->qdiscs[i]);
> 
> Are you sure that we can't graft a NULL in the middle of the array?

that should not happen, because child qdiscs are checked for being non-
NULL when they are created:

https://elixir.bootlin.com/linux/v5.10/source/net/sched/sch_taprio.c#L1674

and then assigned to q->qdiscs[i]. So, there might be NULL elements of
q->qdiscs[] in the middle of the array when taprio_reset() is called,
but it should be ok to finish the loop when we encounter the first one:
subsequent ones should be NULL as well.

> Shouldn't this be:
> 
> 	for (i = 0; i < dev->num_tx_queues; i++)
> 		if (q->qdiscs[i])
> 			qdisc_reset(q->qdiscs[i]);
> 
> ?

probably the above code is more robust, but - like you noticed - then we
should also change the same 'for' loop in taprio_destroy(), otherwise it
leaks resources. If you and Vinicius agree, I can post a follow-up patch
that makes ->reset() and ->destroy()  more consistent with ->enqueue() 
and ->dequeue(), and send it for net-next when it reopens. Ok?

-- 
davide

