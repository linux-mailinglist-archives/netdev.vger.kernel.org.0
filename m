Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EC440495B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbhIILgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbhIILf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 07:35:59 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870DCC061575;
        Thu,  9 Sep 2021 04:34:50 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 74FA34F288FA9;
        Thu,  9 Sep 2021 04:34:47 -0700 (PDT)
Date:   Thu, 09 Sep 2021 12:34:42 +0100 (BST)
Message-Id: <20210909.123442.1648633411296774237.davem@davemloft.net>
To:     linux@roeck-us.net
Cc:     ajk@comnets.uni-bremen.de, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 6pack: Fix tx timeout and slot time
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210909035743.1247042-1-linux@roeck-us.net>
References: <20210909035743.1247042-1-linux@roeck-us.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 09 Sep 2021 04:34:48 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Wed,  8 Sep 2021 20:57:43 -0700

> tx timeout and slot time are currently specified in units of HZ.
> On Alpha, HZ is defined as 1024. When building alpha:allmodconfig,
> this results in the following error message.
> 
> drivers/net/hamradio/6pack.c: In function 'sixpack_open':
> drivers/net/hamradio/6pack.c:71:41: error:
> 	unsigned conversion from 'int' to 'unsigned char'
> 	changes value from '256' to '0'
> 
> In the 6PACK protocol, tx timeout is specified in units of 10 ms
> and transmitted over the wire. Defining a value dependent on HZ
> doesn't really make sense. Assume that the intent was to set tx
> timeout and slot time based on a HZ value of 100 and use constants
> instead of values depending on HZ for SIXP_TXDELAY and SIXP_SLOTTIME.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> No idea if this is correct or even makes sense. Compile tested only.

These are timer offsets so they have to me HZ based.  Better to make the
structure members unsigned long, I think.

Thanks.

