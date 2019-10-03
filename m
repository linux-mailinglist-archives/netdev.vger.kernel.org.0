Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F2CB16A
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbfJCVmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbfJCVmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 17:42:20 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65BD20679;
        Thu,  3 Oct 2019 21:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570138939;
        bh=wc6zJQicDvo3ks4P6CXzbbolwKSwVh6gY+HN4p79Nk4=;
        h=From:To:Cc:Subject:Date:From;
        b=ismxWFhMtU9rtAo7svYY0/47QjlbzW/eUr+C+Ve/IPVpKsxdPw+8qXw5ba5LjPEey
         8qNMrb1ehaK0RjXp7jkMuMrGWKEP+c53+bdzK5Zdn/+yTmEfcmn+0cUATjsdB9hUb6
         xoVxretLGkODfk3Wyx4bbbEQXU4fWlQRjxyjxYhc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com,
        eric.dumazet@gmail.com, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] Revert "ipv6: Handle race in addrconf_dad_work"
Date:   Thu,  3 Oct 2019 14:46:15 -0700
Message-Id: <20191003214615.10119-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This reverts commit a3ce2a21bb8969ae27917281244fa91bf5f286d7.

Eric reported tests failings with commit. After digging into it,
the bottom line is that the DAD sequence is not to be messed with.
There are too many cases that are expected to proceed regardless
of whether a device is up.

Revert the patch and I will send a different solution for the
problem Rajendra reported.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/addrconf.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dd3be06d5a06..6a576ff92c39 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4032,12 +4032,6 @@ static void addrconf_dad_work(struct work_struct *w)
 
 	rtnl_lock();
 
-	/* check if device was taken down before this delayed work
-	 * function could be canceled
-	 */
-	if (idev->dead || !(idev->if_flags & IF_READY))
-		goto out;
-
 	spin_lock_bh(&ifp->lock);
 	if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
 		action = DAD_BEGIN;
@@ -4083,6 +4077,11 @@ static void addrconf_dad_work(struct work_struct *w)
 		goto out;
 
 	write_lock_bh(&idev->lock);
+	if (idev->dead || !(idev->if_flags & IF_READY)) {
+		write_unlock_bh(&idev->lock);
+		goto out;
+	}
+
 	spin_lock(&ifp->lock);
 	if (ifp->state == INET6_IFADDR_STATE_DEAD) {
 		spin_unlock(&ifp->lock);
-- 
2.11.0

