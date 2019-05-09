Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0081859A
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 08:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfEIGzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 02:55:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45083 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfEIGzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 02:55:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id i21so685283pgi.12
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 23:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7+Ptc7P71SaU+2c/JY/C+wkHNfadoN+CdfTmH7wR304=;
        b=UAmlfJYwOOOFSn3oOXeK1GAPPFvtlFfZvob9Qmm9VOifOuslSYE6shlq4ok+gOr5n1
         6+IlpjgDu9OTTVZr2J9ZNI3mQl1Y4FqEnS8ISx/R/0FfHs6Uzq29zo7DP9exYQ2uqjUA
         qJUa1DKoHxmcqBmpbFEMjDOmIJFkxiQ1LLKmu4DGdqJ/PEoyG3VD7avxB8jrSgpyh8DW
         JpjUbzrvTknU1UjswWmhGsZqLitJbdGnzEOr9IUmaq1i6j1+mUtRh+b1qPwa8DFrnmaz
         6/OnWnuckNxafiskm+3hakIiOTs4x8TtQa+hko3tvhPOtADrDSXlkYvfx0ZqTNi6yRO5
         ILCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7+Ptc7P71SaU+2c/JY/C+wkHNfadoN+CdfTmH7wR304=;
        b=l2RVJK93ZDyH8yBJUKF9VLSjmOeHcpNOeQtW13RUdQmedbvUCjX6hKv5qEAFzZBOUX
         nNMyIDzknlpuLM6Hc2KxTONPU50u6S4422OPv5QRLmkZJ5xkFv1xfLcEfChdvm2zVuL2
         tB33U1lxEOCDlfsL8Z0mTLmUTrqMJAR8KNRUssuTRm2Pu5sgW7xsMvjQm27rB2lauyz5
         Q2RPtz1g/9/UsWFl6ztQRriUysiFj+aSfMpjM4N8CGUvB1TBEqbkh3UAV6e1ElCCJtUq
         GXOtuVptbuzKvG9jskUy6ZjR0cGzX7d+Gwr39DxghwcA/+Ni1Q2FKl5YsF6KLtf9243y
         lDkg==
X-Gm-Message-State: APjAAAUSjASyPS0OXx7k+WSpiH2SbK7Bajz3DOfvwm3qXZhft+WjDBz8
        r6ZTwJm+QJtzWTbVeu/n01CtzdyqH4Q=
X-Google-Smtp-Source: APXvYqwXwlApzrXJrywmJ+2pdcj5Xib3RgHlfP9nVpMu80df1r1bwbkMYogYelTxRhtor1/zHZjgbw==
X-Received: by 2002:a63:6849:: with SMTP id d70mr3293393pgc.21.1557384921075;
        Wed, 08 May 2019 23:55:21 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d15sm3235615pfm.186.2019.05.08.23.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 23:55:20 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>,
        stefan.sorensen@spectralink.com, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] vlan: disable SIOCSHWTSTAMP in container
Date:   Thu,  9 May 2019 14:55:07 +0800
Message-Id: <20190509065507.23991-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With NET_ADMIN enabled in container, a normal user could be mapped to
root and is able to change the real device's rx filter via ioctl on
vlan, which would affect the other ptp process on host. Fix it by
disabling SIOCSHWTSTAMP in container.

Fixes: a6111d3c93d0 ("vlan: Pass SIOC[SG]HWTSTAMP ioctls to real device")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/8021q/vlan_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index f044ae56a313..2a9a60733594 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -370,10 +370,12 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	ifrr.ifr_ifru = ifr->ifr_ifru;
 
 	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		if (!net_eq(dev_net(dev), &init_net))
+			break;
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-	case SIOCSHWTSTAMP:
 	case SIOCGHWTSTAMP:
 		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
 			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);
-- 
2.19.2

