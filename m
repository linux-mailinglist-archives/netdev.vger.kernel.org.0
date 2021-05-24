Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667CE38E927
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhEXOsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233172AbhEXOr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 978DF613BC;
        Mon, 24 May 2021 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867591;
        bh=xDh8vqmsD0PqY7lkpUvW7q/+AmZ23MBZFO5QElc9QaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8qYhsoV0bYiY9RkaQwa1fN1N7MB6g1YTPnEm26xXKUpppThI4H5IP7hTr98AIC72
         ++6C8+6c2pKc/iElMx+cd4BVBeNnrCJYdCQIh4MJ3ckFAauyujzdnr7+xSjygGF3qX
         40aDZKJgCqycB7AhJ4RVD28ju5qg6BgQQHbMXPvuDevtWcSbbl4wb/bPuvI6psTkys
         lZq2mQOCQXL7rK1hNGyEEAG8GIbLolYPLV9WgVNEjkmYD3klD/OqDTIElSQNk7Lo5P
         VGg0U4uhc+NkyMYT1nhhYfDD78l7Pg9s6bbaCIEjvZaUm6Ss62RmV6GoZu9yI4Ay+j
         hdz5zc5+RCEyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 08/63] Revert "net: fujitsu: fix a potential NULL pointer dereference"
Date:   Mon, 24 May 2021 10:45:25 -0400
Message-Id: <20210524144620.2497249-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 5f94eaa4ee23e80841fa359a372f84cfe25daee1 ]

This reverts commit 9f4d6358e11bbc7b839f9419636188e4151fb6e4.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original change does not change any behavior as the caller of this
function onlyu checks for "== -1" as an error condition so this error is
not handled properly.  Remove this change and it will be fixed up
properly in a later commit.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-15-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index a7b7a4aace79..dc90c61fc827 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -547,11 +547,6 @@ static int fmvj18x_get_hwinfo(struct pcmcia_device *link, u_char *node_id)
 	return -1;
 
     base = ioremap(link->resource[2]->start, resource_size(link->resource[2]));
-    if (!base) {
-	    pcmcia_release_window(link, link->resource[2]);
-	    return -ENOMEM;
-    }
-
     pcmcia_map_mem_page(link, link->resource[2], 0);
 
     /*
-- 
2.30.2

