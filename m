Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116826D7468
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbjDEGda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbjDEGd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:33:28 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8226130FF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:33:25 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id q8so3682829ilo.1
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 23:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680676405;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k2r4QI5U2xToOmDkPtJhf7Jhqw0jIt0t8tP0ZqCmskQ=;
        b=GSnrsXD+T0b/pGmUJruXFQ/5/adaCmoasKrB12+KWkLtnjyx9JXCT2DqIDns0sQ2Wd
         lXjW5Q1Ki2mbI+4pp2cGrhgeREldTXExSqapa9Wf7UA+nnxTcpH2tV3JVciSK9gmWCV1
         U6rXyQ9ukf/5bDjxoIyRFeQuB4YfCdVGL01AjgdRMVXmK3QYZ5Z7WTRbXwGfkMsTGNWI
         3j+A1YSPu26COgCVOuoTm1iRXM5e3OzqLyLlXAzjyQ5JbPLxaqYVPzrqKKo1LaIW53sw
         EOo3kCCBAyYTVzcwEB6ulRirHae6s6hgQZHq6k3SfIhvVgeIAqTCaJKIU+fkCtfUST9O
         1WdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680676405;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k2r4QI5U2xToOmDkPtJhf7Jhqw0jIt0t8tP0ZqCmskQ=;
        b=cHwminN+v2MiRBe6mK2Hie29j1LLJbVxdr9KPSHhpL1y40DSKdncV7y9x/wVyGC2DM
         rfRGX3q5m8N5E2k0aHvpn2EW2H15dwHANThQ6XyP0JHKW16B9wEYyzVF2ccyDUUbbvcP
         xBT9MdmNlDX4kdW+vi/euH1WMWb5moRaIw4GdWqA0xGS7kOPkE7j3NbjStYZfgeJUODe
         9+jRBLMUlHpNiDdvOyMFobTySpNN3mZQr6w0ZOGPXtIOXb1WN7AbEmbZs63tUpmjVeNv
         s+lWW6ghlHAF4mt9n8G9ODdEqTCB0qG930PB1sWJigBq96e8XgTADBkfEqs9cyAJDXKY
         /o8w==
X-Gm-Message-State: AAQBX9djgr+PiO5btRgVzLkLNnrc3ZvT0QdrsDCxBCnmakB92oxM7Mgu
        4SNQOjrbkeG99x9bBOoKcls=
X-Google-Smtp-Source: AKy350ZptuN1F948ptgZ1usiP5xteDxIa+AjMHGz+psh2lpE+hlTKUI6bBWvdHr29wZ9G5cC+LtKtQ==
X-Received: by 2002:a92:d385:0:b0:326:6d28:94be with SMTP id o5-20020a92d385000000b003266d2894bemr3797517ilo.12.1680676404782;
        Tue, 04 Apr 2023 23:33:24 -0700 (PDT)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id g3-20020a056e020d0300b003230c7d6a3csm3786671ilj.67.2023.04.04.23.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 23:33:24 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code path
Date:   Wed,  5 Apr 2023 00:33:23 -0600
Message-Id: <20230405063323.36270-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes VLAN subsystem to use the newly introduced
ndo_hwtstamp_get/set API to pass hw timestamp requests to
underlying NIC drivers in case if these drivers implement
ndo_hwtstamp_get/set functions. Otherwise VLAN·subsystem
falls back to calling ndo_eth_ioctl.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 net/8021q/vlan_dev.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 5920544e93e8..66d54c610aa5 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -353,6 +353,44 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
+static int vlan_dev_hwtstamp(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct kernel_hwtstamp_config kernel_config = {};
+	struct hwtstamp_config config;
+	int err;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	if ((cmd == SIOCSHWTSTAMP && !ops->ndo_hwtstamp_set) ||
+	    (cmd == SIOCGHWTSTAMP && !ops->ndo_hwtstamp_get)) {
+		if (ops->ndo_eth_ioctl) {
+			return ops->ndo_eth_ioctl(real_dev, &ifr, cmd);
+		else
+			return -EOPNOTSUPP;
+	}
+
+	kernel_config.ifr = ifr;
+	if (cmd == SIOCSHWTSTAMP) {
+		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+			return -EFAULT;
+
+		hwtstamp_config_to_kernel(&kernel_config, &config);
+		err = ops->ndo_hwtstamp_set(dev, &kernel_config, NULL);
+	} else if (cmd == SIOCGHWTSTAMP) {
+		err = ops->ndo_hwtstamp_get(dev, &kernel_config, NULL);
+	}
+
+	if (err)
+		return err;
+
+	hwtstamp_kernel_to_config(&config, &kernel_config);
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+	return 0;
+}
+
 static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
@@ -368,10 +406,12 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!net_eq(dev_net(dev), dev_net(real_dev)))
 			break;
 		fallthrough;
+	case SIOCGHWTSTAMP:
+		err = vlan_dev_hwtstamp(real_dev, &ifrr, cmd);
+		break;
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-	case SIOCGHWTSTAMP:
 		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
 			err = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
 		break;
-- 
2.39.2

