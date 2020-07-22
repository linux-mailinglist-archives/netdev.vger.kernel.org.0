Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75178229B33
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732794AbgGVPUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgGVPUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:20:17 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD13C0619DC;
        Wed, 22 Jul 2020 08:20:17 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id di5so1155679qvb.11;
        Wed, 22 Jul 2020 08:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mC+9VCisrQOLG6kTWdRwYqg9YnRsNnWuSWD6BGUaBPU=;
        b=FZ8HekGeo5ShXhCW8K3Qz+diyX/yNtoMBwYcfNlQOkYqwJMOBDgkjjnrXxMcFytvl0
         EUX2omBZVUM4mZLAJv89P8Bsab6RM96iDKoWFBid86ut6Rknmzs9hd4FivGcc5tzWmQe
         WPpqaU6RcomIDNnm5zy7m/x16lXpOcKVuJ8icY/dPG9fNcMZwDbSClIimXXW4FeW0x/k
         sYD9XbJqXHFmkDNHbxUi39CWdyXfFfd2joCrE6kn+tBk1FIU6AqzTvCiRBhFHukdqTv/
         A/2auoshCGbIidQlhZt5lalBFxNltjZZYOPyxB0qTqMD5DqmgL5eZl/75YGNCnWB3mq1
         /gDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mC+9VCisrQOLG6kTWdRwYqg9YnRsNnWuSWD6BGUaBPU=;
        b=EpJUoU3ByiX0FpbuMhoow2vNygHAiYkh8DUefhVS65aKN+pxJrkSTl6p2Yzm67VN46
         G9NCXk+D/j7/6LjZQbYolTFW6pN9nldmLQ63/Za6nmkVpWlb9T9DWHgnshgJmNdAbEwj
         Co1P1IZey/92VGygwhX0BIYtPFYxV+ooKUtstBIrKWQIQRNbe9P8uyJUQ8aNEbyQK0W7
         0WD4MhoYjNSg2oqJT7TmPDYSoxKu6Vamn0qXSyxo3tL8FIf5PoA6ESmlyCXFpxM3J4AX
         /YYzSwfasBz8l8oe2yanmEIGOPvnIPxz/zlqVbHqWIRK5DDgGS3eBCDJ5YrRQANhxii+
         VIaw==
X-Gm-Message-State: AOAM531ePh71OXvi/pIJxzl5rr7fTuYcuEk6V4gHBMiZM14u+ei/FC0N
        5WhaEmTmD3igUuuihK4RdA==
X-Google-Smtp-Source: ABdhPJyQlAbWhv80O6xSt+eVr/q5xPqqgm6J3gKBuQeelHhV7/HpWfRDD0xY6q8tS7Z3mN/bUfbdRQ==
X-Received: by 2002:ad4:4583:: with SMTP id x3mr454680qvu.133.1595431216569;
        Wed, 22 Jul 2020 08:20:16 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id 16sm147427qkv.48.2020.07.22.08.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 08:20:16 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Joerg Reuter <jreuter@yaina.de>, Ralf Baechle <ralf@linux-mips.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] AX.25: Fix out-of-bounds read in ax25_connect()
Date:   Wed, 22 Jul 2020 11:19:01 -0400
Message-Id: <20200722151901.350003-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checks on `addr_len` and `fsa->fsa_ax25.sax25_ndigis` are insufficient.
ax25_connect() can go out of bounds when `fsa->fsa_ax25.sax25_ndigis`
equals to 7 or 8. Fix it.

This issue has been reported as a KMSAN uninit-value bug, because in such
a case, ax25_connect() reaches into the uninitialized portion of the
`struct sockaddr_storage` statically allocated in __sys_connect().

It is safe to remove `fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS` because
`addr_len` is guaranteed to be less than or equal to
`sizeof(struct full_sockaddr_ax25)`.

Reported-by: syzbot+c82752228ed975b0a623@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=55ef9d629f3b3d7d70b69558015b63b48d01af66
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 net/ax25/af_ax25.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index fd91cd34f25e..ef5bf116157a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1187,7 +1187,9 @@ static int __must_check ax25_connect(struct socket *sock,
 	if (addr_len > sizeof(struct sockaddr_ax25) &&
 	    fsa->fsa_ax25.sax25_ndigis != 0) {
 		/* Valid number of digipeaters ? */
-		if (fsa->fsa_ax25.sax25_ndigis < 1 || fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS) {
+		if (fsa->fsa_ax25.sax25_ndigis < 1 ||
+		    addr_len < sizeof(struct sockaddr_ax25) +
+		    sizeof(ax25_address) * fsa->fsa_ax25.sax25_ndigis) {
 			err = -EINVAL;
 			goto out_release;
 		}
-- 
2.25.1

