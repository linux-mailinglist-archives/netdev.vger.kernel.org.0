Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85FB3958E3
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhEaKWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhEaKWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 06:22:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955AFC061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 03:20:58 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b11so6078946edy.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 03:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2oRtYygVzTdW+oUnjUmCThuV8Q8QwZkPup3+69c214=;
        b=gbdM9mdvVuT5tcMb4HNt3/VlXaUDX+dW+AXLP1CiTnkPa9AzVfS/bgNW2isd6H7ZRE
         QwHVZhEJgjV1Sf7GD0uo4hJ2nWj3ZDVVOvuuGm+PfR1OqKz/kZa0/e5cPfFS2cj7KItx
         AETf+DKX2XmbPGAp6skr1YUe49Sf+BxxdBR5UAeXTslrEKn8McVu8EFyIuDbFd1R51U2
         kIwDag5MI/taUuIIS66bf6VQxUEVL9/CRWpyQMhRIgdWx1CJ4sph4cLG+8hdXZjHjtCB
         pj9KWginTYDeGaZsAVurPTdPVJ3ZWmUphMXQixbcYwt1GBmIJ8l1O0NbbR6OnwpiZlGd
         XFbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2oRtYygVzTdW+oUnjUmCThuV8Q8QwZkPup3+69c214=;
        b=mqsqZg5Sypzt70vtBJtF6cb0phbd1DnT1euAQGUxC0PVTrdWxZNN+Hl1+ZMKbi+7p0
         GjVABS4EZRiC05UB5periRelPXVIJBung4ExOEcvfFsy6ZacYLEuJkUd3I0GjErVM5ke
         iNMzpAwTiIaRt+F/9XPnYWa9c0/tDgCFZTkZWzSsgBE8rpbxjT6tdtz+vTEP9v0ye8YA
         hMeewycB7LdGArCy5d8OqCr1YJ5QeyaxuwXRz9e8/VuTjlwSfcj37q2mbRJxgVlW20eW
         Bty0QEP1faMevD7VrylsuckckdRVNh1Ox/of+1eovr3MqbQ1eVXnd4IXK7m6mPAx2oz6
         cqiw==
X-Gm-Message-State: AOAM530ImaQltqCED4j9daqlfVtdbXDSOUNGa8RTmBX7mFndrQdxTGjQ
        xCsvMyQbebU8W/HcwBOK8rA=
X-Google-Smtp-Source: ABdhPJzEyCAIJzUlIGawGMtz1+UILyhK70JGroYXJJnN9GgkYFF2oY5kZDDocNsOEqS4k7GTv+f8sw==
X-Received: by 2002:a50:eb08:: with SMTP id y8mr24794389edp.89.1622456457164;
        Mon, 31 May 2021 03:20:57 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id y14sm3739675ejq.102.2021.05.31.03.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 03:20:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: dsa: tag_8021q: fix the VLAN IDs used for encoding sub-VLANs
Date:   Mon, 31 May 2021 13:20:45 +0300
Message-Id: <20210531102045.936595-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When using sub-VLANs in the range of 1-7, the resulting value from:

	rx_vid = dsa_8021q_rx_vid_subvlan(ds, port, subvlan);

is wrong according to the description from tag_8021q.c:

 | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
 +-----------+-----+-----------------+-----------+-----------------------+
 |    DIR    | SVL |    SWITCH_ID    |  SUBVLAN  |          PORT         |
 +-----------+-----+-----------------+-----------+-----------------------+

For example, when ds->index == 0, port == 3 and subvlan == 1,
dsa_8021q_rx_vid_subvlan() returns 1027, same as it returns for
subvlan == 0, but it should have returned 1043.

This is because the low portion of the subvlan bits are not masked
properly when writing into the 12-bit VLAN value. They are masked into
bits 4:3, but they should be masked into bits 5:4.

Fixes: 3eaae1d05f2b ("net: dsa: tag_8021q: support up to 8 VLANs per port using sub-VLANs")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 008c1ec6e20c..122ad5833fb1 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -64,7 +64,7 @@
 #define DSA_8021Q_SUBVLAN_HI_SHIFT	9
 #define DSA_8021Q_SUBVLAN_HI_MASK	GENMASK(9, 9)
 #define DSA_8021Q_SUBVLAN_LO_SHIFT	4
-#define DSA_8021Q_SUBVLAN_LO_MASK	GENMASK(4, 3)
+#define DSA_8021Q_SUBVLAN_LO_MASK	GENMASK(5, 4)
 #define DSA_8021Q_SUBVLAN_HI(x)		(((x) & GENMASK(2, 2)) >> 2)
 #define DSA_8021Q_SUBVLAN_LO(x)		((x) & GENMASK(1, 0))
 #define DSA_8021Q_SUBVLAN(x)		\
-- 
2.25.1

