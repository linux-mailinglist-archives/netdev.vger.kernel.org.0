Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6951C4D3E18
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbiCJAaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238996AbiCJA36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:29:58 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0BA123BFC
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:28:58 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id s11so3645612pfu.13
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmMmAv7X/GTOQMp14Z492/H8MoM1ZZZ0aZt3DTBRw6M=;
        b=UgQEOY922LF35qRMVvCscw6ATVC4ooffMelzUclgX391LKHUlWFMuoXhRWIjx3wkw5
         Bqr5zUm+Y8yJucSiNKGDjRusEninlbhG307KOdRrDYX36zmQ3chXLxN9xHYGa99gAky9
         OQ43ROeaXMABIELEojPMTE75yp9lHMew8dn5SE6FvSawzP+m6jtZKnB2mbfbgx//FhJ9
         zxK4KVkgnr9+FR2CgKPfPlsUG3ZKGhvVaGSS+j+vSinlLNFemPmV8y/17DP66oFKy8jf
         0krhjN7DJVcYAyXdXJTfmfiV4Nr2jUvSWgpriAzPdKnpCgB59px/bYV41WakMh8vQCrA
         /1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmMmAv7X/GTOQMp14Z492/H8MoM1ZZZ0aZt3DTBRw6M=;
        b=1It4ifFswPedA/jtvxn/UcSU3+ZXXVsptuCKfwEoDEdGMxVFGvQzwdp4KS2JJ9Bk5l
         gIScaTHMjNXFJ+smj5Pw3ErKvb051qyO6afXCNQxP4fILwQGiidFTOUwiB+9/QnizFvQ
         jOFA1K3L+lWn+fDtOBrQDLTYxhRgB/dnWWN+7kBq4yYgdSZb8BfPHvKl0v9Hfh4wnWIo
         RM96DILRR2sTMwCmzI5g8d7M1wgZ6MapTfuVtKP+rzOCE+LnB+yC6l9Ak3fw1hdfdwwL
         8P53Tp7kCOexEFhR+TLBNm9xz/vyZ1W3m2g7Y4/BxtzHxFRg+8qdzwKZt4rmISqBpito
         ofog==
X-Gm-Message-State: AOAM530umZJqvkcNjxBWcBo2ITcSA0aRq9jVQ1hO553VGNrbia80+HV7
        NgfbGzQc+VCu9IWUFJ+IK7o=
X-Google-Smtp-Source: ABdhPJwLWUdp/2aP12ApTjx4m4m10jn+Uat5z8b/WTUDcI3bxC7kgTimc+WMz6u8bTIjK+ETZLW5bw==
X-Received: by 2002:a63:465b:0:b0:374:642c:ab62 with SMTP id v27-20020a63465b000000b00374642cab62mr1927696pgk.187.1646872138193;
        Wed, 09 Mar 2022 16:28:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:28:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 04/14] ipv6: add struct hop_jumbo_hdr definition
Date:   Wed,  9 Mar 2022 16:28:36 -0800
Message-Id: <20220310002846.460907-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310002846.460907-1-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Following patches will need to add and remove local IPv6 jumbogram
options to enable BIG TCP.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c7c39f4c07f0c05b4e6cf34a7878e..63d019953c47ea03d3b723a58c25e83c249489a9 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -151,6 +151,17 @@ struct frag_hdr {
 	__be32	identification;
 };
 
+/*
+ * Jumbo payload option, as described in RFC 2675 2.
+ */
+struct hop_jumbo_hdr {
+	u8	nexthdr;
+	u8	hdrlen;
+	u8	tlv_type;	/* IPV6_TLV_JUMBO, 0xC2 */
+	u8	tlv_len;	/* 4 */
+	__be32	jumbo_payload_len;
+};
+
 #define	IP6_MF		0x0001
 #define	IP6_OFFSET	0xFFF8
 
-- 
2.35.1.616.g0bdcbb4464-goog

