Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2177C1D8AEE
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgERWaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgERWaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:30:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FB34207ED;
        Mon, 18 May 2020 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589841007;
        bh=U5qT/2aPoZavX7g3zxtHrmSQmOm/kvN8jYrMuRUOQDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CN0Uw+T4ZL2qdi+Znnb1BX7EOAhHJ1hYe3X3Oi8F0hhsModWqqrkghctAWA6QmztD
         McGkWUNSksJ8PqfhObGOvdDPuKaXqzmkHogJByntFflJ2lvh+tXK3Vmu3OLAuy4w2H
         YAjrhynvnbH5egQo+/WjW1z+VJG+q/H2sa+f3oKY=
Date:   Mon, 18 May 2020 15:30:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net/tls: fix encryption error checking
Message-ID: <20200518153005.577dfe99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200517014451.954F05026DE@novek.ru>
References: <20200517014451.954F05026DE@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 May 2020 02:48:39 +0300 Vadim Fedorenko wrote:
> tls_push_record can return -EAGAIN because of tcp layer. In that
> case open_rec is already in the tx_record list and should not be
> freed.
> Also the record size can be more than the size requested to write
> in tls_sw_do_sendpage(). That leads to overflow of copied variable
> and wrong return code.
> 
> Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Doesn't this return -EAGAIN back to user space? Meaning even tho we
queued the user space will try to send it again?
