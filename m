Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF62299319
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786761AbgJZQ5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:57:47 -0400
Received: from m12-18.163.com ([220.181.12.18]:46116 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1786737AbgJZQ5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 12:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=5UgJD
        aZxvrA37eNyjgYmRvwWAPd5d2FMzatNwQgd0Iw=; b=moSyN+YQ6aS13hpxSBC/u
        rfqcpR25npzyEyhxecnJX5h5hOEqaDkM8/d3SLmz22fAXrPGBl0rGshT6oFHO3MY
        VkLv0XuJrBAN2lQBVjBdMp0BlXN5cZNYUe6ut5Z2Q2H33NR4M/0hYonH75wlSqbA
        u981InXC990KDY8oOzvL1I=
Received: from localhost (unknown [101.86.209.121])
        by smtp14 (Coremail) with SMTP id EsCowAA3yRjd_5ZfI8kjAQ--.61294S2;
        Tue, 27 Oct 2020 00:57:01 +0800 (CST)
Date:   Tue, 27 Oct 2020 00:57:00 +0800
From:   Hui Su <sh_def@163.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/atm: use list_is_singular() in br2684_setfilt()
Message-ID: <20201026165700.GA8218@rlk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowAA3yRjd_5ZfI8kjAQ--.61294S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFyUKF1rXF1xZw1rGw45Wrg_yoW3KrbEqF
        1Fkws7WrW5Jw4kKw4Fyws8try3Jr93u393XF1Ivas3AryrGrn5WFWkGF95Jry7W39rKF1f
        Xr1DGF45Gw1SkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8xuctUUUUU==
X-Originating-IP: [101.86.209.121]
X-CM-SenderInfo: xvkbvvri6rljoofrz/1tbiOR3JX1XlvO01HgAAs4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

list_is_singular() can tell whether a list has just one entry.
So we use list_is_singular（) here.

Signed-off-by: Hui Su <sh_def@163.com>
---
 net/atm/br2684.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index 3e17a5ecaa94..398f7e086cf4 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -372,8 +372,7 @@ static int br2684_setfilt(struct atm_vcc *atmvcc, void __user * arg)
 		struct br2684_dev *brdev;
 		read_lock(&devs_lock);
 		brdev = BRPRIV(br2684_find_dev(&fs.ifspec));
-		if (brdev == NULL || list_empty(&brdev->brvccs) ||
-		    brdev->brvccs.next != brdev->brvccs.prev)	/* >1 VCC */
+		if (brdev == NULL || !list_is_singular(&brdev->brvccs))	/* >1 VCC */
 			brvcc = NULL;
 		else
 			brvcc = list_entry_brvcc(brdev->brvccs.next);
-- 
2.25.1


