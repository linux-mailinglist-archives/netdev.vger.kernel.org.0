Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7128713D2B9
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 04:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgAPDa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 22:30:56 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40852 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgAPDa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 22:30:56 -0500
Received: by mail-yb1-f194.google.com with SMTP id l197so2287551ybf.7;
        Wed, 15 Jan 2020 19:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=5hCR7l+IGjuAIghwhgN04Y/kSevJvkdqqxO3+5DqDlw=;
        b=KHBzuXl79SLLfI07GT7wSJ59Fu+Hf5+n7nBcA03SAtoRLqF4M9q6YLaEGCWnUHfsVH
         OccsEPIuvRg3Y32BWv5+rlysndItQ0Jq85VfgKGbiBkpKtROjzHRFq4rkQ4c5Rg1P8Wd
         xH/sw94CEVWp4jOLP7bEgoHKoCqDIvfAC38IEBFybUtmGvlmGJ1Kr1WFb7ErY/ip/piJ
         EUsfy0v7fLYnjvbImfg9eIfTlGMhZrOuHzfqy4MqNID+k4zq/8lPfxUjK40fTxqLT7S0
         Mizp0IMIs42TIJT/etldE+qzz+WFZ0nNwfCydlSxxzsCD4Ob1dyHghuMoL6/7t75WFkc
         5+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=5hCR7l+IGjuAIghwhgN04Y/kSevJvkdqqxO3+5DqDlw=;
        b=ZVdhixKwvToatpmwHYf6PMNB4zppDj79PEF+5o/Y6Ad+tWRh1rZpHLXH8SYrwuwegQ
         c0131zgyyGXL2SjrWn08iAhtmCVQu1spxk0WQiIGtgqEThUfFvueUdXHmRX+TavBCkza
         flzyZeDyELbi+3ocPstwW3QqT4I0uKA//kqwyisY4J7HhXlua7HwO3pqGHaHKy5AMU/d
         Dj1Lq+XkGCW+p646sPqP1ghsiwiZ6ExVoFAlatQXC3lf81EQ+MFdf5Ju6jv/FNEIB2uG
         wS9Is/0/hZpVENG8Ug45buBQwRDTknReXsb+0yxioc6Y37J7rHO+Xw3p+4pO0S96m7HU
         RJZQ==
X-Gm-Message-State: APjAAAUKRgs3Ov1F+C526n6BqLk/wCHZd9Lrj8aHaf+9z2AavPCu3wKE
        zVLEimSgrrm6U7wHMkW5A6q/hmc/urFf4g==
X-Google-Smtp-Source: APXvYqxZpZD+KGfqIelCMRxWJ7fQdK7H7zxQmKWaH+hTRB8O/y5kahyWjkpw+Bk/XmNsVz82yixwww==
X-Received: by 2002:a25:c589:: with SMTP id v131mr20721253ybe.490.1579145454751;
        Wed, 15 Jan 2020 19:30:54 -0800 (PST)
Received: from hunterzg-yangtiant6900c-00 ([95.179.219.143])
        by smtp.gmail.com with ESMTPSA id t3sm9685156ywi.18.2020.01.15.19.30.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jan 2020 19:30:54 -0800 (PST)
Date:   Thu, 16 Jan 2020 11:30:44 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] driver: tg3: fix potential UAF in
 tigon3_dma_hwbug_workaround()
Message-ID: <20200116033044.GA2783@hunterzg-yangtiant6900c-00>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tigon3_dma_hwbug_workaround(), pskb is first stored in skb. And this
function is to store new_skb into pskb at the end. However, in the error
paths when new_skb is freed by dev_kfree_skb_any(), stroing new_skb to pskb
should be prevented.

And freeing skb with dev_consume_skb_any() should be executed after storing
new_skb to pskb, because freeing skb will free pskb (alias).

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
---
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ca3aa12..dbfac26 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7826,6 +7826,7 @@ static int tigon3_dma_hwbug_workaround(struct tg3_napi *tnapi,
 
 	if (!new_skb) {
 		ret = -1;
+		goto new_skb_err;
 	} else {
 		/* New SKB is guaranteed to be linear. */
 		new_addr = pci_map_single(tp->pdev, new_skb->data, new_skb->len,
@@ -7834,6 +7835,7 @@ static int tigon3_dma_hwbug_workaround(struct tg3_napi *tnapi,
 		if (pci_dma_mapping_error(tp->pdev, new_addr)) {
 			dev_kfree_skb_any(new_skb);
 			ret = -1;
+			goto new_skb_err;
 		} else {
 			u32 save_entry = *entry;
 
@@ -7849,12 +7851,14 @@ static int tigon3_dma_hwbug_workaround(struct tg3_napi *tnapi,
 				tg3_tx_skb_unmap(tnapi, save_entry, -1);
 				dev_kfree_skb_any(new_skb);
 				ret = -1;
+				goto new_skb_err;
 			}
 		}
 	}
 
-	dev_consume_skb_any(skb);
 	*pskb = new_skb;
+	dev_consume_skb_any(skb);
+new_skb_err:
 	return ret;
 }
 
