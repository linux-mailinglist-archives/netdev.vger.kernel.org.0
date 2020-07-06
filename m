Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2457E215AB5
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgGFP2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:28:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40116 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgGFP2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:28:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id f2so13461970wrp.7;
        Mon, 06 Jul 2020 08:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2nVcRN2OKTcUql/9uC2N+V8iPEPLUhGFl7cLdrlB9Og=;
        b=aBZxrxpWHlSq+CvCCtdMfVZGdUE+2Pt4aoKrzg+DI1XjpbUdbe4DdL24cCUKouvVb/
         I9i7ttZhp3q3BN7PgEY9Y00L2tuV0e1Mor9lHupNLFso4QyqbHmkSKFEdz1bbZLqevE2
         Lql48hXd9ZRbL739Lk0Wpv8u4jucHDXsM5qjME4ZBtvVLFcWwXrs0J8J7APWpxp8xPLF
         MYzbnK9BiB1lcUESMuPhXsm4g5lnilo7eWt51NLfRAUvV764I9r7IsOKavaec/FCeQn9
         +IcOaEyfpo1AKifdlVO6hyJgFkN9L8TKK/CfbfSCWxZXaXPJvmad96Sawap4CxhHN7eT
         V6+g==
X-Gm-Message-State: AOAM533kuje8/92qZKByhM3zY15I12NnlWCSh27sW6vC7Rkn89DWlSFO
        pRwP6d+XYSjkOzNtlh+p5h1KCUgkWuQ=
X-Google-Smtp-Source: ABdhPJw0MaIlPqdbFH1B3wYRgnpP/Le27dwzsmua5Fbd4WIirpgbyaR9pgx6rX8FiZjlnQjlETYo2Q==
X-Received: by 2002:adf:f60a:: with SMTP id t10mr41848476wrp.64.1594049297584;
        Mon, 06 Jul 2020 08:28:17 -0700 (PDT)
Received: from msft-t490s.lan ([2001:b07:5d26:7f46:d7c1:f090:1563:f81f])
        by smtp.gmail.com with ESMTPSA id g3sm15846277wrb.59.2020.07.06.08.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:28:16 -0700 (PDT)
Date:   Mon, 6 Jul 2020 17:28:12 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Colin Ian King <colin.king@canonical.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mvpp2: XDP TX support
Message-ID: <20200706171504.0494beba@msft-t490s.lan>
In-Reply-To: <18eb549b-d2f6-9352-582e-aec484dc95c1@canonical.com>
References: <18eb549b-d2f6-9352-582e-aec484dc95c1@canonical.com>
Organization: Microsoft
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jul 2020 14:59:22 +0100
Colin Ian King <colin.king@canonical.com> wrote:

> Hi,
> 
> Static analysis with Coverity has found a potential issue in the
> following commit:
> 
> commit c2d6fe6163de80d7f7cf400ee351f56d6cdb7a5a
> Author: Matteo Croce <mcroce@microsoft.com>
> Date:   Thu Jul 2 16:12:43 2020 +0200
> 
>     mvpp2: XDP TX support
> 
> 
> In source drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c in function
> mvpp2_check_pagepool_dma, analysis is as follows:
> 
> 
> 4486        if (!priv->percpu_pools)
> 4487                return err;
> 4488
> CID (#1 of 1): Array compared against 0 (NO_EFFECT)
> array_null: Comparing an array to null is not useful: priv->page_pool,
> since the test will always evaluate as true.
> 
>     Was priv->page_pool formerly declared as a pointer?
> 
> 4489        if (!priv->page_pool)
> 4490                return -ENOMEM;
> 4491
> 
> 
> page_pool is declared as:
> 
> 	struct page_pool *page_pool[MVPP2_PORT_MAX_RXQ];
> 
> ..it is an array and hence cannot be null, so the null check is
> redundant.  Later on there is a reference of priv->page_pool[0], so
> was the check meant to be:
> 
> 	if (!priv->page_pool[0])
> 
> Colin

Hi,

yes, the check was meant to be 'if (!priv->page_pool[0])'.
Maybe it's a copy/paste error from other points where 'page_pool' is a
local variable.

While at it, I've found that in case a page_pool allocation fails, I
don't cleanup the previously allocated pools, and upon deallocation the
pointer isn't set back to NULL.

I should add something like:

@@ -548,8 +548,10 @@ static int mvpp2_bm_pool_destroy(struct device
*dev, struct mvpp2 *priv, val |= MVPP2_BM_STOP_MASK;
 	mvpp2_write(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id), val);
 
-	if (priv->percpu_pools)
+	if (priv->percpu_pools) {
 		page_pool_destroy(priv->page_pool[bm_pool->id]);
+		priv->page_pool[bm_pool->id] = NULL;
+	}
 
 	dma_free_coherent(dev, bm_pool->size_bytes,
 			  bm_pool->virt_addr,
@@ -609,8 +611,15 @@ static int mvpp2_bm_init(struct device *dev,
struct mvpp2 *priv) mvpp2_pools[pn].buf_num,
 						       mvpp2_pools[pn].pkt_size,
 						       dma_dir);
-			if (IS_ERR(priv->page_pool[i]))
-				return PTR_ERR(priv->page_pool[i]);
+			if (IS_ERR(priv->page_pool[i])) {
+				err = PTR_ERR(priv->page_pool[i]);
+
+				for (i--; i >=0; i--) {
+
page_pool_destroy(priv->page_pool[i]);
+					priv->page_pool[i] = NULL;
+				}
+				return err;
+			}
 		}
 	}
 
Looks sane to you?

Regards,
-- 
per aspera ad upstream
