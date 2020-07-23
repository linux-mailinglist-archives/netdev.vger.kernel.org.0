Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B16D22ADC8
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgGWLaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:30:12 -0400
Received: from mail.katalix.com ([3.9.82.81]:44048 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgGWLaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:30:06 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 23A2B8AD88;
        Thu, 23 Jul 2020 12:30:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595503805; bh=Ls8curZf6Cv1QIh0sm0Lz4UaRbbSF9ZSUL/0K0NLgcg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=206/6]=20l2tp:=20cleanup=20kzall
         oc=20calls|Date:=20Thu,=2023=20Jul=202020=2012:29:55=20+0100|Messa
         ge-Id:=20<20200723112955.19808-7-tparkin@katalix.com>|In-Reply-To:
         =20<20200723112955.19808-1-tparkin@katalix.com>|References:=20<202
         00723112955.19808-1-tparkin@katalix.com>;
        b=KbyNkkJPVOSfj81GCWZBx3iPJ+rlzb+XBkmnN8xFbSA10+oAOHOgzMCduEeEzmzjY
         N0avtfVRaDbS74uakMcW1oG0KI8cmI2r4XGAdR2Kn19RGXIi8pfJF4UE6/eAZ4kW9V
         TeOpuTJ8DJnvoTG7wlamXLqKxqCrUyxNB63dbUQDFf7Th7wcb13nstAURpgCICg3b1
         HM4bpqoNa9aT47JoFo86CKIEirWPOXNcp9Oj3LaPG/6quP8Kic+AlE+lkG2ug3WC0I
         EgA/CwGPgjRcy0RcuOgX5aH+lhNj/GlLLElA4h8nzYRdP0x1DDBhgcT4KVtkQLe2Cn
         aMxE1eqI8Tjuw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 6/6] l2tp: cleanup kzalloc calls
Date:   Thu, 23 Jul 2020 12:29:55 +0100
Message-Id: <20200723112955.19808-7-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200723112955.19808-1-tparkin@katalix.com>
References: <20200723112955.19808-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing "sizeof(struct blah)" in kzalloc calls is less readable,
potentially prone to future bugs if the type of the pointer is changed,
and triggers checkpatch warnings.

Tweak the kzalloc calls in l2tp which use this form to avoid the
warning.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index d1403f27135e..7e3523015d6f 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1410,7 +1410,7 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 	if (cfg)
 		encap = cfg->encap;
 
-	tunnel = kzalloc(sizeof(struct l2tp_tunnel), GFP_KERNEL);
+	tunnel = kzalloc(sizeof(*tunnel), GFP_KERNEL);
 	if (!tunnel) {
 		err = -ENOMEM;
 		goto err;
@@ -1647,7 +1647,7 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 {
 	struct l2tp_session *session;
 
-	session = kzalloc(sizeof(struct l2tp_session) + priv_size, GFP_KERNEL);
+	session = kzalloc(sizeof(*session) + priv_size, GFP_KERNEL);
 	if (session) {
 		session->magic = L2TP_SESSION_MAGIC;
 		session->tunnel = tunnel;
-- 
2.17.1

