Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1E71632D5
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgBRUQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:17 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43762 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgBRUQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:14 -0500
Received: by mail-wr1-f67.google.com with SMTP id r11so25490133wrq.10;
        Tue, 18 Feb 2020 12:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eg8exemn6RFQ1waqizhnuL0C4cHuSnz9Pgrt66/ymow=;
        b=AqEBKSBbTanoAknHtpxObipPBQV7SJht8A+XjLrB8RQH+GMeyVQT/skgmIgAmhkxE0
         3XaEE/1/sg8Qc6Dsd25mlZIbEoO4fH0a9b/j+XA7XLVi3dhwEuSnjA/wFgseJJVkx0jo
         Q00EA6yToL4fy4RiNkTALTdybjFN4HKEnvqkqAWDRmMAKv0lyFN+QpiCb8d4fHrwedSE
         j4cKizxE4jhNCsjYJ6oQJEI0RqJyldLLRrYC2FPRw+swqiDpgBKk4yar+GjDKaUHUFR5
         t8+WGMHB88xWkEEetrirHBMvw4pnXfTyZ4qWYYsruphiQhjwnPvvi0bJj/seIMlw1DlB
         ko9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eg8exemn6RFQ1waqizhnuL0C4cHuSnz9Pgrt66/ymow=;
        b=hsLxadXkKyan3KMJgfwP01OBhln5Z0ZON/OGr1BM/e84C9w/8FkUxsq3Bcjl1KsRoe
         RWMkKJmd1En0wBprS4iZIEtqm74uQynyz08KUO+Nb35esSnp01xjcLz01Yx9BYx5Nba5
         Q7RvaclLS9bwQoe27Ey4dQH7Jc6ORlEyY9j+UdCtuDqxJua9kXtQ9NGOdblmOW9IlTLG
         WSfCAVOaKyCyRX+L6JJnrEsUsHnIDS0myz50JIrFKcW64kARxdmFRqPz8+HVwRDLcGW6
         zSscuES1aOFQ2vXVyQZAfWRGNkEykLfIXUu9wJrQ40MkdflhFT3BDYei8RZTEovBbd8S
         wsRw==
X-Gm-Message-State: APjAAAX/CMvx3xyCCwCrlnHzgTiRcYHcDj3GjRyNUXHnGTSkL+Nlxv8S
        Z4DVnnLWE24akwfpMmAaiWEpiwYr
X-Google-Smtp-Source: APXvYqxiBN98MV9P/PGE87wT1oU6t3rwpD01kH9ZfcJ4GA9rxBLC6GRN34WNyLfHhzaXh1SCVmh65w==
X-Received: by 2002:adf:a354:: with SMTP id d20mr30609093wrb.257.1582056972253;
        Tue, 18 Feb 2020 12:16:12 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id h5sm2510516wmf.8.2020.02.18.12.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:11 -0800 (PST)
Subject: [PATCH net-next v2 04/13] bna: use new helper tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <d6806002-df28-5c63-dd92-617d6baeecfd@gmail.com>
Date:   Tue, 18 Feb 2020 21:01:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/brocade/bna/bnad.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 01a50a4b2..d6588502a 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2504,12 +2504,7 @@ bnad_tso_prepare(struct bnad *bnad, struct sk_buff *skb)
 					   IPPROTO_TCP, 0);
 		BNAD_UPDATE_CTR(bnad, tso4);
 	} else {
-		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-
-		ipv6h->payload_len = 0;
-		tcp_hdr(skb)->check =
-			~csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr, 0,
-					 IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb);
 		BNAD_UPDATE_CTR(bnad, tso6);
 	}
 
-- 
2.25.1


