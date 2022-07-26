Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE8B5817FB
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbiGZQzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGZQzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:55:41 -0400
Received: from a1-bg02.venev.name (a1-bg02.venev.name [IPv6:2001:470:20aa::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C7795A9;
        Tue, 26 Jul 2022 09:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
        s=default; h=Content-Transfer-Encoding:Message-Id:Date:Subject:To:From:
        Content-Type:Reply-To:Sender; bh=DlPu22/HelfnwMZAefYnjzPtyiMpmlvP9Ci1dPmHDMU=
        ; b=hhsDVJZ3OFr70WMaymkHHeXx5mNEZ3A2XeRRDJcLK3GmFcBq8Nf8jAac4qlMIuU8wqidx99Qh
        OQ6vIKBXjvJ8fxWDF5HkKsqjGckKC64rw9f5n63KQ59CUQjAkZ0SYL0nSfahqeKRJxU5v3lgJ19Zr
        2e4kHlOhnPMJUshsmm7Qb5jV0ane5TYpDz5dMjvKEF3QyUhlLhzdlTG8WLQ7bkAuaqZXqXxvQCTMZ
        9YPkV866cwN+MAF9NQHZh9OTE0Iy6No1N1gLzmRBN4tT0M5vsFnB6PZVLJOzUVEQreKcWhOg7rPmE
        eSzxMussGey3vEiYynzZdSrpaCIBL+bL2tMRPCL+XzorB7ojhV/xjHkVW13FPPopX5FqUXlSB9z15
        iOgXsloZOA8+KZfkssROxAkpOEvThLAcJf/iRm4nTr0lwV7384kJLyzV09KspWBr/JjOugVkjwNiz
        rTq598h2wehJdnPMGKJPujsniVEJzeQbNxCOqySletjPa5ntsO2qKN8Kqg0H6R/ma6Y85t2f/gYny
        j8Udc6p8k1w2xuWS1WpJgXUG2vbhvVpizzG9d4RwHeV6RLsTHtTBEvEaqWeh0iQHcaVrccRgEaSum
        epKyWKV4jj07/FdMl0YKIAp5V1IeRoyS1PpSE0bq7Cudu1hLw68O56miavNerAwk134FzFg=;
X-Check-Malware: ok
Received: from a1-bg02.venev.name ([213.240.239.49] helo=pmx1.venev.name)
        by a1-bg02.venev.name with esmtps
        id 1oGNq6-000WGL-6w
        (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (envelope-from <hristo@venev.name>);
        Tue, 26 Jul 2022 16:55:21 +0000
Received: from venev.name ([213.240.239.49])
        by pmx1.venev.name with ESMTPSA
        id vOLEBXgc4GJx5AEAdB6GMg
        (envelope-from <hristo@venev.name>); Tue, 26 Jul 2022 16:55:21 +0000
From:   Hristo Venev <hristo@venev.name>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hristo Venev <hristo@venev.name>
Subject: [PATCH net v2] be2net: Fix uninitialized variable
Date:   Tue, 26 Jul 2022 19:54:54 +0300
Message-Id: <20220726165454.123991-1-hristo@venev.name>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722214205.5e384dbb@kernel.org>
References: <20220722214205.5e384dbb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following error is reported by Smatch:

    drivers/net/ethernet/emulex/benet/be_ethtool.c:1392 be_get_module_eeprom()
    error: uninitialized symbol 'status'.

When `eeprom->len == 0` and `eeprom->begin == PAGE_DATA_LEN`, we end
up with neither of the pages being read, so `status` is left
uninitialized.

While it appears that no caller will actually give `get_module_eeprom`
a zero length, fixing this issue is trivial.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: d7241f679a59 ("be2net: Fix buffer overflow in be_get_module_eeprom")
Signed-off-by: Hristo Venev <hristo@venev.name>
---
 drivers/net/ethernet/emulex/benet/be_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index bd0df189d871..2145882d00cc 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1361,7 +1361,7 @@ static int be_get_module_eeprom(struct net_device *netdev,
 				struct ethtool_eeprom *eeprom, u8 *data)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
-	int status;
+	int status = 0;
 	u32 begin, end;
 
 	if (!check_privilege(adapter, MAX_PRIVILEGES))
-- 
2.37.1

