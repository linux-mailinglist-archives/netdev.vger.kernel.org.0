Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA46335A9EB
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 03:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhDJBX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 21:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhDJBX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 21:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2818D610E5;
        Sat, 10 Apr 2021 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618017793;
        bh=eHinba/b43Qm1YPgt0k98KpU2ScxfhNtgLreIjItFOY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kZPLJJ84ISSpgSUF6OxQQn3SOEtfniA6VeJsfYeQppFZYVabUTVZM4NOJh0Jp0K2v
         jgcAPrk00euha41eyfdEtG+FxTgsKZ5t9/xN7j201gqyCu22Sdxgctc6Un+XJde5aC
         c7UOAvVTxmrJ6c3iWI7vrSHYkIVuX0jLkVTn08jBRwSjXU2Lv/o+7YgTDOGS1MsdTT
         SScuCwf3ciHGkis4wFQnS6PpyAPg3Rr3DpVOqqUH1+vwHRR/QCW0oMDAh/CuLzV73h
         OgnmGFOCJ2X/ToQJQ2sbuvuhf7fjRewls7e5QfBZUSWgeKQu+5CdBrEI55E08v1fsP
         ZMV+DsCvptz6Q==
Date:   Fri, 9 Apr 2021 18:23:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] enetc: Use generic rule to map Tx rings to
 interrupt vectors
Message-ID: <20210409182312.5f440d95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409101952.iyf4svtgxvgwvxfr@skbuf>
References: <20210409071613.28912-1-claudiu.manoil@nxp.com>
        <20210409101952.iyf4svtgxvgwvxfr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 13:19:52 +0300 Vladimir Oltean wrote:
> On Fri, Apr 09, 2021 at 10:16:13AM +0300, Claudiu Manoil wrote:
> > Even if the current mapping is correct for the 1 CPU and 2 CPU cases
> > (currently enetc is included in SoCs with up to 2 CPUs only), better
> > use a generic rule for the mapping to cover all possible cases.
> > The number of CPUs is the same as the number of interrupt vectors:
> > 
> > Per device Tx rings -
> > device_tx_ring[idx], where idx = 0..n_rings_total-1
> > 
> > Per interrupt vector Tx rings -
> > int_vector[i].ring[j], where i = 0..n_int_vects-1
> > 			     j = 0..n_rings_per_v-1
> > 
> > Mapping rule -
> > n_rings_per_v = n_rings_total / n_int_vects
> > for i = 0..n_int_vects - 1:
> > 	for j = 0..n_rings_per_v - 1:
> > 		idx = n_int_vects * j + i
> > 		int_vector[i].ring[j] <- device_tx_ring[idx]
> > 
> > Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks!
