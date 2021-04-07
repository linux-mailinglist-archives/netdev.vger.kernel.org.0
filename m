Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9659356A4C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351449AbhDGKux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351515AbhDGKtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 06:49:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65FA86108B;
        Wed,  7 Apr 2021 10:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617792550;
        bh=MBTn7f+U7eT5a0y4eY4W/cKzzRkqROJDMGKQWGHgY3I=;
        h=From:To:Cc:Subject:Date:From;
        b=HBOol3DTzDwf59J9/tYwnGvSHsLl5s6c2GY7ptsQuN320msxSJvos6uJao9uVjn5B
         u8CoQv/ayoy/XkJzwHzYZX+ZR0nF+ycYXSkZ2nLJ0xuiPm0Z92v9USd7lHzzWC34J0
         PqP+rgD/RZRZ+zNx1l2pCDIcvEa6eNXoUe0eNoRlVI32trNyRPW/ryJtamrphtoGbW
         xRWDpq2k4KmTb6ezTAVvlF9VT1wfDrNtHKRjx3jh/63JqFAxCKcqoe7CAukRCWNcJ5
         S3FKYy6UQoTSe+jR72y9/ae+C69+Lm3NudMM0xGrmDKkNqFuCxSvcs2fnLu4O5QOAj
         Yt6D8Q2egHPpA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lU5k6-0000MQ-Oi; Wed, 07 Apr 2021 12:49:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH net-next] net: wan: z85230: drop unused async state
Date:   Wed,  7 Apr 2021 12:48:56 +0200
Message-Id: <20210407104856.1345-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the changelog, asynchronous mode was dropped sometime
before v2.2. Let's get rid of the unused driver-specific async state as
well so that it doesn't show up when doing tree-wide tty work.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wan/z85230.h | 39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/net/wan/z85230.h b/drivers/net/wan/z85230.h
index 1081d171e477..462cb620bc5d 100644
--- a/drivers/net/wan/z85230.h
+++ b/drivers/net/wan/z85230.h
@@ -327,45 +327,6 @@ struct z8530_channel
 	void		*private;	/* For our owner */
 	struct net_device	*netdevice;	/* Network layer device */
 
-	/*
-	 *	Async features
-	 */
-
-	struct tty_struct 	*tty;		/* Attached terminal */
-	int			line;		/* Minor number */
-	wait_queue_head_t	open_wait;	/* Tasks waiting to open */
-	wait_queue_head_t	close_wait;	/* and for close to end */
-	unsigned long		event;		/* Pending events */
-	int			fdcount;    	/* # of fd on device */
-	int			blocked_open;	/* # of blocked opens */
-	int			x_char;		/* XON/XOF char */
-	unsigned char 		*xmit_buf;	/* Transmit pointer */
-	int			xmit_head;	/* Transmit ring */
-	int			xmit_tail;
-	int			xmit_cnt;
-	int			flags;	
-	int			timeout;
-	int			xmit_fifo_size;	/* Transmit FIFO info */
-
-	int			close_delay;	/* Do we wait for drain on close ? */
-	unsigned short		closing_wait;
-
-	/* We need to know the current clock divisor
-	 * to read the bps rate the chip has currently
-	 * loaded.
-	 */
-
-	unsigned char		clk_divisor;  /* May be 1, 16, 32, or 64 */
-	int			zs_baud;
-
-	int			magic;
-	int			baud_base;		/* Baud parameters */
-	int			custom_divisor;
-
-
-	unsigned char		tx_active; /* character is being xmitted */
-	unsigned char		tx_stopped; /* output is suspended */
-
 	spinlock_t		*lock;	  /* Device lock */
 };
 
-- 
2.26.3

