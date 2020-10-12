Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB8A28ACC7
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 06:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgJLEYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 00:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgJLEYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 00:24:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B732EC0613CE;
        Sun, 11 Oct 2020 21:24:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 144so12365281pfb.4;
        Sun, 11 Oct 2020 21:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tGGjPH4vRcWgaIyBvIwbuR8WDhMxPW1JkVrUAJH4wsw=;
        b=HVFLCVrJ9e/R18ofzZLeou3umzwT5fdPgRN+4LEas2eE+jBqseaUGv3FhBZk+khqI+
         5mZoEdAKnTgukkl0I4m5od9383+CT8FO/EW/+8PrsIx7gScnYEWOi7VM11l5TpIfHXYW
         viON4q9nrl+25CgwiOMJPUxxnb0fI8/LN+UQNLiclRpHfAjNZtm3b1/ssZd4l4VkRfSd
         6BQ1gpvAUfsndFgH+cFETq+OsAPplgexzPWrgEcv8vgke+38nK7Q7Db65iSFnYIP0ZpZ
         hcTynQ4e4vIH0HvGOKjR4A/ddjHJJDM+n5GiP23JNcACLzMQS9/3N+RuyHCH3TpSd+Wy
         5Lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tGGjPH4vRcWgaIyBvIwbuR8WDhMxPW1JkVrUAJH4wsw=;
        b=R+DLo15mGKsHaGTS55gqktv4QCLWtCUPEeylWK3xtW8TOnLHtQazvz+yYVvssnhV1v
         kCRc5HHoxDmOdjeJVupHG4KhoQVQdJ0cv+rFpJxX47MSPHTcxEGZ2vk+UzoFyCavduoj
         gxcYq4LWyaZI0zJs1lVzWfBXoXXFXy+svYKGiVQRAKvYTvwe1DrF5Y8M9ojr2FyfdYbJ
         EytKcWMfXwJcdWlYv9cIvsYcNlANYtCDd5tzVkJ4iK0DONJuMaauGg6Lwmhr6o92No50
         kUJcFR553WEPNCO+BWpboqmXpQa9sxRMBnFqQJoqpaV2SdoXd/upYa1/tUI/iJ1QrX6L
         uomw==
X-Gm-Message-State: AOAM530J2WP5ownl6DkfnC6lhJF70ewMKVyqULkapvdGFN0sMNqx++zT
        GUBFYoCTktF1Jr5k3jr8WjQ=
X-Google-Smtp-Source: ABdhPJzZRPX105i1KB5YPC6MVCCPOxq7CKb10XSNAcjI+7RWRlEQZdWUkpBRYMRarueOXCGcZlpXdQ==
X-Received: by 2002:a65:6858:: with SMTP id q24mr11849299pgt.10.1602476663055;
        Sun, 11 Oct 2020 21:24:23 -0700 (PDT)
Received: from localhost.localdomain ([49.207.200.2])
        by smtp.gmail.com with ESMTPSA id ck21sm21348723pjb.56.2020.10.11.21.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 21:24:22 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Subject: [PATCH net] net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid
Date:   Mon, 12 Oct 2020 09:54:04 +0530
Message-Id: <20201012042404.2508-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In p9_fd_create_unix, checking is performed to see if the addr (passed
as an argument) is NULL or not.
However, no check is performed to see if addr is a valid address, i.e.,
it doesn't entirely consist of only 0's.
The initialization of sun_server.sun_path to be equal to this faulty
addr value leads to an uninitialized variable, as detected by KMSAN.
Checking for this (faulty addr) and returning a negative error number
appropriately, resolves this issue.

Reported-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Tested-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
 net/9p/trans_fd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index c0762a302162..8f528e783a6c 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1023,7 +1023,7 @@ p9_fd_create_unix(struct p9_client *client, const char *addr, char *args)
 
 	csocket = NULL;
 
-	if (addr == NULL)
+	if (!addr || !strlen(addr))
 		return -EINVAL;
 
 	if (strlen(addr) >= UNIX_PATH_MAX) {
-- 
2.25.1

