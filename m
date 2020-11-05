Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777BE2A74C9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387851AbgKEBQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKEBQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:16:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BBED206E3;
        Thu,  5 Nov 2020 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604538970;
        bh=3r2MutcLvA5vfYMXLE0DmewD6e+qCFh7NdwOTIdnQNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ziB/nHm8W6P7qa3XOAWj843yTttfuQ7/eTLli6c7E4Km5sWXA/wFfO/XU9FyUDy3z
         8qxUO3kmjFsUAdyNjYT9wFdgfHFvGigmMcmxlMRAR+jqVVAGvABVIW7ib1NcvlDn11
         2I0jQQh6EnfQOQ37AOmZTgSTUGVGbo3UKeLg6dds=
Date:   Wed, 4 Nov 2020 17:16:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
Message-ID: <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103104702.798-1-vinay.yadav@chelsio.com>
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 16:17:03 +0530 Vinay Kumar Yadav wrote:
> user can initialize tls ulp using setsockopt call on socket
> before listen() in case of tls-toe (TLS_HW_RECORD) and same
> setsockopt call on connected socket in case of kernel tls (TLS_SW).
> In presence of tls-toe devices, TLS ulp is initialized, tls context
> is allocated per listen socket and socket is listening at adapter
> as well as kernel tcp stack. now consider the scenario, connections
> are established in kernel stack.
> on every connection close which is established in kernel stack,
> it clears tls context which is created on listen socket causing
> kernel panic.
> Addressed the issue by setting child socket to base (non TLS ULP)
> when tls ulp is initialized on parent socket (listen socket).
> 
> Fixes: 76f7164d02d4 ("net/tls: free ctx in sock destruct")
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

We should prevent from the socket getting into LISTEN state in the
first place. Can we make a copy of proto_ops (like tls_sw_proto_ops) 
and set listen to sock_no_listen? 
