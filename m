Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACCF4E3F92
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 14:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbiCVNbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 09:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbiCVNbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 09:31:48 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514C52DD50
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 06:30:20 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 17so9000366ljw.8
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 06:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=9HKooFSzF8EEsT2BEZgeunYRwvAjSyxG2IXK+iRrPEs=;
        b=29htvhMmpTh4PKGEPvfVlPAUZrleKez8uBO1KBF0exKnC1WyZp6jRTQwDHy/q9a/if
         R4OwsReo7NGIThGIV7Cil5RrsIpD6Gq6vC1sQxSVfEfj+mIzlK0nKfNpZ9QbNiwlgS8C
         IAU6K1e3RWdb5GSt7vgRoCkvtWl8/5rV2tcGNYmKwgvSq1+bnrrTogQhTcAQrJIYuQV4
         c2i+5SZEbLgLKdrjjNhmiO9KDuvbzRn9mfT3oshKO442uXOdu1FxRcxyAka7Iz174Xak
         A40spqBYtTqd5MC1/e/YiixXhFlC5r4oiPSg7YS+KHOQSiu7YXIEt7T90404opxzbomi
         bUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=9HKooFSzF8EEsT2BEZgeunYRwvAjSyxG2IXK+iRrPEs=;
        b=BSggd7uL34Ivw2vcKCdituMjZp0SwhGGDxFcSDZ4ZDqrrdj+mA7Hn7yHzBeHxMD0ml
         TptuM4AAmG3bGj5UzOckDDK0q4SEorYTHDQseLcPpE43Kw7IVyS1+ANv5USzdyyB3UDR
         xBpjT+4D8xZ6Vt2cW+Zp3e7m8x6a525M/w82J7Ykg1xYcsyejCVf+zQ/9ahe1PH2sB+A
         RmWL/mnerOGLY3+xZeWjrKZW/cSKY1r2dFasCCuzJRs/abdv3ko362ohsTiiD0ekzRm7
         dLX0WB5f/TntmBdGkixDTj0C0qKaE80xsdE7mNRQy9b2tDTNLO8evqmzmXhFMutqUYjO
         MLaA==
X-Gm-Message-State: AOAM532BMqbPbWhTXoxDCGC0v/cukfXxBZkLn9t1xEXB/PHiTKtB2hDL
        OEaSZ4RLIFiwncdQhjStqhf7Vw==
X-Google-Smtp-Source: ABdhPJxkwrq7ZJvbNzKo/Kac7gQ286RAOZTZyDPHLItZIJZkOra75RUq9+xsw1H+JJrRwUndrhihDg==
X-Received: by 2002:a2e:a4d1:0:b0:249:8c9c:5ae0 with SMTP id p17-20020a2ea4d1000000b002498c9c5ae0mr4441949ljm.283.1647955817198;
        Tue, 22 Mar 2022 06:30:17 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y26-20020a19915a000000b0044a0356abc4sm1779904lfj.220.2022.03.22.06.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 06:30:16 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: bridge: mst: Restrict info size queries to bridge ports
Date:   Tue, 22 Mar 2022 14:30:01 +0100
Message-Id: <20220322133001.16181-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that no bridge masters are ever considered for MST info
dumping. MST states are only supported on bridge ports, not bridge
masters - which br_mst_info_size relies on.

Fixes: 122c29486e1f ("net: bridge: mst: Support setting and reporting MST port states")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

It turns out that even with Eric's fix, the guard was not restrictive
enough. Sorry about all the noise around this.

 net/bridge/br_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 204472449ec9..200ad05b296f 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -119,7 +119,7 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 	/* Each VLAN is returned in bridge_vlan_info along with flags */
 	vinfo_sz += num_vlan_infos * nla_total_size(sizeof(struct bridge_vlan_info));
 
-	if (vg && (filter_mask & RTEXT_FILTER_MST))
+	if (p && vg && (filter_mask & RTEXT_FILTER_MST))
 		vinfo_sz += br_mst_info_size(vg);
 
 	if (!(filter_mask & RTEXT_FILTER_CFM_STATUS))
-- 
2.25.1

