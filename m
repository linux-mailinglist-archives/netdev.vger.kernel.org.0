Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A76149F30
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 08:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgA0HVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 02:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgA0HVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 02:21:16 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF6720702;
        Mon, 27 Jan 2020 07:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580109675;
        bh=dqlc/qctrnV6ugObfCAanSuzvqAbbXtb8enfOjgNnSM=;
        h=From:To:Cc:Subject:Date:From;
        b=yiwROvSlcjXXV7ShcWm8l2sW8oUIOTwSDtPRtotAf2t85ExkFl/bjcxEbysjR1m8p
         JaFDUwgj59XE9vjgDY/ZHkpkP3Z1NvRVRImihxGAmGdOw+HGi5EcLCyPJELMUV9+yN
         mRT2/PNf1/zb3mD6KVaTM77tW6LJa6dunoRtGeCc=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Shannon Nelson <snelson@pensando.io>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH net-next v4] net/core: Replace driver version to be kernel version
Date:   Mon, 27 Jan 2020 09:20:28 +0200
Message-Id: <20200127072028.19123-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

In order to stop useless driver version bumps and unify output
presented by ethtool -i, let's set default version string.

As Linus said in [1]: "Things are supposed to be backwards and
forwards compatible, because we don't accept breakage in user
space anyway. So versioning is pointless, and only causes
problems."

They cause problems when users start to see version changes
and expect specific set of features which will be different
for stable@, vanilla and distribution kernels.

Distribution kernels are based on some kernel version with extra
patches on top, for example, in RedHat world this "extra" is a lot
and for them your driver version say nothing. Users who run vanilla
kernels won't use driver version information too, because running
such kernels requires knowledge and understanding.

Another set of problems are related to difference in versioning scheme
and such doesn't allow to write meaningful automation which will work
sanely on all ethtool capable devices.

Before this change:
[leonro@erver ~]$ ethtool -i eth0
driver: virtio_net
version: 1.0.0
After this change and once ->version assignment will be deleted
from virtio_net:
[leonro@server ~]$ ethtool -i eth0
driver: virtio_net
version: 5.5.0-rc6+

Link: https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/
Link: https://lore.kernel.org/linux-rdma/20200122152627.14903-1-michal.kalderon@marvell.com/T/#md460ff8f976c532a89d6860411c3c50bb811038b
Link: https://lore.kernel.org/linux-rdma/20200127060835.GA570@unicorn.suse.cz
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 Changelog:
 v4: Set default driver version prior to calling ->get_drvinfo(). This will allow
     us to remove all in-the-tree version assignments, while keeping ability
     to overwrite it for out-of-tree drivers.
 v3: https://lore.kernel.org/linux-rdma/20200126105422.86969-1-leon@kernel.org
     Used wrong target branch, changed from rdma-next to net-next.
 v2: https://lore.kernel.org/linux-rdma/20200126100124.86014-1-leon@kernel.org
     Updated commit message.
 v1: https://lore.kernel.org/linux-rdma/20200125161401.40683-1-leon@kernel.org
     Resend per-Dave's request
     https://lore.kernel.org/linux-rdma/20200125.101311.1924780619716720495.davem@davemloft.net
     No changes at all and applied cleanly on top of "3333e50b64fe Merge branch 'mlxsw-Offload-TBF'"
 v0: https://lore.kernel.org/linux-rdma/20200123130541.30473-1-leon@kernel.org
---
 net/ethtool/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 182bffbffa78..0501b615e920 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/phy.h>
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
+#include <linux/vermagic.h>
 #include <linux/vmalloc.h>
 #include <linux/sfp.h>
 #include <linux/slab.h>
@@ -655,6 +656,7 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,

 	memset(&info, 0, sizeof(info));
 	info.cmd = ETHTOOL_GDRVINFO;
+	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
 	if (ops->get_drvinfo) {
 		ops->get_drvinfo(dev, &info);
 	} else if (dev->dev.parent && dev->dev.parent->driver) {
--
2.24.1

