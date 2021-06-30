Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2858D3B8A3E
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 23:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhF3V4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 17:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhF3V4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 17:56:41 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E3AC061756;
        Wed, 30 Jun 2021 14:54:10 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id a11so4430628ilf.2;
        Wed, 30 Jun 2021 14:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SiO6sM+XvfiysPkLpQDRfRvm5Fce6TSrKOnYNqubSNc=;
        b=OpbwTy+lUhPiAsepyJOe6PhqnD/hYzT1wHPFTG0zTApbDjZxknvLxWzPOoIYqlFIX9
         aiCUbEIT14WW01FJvNrD5shPCDLX8Psskgehq7bNDf+2SkkbiwCkM/rcRy23aZVy1l78
         x9vQCsb/uQhubRpUfZBRHM6TBLWWnid4NPvxvgIBOWjFbfJa1491vXT4gsS17gmGnbQW
         kX467VxUEmMuA4mbr/4XsfJktsCpNfCPFq/Hs4bLVcocndCN+xaYe6B0ZIwar3JbPA2I
         pI1NRCUs6aiDrh1t2XiKC434Y9SSm00Z5F53/Ccw2Aw8QlikOB6pMnXzq/OfhdVKmoW+
         RKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SiO6sM+XvfiysPkLpQDRfRvm5Fce6TSrKOnYNqubSNc=;
        b=qdc8SoxVhpo4LfPs0PRY+CPbQ5Tb3U6Obaxi32jWSfsZjzKswSmd96S/qSF3bstnmW
         IdLxOGmAXdpTzn0MS1zCmNz+BiyOL2iKu/NKdcQHzgB9Xg3WxycepYAYzlRRAhgUF+X3
         xsLyFUAjsuNOTPrbJbVTmfRoyWAELhxKgrhgf4fpoOBfY3TxM9cZUbaxwlevFh6SUc2e
         Fn3zdv56xUQgk5VI/DZEGZidAPvIxBRyZwuJVN0t/cVUaWayrkLU8N0Xv2EQStUknwpY
         GHygFU20G5VjT8AirdhZSctHTl7ODJkSKGHWrfSE9QiOAoKZXCOlSqm4O1VLvfLqm4Xp
         q9RA==
X-Gm-Message-State: AOAM533kH8idT4SC/KcyM6j1P4sT/SyCNVywUriuYjPeJWvXtazXPo//
        Ap0jjT3ksr6TgPsmStpDJJ4=
X-Google-Smtp-Source: ABdhPJwNvC4PBlUxp/GdvPOXg/nkg/iL/HtT3pkbq07NMgxUkzqman/OQrUatcUb/JMP7g0TQpyYpw==
X-Received: by 2002:a92:3647:: with SMTP id d7mr27680236ilf.231.1625090050190;
        Wed, 30 Jun 2021 14:54:10 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id b3sm5541210ilm.73.2021.06.30.14.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 14:54:09 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf, sockmap 1/2] bpf, sockmap: fix potential memory leak on unlikely error case
Date:   Wed, 30 Jun 2021 14:53:48 -0700
Message-Id: <20210630215349.73263-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210630215349.73263-1-john.fastabend@gmail.com>
References: <20210630215349.73263-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb_linearize is needed and fails we could leak a msg on the error
handling. To fix ensure we kfree the msg block before returning error.
Found during code review.

Fixes: 4363023d2668e ("bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9b6160a191f8..22603289c2b2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -505,8 +505,10 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	 * drop the skb. We need to linearize the skb so that the mapping
 	 * in skb_to_sgvec can not error.
 	 */
-	if (skb_linearize(skb))
+	if (skb_linearize(skb)) {
+		kfree(msg);
 		return -EAGAIN;
+	}
 	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
 	if (unlikely(num_sge < 0)) {
 		kfree(msg);
-- 
2.25.1

