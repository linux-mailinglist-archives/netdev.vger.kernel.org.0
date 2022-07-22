Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F9457E3B0
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 17:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbiGVPXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 11:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiGVPXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 11:23:35 -0400
Received: from a1-bg02.venev.name (a1-bg02.venev.name [IPv6:2001:470:20aa::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335B39F050
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 08:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
        s=default; h=Content-Transfer-Encoding:Message-Id:Date:Subject:To:From:
        Content-Type:Reply-To:Sender; bh=wRzxD5OK0yZmKuNkMhrV09hlvnq/ACuUqTWh/glpdpk=
        ; b=d75douFD9hLTpbYdz06h3DSfS3E+QtmdhxyJY/kA+po2trXmjTJTCbuTFzw0f9iK75QyCmINF
        acEVI8p9nL8g5DYIdJjbrxuCGeADA9uCe7+duYao20y2V1M2SWaAlmYW7QQZ039XtOgop3uXj/rrh
        b0vYfieQT9PzA5uhWLpmXzcY8iYE99gyEF2sPR7rZWmjPWvQ5+bBc+Sk6hXUZebwUNno81ZNGwT57
        UY5rtorreKMwNiGu62P4sJkzy/iKN00hvmmflOT77Hr5NSEH9cfrGa8f9QBZMX+6xtRXY1/RovyWU
        2WlC58w1/XCAKD1EdZp7RxcOYU3JAr6AUBOjdVR9zoGGmMV5psJcdv1sL4mYYdmz2gqdayNEvQlB3
        Qx0U0P1UeL8Mc9uLh4lKe4LDJ1yhX5EQHKYcXxUq9k28r6tkBgnYxKrbnTI9YVFQVVaRtS/N3XCGh
        BKbgSWaXYkntYjieWCy5W7P39/l7dGZiyHfadLETU4fVQiy16G0KzuOwkSmp+UB7nKXDBvuN3PscG
        XNu3GDjlhjlFY1jpFLyQeXnRVS4SbHzjdohQjQrbRfusMjTCX7sr4UfV1rRw9ephAeWdH1pBA3EpW
        ScO+GXUj0zbMC5BlJtKoIkIH8yGGO+X2Qfcf9gIQLKcRgX69wF64EbvNrKdIP7hcRdGlsCg=;
X-Check-Malware: ok
Received: from a1-bg02.venev.name ([213.240.239.49] helo=pmx1.venev.name)
        by a1-bg02.venev.name with esmtps
        id 1oEuUS-00011t-D6
        (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (envelope-from <hristo@venev.name>);
        Fri, 22 Jul 2022 15:23:10 +0000
Received: from venev.name ([213.240.239.49])
        by pmx1.venev.name with ESMTPSA
        id 2K0xEc/A2mJ1DwAAdB6GMg
        (envelope-from <hristo@venev.name>); Fri, 22 Jul 2022 15:22:56 +0000
From:   Hristo Venev <hristo@venev.name>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hristo Venev <hristo@venev.name>
Subject: [PATCH] be2net: Fix Smatch error
Date:   Fri, 22 Jul 2022 18:20:52 +0300
Message-Id: <20220722152050.3752-1-hristo@venev.name>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <YtlIZgG/wQtxpKMh@kili>
References: <YtlIZgG/wQtxpKMh@kili>
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

    drivers/net/ethernet/emulex/benet/be_ethtool.c:1392 be_get_module_eeprom()
    error: uninitialized symbol 'status'.

When `eeprom->len == 0` and `eeprom->offset == PAGE_DATA_LEN`, we end
up with neither of the pages being read, so `status` is left
uninitialized.

While it appears that no caller will actually give `get_module_eeprom`
a zero length, fixing this issue is trivial.

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

