Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BED1DC0CD
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgETVB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 17:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgETVB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 17:01:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8834B2075F;
        Wed, 20 May 2020 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590008516;
        bh=AjzFwOEpYCxrPU4WdZeyfr0rlSC2xjlwacH7EQRs6jk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OmkT+hhUNlGyWg943zduC4uihFaBpkAbBtle6VSTVRcdEyFCyJ/dBiVRHZWtt5CGo
         hiNAvrv51X71Qz/9Nmf125AXUSmypxXGPDGLAbEAliy6qQcr9NkAmHy3C5xAvB+r/j
         mo6ee32KYdCzXMDFMSSY7RWoGg2lxLiSRzp1bsKw=
Date:   Wed, 20 May 2020 14:01:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>
Subject: Re: [PATCH net-next 03/12] net: atlantic: changes for multi-TC
 support
Message-ID: <20200520140154.6b6328de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520134734.2014-4-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
        <20200520134734.2014-4-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 16:47:25 +0300 Igor Russkikh wrote:
> From: Dmitry Bezrukov <dbezrukov@marvell.com>
> 
> This patch contains the following changes:
> * add cfg->is_ptp (used for PTP enable/disable switch, which
>   is described in more details below);
> * add cfg->tc_mode (A1 supports 2 HW modes only);
> * setup queue to TC mapping based on TC mode on A2;
> * remove hw_tx_tc_mode_get / hw_rx_tc_mode_get hw_ops.
> 
> In the first generation of our hardware (A1), a whole traffic class is
> consumed for PTP handling in FW (FW uses it to send the ptp data and to
> send back timestamps).
> Since this conflicts with QoS (user is unable to use the reserved TC2),
> we suggest using module param to give the user a choice: disabling PTP
> allows using all available TCs.

Is there really no way to get the config automatically chosen
when user sets up TCs or does SIOCSHWTSTAMP? It's fine to return
-EOPNOTSUPP when too many things are enabled, but user having to set
module parameters upfront is quite painful.
