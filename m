Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF178160FC5
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgBQKRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:17:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729058AbgBQKRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 05:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581934651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppDD5AMkrOfQjlQvQgRMNAO+Ohmwmyr7wzDAlX1AsEc=;
        b=IwM5yWa3IJ5OOr1YThhT7a4Xv2YlfsJ/SjP/5hBAWBjcIC+GerAf0nZ00JOaEGGhaSp95X
        NxE+DKaD4txD4CbqhqsziZZkznRla+CxmEtP72Mkdm2AftYZDmZK1rm3vrbS6+kTI5w6hW
        7syP4FW6mm4lFI/C4RgWcwcm3QqvRaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-HZVGfACIP069pHQUmWBUdg-1; Mon, 17 Feb 2020 05:17:29 -0500
X-MC-Unique: HZVGfACIP069pHQUmWBUdg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14950800D5A;
        Mon, 17 Feb 2020 10:17:28 +0000 (UTC)
Received: from carbon (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CC785C3FA;
        Mon, 17 Feb 2020 10:17:20 +0000 (UTC)
Date:   Mon, 17 Feb 2020 11:17:18 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, David Ahern <dsahern@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to
 ethtool
Message-ID: <20200217111718.2c9ab08a@carbon>
In-Reply-To: <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
References: <cover.1581886691.git.lorenzo@kernel.org>
        <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Feb 2020 22:07:32 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> @@ -2033,6 +2050,7 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
>  	u64_stats_update_begin(&stats->syncp);
>  	stats->es.ps.tx_bytes += xdpf->len;
>  	stats->es.ps.tx_packets++;
> +	stats->es.ps.xdp_tx++;
>  	u64_stats_update_end(&stats->syncp);

I find it confusing that this ethtool stats is named "xdp_tx".
Because you use it as an "xmit" counter and not for the action XDP_TX.

Both XDP_TX and XDP_REDIRECT out this device will increment this
"xdp_tx" counter.  I don't think end-users will comprehend this...

What about naming it "xdp_xmit" ?


>  	mvneta_txq_inc_put(txq);
> @@ -2114,6 +2132,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  
>  	switch (act) {
>  	case XDP_PASS:
> +		stats->xdp_pass++;
>  		return MVNETA_XDP_PASS;
>  	case XDP_REDIRECT: {
>  		int err;
> @@ -2126,6 +2145,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  					     len, true);
>  		} else {
>  			ret = MVNETA_XDP_REDIR;
> +			stats->xdp_redirect++;
>  		}
>  		break;
>  	}
> @@ -2147,6 +2167,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  				     virt_to_head_page(xdp->data),
>  				     len, true);
>  		ret = MVNETA_XDP_DROPPED;
> +		stats->xdp_drop++;
>  		break;
>  	}


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

