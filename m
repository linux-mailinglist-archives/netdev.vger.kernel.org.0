Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295052B0F1E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgKLUms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727025AbgKLUms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 15:42:48 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F8A216C4;
        Thu, 12 Nov 2020 20:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605213768;
        bh=PHfB4RkTraUL/H9bLEP3SW5hA6seRMXIa0vuiNWCKqc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=wEKHsVsKm7sWXNkh24OXBzEQJqEU6bs7eJbJjEe5s0uGvysvH8P611RJ1a1ii2Rai
         oWJ46tVAhtMfE8K90Lf4Hb4IoNNMjfhK/YxgwgrhclHVixomy6HKFzkYQ65OVvl1rt
         L/dsYXgY/I2SP25HYNGwrEXtbgxtJJrb06VgW4pw=
Message-ID: <8a8e5afd2502a57c9a86f64b30066a467afb3c2f.camel@kernel.org>
Subject: Re: [PATCH net-next 2/7] dpaa_eth: add basic XDP support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Camelia Groza <camelia.groza@nxp.com>, kuba@kernel.org,
        brouer@redhat.com, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:42:43 -0800
In-Reply-To: <7389fa62d9e311236f2e39c5d5d153cabc59949d.1605181416.git.camelia.groza@nxp.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
         <7389fa62d9e311236f2e39c5d5d153cabc59949d.1605181416.git.camelia.groza@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 20:10 +0200, Camelia Groza wrote:
> +       if (likely(fd_format == qm_fd_contig)) {
> 
> +               xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd,
> vaddr,
> 
> +                                      &xdp_meta_len);
> 
> +               if (xdp_act != XDP_PASS) {
> 
> +                       percpu_stats->rx_packets++;
> 
> +                       percpu_stats->rx_bytes +=
> qm_fd_get_length(fd);
> 
> +                       return qman_cb_dqrr_consume;
> 
> +               }
> 
>                 skb = contig_fd_to_skb(priv, fd);
> 
> -       else
> 
> +       } else {
> 
> +               WARN_ONCE(priv->xdp_prog, "S/G frames not supported
> under XDP\n");
> 

Why do you even allow xdp_setup() if S/G is configured ?
just block this on xdp_setup() or on S/G setup on device open()

>                 skb = sg_fd_to_skb(priv, fd);
> 
> +       }

