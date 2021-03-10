Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E113335FE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 07:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhCJGqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 01:46:53 -0500
Received: from mx1.emlix.com ([136.243.223.33]:40960 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhCJGq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 01:46:28 -0500
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id C58F05FED7;
        Wed, 10 Mar 2021 07:46:26 +0100 (CET)
Date:   Wed, 10 Mar 2021 07:46:26 +0100
From:   Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
To:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Softirq error with mcp251xfd driver
Message-ID: <20210310064626.GA11893@homes.emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

the mcp251xfd driver uses a threaded irq handler to queue skbs with the
can_rx_offload_* helpers. I get the following error on every packet until
the rate limit kicks in:

NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!

Adding local_bh_disable/local_bh_enable around the can_rx_offload_* calls
gets rid of the error, but is that the correct way to fix this?
Internally the can_rx_offload code uses spin_lock_irqsave to safely
manipulate its queue.

Best regards,

  Daniel
