Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA00733821C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhCLAK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:10:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhCLAKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:10:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8953264F86;
        Fri, 12 Mar 2021 00:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615507831;
        bh=h8hG6xxanahHaqGCf65+TvGHPEWMZDrBHbB++93jOFk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gDLfCOm0rmXX1tOxTGcySetptlPlSEkO+cMUJD5cna3ehVsDkMQcqa1yLuLA/aNhb
         oEpiBcwsyuj2NrgJlmLklBRRuCYke+xFXsS/cyKGzPCOcBSctgnucfkI1me/wm2DzI
         i6wKmOp/JvjONNDUORfY0A10U3RwP11WW+ZXQShz+VSeHPBuoqN0U/g0Vc32zZVbfD
         lHW6p8ahljDNixxJOuEk+3WRQjd8gqAyZ6YL5jSYH67KQhTwgKZHIPIyXZeph3cIhp
         QgpCs3j+LCr8i6bMpi1Rc1mfDbsdSKswymEu3OKY78ozj4ZSRbggXRDR/CZ93PLZhb
         jNXcvYN8h85zQ==
Date:   Thu, 11 Mar 2021 16:10:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking
 whether the netif is running
Message-ID: <20210311161030.5ed11805@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_EMR6kqsetwNUbJJziLW97T0pXBSqSNZ5ma-q175cxoKyQ@mail.gmail.com>
References: <20210311072311.2969-1-xie.he.0141@gmail.com>
        <20210311124309.5ee0ef02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EMToKj2OeeE1fMfwAVYvhbgZpENkv0C7ac+XHnWcTe2Tg@mail.gmail.com>
        <20210311145230.5f368151@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EMR6kqsetwNUbJJziLW97T0pXBSqSNZ5ma-q175cxoKyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 15:13:01 -0800 Xie He wrote:
> On Thu, Mar 11, 2021 at 2:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Normally driver's ndo_stop() calls netif_tx_disable() which takes TX
> > locks, so unless your driver is lockless (LLTX) there should be no xmit
> > calls after that point.  
> 
> Do you mean I should call "netif_tx_disable" inside my "ndo_stop"
> function as a fix for the racing between "ndo_stop" and
> "ndo_start_xmit"?
> 
> I can't call "netif_tx_disable" inside my "ndo_stop" function because
> "netif_tx_disable" will call "netif_tx_stop_queue", which causes
> another racing problem. Please see my recent commit f7d9d4854519
> ("net: lapbether: Remove netif_start_queue / netif_stop_queue")

And the "noqueue" queue is there because it's on top of hdlc_fr.c
somehow or some out of tree driver? Or do you install it manually?
