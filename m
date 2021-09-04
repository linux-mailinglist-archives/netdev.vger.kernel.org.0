Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FD2400C85
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 20:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhIDSbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 14:31:25 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:60179 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhIDSbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 14:31:24 -0400
X-Greylist: delayed 1825 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Sep 2021 14:31:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=2PacTOPFHG4uyTsOWJLrF0cv36iJKa7RYdDCEzjZX9k=; b=d+2Or
        PEGXGJP3Yt2f59HoVYIXXGAFy0rW0BOsPVvLVDxGXLiyPfsybQ2Emm+BOIeoSRTKY4rY8Yiav434d
        Pnx+HTGky3NXrV0MtdDKoEH14LFLNUqj2iDMbe6gplecx91Kh/snbHWttBetF3+qrDPRcgvnJ+a/V
        zzYfZBkxv2KNPkz4IZA3W6yt4C1TE47RjgYGGthi8RdZwXSx3XsGdiYLuI/whyBNSJ1P4+FZWKjZa
        gxc6BAmXEgQkhI5U+PHFaORHfNuCq1IqvxQXebZcea4Qh7kjTfY2rS8y4wfOWjOMDCp6BBtDTmJLh
        ZDFW0EWWCZw3Jx5CNUkKRbArmkSYw==;
Message-Id: <61ea0f0faaaaf26dd3c762eabe4420306ced21b9.1630770829.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1630770829.git.linux_oss@crudebyte.com>
References: <cover.1630770829.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Sat, 4 Sep 2021 17:12:51 +0200
Subject: [PATCH 2/2] net/9p: increase default msize to 128k
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Greg Kurz <groug@kaod.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's raise the default msize value to 128k.

The 'msize' option defines the maximum message size allowed for any
message being transmitted (in both directions) between 9p server and 9p
client during a 9p session.

Currently the default 'msize' is just 8k, which is way too conservative.
Such a small 'msize' value has quite a negative performance impact,
because individual 9p messages have to be split up far too often into
numerous smaller messages to fit into this message size limitation.

A default value of just 8k also has a much higher probablity of hitting
short-read issues like: https://gitlab.com/qemu-project/qemu/-/issues/409

Unfortunately user feedback showed that many 9p users are not aware that
this option even exists, nor the negative impact it might have if it is
too low.

Link: https://lists.gnu.org/archive/html/qemu-devel/2021-03/msg01003.html
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 1cb255587fff..213f12ed76cd 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -30,7 +30,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/9p.h>
 
-#define DEFAULT_MSIZE 8192
+#define DEFAULT_MSIZE (128 * 1024)
 
 /*
   * Client Option Parsing (code inspired by NFS code)
-- 
2.20.1

