Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D829B3609CE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 14:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhDOMwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 08:52:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232223AbhDOMwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 08:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618491102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+egjn8p3lm4N8WT7Rqz4QHSvGTjGYcB6Au487i0bKQ=;
        b=NmZCHWJTf8Lf9AcR3Fc5yIBRgWvsRDk2S3zSfxc4oyjaSWy6SQ4ddFe3/LTqIkyF8Fjwi6
        A6JNsHIj65OgdFe4sbWW3rBBFPzKBLrZJyVxC67sFhVrvTCEI7mX5rGNpu/lr3w+5k1UHH
        jwMmMbovXczOWvgLiTNOFwKE6cjZpjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-Cz96uEqYPjG0x8NmQ1PDqg-1; Thu, 15 Apr 2021 08:51:38 -0400
X-MC-Unique: Cz96uEqYPjG0x8NmQ1PDqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDF85107ACE6;
        Thu, 15 Apr 2021 12:51:35 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9436060CE7;
        Thu, 15 Apr 2021 12:51:31 +0000 (UTC)
Date:   Thu, 15 Apr 2021 14:51:28 +0200
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net] igb: Fix XDP with PTP enabled
Message-ID: <20210415145011.6734d3fb@carbon>
In-Reply-To: <874kg7hhej.fsf@kurt>
References: <20210415092145.27322-1-kurt@linutronix.de>
        <20210415140438.60221f21@carbon>
        <874kg7hhej.fsf@kurt>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 14:16:36 +0200
Kurt Kanzenbach <kurt@linutronix.de> wrote:

> On Thu Apr 15 2021, Jesper Dangaard Brouer wrote:
> > On Thu, 15 Apr 2021 11:21:45 +0200
> > Kurt Kanzenbach <kurt@linutronix.de> wrote:
> >  
> >> When using native XDP with the igb driver, the XDP frame data doesn't point to
> >> the beginning of the packet. It's off by 16 bytes. Everything works as expected
> >> with XDP skb mode.
> >> 
> >> Actually these 16 bytes are used to store the packet timestamps. Therefore, pull
> >> the timestamp before executing any XDP operations and adjust all other code
> >> accordingly. The igc driver does it like that as well.
> >> 
> >> Tested with Intel i210 card and AF_XDP sockets.  
> >
> > Doesn't the i210 card use the igc driver?
> > This change is for igb driver.  
> 
> Nope. igb is for i210 and igc is for the newer Intel i225 NICs.
> 
> |01:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
> |[...]
> |        Kernel driver in use: igb
> |        Kernel modules: igb

Thanks a lot for correcting me!

I have a project involving i225+igc (using TSN).  And someone suggested
that I also looked at i210 for TSN.  I've ordered hardware that have
i210 on motherboard (and I will insert my i225 card) so I have a system
with both chips for experimenting with TSN.  I guess, I would have
discovered this eventually when I got the hardware.  Thanks for saving
me from this mistake. Thanks!

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

