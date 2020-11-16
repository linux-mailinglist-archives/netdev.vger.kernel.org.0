Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D332B4AC9
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbgKPQVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731938AbgKPQVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:21:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13740C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:21:24 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605543682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jtvi8V/LQ5Rz6+0ztSY/Wqp0Vo+6J9KTqf1s3xDgcTo=;
        b=yMsU7MtjRiWYE/hV3aSXuElkOrLBBaBHa6p6FnbBdqqeeeEQWQw39NYOVGk9Ufvdl6YLJ1
        bsIGLHFo5EQ9JCHslkNw83dLATvFZM6nr7F7pPrjkKZrQG3WIhpqTQssaVH5KAXC9OHrIR
        0Thvt4teukV2zWRZAOEkG8bptsH5G+y7gTh54FUZbmxl53zaIH9IoWRkHpBk99+3mf89vn
        r7U8SHcOFXn0wAehQCG8I/za6Br7t98DOBsk7C2NITGTpAjhKZkfsYNZG/aGbDHYYubyvs
        IcLKWF+Iq3QuTthm6xct584zQwsP+iH1gu0tRtiIih26SYt2MgnnQ53fv/WMJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605543682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jtvi8V/LQ5Rz6+0ztSY/Wqp0Vo+6J9KTqf1s3xDgcTo=;
        b=mIao/k0l+YKGI6MGB/D+EmLXVbSEol2bfW+xcs228wXAp5uCbpWzBuT/oNMm2AJnVR5oAZ
        cXusfG4J4XMKG6Cw==
To:     linux-atm-general@lists.sourceforge.net
Cc:     Chas Williams <3chas3@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/3] atm: lanai: Remove in_interrupt() usage
Date:   Mon, 16 Nov 2020 17:21:16 +0100
Message-Id: <20201116162117.387191-4-bigeasy@linutronix.de>
In-Reply-To: <20201116162117.387191-1-bigeasy@linutronix.de>
References: <20201116162117.387191-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lanai_shutdown_tx_vci() uses in_interrupt() to issue a warning message
if the function was used in context in which it is not safe to sleep.

The usage of in_interrupt() in driver code is deprecated as it can not alwa=
ys
detect all states where it is not allowed to sleep.

msleep() has debug code which will trigger a warning if used in bad
context.

Remove in_interrupt().

Cc: Chas Williams <3chas3@gmail.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/atm/lanai.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index ac811cfa68431..d7277c26e4232 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -765,8 +765,7 @@ static void lanai_shutdown_tx_vci(struct lanai_dev *lan=
ai,
 	struct sk_buff *skb;
 	unsigned long flags, timeout;
 	int read, write, lastread =3D -1;
-	APRINTK(!in_interrupt(),
-	    "lanai_shutdown_tx_vci called w/o process context!\n");
+
 	if (lvcc->vbase =3D=3D NULL)	/* We were never bound to a VCI */
 		return;
 	/* 15.2.1 - wait for queue to drain */
--=20
2.29.2

