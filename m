Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D96F080CF5
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfHDWjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:39:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50269 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfHDWj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:39:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so72950085wml.0
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 15:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wBAe/3BkJFIDgMhBVA/evqzIO8LKpkC8MOgn2O4VUJg=;
        b=sFh5iZtucFZm3ndmAN65kLbv2pe+aw0XtZiomI+veI52LMP+NBDOvIzlCvvcgg2SZ6
         qGHCFgDAsbM66KP1Gl752oGEK/+O+muzr3tXBbhk10z9hNW79jXDxa2233UBnnnrK9eU
         tDQ0ityTIiHgnzgTM5MIwmtDeQ8UqES9FeUTwVqj+WUYTvsVIDFQOu0wJ4PQA5qnSNGc
         JQMIJvLwnHAorSXK0lPw80XgM4+cRGZIL6EOnmjlh60qoSA16nK8UvspNzoRhTeRGEbn
         lBLHhHaKdiAviT7CbYq/dG2Hb07eAQQbG5bPpldzWxjoEMeZhrOlsncB0zn0wHQJO7tD
         SkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wBAe/3BkJFIDgMhBVA/evqzIO8LKpkC8MOgn2O4VUJg=;
        b=T2ZcQXEG38WhWtjMIHVSnIYXNaN8H9PnP6/HmK63Kf03FjyiuhZYQW5zMkW4tclSai
         /bZieFDAAvrz9nWPthAtKAlfQU6AyVpoZnC/aESDV16PotmGH267zfcV1k7EO41wp17t
         /TamZLntFapB2V+4yEKNYhsSE7kYf6eLGg2P5XmR/wwT9qnOczezC4H8s/CsO+cfGnoR
         1AmtY0/xfIcebWJ1ottydZ7ugn06OBmbJqpfqeSK/nEO7GN2lhNV0IaPKLwivjRulzCj
         A78qm45ld2NAzJhho2KZqHLdAmO9PjY0Zhupzjk2wS4dDAhVZGOkosNM3BuFKd9BYoi4
         9FXg==
X-Gm-Message-State: APjAAAVmfLMgF69a+Qt8TFqHhFokxvynLIs/fmQsEPp2v+shGSAsv6nK
        l/AaBvMyt9hGRflX0CTQyH7x9x6Hjtg=
X-Google-Smtp-Source: APXvYqxjaY/qGk3b82FIx0Qc6ICGGfFIYcR4qWBvovZCwsSeLj1OLl4B4hCf56hrGmr7FqNIICSAIA==
X-Received: by 2002:a1c:e710:: with SMTP id e16mr15289803wmh.38.1564958366620;
        Sun, 04 Aug 2019 15:39:26 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id j33sm187795615wre.42.2019.08.04.15.39.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:39:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 5/5] net: dsa: sja1105: Fix memory leak on meta state machine error path
Date:   Mon,  5 Aug 2019 01:38:48 +0300
Message-Id: <20190804223848.31676-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190804223848.31676-1-olteanv@gmail.com>
References: <20190804223848.31676-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When RX timestamping is enabled and two link-local (non-meta) frames are
received in a row, this constitutes an error.

The tagger is always caching the last link-local frame, in an attempt to
merge it with the meta follow-up frame when that arrives. To recover
from the above error condition, the initial cached link-local frame is
dropped and the second frame in a row is cached (in expectance of the
second meta frame).

However, when dropping the initial link-local frame, its backing memory
was being leaked.

Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_sja1105.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 8fa8dda8a15b..47ee88163a9d 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -165,6 +165,7 @@ static struct sk_buff
 					    "Expected meta frame, is %12llx "
 					    "in the DSA master multicast filter?\n",
 					    SJA1105_META_DMAC);
+			kfree_skb(sp->data->stampable_skb);
 		}
 
 		/* Hold a reference to avoid dsa_switch_rcv
-- 
2.17.1

