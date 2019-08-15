Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB9B8F7A3
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHOXgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:36:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHOXgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:36:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 658A812651255;
        Thu, 15 Aug 2019 16:36:49 -0700 (PDT)
Date:   Thu, 15 Aug 2019 16:36:48 -0700 (PDT)
Message-Id: <20190815.163648.1684648819390926444.davem@davemloft.net>
To:     sr@denx.de
Cc:     netdev@vger.kernel.org, opensource@vdorst.com,
        daniel@makrotopia.org, sean.wang@mediatek.com, john@phrozen.org
Subject: Re: [PATCH net-next 4/4 v2] net: ethernet: mediatek: Add MT7628/88
 SoC support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814111825.10855-4-sr@denx.de>
References: <20190814111825.10855-1-sr@denx.de>
        <20190814111825.10855-4-sr@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 16:36:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Roese <sr@denx.de>
Date: Wed, 14 Aug 2019 13:18:25 +0200

> +static int txd_to_idx(struct mtk_tx_ring *ring, struct mtk_tx_dma *dma)
> +{
> +	return ((u32)dma - (u32)ring->dma) / sizeof(*dma);
> +}

This will definitely warn on 64-bit, and you should avoid that even if this
driver can not possibly be built on 64-bit platforms.

You cannot truncate a pointer to an integer which is potentially smaller
in representation size than a pointer could potentially be.

Just can avoid all of these issues by using real pointer arithmetic and
casting to (char *), or even better, (void *).
