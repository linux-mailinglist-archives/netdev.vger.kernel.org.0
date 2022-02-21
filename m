Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3D34BEA7B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiBUSab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:30:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiBUS2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:28:33 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A44117A;
        Mon, 21 Feb 2022 10:27:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645468040; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=I2nhWluehVpIg7LYRGj0lb+HtX6yuKYu20+HSz62h32exN7yPEiJDQn8btAI11cyM5XmiYUZthdipTX49sSJnVqXsXK3hvTrh25OpG7vTWSkW68Y2k+gy6PllvTG1Uc303TaXZT7hWlZrmChmLa5muOpbeH0Tos7bi6vUTCBe3U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645468040; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=lsUTstuCLZiXo8cyZqtWGt1ha64pvUvvNjWGO5Xlg8k=; 
        b=j/qndHkpJz3g23MiJ2RQqOTup8U4Nbm1ZsuiDzs9z6Cggx1DOFtM3usA3n/oP/5aUaAGHFgXuAzd915/28De3m5K9wSUdg/0L9wDXcc0lOtLnBmaljZcmNjiyaK9nUM9wzCbym5yrmDxzSiihgq74wWox1NzMDUQpGBHz2D041k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645468040;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=lsUTstuCLZiXo8cyZqtWGt1ha64pvUvvNjWGO5Xlg8k=;
        b=S7s2+BgP6VRv8X/YaNCQeF+h2DvmTXQeaHMZyBwzzeNAoZYo722ahsD4VjPBiYPA
        OnbPTx6Pun2OdKdOFs0xQD3BxTOHMXw1jxf3/96lSSJi2rhTVMZ+0RQlrP3xmtCerQJ
        3F3zbJiZ+0C5ZdLUFg+PofrziETk0It2Vdfmqkiw=
Received: from anirudhrb.com (49.207.206.107 [49.207.206.107]) by mx.zohomail.com
        with SMTPS id 1645468038663423.2394169010746; Mon, 21 Feb 2022 10:27:18 -0800 (PST)
Date:   Mon, 21 Feb 2022 23:57:11 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     syzbot <syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] INFO: task hung in vhost_work_dev_flush
Message-ID: <YhPZf7qHeOWHgTHe@anirudhrb.com>
References: <00000000000057702a05d8532b18@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000057702a05d8532b18@google.com>
X-ZohoMailClient: External
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 670d56c879e5..fef9daa9f09f 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -53,8 +53,13 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 			      void *opaque)
 {
 	struct vhost_iotlb_map *map;
+	u64 size = last - start + 1;
 
-	if (last < start)
+	pr_info("vhost_iotlb_add_range: iotlb=%p, start=%llu, last=%llx, addr=%llu\n",
+			iotlb, start, last, addr);
+
+	// size can overflow to 0 when start is 0 and last is (2^64 - 1).
+	if (last < start || size == 0)
 		return -EFAULT;
 
 	if (iotlb->limit &&
@@ -69,7 +74,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 		return -ENOMEM;
 
 	map->start = start;
-	map->size = last - start + 1;
+	map->size = size;
 	map->last = last;
 	map->addr = addr;
 	map->perm = perm;
