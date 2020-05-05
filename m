Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DA31C61EE
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgEEUZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728756AbgEEUZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:25:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE99C061A0F;
        Tue,  5 May 2020 13:25:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C90331280C7D8;
        Tue,  5 May 2020 13:24:59 -0700 (PDT)
Date:   Tue, 05 May 2020 13:24:59 -0700 (PDT)
Message-Id: <20200505.132459.1059623707678036566.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     anders.roxell@linaro.org, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: fix build
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505162123.13366-1-grygorii.strashko@ti.com>
References: <20200505162123.13366-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 13:25:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Tue, 5 May 2020 19:21:23 +0300

> It's possible to have build configuration which will force PTP_1588_CLOCK=m
> and so TI_K3_AM65_CPTS=m while still have TI_K3_AM65_CPSW_NUSS=y. This will
> cause build failures:
> 
> aarch64-linux-gnu-ld: ../drivers/net/ethernet/ti/am65-cpsw-nuss.o: in function `am65_cpsw_init_cpts':
> ../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685: undefined reference to `am65_cpts_create'
> aarch64-linux-gnu-ld: ../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:(.text+0x2e20):
> relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `am65_cpts_create'
> 
> Fix it by adding dependencies from CPTS in TI_K3_AM65_CPSW_NUSS as below:
>    config TI_K3_AM65_CPSW_NUSS
>    ...
>      depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS
> 
> Note. This will create below dependencies and for NFS boot + CPTS all of them
> have to be built-in.
>   PTP_1588_CLOCK -> TI_K3_AM65_CPTS -> TI_K3_AM65_CPSW_NUSS
> 
> While here, clean up TI_K3_AM65_CPTS definition.
> 
> Fixes: b1f66a5bee07 ("net: ethernet: ti: am65-cpsw-nuss: enable packet timestamping support")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Reported-by: Anders Roxell <anders.roxell@linaro.org>

Applied.
