Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C5A1C430D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgEDRjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729969AbgEDRjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:39:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCA5C061A0E;
        Mon,  4 May 2020 10:39:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3A8F15B52E80;
        Mon,  4 May 2020 10:39:36 -0700 (PDT)
Date:   Mon, 04 May 2020 10:39:35 -0700 (PDT)
Message-Id: <20200504.103935.1584665284135386530.davem@davemloft.net>
To:     joyce.ooi@intel.com
Cc:     thor.thayer@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dalon.westergreen@intel.com,
        ley.foon.tan@intel.com, chin.liang.see@intel.com,
        dinh.nguyen@intel.com
Subject: Re: [PATCHv2 01/10] net: eth: altera: tse_start_xmit ignores
 tx_buffer call response
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504082558.112627-2-joyce.ooi@intel.com>
References: <20200504082558.112627-1-joyce.ooi@intel.com>
        <20200504082558.112627-2-joyce.ooi@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 10:39:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joyce Ooi <joyce.ooi@intel.com>
Date: Mon,  4 May 2020 16:25:49 +0800

> The return from tx_buffer call in tse_start_xmit is
> inapropriately ignored.  tse_buffer calls should return
> 0 for success or NETDEV_TX_BUSY.  tse_start_xmit should
> return not report a successful transmit when the tse_buffer
> call returns an error condition.

From driver.txt:

====================
1) The ndo_start_xmit method must not return NETDEV_TX_BUSY under
   any normal circumstances.  It is considered a hard error unless
   there is no way your device can tell ahead of time when it's
   transmit function will become busy.
====================

The problem is that when you return this error code, something has
to trigger restarting the transmit queue to start sending packets
to your device again.  The usual mechanism is waking the transmit
queue, but it's obviously already awake since your transmit routine
is being called.  Therefore nothing will reliably restart the queue
when you return this error code.

The best thing to do honestly is to drop the packet and return
NETDEV_TX_OK, meanwhile bumping a statistic counter to record this
event.
