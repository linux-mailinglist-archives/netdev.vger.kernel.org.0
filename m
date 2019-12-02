Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85CF10F1F4
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 22:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfLBVN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 16:13:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfLBVN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 16:13:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11AEF14CF4DEA;
        Mon,  2 Dec 2019 13:13:28 -0800 (PST)
Date:   Mon, 02 Dec 2019 13:13:27 -0800 (PST)
Message-Id: <20191202.131327.1991319206654704992.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     inaky@linux.intel.com, linux-wimax@intel.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2400m/USB: fix error return when rx_size is too large
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191202174246.77305-1-colin.king@canonical.com>
References: <20191202174246.77305-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Dec 2019 13:13:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon,  2 Dec 2019 17:42:46 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently when the rx_size is too large the intended error
> -EINVAL is not being returned as this is being assigned to
> result rather than rx_skb. Fix this be setting rx_skb
> to ERR_PTR(-EINVAL) so that the error is returned in rx_skb
> as originally intended.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: a8ebf98f5414 ("i2400m/USB: TX and RX path backends")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

This leaks rx_skb, the caller is supposed to clean up rx_skb
by freeing it if this function doesn't transmit it successfully.
