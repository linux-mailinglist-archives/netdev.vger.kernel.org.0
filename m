Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC2916101A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgBQKc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:32:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58475 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729128AbgBQKcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 05:32:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581935544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I2la9dD/V2BQS999VzBzum/9H67L/Yfiqp0f9+xcYbc=;
        b=Gpgl8/0YUXOb2itJ9FzimdNre5dGHSHqt58XpZHntZESWeYE7yqlo+gEWyHZlUPhQeYw+a
        MSjYEd+wwuzmo0Y+mxaCFFhaqzxqRxmWAcQ99WjyA5L6yl7yp3AWfRqMPsPmkKuXMrUSn/
        OwxUgOm1FW21LIkDZKmQa6SSSqKsK4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-yVwm-QOqMiG1I4dEYLsY8A-1; Mon, 17 Feb 2020 05:32:20 -0500
X-MC-Unique: yVwm-QOqMiG1I4dEYLsY8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E3DF8024FB;
        Mon, 17 Feb 2020 10:32:19 +0000 (UTC)
Received: from carbon (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 009648DC1E;
        Mon, 17 Feb 2020 10:32:11 +0000 (UTC)
Date:   Mon, 17 Feb 2020 11:32:09 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        David Ahern <dsahern@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to
 ethtool
Message-ID: <20200217113209.2dab7f71@carbon>
In-Reply-To: <20200217102550.GB3080@localhost.localdomain>
References: <cover.1581886691.git.lorenzo@kernel.org>
        <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
        <20200217111718.2c9ab08a@carbon>
        <20200217102550.GB3080@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Feb 2020 11:25:50 +0100
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > On Sun, 16 Feb 2020 22:07:32 +0100
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >   
> > > @@ -2033,6 +2050,7 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
> > >  	u64_stats_update_begin(&stats->syncp);
> > >  	stats->es.ps.tx_bytes += xdpf->len;
> > >  	stats->es.ps.tx_packets++;
> > > +	stats->es.ps.xdp_tx++;
> > >  	u64_stats_update_end(&stats->syncp);  
> > 
> > I find it confusing that this ethtool stats is named "xdp_tx".
> > Because you use it as an "xmit" counter and not for the action XDP_TX.
> > 
> > Both XDP_TX and XDP_REDIRECT out this device will increment this
> > "xdp_tx" counter.  I don't think end-users will comprehend this...
> > 
> > What about naming it "xdp_xmit" ?  
> 
> Hi Jesper,
> 
> yes, I think it is definitely better. So to follow up:
> - rename current "xdp_tx" counter in "xdp_xmit" and increment it for
>   XDP_TX verdict and for ndo_xdp_xmit
> - introduce a new "xdp_tx" counter only for XDP_TX verdict.
> 
> If we agree I can post a follow-up patch.

I agree, that sounds like an improvement to this patchset.


I suspect David Ahern have some opinions about more general stats for
XDP, but that it is a more general discussion, that it outside this
patchset, but we should also have that discussion.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

