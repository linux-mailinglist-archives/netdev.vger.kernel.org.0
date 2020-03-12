Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A2183CB1
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCLWlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:41:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgCLWlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:41:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F1A91584237D;
        Thu, 12 Mar 2020 15:41:10 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:41:10 -0700 (PDT)
Message-Id: <20200312.154110.308373641367156886.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] ionic: tx and rx queues state follows
 link state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312215015.69547-2-snelson@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
        <20200312215015.69547-2-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:41:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 12 Mar 2020 14:50:09 -0700

> +		if (!test_bit(IONIC_LIF_F_UP, lif->state) &&
> +		    netif_running(netdev)) {
> +			rtnl_lock();
> +			ionic_open(netdev);
> +			rtnl_unlock();
>  		}

You're running into a major problem area here.

ionic_open() can fail, particularly because it allocates resources.

Yet you are doing this in an operational path that doesn't handle
and unwind from errors.

You must find a way to do this properly, because the current approach
can result in an inoperable interface.
