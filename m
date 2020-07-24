Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E26B22C950
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgGXPcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgGXPcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:32:06 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98F74C0619E4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 08:32:06 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8E1808ADAD;
        Fri, 24 Jul 2020 16:32:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604725; bh=kUiqyrJBnTTcKz3WKWE5+ihZm1VtcYbkrlnfi5v+ZsM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=206/9]=20l2tp:=20don't=20BUG_ON=
         20seqfile=20checks=20in=20l2tp_ppp|Date:=20Fri,=2024=20Jul=202020=
         2016:31:54=20+0100|Message-Id:=20<20200724153157.9366-7-tparkin@ka
         talix.com>|In-Reply-To:=20<20200724153157.9366-1-tparkin@katalix.c
         om>|References:=20<20200724153157.9366-1-tparkin@katalix.com>;
        b=ZI+r/O+iFum29bb5SsIbIjNYXv6CJw10Pz6wGxabkj8EbdgKZhZS0r+i/X9gPJr4B
         Xz9OSLbZ3WmM8n/4RF+gFFoqOxloODMgHYjGZ7adFerNmemAYmEZImmsEakPivPIPC
         Yf8DqOhUJmtxAoYQ4LnjKJnn5lXah53Qqx4ixkufifOAUO/AK3kk74CcTiOEcP1nl3
         /l2AjstYYLH0NInRXFYIwLTXMsztV0je0g4pBgvqfo9zpMmDuAltQI0PE1g/cRxp48
         0hM3bzsLjo1d3hoN9yNuGdZBay4Z3fQVl3iiurAQ8o1UmRGCdDWxHZhoXhBPmKog+C
         R1QAlr1TQRtvw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 6/9] l2tp: don't BUG_ON seqfile checks in l2tp_ppp
Date:   Fri, 24 Jul 2020 16:31:54 +0100
Message-Id: <20200724153157.9366-7-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch advises that WARN_ON and recovery code are preferred over
BUG_ON which crashes the kernel.

l2tp_ppp has a BUG_ON check of struct seq_file's private pointer in
pppol2tp_seq_start prior to accessing data through that pointer.

Rather than crashing, we can simply bail out early and return NULL in
order to terminate the seq file processing in much the same way as we do
when reaching the end of tunnel/session instances to render.

Retain a WARN_ON to help trace possible bugs in this area.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_ppp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 3b6613cfef48..c2d14cecbecf 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1478,7 +1478,11 @@ static void *pppol2tp_seq_start(struct seq_file *m, loff_t *offs)
 	if (!pos)
 		goto out;
 
-	BUG_ON(!m->private);
+	if (WARN_ON(!m->private)) {
+		pd = NULL;
+		goto out;
+	}
+
 	pd = m->private;
 	net = seq_file_net(m);
 
-- 
2.17.1

