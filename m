Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD9F6608C5
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjAFVVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236635AbjAFVUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:20:33 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B507872A1
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 13:20:00 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d3so2964751plr.10
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 13:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YXGpQAAYlWBIEcuAHJ+wNCKt49He6RKy7j3EpC2Vh/c=;
        b=ciF7WRLuLBxNdksji3PHBGUn4NV8sZzLT2NQ8QwltxmtLol8vZPGIyPRsgZnoC1IWW
         Co2TxTYkIW5+YSFND27lBCIfs3uVQOKVArThFyIhzsdCH4Id1nTmPHwpU/Rrcd67wdeh
         zz8QqY4hxNjqRsukF/GzNjGOlOenSpkbckPH1VJMaZOlHvw0EsrLIAFEY0+KpB1GJaSW
         ritv0oYCvx1d/MEELe868YRRezqvktKJBwzWrPx685o3On8Q5f0tZ+C9S6tF9lG4Ib25
         1i+cabQtxiL/M2TF2IIcR7Xlun4pbyT0F+jhnooavQ5QTKNaxQVeIo7zzjt10SbWxs2f
         Xrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YXGpQAAYlWBIEcuAHJ+wNCKt49He6RKy7j3EpC2Vh/c=;
        b=x/ntAf/ZhEjT2pfh2K7HEvAbgqA2SGGiZHMGBXu0qLLl5otToEXr0S1mrsONQMweZg
         PepytrhjLcBD0WBBxnSe2+QazPKyoPPej7aVYKwrbGdusSSLix3/jauvx1034R0k6DxE
         XmwDSkF9PekZfCnTsRYU//kyHMgA5X7IvIAeVmt0XPFAMkXeEURNKPEivm42H5U5Xq0d
         gaYWpA/4zGTTYUblXqJGHTAc4+t94p36T5lozYZ8x4c+0m5jcU2t8EowGw5Z2GvX7PTa
         z6uvD1yp9P/riXtfXzMrWm1QrMn9VJrl5MOMoNwvjL9GhDAh9jIN4b9uQTAd1DrfI6MB
         OG7g==
X-Gm-Message-State: AFqh2kpHjuMsyY/DKY5Nqp1Y3ShjyeiSkNmbE6alTUk3iug7GYUIA96e
        hFNragyV7vmfezVhxucbZpWu68cLLoKj5Q==
X-Google-Smtp-Source: AMrXdXvLciXJScLBXJDGKRAR0YoIbdVzzJNxIEGIktrbRjHby8KEiC5WwTy3B942STuJgFTCn2fRYQ==
X-Received: by 2002:a17:902:b78b:b0:192:806e:e236 with SMTP id e11-20020a170902b78b00b00192806ee236mr39087479pls.47.1673039995047;
        Fri, 06 Jan 2023 13:19:55 -0800 (PST)
Received: from westworld (209-147-138-100.nat.asu.edu. [209.147.138.100])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902784200b0017d97d13b18sm1399671pln.65.2023.01.06.13.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 13:19:54 -0800 (PST)
Date:   Fri, 6 Jan 2023 14:19:52 -0700
From:   Kyle Zeng <zengyhkyle@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: net: ipv6: raw: fixes null pointer deference in
 rawv6_push_pending_frames
Message-ID: <Y7iQeGb2xzkf0iR7@westworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The local variable csum_skb is initialized to NULL. It is posible that the skb_queue_walkloop
does not assign csum_skb to a real skb. After the loop, skb will be set to csum_skb, which
means skb is set to NULL. Then when the skb is used later, null pointer deference bug happens.
This patch catches the case and avoids the oops.

Signed-off-by: Kyle Zeng <zengyhkyle@gmail.com>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index a06a9f847..982a8b77a 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -556,6 +556,9 @@ static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 		skb = csum_skb;
 	}
 
+	if (skb == NULL)
+		goto out;
+
 	offset += skb_transport_offset(skb);
 	err = skb_copy_bits(skb, offset, &csum, 2);
 	if (err < 0) {
-- 
2.34.1

