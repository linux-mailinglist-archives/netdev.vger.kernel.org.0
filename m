Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAFCD608AB
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfGEPFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:05:15 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:35981 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbfGEPFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:05:12 -0400
Received: by mail-lf1-f50.google.com with SMTP id q26so6540860lfc.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h0qJMdNciD39g3Q1jo3+1MbbNG9llP7wamgm8+ijc+0=;
        b=oDfE98kPmAv8olG5EU/cTLrPDhDZJWfBTXlVneiTLeFEQ9KVnwf7eKt2hlFFPocvxy
         uUe6nfw3ViFwp6yvmIysmpnO+k9Wu4fTfhs3b2tq6dQfOoYCsExy7L4KNXeqdLhAdPB+
         1TD/0Ae8V6EAMs6Bp058Iot84/ZdoxMc4KMgSAsQU52JUMJJXwvWaGJClgWF6teMbUBo
         uxIthothA0rkhAtBjhsvVdG0aikqWxw7xh3yzReaMfq/gpNokRVaTVAT2x/zMcsjRGHC
         9G5We3AuyDNiOJXRYSYb0VMqaQpmIp1a2feZzkvQOtBADs5UthlrQM8CmV6gNxnsdfwn
         h3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h0qJMdNciD39g3Q1jo3+1MbbNG9llP7wamgm8+ijc+0=;
        b=TjhpPeQEywcm//hc+yhdMhsS4vq5G9V71R8ozCDH105p7a7hTISfI8P2k4SvY8fTJ0
         M4YkVcmy3wSy8WmDxb7Qpiga86i4n9Y0TxkdSqrowRWEzVPxG0wOPD1tBuygXEKCZeIe
         mqhllhYGpv9fSaZn0V+UNFZUomhRgd/ebe3qNboS19G1isfpj6C5ipAEKbrP7+Gi2SP6
         Fz3+XgXUMIkjj9mFYrA4qNZz7KwY24D5Qvl1F1Yy0LmTA60ekXtAnxSN6NwSWhdUKmAS
         AmYjPLtjKQbVGvMu8NflpZ09KB4dDVSoKvnJvkGzGnQeSq5XkD4CpXjzc46AX22MHNJm
         5Keg==
X-Gm-Message-State: APjAAAVuXFHbxCuODvz8yW47CCCD59Wv6R+93ejWOxn6QWIpLgns6AJX
        fdXbU2qbd3s4fSSdU/liSjEHUA==
X-Google-Smtp-Source: APXvYqzQfwbBeTQKyZdYAG35Uh8Vra3vPjcNMNKZk9DOT4QKJnpXvwesQAlh7D0yawCUdKeVyP7mGA==
X-Received: by 2002:ac2:5c42:: with SMTP id s2mr2285518lfp.61.1562339110625;
        Fri, 05 Jul 2019 08:05:10 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id y4sm1433660lfc.56.2019.07.05.08.05.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 08:05:10 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v8 net-next 4/5] net: ethernet: ti: cpsw_ethtool: allow res split while down
Date:   Fri,  5 Jul 2019 18:05:01 +0300
Message-Id: <20190705150502.6600-5-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705150502.6600-1-ivan.khoronzhuk@linaro.org>
References: <20190705150502.6600-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That's possible to set channel num while interfaces are down. When
interface gets up it should resplit budget. This resplit can happen
after phy is up but only if speed is changed, so should be set before
this, for this allow it to happen while changing number of channels,
when interfaces are down.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index c477e6b620d6..e4d7185fde49 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -620,8 +620,7 @@ int cpsw_set_channels_common(struct net_device *ndev,
 		}
 	}
 
-	if (cpsw->usage_count)
-		cpsw_split_res(cpsw);
+	cpsw_split_res(cpsw);
 
 	ret = cpsw_resume_data_pass(ndev);
 	if (!ret)
-- 
2.17.1

