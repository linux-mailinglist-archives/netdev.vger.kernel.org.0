Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8727F7A0
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390697AbfHBM5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:57:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42336 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729507AbfHBM5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 08:57:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so35999725pff.9;
        Fri, 02 Aug 2019 05:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LoAtgdh28RgsnIrIHcdfMXphwAqA4AaDMnurCisSK6U=;
        b=IQhAZ6Mniq30SEmLYLZBzc5g2RlDWm/ysbnhx6XLlNt4XriLjwcttXz0juAkSQxIrt
         NOexkQVCuRTzcpQ9XPS3wxiYl9B1co23j02WmpVOhDS1YQoD5bPcoo+pmISS2v1RRqZH
         n79hrX3tL2nDp5MvAoNrno13iE+v4F77pJeZUReTNYm+BxjbM1fCJOaIcd2NvHSXh6gv
         I9+ZRmHR4NGVBFDR/GjT76Fpx/WORTxShwt/Olo1xl22D/XB3KcL1WzjUuT1+aWi3DQu
         Vo869HnIozxzBbud7oKunCsYQnXlGDLaHCnAtKePHFTFDdrtT5HWNrlT/dxzHvtBF6gL
         QR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LoAtgdh28RgsnIrIHcdfMXphwAqA4AaDMnurCisSK6U=;
        b=aopdyLFAvzsGByuRVbcXDQBdqSt6gqTJYU9eE+U+ubE9Swomd5HEylg1WQNmekOxgM
         jZHgoEeCSl83pyNpZ+tuzK+2hbskDPunCdVI2rZkMvX2bFYCPEeTk7UjxorIA44Z6G0R
         R+w0wgtgSmIamSf6WYzgrQGfTjHFck9OuJFB8UvWISmX5I/zEfo5f2Gff3AYVeLmXt3w
         VNyeLAZLn2YW+/ALpNH04llV5A6FVM4qFtr9i4Vaok+10kkcBuEXL6wzKlxxbU42CU3I
         /1b36+DlDl0m2q8UrTMgzkr2K4qYaLd3W0YQcxock6pgQPyg8xoF8N6EmK1CyYUZNdEZ
         WXwQ==
X-Gm-Message-State: APjAAAV8NneCFf/Xstx7T82Yp2daU0JdxzpusRtFTzAVX8iD92GQsSa7
        lcFcd0dFDfHRGmToR3PA7As=
X-Google-Smtp-Source: APXvYqwC+xBVwrbnvwY/onebEyoZ/bnVlukBkRdWNXMitH24mNcG5N+1XdaCyIawjXpXhLqxmxcEFw==
X-Received: by 2002:a62:2aca:: with SMTP id q193mr60883175pfq.209.1564750639787;
        Fri, 02 Aug 2019 05:57:19 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id q21sm4296785pgm.39.2019.08.02.05.57.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 05:57:19 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] mkiss: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 20:57:14 +0800
Message-Id: <20190802125714.22309-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/hamradio/mkiss.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 442018ccd65e..b0afd7d13553 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -70,7 +70,7 @@ struct mkiss {
 #define CRC_MODE_FLEX_TEST	3
 #define CRC_MODE_SMACK_TEST	4
 
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct completion	dead;
 };
 
@@ -668,7 +668,7 @@ static struct mkiss *mkiss_get(struct tty_struct *tty)
 	read_lock(&disc_data_lock);
 	ax = tty->disc_data;
 	if (ax)
-		atomic_inc(&ax->refcnt);
+		refcount_inc(&ax->refcnt);
 	read_unlock(&disc_data_lock);
 
 	return ax;
@@ -676,7 +676,7 @@ static struct mkiss *mkiss_get(struct tty_struct *tty)
 
 static void mkiss_put(struct mkiss *ax)
 {
-	if (atomic_dec_and_test(&ax->refcnt))
+	if (refcount_dec_and_test(&ax->refcnt))
 		complete(&ax->dead);
 }
 
@@ -704,7 +704,7 @@ static int mkiss_open(struct tty_struct *tty)
 	ax->dev = dev;
 
 	spin_lock_init(&ax->buflock);
-	atomic_set(&ax->refcnt, 1);
+	refcount_set(&ax->refcnt, 1);
 	init_completion(&ax->dead);
 
 	ax->tty = tty;
@@ -784,7 +784,7 @@ static void mkiss_close(struct tty_struct *tty)
 	 * We have now ensured that nobody can start using ap from now on, but
 	 * we have to wait for all existing users to finish.
 	 */
-	if (!atomic_dec_and_test(&ax->refcnt))
+	if (!refcount_dec_and_test(&ax->refcnt))
 		wait_for_completion(&ax->dead);
 	/*
 	 * Halt the transmit queue so that a new transmit cannot scribble
-- 
2.20.1

