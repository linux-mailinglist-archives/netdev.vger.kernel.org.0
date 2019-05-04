Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC15A13A05
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfEDNUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:20:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35363 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfEDNUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:20:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id y197so9768702wmd.0
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3tHsYGiOnPV/CNdb968gq58rGdI6Zucx71LphAjONv4=;
        b=BP5zOBpkPwO16f439P6PZMVduT81p+azkwLyVtjlbhkddHHH85P0BV2cE4IpuU7bBo
         E29JrgiEu3RtY6VIINvNSJUT9A5GliUvGmd46nba50Rf1qMwcJUO4U6A1ExdshzPNgOW
         mXxbCrntMoWfh2e6a5ITXoa0FkW9f/s0991PgJKLhg+BO9OJ24xmeRJxmcrMkjBYgVBM
         gD7OyEk28E/dxc3QdleeXEM/U1S8U5shH0RYoffSZs9s28uJzWm+hqbXXtN2oLJgek2A
         EdMeJbbZhkrP+3yFAXY84uWm4uVHnvfiwBSXv/zuSx20gDbkRZc1J891uEekZ7r80IB7
         qyfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3tHsYGiOnPV/CNdb968gq58rGdI6Zucx71LphAjONv4=;
        b=Y7Br1rQ58w5yRz09CR//SdZJI9kKdL855olkqxZgOwBBPsmZNbU62xAGNUYBQZ+jDR
         VmtZ7TTtg4vhWGuVC2uVr+aJ/ZgWLubV7egU8oInzR3BxOlmyy4i+WPhivzZwe2lzHnN
         c3BVP6gYukhnZj+zW4DBF/MRSgHJ1YO1YT5ygGZ0/dcVGOxkh6hMBMucEjZGEqSUktjM
         ZqlYFuRN19yX6KeLGC/PgpgiM5ILNfZ6+io8jeJQKtuvCJXhG8uKloapXbdSSP3RfH0x
         6qsRzc2+NJL5qGBSYYAijvYO8pNQtuXbGPvi1UEoxPHMTKlCN/fyhUJJIYQZpo0vhj0z
         MW9w==
X-Gm-Message-State: APjAAAUpXOBtHEb4CLVHXiu9GxQIsylgkB7J2eTuYjEwgsQYX8PgwDv+
        xCSQkdGoUaqEuE9MUR1F925Hxkp6F8w=
X-Google-Smtp-Source: APXvYqwtsEAT5pTyuB7k7z8J6O3LEUzH1v2IVJ7atCDtDws/KhJ5JBUymIMdfEIV5Ri1GHHsig/dhA==
X-Received: by 2002:a1c:d102:: with SMTP id i2mr3306519wmg.143.1556976045669;
        Sat, 04 May 2019 06:20:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:4cd8:8005:fc98:c429? (p200300EA8BD457004CD88005FC98C429.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:4cd8:8005:fc98:c429])
        by smtp.googlemail.com with ESMTPSA id x81sm3609709wmg.8.2019.05.04.06.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:20:44 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: speed up rtl_loop_wait
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <1d0fa904-b911-8349-27fb-6cec1d8f8287@gmail.com>
Date:   Sat, 4 May 2019 15:20:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing I figured out that most operations signal finish even
before we trigger the first delay. Seems like PCI(e) access and
memory barriers typically add enough latency. Therefore move the
first delay after the first check.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 4f1b6e97f..8c41b74ce 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -775,9 +775,9 @@ static bool rtl_loop_wait(struct rtl8169_private *tp, const struct rtl_cond *c,
 	int i;
 
 	for (i = 0; i < n; i++) {
-		delay(d);
 		if (c->check(tp) == high)
 			return true;
+		delay(d);
 	}
 	netif_err(tp, drv, tp->dev, "%s == %d (loop: %d, delay: %d).\n",
 		  c->msg, !high, n, d);
-- 
2.21.0

