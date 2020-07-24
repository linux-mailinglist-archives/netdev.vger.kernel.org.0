Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B6222BD2D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 06:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgGXEuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 00:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGXEuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 00:50:52 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6E9C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 21:50:51 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id 72so3832974ple.0
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 21:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBbONK3/3q1TsKJGKzM0GmT2Z8r1yOy5gHh7hXuu8rg=;
        b=jKXdWUFDh2VQbGrAcqQvvAbabsqDAkmy3ghtjRzAFc1VQQBaUKcefiIHrd3Q+sgP4S
         /xCJmHB+g/ROfjUdCbUoXHSkxZV14zz4AShkcB89oHD+E85fEC2c4r/M1ey0wWJEEUhl
         hefk5cobeAoSNI4haP7TOkz61gzdWbGcn8yrHBKkyABdSbCyMA8SatMJiA/Z2c6yzXlr
         2zbc3IngVWwPiD4nAzCXTZ5Ojs+y8Li48iWontRJaq2Bau6Id32t9e9B43OwAJzOT8bL
         JSYP7JYW6o5ZXsMerKadfE9yoLJ6mpDI/UNyev0Xm5oy6Dbftk4+2xOJd4NXqJ8m2Ngf
         TUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBbONK3/3q1TsKJGKzM0GmT2Z8r1yOy5gHh7hXuu8rg=;
        b=BpR+AFJnO/H/o3uCHEyaFwhXC6oiAQtOXZKFYNXPYQKQws8zrEBGY4QV31DbYsINFD
         1Mn4ezf2Hsazoya6VH1apStaP4eTjtCx3bt3inp7BSMmjZ+LyrcHd/KMTB4FzB/Yg8co
         efEUYom89XEKnB/xQRwUoYymyvXHVo0W6pYGkKlrfeSvSMH0MWYhvmHdhfUQDlrCWAAW
         YJ9GGHublqRJ3DJNAPBDncDF7aONG+FS6U0slSXsWk3Y2cXFw5AHyqSVKyYTvK/Iw8o1
         IMr21PSl8HRTj8Sn8eh2T/n3vKq0KIHSWi++gcbMT1k5W0q/zgXrvoz3S2G/cWxrHfac
         qUhw==
X-Gm-Message-State: AOAM530xkBNyaRSOKMc4iM4bcIteNKjH4HM5F569E5LgAFypgz/AYHRF
        QBT0rZWOoHGcsPL4VNyxDB+4b+PYGjs=
X-Google-Smtp-Source: ABdhPJz/cj/FROm6Nv1AI29PusAElGmupgsqJWVuD24+dNE9rRMeKv08zGzRSA96+Z9EAq900ZVy0g==
X-Received: by 2002:a17:90a:ec0a:: with SMTP id l10mr3277955pjy.152.1595566250629;
        Thu, 23 Jul 2020 21:50:50 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::46])
        by smtp.gmail.com with ESMTPSA id z11sm4579074pfk.46.2020.07.23.21.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 21:50:50 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [Patch net] qrtr: orphan skb before queuing in xmit
Date:   Thu, 23 Jul 2020 21:50:40 -0700
Message-Id: <20200724045040.20070-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to tun_net_xmit(), we have to orphan the skb
before queuing it, otherwise we may use the socket when
purging the queue after it is freed by user-space.

Reported-and-tested-by: syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com
Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/qrtr/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index 15ce9b642b25..54a565dcfef3 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -20,6 +20,7 @@ static int qrtr_tun_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 {
 	struct qrtr_tun *tun = container_of(ep, struct qrtr_tun, ep);
 
+	skb_orphan(skb);
 	skb_queue_tail(&tun->queue, skb);
 
 	/* wake up any blocking processes, waiting for new data */
-- 
2.27.0

