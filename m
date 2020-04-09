Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9DBB1A2FA6
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgDIG4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 02:56:32 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42442 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIG4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 02:56:32 -0400
Received: by mail-qv1-f67.google.com with SMTP id ca9so4993525qvb.9
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 23:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GrAlTd7ha3CV6gCFirjFgEM//iNaaleQDGz96CqZCss=;
        b=if5DE+qhWDF/+FcO4RP+7ZBup5a3bI2RYi+2Mo4xO68dhDgy8ATe9M3MiN1gnCgAuO
         tzY+GsVqA9aYg2Cduxa0qMiiRwrQnkCuu7niIST9ywAxHyTJkKJQTTMbsxOJQ+jG7LNr
         QmFhGYiS/d9EMGr2VlS8pDCkeAeZ9c+6cmlAWPbyCWrxI6EuQRt8VsD+PLFnKESWBBfp
         iuAcAHvW6Zi94T6lhDcslaQrUWpfv7NCZynix2wKelO6W0UejNm9ZN67f5k0kqZpZ1fq
         DUWr+T2aP9Ol+46n+wCO5wIMWuSbf73WmvQ+TlmE1yHWoYpbvrd6WREdhOK/F6Z9xVjy
         dEzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GrAlTd7ha3CV6gCFirjFgEM//iNaaleQDGz96CqZCss=;
        b=S6/A14OtWzo1GCGSV9RLKbC4HCvUJKipOQAAxxK95N7rcQyuVn12bYV/ujuuon/1Qf
         F4Gr9FaFXhwtfZcqYZW3WMiQwlAcIPil1Nrs0FmoWWIWBNHpHyIeT7dChqxIF4Y9PoHv
         lgUinOHDlzQeA0Cjt1bOiW9yljAsUZJhSMEviyN9zAjvTm/1rO/de2SMYxL+KIMYrFEQ
         L8ZbInu0VtWU/mXL/cSZ2xaKGetevu+fn3mHJuZCZhGrL442547Prz9H/R46HCuzGn6o
         5WGhzsB8WHOui/fgv9lE/eMABA6rDIt87lyAM10lg2t/Plfq7s+zSErtBWVJaT+mnvht
         K9lA==
X-Gm-Message-State: AGi0PuaAx6SOnuS4MlaGcHjj/Gx2XAnp+Y8A21+UEsOjjxpJ2ZFOIV8o
        Tm/v0odNX2hsQVaex2p7EWKFcRjeNjs=
X-Google-Smtp-Source: APiQypIljmtfy1cTS2vP4rtwT7x8tsTujNVw3GDevrfa8O4X4hfGoJfilMGTDTX2OvMj0/M7vf2ctQ==
X-Received: by 2002:a0c:b503:: with SMTP id d3mr11357852qve.176.1586415390232;
        Wed, 08 Apr 2020 23:56:30 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l62sm20789825qte.52.2020.04.08.23.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 23:56:29 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] net/ipv6: allow token to be set when accept_ra disabled
Date:   Thu,  9 Apr 2020 14:56:04 +0800
Message-Id: <20200409065604.817-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The token setting should not depend on whether accept_ra is enabled or
disabled. The user could set the token at any time. Enable or disable
accept_ra only affects when the token address take effective.

On the other hand, we didn't remove the token setting when disable
accept_ra. So let's just remove the accept_ra checking when user want
to set token address.

Fixes: f53adae4eae5 ("net: ipv6: add tokenized interface identifier support")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 24e319dfb510..4e63330f63e5 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5689,8 +5689,6 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
 		return -EINVAL;
 	if (dev->flags & (IFF_LOOPBACK | IFF_NOARP))
 		return -EINVAL;
-	if (!ipv6_accept_ra(idev))
-		return -EINVAL;
 	if (idev->cnf.rtr_solicits == 0)
 		return -EINVAL;
 
-- 
2.19.2

