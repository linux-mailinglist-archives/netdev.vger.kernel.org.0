Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DC6206EFA
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388962AbgFXIca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:32:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32649 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387606AbgFXIc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592987548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OSrhU2U4QyjO2CsAB/VdgS7GwuU/GZnPP9rBRWDJ5zk=;
        b=PucTaZSsbD4II5wk8mcgaFKPahEyfpw1cwd0pT9DnmbnLE0JadGcDNlwPi3WM62T8l09Em
        5R3/csudD+RgyTRCIHqRM1wTMSwzf7TQScuLmq+K1tKrf7LID78Mn54rQ3mD48wFL0iCRy
        faHDgQ0MfzmgD1rk8P4LWK2SPozkKmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-f44SuL3XMJiILXpXOpK1KA-1; Wed, 24 Jun 2020 04:32:24 -0400
X-MC-Unique: f44SuL3XMJiILXpXOpK1KA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DED0805EE1;
        Wed, 24 Jun 2020 08:32:23 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 113D01A835;
        Wed, 24 Jun 2020 08:32:10 +0000 (UTC)
Date:   Wed, 24 Jun 2020 10:32:09 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 6/9] bpf: cpumap: implement XDP_REDIRECT for
 eBPF programs attached to map entries
Message-ID: <20200624103209.18276e44@carbon>
In-Reply-To: <cad5c3a21ba8ac953b2a6e7fb70b39ae49c597ac.1592947694.git.lorenzo@kernel.org>
References: <cover.1592947694.git.lorenzo@kernel.org>
        <cad5c3a21ba8ac953b2a6e7fb70b39ae49c597ac.1592947694.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 23:39:31 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce XDP_REDIRECT support for eBPF programs attached to cpumap
> entries.
> This patch has been tested on Marvell ESPRESSObin using a modified
> version of xdp_redirect_cpu sample in order to attach a XDP program
> to CPUMAP entries to perform a redirect on the mvneta interface.
> In particular the following scenario has been tested:
> 
> rq (cpu0) --> mvneta - XDP_REDIRECT (cpu0) --> CPUMAP - XDP_REDIRECT (cpu1) --> mvneta
> 
> $./xdp_redirect_cpu -p xdp_cpu_map0 -d eth0 -c 1 -e xdp_redirect \
> 	-f xdp_redirect_kern.o -m tx_port -r eth0
> 
> tx: 285.2 Kpps rx: 285.2 Kpps
> 
> Attacching a simple XDP program on eth0 to perform XDP_TX gives
  ^^^^^^^^^^

Spelling/typo.

> comparable results:
> 
> tx: 288.4 Kpps rx: 288.4 Kpps
> 
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> ---
>  include/net/xdp.h          |  1 +
>  include/trace/events/xdp.h |  6 ++++--
>  kernel/bpf/cpumap.c        | 17 +++++++++++++++--
>  3 files changed, 20 insertions(+), 4 deletions(-)
[...]

> @@ -276,7 +286,10 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
>  		}
>  	}
>  
> -	rcu_read_unlock();
> +	if (stats->redirect)
> +		xdp_do_flush_map();
> +
> +	rcu_read_unlock_bh(); /* resched point, may call do_softirq() */

I've tested (on x86) that this extra resched point does not cause sched issues.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

