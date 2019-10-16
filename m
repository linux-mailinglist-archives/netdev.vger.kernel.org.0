Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40032D99DF
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403772AbfJPTTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:19:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390783AbfJPTTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:19:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E657142D4201;
        Wed, 16 Oct 2019 12:19:51 -0700 (PDT)
Date:   Wed, 16 Oct 2019 12:19:50 -0700 (PDT)
Message-Id: <20191016.121950.1487403738523364817.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, shahjada@chelsio.com
Subject: Re: [PATCH net] cxgb4: Fix panic when attaching to ULD fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571039435-22495-1-git-send-email-vishal@chelsio.com>
References: <1571039435-22495-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 12:19:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Mon, 14 Oct 2019 13:20:35 +0530

> @@ -760,7 +762,9 @@ void cxgb4_register_uld(enum cxgb4_uld type,
>  		if (ret)
>  			goto free_irq;
>  		adap->uld[type] = *p;
> -		uld_attach(adap, type);
> +		ret = uld_attach(adap, type);
> +		if (ret)
> +			goto free_irq;

You're not freeing up all of the txq_info ULD stuff that setup_sge_txq_uld
created.
