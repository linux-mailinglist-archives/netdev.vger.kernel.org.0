Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B67780CF2
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfHDWj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:39:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40902 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfHDWj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:39:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so71238759wmj.5
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 15:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HYctCa8SUj6l7GZOSLwg22lbI0n9LrmHjKaO2FK2+QQ=;
        b=fuTTfDy1Ce0j+8VTHcpace5G8e2nalW+F5dtbWPbiMfyWH2WqL+/j8KbPkwvtC7SLA
         dPGmEG95zzkDMohg7EtHw9QLiT1YWbJ1YxzHZcC3Cr7A+Qxh0yAAtpD3/2Vt2u0VHJXt
         c2YWegpqrjr2tezAfGUf8kEiaenpF3af1DK/4sr6HkNzfLcVYCZbuzpz/LzU/Yw7QcQN
         +29BHpgxr4V3Dx6F6lsRRDReEf66hArwRaLkrKHZoaP3ZuPi4GvVaVSf2DFxlXhTtN8v
         bf+16riOBqnzbV8fm+aWaCYJ/oskDtLq6yGvEOZEO/RhhMnuEVXk3bIIz09gx/ifRatv
         UObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HYctCa8SUj6l7GZOSLwg22lbI0n9LrmHjKaO2FK2+QQ=;
        b=Hsw+MRn1Fl0YZW06BFNWd8q+KvbEzIEdFa/SxvQYgk6cGYIxEl92uxFJGFUK6cYfci
         AtWVLdUN4aEIOQiHCa3z3gKPL0A5XHilSAmRusqlMA3eRjUminLdZrwd5LPcQvuDCRMo
         lcyX/SYJpha45L816KxtYcUouErYG7Uq0ovtZFL41Aj+S4Wn1c6RWYpFyzH2u1KpK9oN
         Fu+f+jFH1w9Styy/xbt5fs+vTUeQpc89fVjdzvdVNRlLusPIg99OxvN1gBun8Ai9oxxm
         tGK0w5vbeLfe+MBzMkU3cQKO+/Pg57fdp2cEgidFz1Z+rSKBDE6D4B1MNoinowJJav1b
         3IIQ==
X-Gm-Message-State: APjAAAVZDTcmz4GXk5KMyiPdYgFbMw0Gy6KGB69Yl/h5iB18lW6/GnZ8
        2+XbB+lPYE1fhJK1NpJY7Zz84SOShf8=
X-Google-Smtp-Source: APXvYqyiJQ6MvJiZ2VLEUQsEed3uAeNa5Mtu07/MTbwJpEuTqN7X/puspx3DeTxKSpGESa8kwnesbw==
X-Received: by 2002:a1c:7e85:: with SMTP id z127mr15257226wmc.95.1564958365712;
        Sun, 04 Aug 2019 15:39:25 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id j33sm187795615wre.42.2019.08.04.15.39.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:39:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 4/5] net: dsa: sja1105: Fix memory leak on meta state machine normal path
Date:   Mon,  5 Aug 2019 01:38:47 +0300
Message-Id: <20190804223848.31676-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190804223848.31676-1-olteanv@gmail.com>
References: <20190804223848.31676-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a meta frame is received, it is associated with the cached
sp->data->stampable_skb from the DSA tagger private structure.

Cached means its refcount is incremented with skb_get() in order for
dsa_switch_rcv() to not free it when the tagger .rcv returns NULL.

The mistake is that skb_unref() is not the correct function to use. It
will correctly decrement the refcount (which will go back to zero) but
the skb memory will not be freed.  That is the job of kfree_skb(), which
also calls skb_unref().

But it turns out that freeing the cached stampable_skb is in fact not
necessary.  It is still a perfectly valid skb, and now it is even
annotated with the partial RX timestamp.  So remove the skb_copy()
altogether and simply pass the stampable_skb with a refcount of 1
(incremented by us, decremented by dsa_switch_rcv) up the stack.

Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_sja1105.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 26363d72d25b..8fa8dda8a15b 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -211,17 +211,8 @@ static struct sk_buff
 		 * for further processing up the network stack.
 		 */
 		kfree_skb(skb);
-
-		skb = skb_copy(stampable_skb, GFP_ATOMIC);
-		if (!skb) {
-			dev_err_ratelimited(dp->ds->dev,
-					    "Failed to copy stampable skb\n");
-			spin_unlock(&sp->data->meta_lock);
-			return NULL;
-		}
+		skb = stampable_skb;
 		sja1105_transfer_meta(skb, meta);
-		/* The cached copy will be freed now */
-		skb_unref(stampable_skb);
 
 		spin_unlock(&sp->data->meta_lock);
 	}
-- 
2.17.1

