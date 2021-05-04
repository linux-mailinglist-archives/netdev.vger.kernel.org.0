Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC194372737
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 10:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhEDI3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 04:29:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhEDI3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 04:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620116925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCGIoq+q2yEHekhzcWTEQd9G0dS+82wyYCm9Ec+BzMk=;
        b=ErFG8OWZC8YRJNaNUppDIMmp0RK1aTjlnofg6enNHgefvAU0+6PsEmjMXOapvHc/C6shdQ
        I/xKl4pZkU20gBB8pSwYvy496yY0frhKdGCSIyJLDf4FkskbPgQ10bCpOedCvPi/Bwyetc
        3wgGTeoKpiRBonVENNi+YDt/mF+eN0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-O1LMVxDONsGykzhE3i_Ffw-1; Tue, 04 May 2021 04:28:42 -0400
X-MC-Unique: O1LMVxDONsGykzhE3i_Ffw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 741838030D5;
        Tue,  4 May 2021 08:28:39 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 091EA1A866;
        Tue,  4 May 2021 08:28:28 +0000 (UTC)
Date:   Tue, 4 May 2021 10:28:27 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     brouer@redhat.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
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
        Richard Cochran <richardcochran@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Tyler S <tylerjstachecki@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH net v4] igb: Fix XDP with PTP enabled
Message-ID: <20210504102827.342f6302@carbon>
In-Reply-To: <20210503072800.79936-1-kurt@linutronix.de>
References: <20210503072800.79936-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 May 2021 09:28:00 +0200
Kurt Kanzenbach <kurt@linutronix.de> wrote:

> When using native XDP with the igb driver, the XDP frame data doesn't point to
> the beginning of the packet. It's off by 16 bytes. Everything works as expected
> with XDP skb mode.
> 
> Actually these 16 bytes are used to store the packet timestamps. Therefore, pull
> the timestamp before executing any XDP operations and adjust all other code
> accordingly. The igc driver does it like that as well.
> 
> Tested with Intel i210 card and AF_XDP sockets.
> 
> Fixes: 9cbc948b5a20 ("igb: add XDP support")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Thanks for fixing this!

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

I expect that we/I will (soon) play with getting this area that is
stored in front of the packet (the XDP data_meta area) described via
BTF.  This way both xdp_frame and AF_XDP can get structured access (e.g.
to the PTP timestamp in this case).

I'll be adding my notes on this project here:
 https://github.com/xdp-project/xdp-project/blob/master/areas/tsn/

Looking forward to collaborate on this with you :-)
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

