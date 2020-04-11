Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F241A4FD8
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 14:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgDKMMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 08:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbgDKMMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 08:12:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6A14214D8;
        Sat, 11 Apr 2020 12:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607124;
        bh=GDBkdFyQwNJy3s7hikLvymUoDDGW7i4bveuG7EFg1oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyhTYNDQGQUsOd3W3mGJ/nmQHJzuMZfuWZYC1jxQUWMkjH0RENAGllD7l+tuycm7k
         yUB+346rrQkAw+jP0920bFKx+f/1Br9nCp1t2mmlF2XH5JXrmZT2OKciQgvzA/wQ2U
         +ST0wW0+t2iwRR6ozGEdpldJT3xx8i3OMJfj602M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Palethorpe <rpalethorpe@suse.com>,
        Kees Cook <keescook@chromium.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net
Subject: [PATCH 4.9 17/32] slcan: Dont transmit uninitialized stack data in padding
Date:   Sat, 11 Apr 2020 14:08:56 +0200
Message-Id: <20200411115420.554970658@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
References: <20200411115418.455500023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Palethorpe <rpalethorpe@suse.com>

[ Upstream commit b9258a2cece4ec1f020715fe3554bc2e360f6264 ]

struct can_frame contains some padding which is not explicitly zeroed in
slc_bump. This uninitialized data will then be transmitted if the stack
initialization hardening feature is not enabled (CONFIG_INIT_STACK_ALL).

This commit just zeroes the whole struct including the padding.

Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Fixes: a1044e36e457 ("can: add slcan driver for serial/USB-serial CAN adapters")
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: security@kernel.org
Cc: wg@grandegger.com
Cc: mkl@pengutronix.de
Cc: davem@davemloft.net
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/slcan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -147,7 +147,7 @@ static void slc_bump(struct slcan *sl)
 	u32 tmpid;
 	char *cmd = sl->rbuff;
 
-	cf.can_id = 0;
+	memset(&cf, 0, sizeof(cf));
 
 	switch (*cmd) {
 	case 'r':
@@ -186,8 +186,6 @@ static void slc_bump(struct slcan *sl)
 	else
 		return;
 
-	*(u64 *) (&cf.data) = 0; /* clear payload */
-
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
 	if (!(cf.can_id & CAN_RTR_FLAG)) {
 		for (i = 0; i < cf.can_dlc; i++) {


