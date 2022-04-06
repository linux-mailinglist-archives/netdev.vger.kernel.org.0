Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F6F4F617D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiDFORT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiDFOQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:16:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B8E468259;
        Tue,  5 Apr 2022 18:59:16 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p17so694499plo.9;
        Tue, 05 Apr 2022 18:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZzrJzEO0/L2Fv829K067oD4D3q7XNJ2h/EQeJLl1REM=;
        b=crfzt8upCMe531ZqNzG/w5bacK5PoIW4zpIg4VPCySNfIR4TuTFO9yLeKP+EdVSktl
         X2FZ8jEYUBS1z4hWJJTcu/FOuTwdq86di8oGNSnznOCPTF/6GcE1Zud5GJ4h43fmlJ3z
         9Fa2HVJrw29fx190k5u/msgzpHQxA9W9p7z5HyZjvP4gnPXrOsPaq+2TACfFaDmB+NOU
         ziu+dJ76nHNm+l+f+Onwda91vgKX/F+4SsOUf4T714JGyIxo/6I4L+RPVb/if4O36omE
         CNYwrX5aDZvupPhnCUnXE5McdYEJBnwt+m5EU+u6pZKswsptj1FqXMY3OxqVOU0I/rEt
         Qx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZzrJzEO0/L2Fv829K067oD4D3q7XNJ2h/EQeJLl1REM=;
        b=ImYFy+kwxfOlyl4x80ulBBOf9LO5UcAAfLkmdqrxu+G9kwyNUJAq4i7CIRj8m7FoGi
         ABmQj1HVkpWycNsLd+j4wBGoFPdkh1UG93wdLi4GzqTi6Z9JpOo5w97ts7x460Ze37kk
         M7Jox0hKMhPMzkkD8wgELxttYt7NA/ihJpIrSiElcuZa8jJUQN1/vr19omGxBQMKU8Bv
         lWQpEQx+WEVoALcPGNToL5lHLzXzhSdUDz2NLs9rI6xJgdLct/+8FtMURTsInHY0gn8M
         n8gaeA4dKI2tDXnXwyP5Gz3jp6H+50tKczPkxHThyuPX3p6SVNGG4XVll8zl1rs/pwJO
         jZKA==
X-Gm-Message-State: AOAM531gKnOl5IA5DzLDbSyvC1v4LYLA+9DMB4EGCzBckSJBekd8lZbw
        xLU/gpUCgAqaA8znKYTU/iE=
X-Google-Smtp-Source: ABdhPJxOmc+ENShQLno2fdpX+smu2f45tUg5mi9v08ko8E+JA+jXcFa/qde6p4zCEfgeWe2swp2VDg==
X-Received: by 2002:a17:90b:4b43:b0:1c9:85b0:2db8 with SMTP id mi3-20020a17090b4b4300b001c985b02db8mr7272803pjb.23.1649210356350;
        Tue, 05 Apr 2022 18:59:16 -0700 (PDT)
Received: from localhost.localdomain ([180.150.111.33])
        by smtp.gmail.com with ESMTPSA id x17-20020a17090ab01100b001ca8458964esm3712185pjq.18.2022.04.05.18.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 18:59:15 -0700 (PDT)
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Manish Chopra <manish.chopra@cavium.com>,
        Ariel Elior <ariel.elior@cavium.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] qede: confirm skb is allocated before using
Date:   Wed,  6 Apr 2022 11:58:09 +1000
Message-Id: <b86829347bc923c3b48487a941925292f103588d.1649210237.git.jamie.bainbridge@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qede_build_skb() assumes build_skb() always works and goes straight
to skb_reserve(). However, build_skb() can fail under memory pressure.
This results in a kernel panic because the skb to reserve is NULL.

Add a check in case build_skb() failed to allocate and return NULL.

The NULL return is handled correctly in callers to qede_build_skb().

Fixes: 8a8633978b842 ("qede: Add build_skb() support.")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index b242000a77fd8db322672e541df074be9b5ce9ef..b7cc36589f592e995e3a12bb80bc7c8e3af7dc42 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -748,6 +748,9 @@ qede_build_skb(struct qede_rx_queue *rxq,
 	buf = page_address(bd->data) + bd->page_offset;
 	skb = build_skb(buf, rxq->rx_buf_seg_size);
 
+	if (unlikely(!skb))
+		return NULL;
+
 	skb_reserve(skb, pad);
 	skb_put(skb, len);
 
-- 
2.35.1

