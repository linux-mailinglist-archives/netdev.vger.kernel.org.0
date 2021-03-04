Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA7732CEF2
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhCDIz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:55:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236964AbhCDIze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:55:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614848048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ALBoN6GuLRnOc5Ing6JXs8nS20VaQ0+cVKOusK5494=;
        b=bSfEoD22S4UyxtK+zrSi8tANZ0MHAwn22HjvPURaN0Jem82MSmST138q2GKohnM0J9QH5L
        ZQG3zlQcrnNEJ5PkkPHCQUwoanJLxhlXplOaflsXRw4qEmDPUme4EU5++Q5knQFHe0KwyU
        dK1EPKzIWPUVtr0lWs0KuavydPCghrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-ag5dkR-hMJW0UvGJkkLgAA-1; Thu, 04 Mar 2021 03:54:06 -0500
X-MC-Unique: ag5dkR-hMJW0UvGJkkLgAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D712157;
        Thu,  4 Mar 2021 08:54:04 +0000 (UTC)
Received: from carbon (unknown [10.36.110.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A5F810023AB;
        Thu,  4 Mar 2021 08:53:58 +0000 (UTC)
Date:   Thu, 4 Mar 2021 09:53:56 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, anthony.l.nguyen@intel.com, kuba@kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        brouer@redhat.com, Zhiqian Guan <zhguan@redhat.com>,
        Jean Hsiao <jhsiao@redhat.com>
Subject: Re: [PATCH intel-net 1/3] i40e: move headroom initialization to
 i40e_configure_rx_ring
Message-ID: <20210304095356.054a8778@carbon>
In-Reply-To: <20210303153928.11764-2-maciej.fijalkowski@intel.com>
References: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
        <20210303153928.11764-2-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Mar 2021 16:39:26 +0100
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> i40e_rx_offset(), that is supposed to initialize the Rx buffer headroom,
> relies on I40E_RXR_FLAGS_BUILD_SKB_ENABLED flag.
> 
> Currently, the callsite of mentioned function is placed incorrectly
> within i40e_setup_rx_descriptors() where Rx ring's build skb flag is not
> set yet. This causes the XDP_REDIRECT to be partially broken due to
> inability to create xdp_frame in the headroom space, as the headroom is
> 0.
> 
> For the record, below is the call graph:
> 
> i40e_vsi_open
>  i40e_vsi_setup_rx_resources
>   i40e_setup_rx_descriptors
>    i40e_rx_offset() <-- sets offset to 0 as build_skb flag is set below
> 
>  i40e_vsi_configure_rx
>   i40e_configure_rx_ring
>    set_ring_build_skb_enabled(ring) <-- set build_skb flag
> 
> Fix this by moving i40e_rx_offset() to i40e_configure_rx_ring() after
> the flag setting.
> 
> Fixes: f7bb0d71d658 ("i40e: store the result of i40e_rx_offset() onto i40e_ring")
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 13 +++++++++++++
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 ------------
>  2 files changed, 13 insertions(+), 12 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>

I'm currently looking at extending samples/bpf/ xdp_redirect_map to
detect the situation.  As with this bug the redirect tests/sample
programs will just report really high performance numbers (because
packets are dropped earlier due to err).   Knowing what performance
numbers to expect, I could see that they were out-of-spec, and
investigated the root-cause.

I assume Intel QA tested XDP-redirect and didn't find the bug due to
this.  Red Hat QA also use samples/bpf/xdp* and based on the reports I
get from them, I could not blame them if this bug would slip through,
as the tool reports "good" results.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

