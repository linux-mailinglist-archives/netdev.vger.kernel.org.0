Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405F3C40C3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfJATNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:13:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33292 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfJATNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:13:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id b9so16866708wrs.0
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 12:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ocjb+kgOXh3XXlIOFL1rhIFRqvOm5KiquOEj1WzDcGI=;
        b=OK3W2VZ5ze/olXmNiIK0LxRnm5U75byzb1Zos3fr6QsE17JkA3F7Bit55Uh3vu9vf8
         K2rcYbnCBY66T76XsBghiSSvKpcG1crGH1YhGe5idELNGqJbt23v9PpNIVtifFezd98U
         Gc2dSOdndJVsJwEbYi0x3iFtqfoCasS6DsMhY7F3bDASGZ83yPx8Lc6k25xPDRqpDb/1
         WixKY0krF2Y6eLGWL+OMxfWT2qkUGlrG8n1HuXN+ERyPiyUBub3nGTnHNMcMt1htfWgf
         gyilOqfRkPT0AlBVfAwwkUKX9HQ0adewKdvH2h6jjA0zhk98ZsxBS11/nzqILYyYs1ES
         cJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ocjb+kgOXh3XXlIOFL1rhIFRqvOm5KiquOEj1WzDcGI=;
        b=jYvy1mBqJ12oY9/S5/S/Cq5PiXAgSu3FYQUTs15lPcgPbAuiizLNhISZdG1FAui06E
         9MiL8K0zHWvU53QuwaGdM9WPcR6bB8spwUf2nWQ1TGiiuyjsml3NMAw3WgSSI5UNky3C
         cqfvUh+DRznCIGZAQoCzcnIddnANFyqiPXsa9N8Ya44fcSIVVkrpEeX2UJwppkLuGBrZ
         imgV3qKGhImJYcDtbIAhmoeRaS1MfcyQkzi0knQBDu9CldjXMVfxbXvucgU2Eolmw/xC
         NN7JBS3UadJTms0VHAsikjRjQGRg0zGnS3kRM749G3Z0RtalzovBJBsWBVECKfrn/ndu
         I/5Q==
X-Gm-Message-State: APjAAAW7a7oAckp9OqjtjOFXlzDaU42S80dC1YX/nEVUV781lsJ336Qf
        Yv0DXQAnvZsQ5MWVZuCq3+g=
X-Google-Smtp-Source: APXvYqySjYmLx8g3Gt0tQgkH386dIFtPwn1sp4KJyOwywPHeMzcXkj8NW2PJDmDkhNWbtSvUUIq4lw==
X-Received: by 2002:a05:6000:45:: with SMTP id k5mr12072693wrx.259.1569957179067;
        Tue, 01 Oct 2019 12:12:59 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id c8sm13366658wrr.49.2019.10.01.12.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:12:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: Remove unused __DSA_SKB_CB macro
Date:   Tue,  1 Oct 2019 22:12:50 +0300
Message-Id: <20191001191250.7337-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct __dsa_skb_cb is supposed to span the entire 48-byte skb
control block, while the struct dsa_skb_cb only the portion of it which
is used by the DSA core (the rest is available as private data to
drivers).

The DSA_SKB_CB and __DSA_SKB_CB helpers are supposed to help retrieve
this pointer based on a skb, but it turns out there is nobody directly
interested in the struct __dsa_skb_cb in the kernel. So remove it.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 541fb514e31d..8c3ea0530f65 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -94,8 +94,6 @@ struct __dsa_skb_cb {
 	u8 priv[48 - sizeof(struct dsa_skb_cb)];
 };
 
-#define __DSA_SKB_CB(skb) ((struct __dsa_skb_cb *)((skb)->cb))
-
 #define DSA_SKB_CB(skb) ((struct dsa_skb_cb *)((skb)->cb))
 
 #define DSA_SKB_CB_PRIV(skb)			\
-- 
2.17.1

