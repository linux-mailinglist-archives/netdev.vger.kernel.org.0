Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055EF29398F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 13:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393397AbgJTLEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 07:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392465AbgJTLEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 07:04:38 -0400
X-Greylist: delayed 85 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 20 Oct 2020 04:04:38 PDT
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA19C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 04:04:38 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 044382E1545
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 14:03:10 +0300 (MSK)
Received: from sas1-58a37b48fb94.qloud-c.yandex.net (sas1-58a37b48fb94.qloud-c.yandex.net [2a02:6b8:c08:1d1b:0:640:58a3:7b48])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id fuiGPps9v2-39wer4XE;
        Tue, 20 Oct 2020 14:03:09 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1603191789; bh=5N7HBue0Jzo5KgsWl/WXKgAajfF/jtstQaN08CaHU8I=;
        h=Message-Id:Date:Subject:To:From;
        b=jpjddEzyDIFM6lDqK8sA2Z+E+O1Q9plGUUVoXiBJ3wCZ8C6uUQb0dGnAb92x17xfm
         b8Q2E3yrcHPgWAbJv1gjrGlUEkvhvDXw4bG12VvI0rTi8VsSFcden1zkG5gK+QS6td
         sNLVIJN+KIiQ/y2TPA/+1Avlo/jwqoXLmvIsMdXs=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.sas.yp-c.yandex.net (ov.sas.yp-c.yandex.net [2a02:6b8:c1b:2b1b:0:696:6703:0])
        by sas1-58a37b48fb94.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id DwduTjuT1S-39mWsAO1;
        Tue, 20 Oct 2020 14:03:09 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Subject: [PATCH net] mpls: load mpls_gso after mpls_iptunnel
Date:   Tue, 20 Oct 2020 14:02:55 +0300
Message-Id: <20201020110255.17012-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mpls_iptunnel is used only for mpls encapsuation, and if encaplusated
packet is larger than MTU we need mpls_gso for segmentation.
---
 net/mpls/mpls_iptunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index 2def85718d94..ef59e25dc482 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -300,5 +300,6 @@ static void __exit mpls_iptunnel_exit(void)
 module_exit(mpls_iptunnel_exit);
 
 MODULE_ALIAS_RTNL_LWT(MPLS);
+MODULE_SOFTDEP("post: mpls_gso");
 MODULE_DESCRIPTION("MultiProtocol Label Switching IP Tunnels");
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

