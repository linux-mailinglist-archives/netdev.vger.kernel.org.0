Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DA420AF67
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgFZKGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:06:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45381 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbgFZKGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593166010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wgbgTYfJQqu3PeczY55F3LlScD7j+20EVBpY3jbcgkU=;
        b=IfQs04qbzVLdP6oDLMM9pQIkMu04vfpK1Tfh5p9zrWpDiESnTojhf8O0og3qo+8/7X2S/c
        q5lQOxugt3uTifZXIPL9uSoslbJFDKyontkx//yzHRhWfc/trhPVpNwtoKH19BWtPm18yl
        LTZ8zHEGFrOoTGoJ9OOE5k46aC6yeVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-4fd7yTYYNzutoc07BVtp1Q-1; Fri, 26 Jun 2020 06:06:48 -0400
X-MC-Unique: 4fd7yTYYNzutoc07BVtp1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 314DB18585A2;
        Fri, 26 Jun 2020 10:06:46 +0000 (UTC)
Received: from carbon (unknown [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 541FC70915;
        Fri, 26 Jun 2020 10:06:34 +0000 (UTC)
Date:   Fri, 26 Jun 2020 12:06:32 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v4 bpf-next 6/9] bpf: cpumap: implement XDP_REDIRECT for
 eBPF programs attached to map entries
Message-ID: <20200626120632.6ef16b5c@carbon>
In-Reply-To: <ef1a456ba3b76a61b7dc6302974f248a21d906dd.1593012598.git.lorenzo@kernel.org>
References: <cover.1593012598.git.lorenzo@kernel.org>
        <ef1a456ba3b76a61b7dc6302974f248a21d906dd.1593012598.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 17:33:55 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 83b9e0142b52..5be0d4d65b94 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -99,6 +99,7 @@ struct xdp_frame {
>  };
>  
>  struct xdp_cpumap_stats {
> +	unsigned int redirect;
>  	unsigned int pass;
>  	unsigned int drop;
>  };
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index e2c99f5bee39..cd24e8a59529 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -190,6 +190,7 @@ TRACE_EVENT(xdp_cpumap_kthread,
>  		__field(int, sched)
>  		__field(unsigned int, xdp_pass)
>  		__field(unsigned int, xdp_drop)
> +		__field(unsigned int, xdp_redirect)
>  	),
>  
>  	TP_fast_assign(
> @@ -201,18 +202,19 @@ TRACE_EVENT(xdp_cpumap_kthread,
>  		__entry->sched	= sched;
>  		__entry->xdp_pass	= xdp_stats->pass;
>  		__entry->xdp_drop	= xdp_stats->drop;
> +		__entry->xdp_redirect	= xdp_stats->redirect;
>  	),

Let me stress, that I think can do this in a followup patch (but before
a release).

I'm considering that we should store/give a pointer to xdp_stats
(struct xdp_cpumap_stats) and let the BPF tracing program do the
"decoding"/struct access to get these values.  (We will go from storing
12 bytes to 8 bytes (on 64-bit), so I don't expect much gain).


>  	TP_printk("kthread"
>  		  " cpu=%d map_id=%d action=%s"
>  		  " processed=%u drops=%u"
>  		  " sched=%d"
> -		  " xdp_pass=%u xdp_drop=%u",
> +		  " xdp_pass=%u xdp_drop=%u xdp_redirect=%u",
>  		  __entry->cpu, __entry->map_id,
>  		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
>  		  __entry->processed, __entry->drops,
>  		  __entry->sched,
> -		  __entry->xdp_pass, __entry->xdp_drop)
> +		  __entry->xdp_pass, __entry->xdp_drop, __entry->xdp_redirect)
>  );
>  


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

