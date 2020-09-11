Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA59526763F
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgIKW6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgIKW6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 18:58:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77F80221E5;
        Fri, 11 Sep 2020 22:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599865109;
        bh=f6W2aj1HboJ3SthxU/r2f4lEdlB07Gq3KwE87Wi6GTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W+F2r9X5K61wLDrWsIZ4wmsMPUuUH4df1c5b8p5yGzztWp3rI/ZdCQNYxtnouaoN7
         YI2KiF8oRw40++Gi4F/gU1LopWCM2Geh5YokYASMR7zyDbMptgkC4qDF/zcEubz3Zv
         er7oB5c31VKLV6UlpacOEwBK5QFPOs9zkSRr9v0E=
Date:   Fri, 11 Sep 2020 15:58:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, mkubecek@suse.cz,
        tariqt@nvidia.com, saeedm@nvidia.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 5/8] bnxt: add pause frame stats
Message-ID: <20200911155827.373fcfb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLikDO9+BaJBz+=VBPq7syXkGqgJsRnc8oat=wWO7Fhttmg@mail.gmail.com>
References: <20200911195258.1048468-1-kuba@kernel.org>
        <20200911195258.1048468-6-kuba@kernel.org>
        <CACKFLin6F=Y0jrJZqA75Oa+QwCyAyHK06_QnuB54-WwOqpG8MA@mail.gmail.com>
        <20200911154343.2a319485@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLikDO9+BaJBz+=VBPq7syXkGqgJsRnc8oat=wWO7Fhttmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 15:53:24 -0700 Michael Chan wrote:
> > > This will work, but the types on the 2 sides don't match.  On the
> > > right hand side, since you are casting to the hardware struct
> > > rx_port_stats and tx_port_stats, the types are __le64.
> > >
> > > If rx_stats and tx_stats are *u64 and you use these macros:
> > >
> > > BNXT_GET_RX_PORT_STATS64(rx_stats, rx_pause_frames)
> > > BNXT_GET_TX_PORT_STATS64(tx_stats, tx_pause_frames)
> > >
> > > the results will be the same with native CPU u64 types.  
> >
> > Thanks! My build bot just poked me about this as well.
> >
> > I don't see any byte swaps in bnxt_get_ethtool_stats() -
> > are they not needed there? I'm slightly confused.  
> 
> No, swapping is not needed since we are referencing the sw_stats.
> Every counter has already been swapped when we did the copy and
> overflow check from the hw struct to sw_stats.  sw_stats is exactly
> the same as the hw struct except that every counter is already swapped
> into native CPU u64 and properly adjusted for overflow.

I see, I'll change the pointer types to u64 * as well. Thanks!
