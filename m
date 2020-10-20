Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A32C293A3B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 13:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393800AbgJTLpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 07:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393794AbgJTLpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 07:45:32 -0400
X-Greylist: delayed 103 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 20 Oct 2020 04:45:32 PDT
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCCBC061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 04:45:32 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 3C07C2E1521
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 14:43:46 +0300 (MSK)
Received: from sas2-32987e004045.qloud-c.yandex.net (sas2-32987e004045.qloud-c.yandex.net [2a02:6b8:c08:b889:0:640:3298:7e00])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 01GkrR410q-hkwq9Vxk;
        Tue, 20 Oct 2020 14:43:46 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1603194226; bh=D1HSti143ynqlv8O4ezg1MUKBBhl3ND0FH7p22/Ac/I=;
        h=Message-Id:Date:Subject:To:From;
        b=rBo1EVh+G04CVNLv9HMK/DZAUOZuW57tMtEoyuwhbwSTf96FKx2swaekh/HnERaBv
         grM3GFebfveITmgod9ECCHyEj5JboNLUTk5UMleVnOncf5xVm93rxoID5Llyts6HQZ
         Djhgg08j9S9TAJ4/OU6HxAswRrkPWlATajpjcbpM=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.sas.yp-c.yandex.net (ov.sas.yp-c.yandex.net [2a02:6b8:c1b:2b1b:0:696:6703:0])
        by sas2-32987e004045.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id NAcjNOGT5N-hjmSUfce;
        Tue, 20 Oct 2020 14:43:45 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Subject: [PATCH net v2] mpls: load mpls_gso after mpls_iptunnel
Date:   Tue, 20 Oct 2020 14:43:33 +0300
Message-Id: <20201020114333.26866-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mpls_iptunnel is used only for mpls encapsuation, and if encaplusated
packet is larger than MTU we need mpls_gso for segmentation.

Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
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

