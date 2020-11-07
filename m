Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736FF2AA7FC
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgKGU4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgKGU4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:13 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD38C0613D2
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:11 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id l1so419570wrb.9
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Cwoypn5vRWqLZ2PmtMFZW4bqe7uU2Xj951rJyZK/u3Y=;
        b=uA5w57RM7ywgt18FMf7D07PvnAQtTEODfa2EnI6V8xiVWq1azn63B5H3f/h7JvfmVE
         9kw/Z2MntQAZrHD25To8ecfavAJmdurMwqo7NJoEmbaukXBRbLxE3hEPpOf8P8QI/4Yu
         fCpgIhffGoFGpMpfU93I7DnmpAHrtz7RmrX26q3ORmV6R2soMmTE7KRxgSGOgYBo2ZhG
         PqoFLhKuoaxhmuxXnLefBr2MTi3QfTxyZledB5nAnj5STh9V+YbidbuRITpWn3mCLiBW
         HOCczSjxX20LSmLXwuQuL5cR7SeURMkZC/H1y5sSpLE8IHRDjQLmcj+PgV625rdwzSH3
         9Wxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Cwoypn5vRWqLZ2PmtMFZW4bqe7uU2Xj951rJyZK/u3Y=;
        b=TYacgxs6VC+QFFAwmKfrRATxW8gHzVbnejeK/20IKBKZuKdV6nqIc0SK18Qm0hG5cM
         jvYp3nMtGL/GM72If8Bu4Hjh2K+DLj9l/ZC3ugwF3q4MhukwchtffTQzHMlZME59U1se
         Bu4D4U9+mCnF1gP2iznPBC/4+tZdRSiLAhyJKpUt+Ut7dRU2+QBy8iYyw37LqSuiDsJu
         ENeamHMzqP4mJbLQJL82WsXZ79ruPh/DY9INFa7oXzNus2FVpety6aoMdPyA49Xw4qja
         APwakRwb6gwuAs41x+7JSGoZMnm4wQiI9WfMIES6G+esQf28EGgWn4KvfCB4Zo03LzK/
         tWcg==
X-Gm-Message-State: AOAM531MgTwFBAaeh28m4vqaqqugr94aBHjiWNhw+PfSLT1PEkrXzPKb
        Fp3jtB4HcliYyU/sw62VUQ8=
X-Google-Smtp-Source: ABdhPJy+e7yZL/cGFNMAeW5k7SlR5OQlFSoecym4Sj3wK2vqyInV36SGAAig7CT7aCgs0IhJVqxFPw==
X-Received: by 2002:a5d:4c4f:: with SMTP id n15mr9172276wrt.137.1604782570439;
        Sat, 07 Nov 2020 12:56:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id u10sm7901369wrw.36.2020.11.07.12.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:10 -0800 (PST)
Subject: [PATCH net-next v3 06/10] gtp: switch to dev_get_tstats64
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, wireguard@lists.zx2c4.com,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Message-ID: <e8b41c0a-e86d-b86a-28fa-4872d3f47a43@gmail.com>
Date:   Sat, 7 Nov 2020 21:52:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace ip_tunnel_get_stats64() with the new identical core function
dev_get_tstats64().

Acked-by: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index dc668ed28..4c04e271f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -607,7 +607,7 @@ static const struct net_device_ops gtp_netdev_ops = {
 	.ndo_init		= gtp_dev_init,
 	.ndo_uninit		= gtp_dev_uninit,
 	.ndo_start_xmit		= gtp_dev_xmit,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 };
 
 static void gtp_link_setup(struct net_device *dev)
-- 
2.29.2


