Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EC1196CC
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 04:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfEJCxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 22:53:10 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47099 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbfEJCxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 22:53:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D8AC623EFF;
        Thu,  9 May 2019 22:53:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 09 May 2019 22:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MB29zTtGAQv18AoG4
        ME820wBqkJjcLFJN7yVzkW2rFI=; b=WN4qWqK/yNR+uhX+KfAFdDO6WybPAxf+U
        UpZUGZhBWZGrbdMgbmOlC9F5Fxzb+xpT9ou2mOlO3jVeM7lOiUL/zkC8+shshAaq
        nvtfW81iY22TiRQKjeLa6CWWk20VqgiALYxv84eEUL0kREiMzVpnqQnJghSAsmSZ
        Zzl9EjFKSLsrzDQjwRtEsVUcpradsChjgrvtIIgIvqbAVBTbWGyP1LWo6EH/Zn1S
        w8dPhluv6MkKAL38YAiC3iqO2ZXABYc3NfYdt+QqPAmjx4PhwFIn01FFOtqhFA1c
        4nW3p6MBk7NhtqP1n24Nnn41ZHey1m4Ls1YdPmCYvolkej90nWJ6Q==
X-ME-Sender: <xms:lOfUXMVQ2rp-LdlRVodFgLSqQV-_vSsLq6Pv_GQ5kLDW5mCii_Jtsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeigdduieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpedfvfhosghinhcu
    vedrucfjrghrughinhhgfdcuoehtohgsihhnsehkvghrnhgvlhdrohhrgheqnecuffhomh
    grihhnpehsohhluhhtihhonhdrnhgvthenucfkphepuddvgedrudejuddrvddurdehvden
    ucfrrghrrghmpehmrghilhhfrhhomhepthhosghinheskhgvrhhnvghlrdhorhhgnecuve
    hluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:lOfUXOI9Zeo9qIkdE4RaCoPGvTLxDWbvg4BdRMbColhoVBRSTkD9Bg>
    <xmx:lOfUXG3Tu1ntrd-ZoWt1cHv9D4T96E4xsQ_GA9AtlLmReFQagAbbIA>
    <xmx:lOfUXM7HHatpUmi7N-IngGbP-GQZf5qoBSi1YK1Kz7adHK90b3lwlA>
    <xmx:lOfUXM1wejLbwW8JMjmDVoDWRXFfBRdI9-_pt-RSiDGYHXDDLRrFCQ>
Received: from eros.localdomain (124-171-21-52.dyn.iinet.net.au [124.171.21.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB92B8005B;
        Thu,  9 May 2019 22:53:04 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] bridge: Fix error path for kobject_init_and_add()
Date:   Fri, 10 May 2019 12:52:12 +1000
Message-Id: <20190510025212.10109-1-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently error return from kobject_init_and_add() is not followed by a
call to kobject_put().  This means there is a memory leak.  We currently
set p to NULL so that kfree() may be called on it as a noop, the code is
arguably clearer if we move the kfree() up closer to where it is
called (instead of after goto jump).

Remove a goto label 'err1' and jump to call to kobject_put() in error
return from kobject_init_and_add() fixing the memory leak.  Re-name goto
label 'put_back' to 'err1' now that we don't use err1, following current
nomenclature (err1, err2 ...).  Move call to kfree out of the error
code at bottom of function up to closer to where memory was allocated.
Add comment to clarify call to kfree().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---

v1 was a part of a set.  I have dropped the other patch until I can work
out a correct solution.

 net/bridge/br_if.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 41f0a696a65f..0cb0aa0313a8 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -602,13 +602,15 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	call_netdevice_notifiers(NETDEV_JOIN, dev);
 
 	err = dev_set_allmulti(dev, 1);
-	if (err)
-		goto put_back;
+	if (err) {
+		kfree(p);	/* kobject not yet init'd, manually free */
+		goto err1;
+	}
 
 	err = kobject_init_and_add(&p->kobj, &brport_ktype, &(dev->dev.kobj),
 				   SYSFS_BRIDGE_PORT_ATTR);
 	if (err)
-		goto err1;
+		goto err2;
 
 	err = br_sysfs_addif(p);
 	if (err)
@@ -700,12 +702,9 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	sysfs_remove_link(br->ifobj, p->dev->name);
 err2:
 	kobject_put(&p->kobj);
-	p = NULL; /* kobject_put frees */
-err1:
 	dev_set_allmulti(dev, -1);
-put_back:
+err1:
 	dev_put(dev);
-	kfree(p);
 	return err;
 }
 
-- 
2.21.0

