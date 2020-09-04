Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7114D25D281
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgIDHgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:36:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbgIDHf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 03:35:59 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-8I2tKuALN4GdHpuv0fjZjQ-1; Fri, 04 Sep 2020 03:35:55 -0400
X-MC-Unique: 8I2tKuALN4GdHpuv0fjZjQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0137801AEE;
        Fri,  4 Sep 2020 07:35:53 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0224A18B59;
        Fri,  4 Sep 2020 07:35:43 +0000 (UTC)
Date:   Fri, 4 Sep 2020 09:35:42 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        brouer@redhat.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH v2 net-next 2/9] xdp: initialize xdp_buff mb bit to 0 in
 all XDP drivers
Message-ID: <20200904093542.4dc43682@carbon>
In-Reply-To: <05822dfe200c5d581d6a6cad89c1b63bb7a1c566.1599165031.git.lorenzo@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
        <05822dfe200c5d581d6a6cad89c1b63bb7a1c566.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Sep 2020 22:58:46 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 0b675c34ce49..20c8fd3cd4a3 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -2298,6 +2298,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
>  #if (PAGE_SIZE < 8192)
>  	xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, 0);
>  #endif
> +	xdp.mb = 0;
>  
>  	while (likely(total_rx_packets < budget)) {
>  		union ixgbe_adv_rx_desc *rx_desc;

In this ixgbe driver you are smart and init the xdp.mb bit outside the
(like xdp.frame_sz, when frame_sz is constant).   This is a nice
optimization, but the driver developer that adds XDP multi-buffer
support must remember to reset it.  The patch itself is okay, it is
just something to keep in-mind when reviewing/changing drivers.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

