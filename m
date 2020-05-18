Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAA61D8B43
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgERWuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgERWuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:50:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A76DE207ED;
        Mon, 18 May 2020 22:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589842218;
        bh=JGQcujKukE/1TVxj+H1UZ5CvBZFX4sQdFwUhid7tADc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=owaz4pCYKZMGITDDSyMjkK7Qp2E5PSjO6YACWBM5x4Zk3Tfa7cuJutmkZyEUdLzGt
         s89cunJg16B2w1wJDYvgwBZq1rsCAvZNVMTCvhZwrj1xcE69Z+jEU/LTmDFEijHpuz
         OGk7/uzY8xkdMDDIjOQZpaNImYy4C2juQ5l+nLpQ=
Date:   Mon, 18 May 2020 15:50:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        pooja.trivedi@stackpath.com
Subject: Re: [PATCH net] net/tls(TLS_SW): Fix integrity issue with
 non-blocking sw KTLS request
Message-ID: <20200518155016.75be3663@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1589732796-22839-1-git-send-email-pooja.trivedi@stackpath.com>
References: <1589732796-22839-1-git-send-email-pooja.trivedi@stackpath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 May 2020 16:26:36 +0000 Pooja Trivedi wrote:
> In pure sw ktls(AES-NI), -EAGAIN from tcp layer (do_tcp_sendpages for
> encrypted record) gets treated as error, subtracts the offset, and
> returns to application. Because of this, application sends data from
> subtracted offset, which leads to data integrity issue. Since record is
> already encrypted, ktls module marks it as partially sent and pushes the
> packet to tcp layer in the following iterations (either from bottom half
> or when pushing next chunk). So returning success in case of EAGAIN
> will fix the issue.
> 
> Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption")
> Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
> Reviewed-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
> Reviewed-by: Josh Tway <josh.tway@stackpath.com>

This looks reasonable, I think. Next time user space calls if no new
buffer space was made available it will get a -EAGAIN, right?

Two questions - is there any particular application or use case that
runs into this? Seems a bit surprising to see a patch from Vadim and
you guys come at the same time.

Could you also add test for this bug? 
In tools/testing/selftests/net/tls.c
