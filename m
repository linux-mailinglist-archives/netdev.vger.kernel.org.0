Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B852260719
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 01:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgIGXHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 19:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgIGXHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 19:07:02 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600C5C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 16:07:01 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n13so14042612edo.10
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 16:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+YGoySMSKTqlyBmRjFMBYPju8lGCTQ4AdFGLzFcqKmM=;
        b=kfKBmz2rwiIq2Xyd1pMChb6Is07n5zR8ArR2BsyjSrTNwa8fdbTF0cFFgY6YDzV/w1
         CvDmVt1rk+lIgMVKXa0aXgQsn3usGulkMhdbpPZVZBpHImHJzeHb4R3iEiTEF1tLbPI+
         WFzLmkIz/4KDRy6x80F2Uvd7qtxfc6Z0t/atLqbwmBieyT7ouzx5vNUrJi+Des09Lk+N
         pY1SBlNCvv5c9P0MxB5mvZ6DmZr/t7KOuYT6fMSQPF/cJOJZJO+cUTirhYPL95+iVseg
         069h9qmKTGRv4CaHN0oOAC0PWJyPEn48ZcvaJ0+wnQJgzit8vm3Vh8vBWv6JYLHofuUg
         0qWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+YGoySMSKTqlyBmRjFMBYPju8lGCTQ4AdFGLzFcqKmM=;
        b=AzALlwQ8ncR23ethrlzH+j8M/tqWdBqeTqNJnB3qcRE/PTuxxFXbnfQivlLUyK0te1
         3UGwnpaCPiwLVtjhl17fgCU5aURnGxxD+yR4D6sYy8SeBaF4c3Or02OrX1Oez4Lno5oP
         V2kaWhwZZcsWdtVQYNaa15t9Cdv64099VY6kw/972eXmsB6RQB5+PL+AMSx4hE6WJAhe
         8/fCyhjEw2aU8r6hcizH/ZK6JZeOAMD0B8yp21Oi3NpMFRf2NH2VSJPl4bia+wYCP+92
         rwmBmdDos0MvpIhLdmRw3yXrQx/1c3ryqwVDYf+5114DOcsEDUgnpBkyRb6UD067KvbG
         Us0w==
X-Gm-Message-State: AOAM532pMnDtW+CqL1rUqT6Vk4DSHhKSVT65xGcxiC0zFsH3Nlum2N1p
        dX7i87nDlpJjA8Bnd+8cZNfx5UYy9EU=
X-Google-Smtp-Source: ABdhPJxvZns94aA2Uh+Wp4S9LeAyPtrMc8NYzSPwcGof7U1c4imCGw4E6Q3Yuq++1jhwy8F830Bczw==
X-Received: by 2002:a50:8e17:: with SMTP id 23mr23545981edw.42.1599520019857;
        Mon, 07 Sep 2020 16:06:59 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id n20sm16347406ejg.65.2020.09.07.16.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 16:06:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next] net: dsa: change PHY error message again
Date:   Tue,  8 Sep 2020 02:06:56 +0300
Message-Id: <20200907230656.1666974-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

slave_dev->name is only populated at this stage if it was specified
through a label in the device tree. However that is not mandatory.
When it isn't, the error message looks like this:

[    5.037057] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
[    5.044672] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
[    5.052275] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
[    5.059877] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d

which is especially confusing since the error gets printed on behalf of
the DSA master (fsl_enetc in this case).

Printing an error message that contains a valid reference to the DSA
port's name is difficult at this point in the initialization stage, so
at least we should print some info that is more reliable, even if less
user-friendly. That may be the driver name and the hardware port index.

After this change, the error is printed as:

[    6.051587] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 0
[    6.061192] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 1
[    6.070765] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 2
[    6.080324] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 3

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
The reason why I did not attempt to call dev_alloc_name() as Andrew
suggested:
https://patchwork.ozlabs.org/project/netdev/patch/20200823213520.2445615-1-olteanv@gmail.com/
is that, in the case of a persistent error, all interfaces would get the
same name, and this would create more confusion than it would solve.
Also, that interface name would appear in the kernel log exactly once,
because this is an error path and we're going to free it right away. So,
if a label is not in use, better not print anything.

[    6.051587] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 0, name eth3
[    6.061192] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 1, name eth3
[    6.070765] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 2, name eth3
[    6.080324] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 3, name eth3

 net/dsa/slave.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9af1a2d0cec4..27931141d30f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1792,8 +1792,9 @@ int dsa_slave_create(struct dsa_port *port)
 
 	ret = dsa_slave_phy_setup(slave_dev);
 	if (ret) {
-		netdev_err(master, "error %d setting up slave PHY for %s\n",
-			   ret, slave_dev->name);
+		netdev_err(slave_dev,
+			   "error %d setting up PHY for tree %d, switch %d, port %d\n",
+			   ret, ds->dst->index, ds->index, port->index);
 		goto out_gcells;
 	}
 
-- 
2.25.1

