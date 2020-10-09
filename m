Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FB1287F7F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgJIA20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:32972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728577AbgJIA2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 20:28:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34B4A22253;
        Fri,  9 Oct 2020 00:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602203305;
        bh=5SfylexU6mN7FqDeNr+uOzm4QrDSV4c5RAe3T9CWaC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bNCHXUa2DV0eMSj7T0xLZj1qu2TRxRgW5c3mwcuA+M2aBIBGeLShj6R9vDgP9BU5t
         +9tU9+WVJJ68zG1xWOvhvtpoMOMyOGGLwb+gl5e0iEuTz6U91fnuzSRqahxKClhzLU
         mgPh2CyzLidG2XiT0nAKOdihj4MhbeyRLlPTfgkM=
Date:   Thu, 8 Oct 2020 17:28:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next] mptcp: fix infinite loop on recvmsg()/worker()
 race.
Message-ID: <20201008172823.3e1ea388@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5a2464d778499bdc2ced43b56569008030b470bc.1601965539.git.pabeni@redhat.com>
References: <5a2464d778499bdc2ced43b56569008030b470bc.1601965539.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 08:27:34 +0200 Paolo Abeni wrote:
> If recvmsg() and the workqueue race to dequeue the data
> pending on some subflow, the current mapping for such
> subflow covers several skbs and some of them have not
> reached yet the received, either the worker or recvmsg()
> can find a subflow with the data_avail flag set - since
> the current mapping is valid and in sequence - but no
> skbs in the receive queue - since the other entity just
> processed them.
> 
> The above will lead to an unbounded loop in __mptcp_move_skbs()
> and a subsequent hang of any task trying to acquiring the msk
> socket lock.
> 
> This change addresses the issue stopping the __mptcp_move_skbs()
> loop as soon as we detect the above race (empty receive queue
> with data_avail set).

Applied, thanks!
