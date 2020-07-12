Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16A421CBC4
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgGLWQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgGLWQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:16:37 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F85C08C5DB
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:16:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc9so5158178pjb.2
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c2PP8vI6Q3zuI13PpotIpcM2sPjPaTgti2Sw7JH+Ws0=;
        b=pXZ+CWIpneSWxluqCbryvkMr2S3w14a3XlGDakJrxBmf5FeX7yvgwlbbygIrTbmvcU
         qRemuKeatlUD5N9VHm2Xrx0Xid9arxQzJpcKvENp4hVL9cL8NX73kSKwFsRsLn+8K2RW
         trH4Ve+xSexMhp2HNmYEWyozJzfTQE3rnIQg0UGIjlRcQ9HC9cVoTVwUPJY/l6UVlwp9
         r/aOV6fdYbvtrSoKymkTGbL4VPx8couM3RCYmHd4H4MDKsdgk/NAM4Qt2QjEFlF75F3L
         iRFbiIBd2W6Ugu+U7I9zTAIu63Du4oqVC1uvD9EZ8nZtPGIHODfhA33cGSxeHN8A8cXi
         uNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c2PP8vI6Q3zuI13PpotIpcM2sPjPaTgti2Sw7JH+Ws0=;
        b=mfwarMOBi5oLm3196/5WAYW2nLLcxz9jwr/dvPxIgifAtAcV/lCq/yBKrkCQ0RBi6f
         PW3mdyrOlCsAoLv34kUNwa3eOZPnjTczn4JR6HRub2ySDmcrHZ1OvWABnz9Bi2yjM3Oy
         YrvfgCTk2S7fZr/Y7UP6Yb5W2kwPiW5OBjhCQDmEMRfUvogCcb5XexfdCKvyV0+8xjkD
         7+wiiJVoJePLsP/W2JEzdiCeAPi1tFdMqHHQ8k1DNwBc/PTsrLvH9+SGFm6xnKg/3kgz
         RqXgDIlF/lfYjFbpP7m5+3Yz4W0+AxVOQOeJQxTb82eM7B9nv7+mH5ymzIMt44KVPucf
         oeyQ==
X-Gm-Message-State: AOAM533s48pvJjMdws5RR+5zvVO5r1BRmIZCZ3U1tT8OUMUFAHaSGtBz
        SObCJZANFngVFLjPEamL+MmOaFOH
X-Google-Smtp-Source: ABdhPJz1MWtaEMm7VR9OBbmyARQy6FHQIkK0fNJO/pMJdLqHs1MgjEpoDQpzqcgpxuiw/U0KuvAe6Q==
X-Received: by 2002:a17:90a:d684:: with SMTP id x4mr16587837pju.62.1594592196281;
        Sun, 12 Jul 2020 15:16:36 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y198sm12470228pfg.116.2020.07.12.15.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 15:16:35 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, mkubecek@suse.cz, kuba@kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 2/3] net: dsa: Implement ndo_equal for CPU port net_device
Date:   Sun, 12 Jul 2020 15:16:24 -0700
Message-Id: <20200712221625.287763-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200712221625.287763-1-f.fainelli@gmail.com>
References: <20200712221625.287763-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to preserve comparisons of the DSA network device bound to the
switch's CPU port, implement net_device::ndo_equal which will return
true while doing net_device_ops pointer comparisons.

Network device drivers might do these checks to reject notifications
targeting a different net_device instance and those could be
non-functional because of the DSA overloading of net_device_ops. No such
cases are known to exist in tree today.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/master.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 480a61460c23..1c4f0736426e 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -226,6 +226,14 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return err;
 }
 
+static bool dsa_master_equal(struct net_device *dev,
+			     const struct net_device_ops *ops)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+
+	return cpu_dp->orig_ndo_ops == ops;
+}
+
 static int dsa_master_ethtool_setup(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
@@ -279,6 +287,7 @@ static int dsa_master_ndo_setup(struct net_device *dev)
 
 	ops->ndo_get_phys_port_name = dsa_master_get_phys_port_name;
 	ops->ndo_do_ioctl = dsa_master_ioctl;
+	ops->ndo_equal = dsa_master_equal;
 
 	dev->netdev_ops  = ops;
 
-- 
2.25.1

