Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAE520AEDD
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 11:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgFZJTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 05:19:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38381 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725820AbgFZJTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 05:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593163150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCgtTgtqCADvhdvPI+E6n05c+gvKKnCWOp088pMih8E=;
        b=HHHv3cAumOq20SD4wcSnVTfl0OekwS8tcveNdoUvtVra9GX/xZkod68mhWroaXGHcFZ2+m
        BFWXWVvKOWhSxweX1Pu+cySshWdqMxqjlMH1Ky8ulUqtlNdXPFDL8eA87aiYUsvGf5wbnH
        1mhcgNgDNzq76vTL1tlvraveizGJ3Ok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-4VK0J0DFOiml0TzaQMeHzw-1; Fri, 26 Jun 2020 05:19:05 -0400
X-MC-Unique: 4VK0J0DFOiml0TzaQMeHzw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20BCAEC1A0;
        Fri, 26 Jun 2020 09:19:04 +0000 (UTC)
Received: from carbon (unknown [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4478019C58;
        Fri, 26 Jun 2020 09:18:51 +0000 (UTC)
Date:   Fri, 26 Jun 2020 11:18:50 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        toke@redhat.com, lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v4 bpf-next 6/9] bpf: cpumap: implement XDP_REDIRECT for
 eBPF programs attached to map entries
Message-ID: <20200626111850.3ccfa8ac@carbon>
In-Reply-To: <01248413-7675-d35e-323e-7d2e69128b45@iogearbox.net>
References: <cover.1593012598.git.lorenzo@kernel.org>
        <ef1a456ba3b76a61b7dc6302974f248a21d906dd.1593012598.git.lorenzo@kernel.org>
        <01248413-7675-d35e-323e-7d2e69128b45@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 23:28:59 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> > diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> > index 4e4cd240f07b..c0b2f265ccb2 100644
> > --- a/kernel/bpf/cpumap.c
> > +++ b/kernel/bpf/cpumap.c
> > @@ -240,7 +240,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
> >   	xdp_set_return_frame_no_direct();
> >   	xdp.rxq = &rxq;
> >   
> > -	rcu_read_lock();
> > +	rcu_read_lock_bh();
> >   
> >   	prog = READ_ONCE(rcpu->prog);
> >   	for (i = 0; i < n; i++) {
> > @@ -266,6 +266,16 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
> >   				stats->pass++;
> >   			}
> >   			break;
> > +		case XDP_REDIRECT:
> > +			err = xdp_do_redirect(xdpf->dev_rx, &xdp,
> > +					      prog);
> > +			if (unlikely(err)) {
> > +				xdp_return_frame(xdpf);
> > +				stats->drop++;

I consider if this should be a redir_err counter.

> > +			} else {
> > +				stats->redirect++;
> > +			}  
> 
> Could we do better with all the accounting and do this from /inside/ BPF tracing prog
> instead (otherwise too bad we need to have it here even if the tracepoint is disabled)?

I'm on-the-fence with this one...

First of all the BPF-prog cannot see the return code of xdp_do_redirect.
So, it cannot give the correct/needed stats without this counter. It
would basically report the redirects as successful redirects. (This is
actually a re-occuring support issue, when end-users misconfigure
xdp_redirect sample and think they get good performance, even-though
packets are dropped).

Specifically for XDP_REDIRECT we need to update some state anyhow, such
that we know to call xdp_do_flush_map(). Thus removing the counter
would not gain much performance wise.


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

