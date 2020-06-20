Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CD1202656
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgFTUQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:16:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42391 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgFTUQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:16:06 -0400
Received: by mail-lf1-f66.google.com with SMTP id y13so7470396lfe.9;
        Sat, 20 Jun 2020 13:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bUpHKuGvXMoT2ANSX5o0C6Pui2UhEVNyY7Dw51pTMzQ=;
        b=I5YfqFjS1MNpAA5fUkekX8lImcYybPU8i5LRszlPW7+W9dKLRe3m7XPSm5OE+w0c9b
         5HXVnVtUxQlg+UD7RL2IxB/0/3C7NCu7K8Mee31mtL2mTAQFbe5C+CAtInh54NDp4UD6
         9m4czhc3CLvcGBo2hSguh/0vC3GWwiv4PiHumh48B6IyoFvnS0wFEnCdrMtfj/o3HLXZ
         BKWsi3WvmM68qMWUqqK9ChMos92Bmv7K+9qWxDnP6pr7zY9dMZEp54VjnTG35um3Jd8f
         ujcCDuSqIk8AkWnTklK3DXpRnp6k79C4svheru40Mz9r+/qD3zw9dVKPN2k8ZTqsR9BO
         c3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bUpHKuGvXMoT2ANSX5o0C6Pui2UhEVNyY7Dw51pTMzQ=;
        b=CLkQ3z5mvcPCmXIVXGd/lT+3xw5ARgR9o7NFQUnF2WrL0Pkd+1mghE/DI/4SOeIB+d
         0PERm69f2mQTJ5jY/Cag4CPSBm+WYpPy92Nk5sk8WG+TgnKLzbgRVPzT+SWhKfG0RBKh
         xKNTLK+4VgFRpM+cV0NDI3WHufmAJSxAERhLfDY76a27wvQyVHrsS0ldIoglMdHy9VMB
         P+6ni162NO7bNgiZoz6wWZdZkI4QCyOJyiGAgfoEKM9pQyH65kJfuZTL5YTc1nrvW+2p
         8gpATBTJZuGnKtLax02zGDR5BOBooS+5ClG7XOLdrv7cxn0AScG8hqFcfOuGTkr2mvxC
         M7yg==
X-Gm-Message-State: AOAM533YZR6EmI8HN+Ms6QsUlZKQuDLapauylKUSfxaoWBxJHAQDM/MN
        cJmBhJHvfpirPJTLXUnadKlZ78YvRItSVA==
X-Google-Smtp-Source: ABdhPJy6pTdJ/npXRzJulS4+XYrhRZgNFxdrISm39OyM67KApATxV7ttOA6JOqpzlpmfhSceF2D2lg==
X-Received: by 2002:a19:4cd:: with SMTP id 196mr1349954lfe.136.1592684103363;
        Sat, 20 Jun 2020 13:15:03 -0700 (PDT)
Received: from pc-sasha.localdomain ([146.120.244.6])
        by smtp.gmail.com with ESMTPSA id b6sm2641347lfa.54.2020.06.20.13.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 13:15:02 -0700 (PDT)
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
To:     asmadeus@codewreck.org
Cc:     lucho@ionkov.net, ericvh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.kapshuk@gmail.com
Subject: [PATCH] net/9p: Validate current->sighand in client.c
Date:   Sat, 20 Jun 2020 23:14:56 +0300
Message-Id: <20200620201456.14304-1-alexander.kapshuk@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618190807.GA20699@nautica>
References: <20200618190807.GA20699@nautica>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use (un)lock_task_sighand instead of spin_lock_irqsave and
spin_unlock_irqrestore to ensure current->sighand is a valid pointer as
suggested in the email referenced below.

Signed-off-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Link: https://lore.kernel.org/lkml/20200618190807.GA20699@nautica/
---
 net/9p/client.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index fc1f3635e5dd..15f16f2baa8f 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -787,9 +787,14 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	}
 recalc_sigpending:
 	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		if (!lock_task_sighand(current, &flags)) {
+			pr_warn("%s (%d): current->sighand==NULL in recalc_sigpending\n",
+				__func__, task_pid_nr(current));
+			err = -ESRCH;
+			goto reterr;
+		}
 		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		unlock_task_sighand(current, &flags);
 	}
 	if (err < 0)
 		goto reterr;
@@ -869,9 +874,14 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	}
 recalc_sigpending:
 	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		if (!lock_task_sighand(current, &flags)) {
+			pr_warn("%s (%d): current->sighand==NULL in recalc_sigpending\n",
+				__func__, task_pid_nr(current));
+			err = -ESRCH;
+			goto reterr;
+		}
 		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		unlock_task_sighand(current, &flags);
 	}
 	if (err < 0)
 		goto reterr;
--
2.27.0

