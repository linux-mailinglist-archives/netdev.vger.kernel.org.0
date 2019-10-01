Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B68EC3E5F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfJARQQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 13:16:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50278 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfJARQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:16:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C83CA154F2032;
        Tue,  1 Oct 2019 10:16:15 -0700 (PDT)
Date:   Tue, 01 Oct 2019 10:16:15 -0700 (PDT)
Message-Id: <20191001.101615.1260420946739435364.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next] net/rds: Use DMA memory pool allocation for
 rds_header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 10:16:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Mon, 30 Sep 2019 02:08:00 -0700

> Currently, RDS calls ib_dma_alloc_coherent() to allocate a large piece
> of contiguous DMA coherent memory to store struct rds_header for
> sending/receiving packets.  The memory allocated is then partitioned
> into struct rds_header.  This is not necessary and can be costly at
> times when memory is fragmented.  Instead, RDS should use the DMA
> memory pool interface to handle this.
> 
> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

This is trading a one-time overhead for extra levels of dereferencing
on every single descriptor access in the fast paths.

I do not agree with this tradeoff, please implement this more
reasonably.
