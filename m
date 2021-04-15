Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC43608E1
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhDOMFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 08:05:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232276AbhDOMFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 08:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618488292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KnDmEC1PEXguYIGj0CwznxutAgI3StoFIDa8gakyiAE=;
        b=LrixZqNobu6wJisPQGhyMKsqA/Z34IUtHD8qb7OUixIWN1NL/d/8lkfMRLlfELVwQ+EHxb
        +JS8pX06ts/WB3ntxarN66ECWAL3dTJNYhaKWcv5SEs5UXVOhGvkBBbpQwFfPjG0zaCF9K
        YCdaNAIJn5QOzfM4sUZlxnd8PZDyxlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-z0_8Q-5rPguF2E4pbTNTyA-1; Thu, 15 Apr 2021 08:04:47 -0400
X-MC-Unique: z0_8Q-5rPguF2E4pbTNTyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8755679EC5;
        Thu, 15 Apr 2021 12:04:45 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A5602C01E;
        Thu, 15 Apr 2021 12:04:41 +0000 (UTC)
Date:   Thu, 15 Apr 2021 14:04:38 +0200
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
Message-ID: <20210415140438.60221f21@carbon>
In-Reply-To: <20210415092145.27322-1-kurt@linutronix.de>
References: <20210415092145.27322-1-kurt@linutronix.de>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 11:21:45 +0200
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

Doesn't the i210 card use the igc driver?
This change is for igb driver.


> Fixes: 9cbc948b5a20 ("igb: add XDP support")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
[...]
> 
> drivers/net/ethernet/intel/igb/igb.h      |  3 +-
>  drivers/net/ethernet/intel/igb/igb_main.c | 46 ++++++++++++-----------
>  drivers/net/ethernet/intel/igb/igb_ptp.c  | 21 ++++-------
>  3 files changed, 33 insertions(+), 37 deletions(-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

