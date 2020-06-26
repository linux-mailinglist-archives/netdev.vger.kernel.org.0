Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D3220AD8E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 09:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgFZHty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 03:49:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29289 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728341AbgFZHty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 03:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593157793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sa86zJwICzW4pRMjqh+/WTQ2NZV6RCOp7KLNEBhVXLs=;
        b=hXCdxWXLdVqmRfPl0IG5wcMKzRGbmaAmIt+v5YyNKz3IhxTo9UNmqsxuBJLcGBXA95QaEn
        owQB0FP8OnWHLKxkIan1Y6d73oS384QUc99c5qClym9r6Q0QWLk8lCtrScbZ8Y4x3WncvQ
        L+m19V2T6lN6EZ9EOSWbvLcrSwnUFoo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-y92IeX77MSKTrZYZXNO_0Q-1; Fri, 26 Jun 2020 03:49:50 -0400
X-MC-Unique: y92IeX77MSKTrZYZXNO_0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 610611005513;
        Fri, 26 Jun 2020 07:49:48 +0000 (UTC)
Received: from carbon (unknown [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2DE21002395;
        Fri, 26 Jun 2020 07:49:36 +0000 (UTC)
Date:   Fri, 26 Jun 2020 09:49:34 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        toke@redhat.com, lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v4 bpf-next 6/9] bpf: cpumap: implement XDP_REDIRECT for
 eBPF programs attached to map entries
Message-ID: <20200626094934.49f9a94e@carbon>
In-Reply-To: <01248413-7675-d35e-323e-7d2e69128b45@iogearbox.net>
References: <cover.1593012598.git.lorenzo@kernel.org>
        <ef1a456ba3b76a61b7dc6302974f248a21d906dd.1593012598.git.lorenzo@kernel.org>
        <01248413-7675-d35e-323e-7d2e69128b45@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 23:28:59 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> > @@ -276,7 +286,10 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
> >   		}
> >   	}
> >   
> > -	rcu_read_unlock();
> > +	if (stats->redirect)
> > +		xdp_do_flush_map();
> > +
> > +	rcu_read_unlock_bh(); /* resched point, may call do_softirq() */
> >   	xdp_clear_return_frame_no_direct();  
> 
> Hm, this looks incorrect. Why do you call the xdp_clear_return_frame_no_direct() /after/
> the possibility where there is a rescheduling point for softirq?

Good you caught this! - This needs to be fixed.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

