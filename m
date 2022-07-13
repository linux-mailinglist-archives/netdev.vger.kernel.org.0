Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125B2573513
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbiGMLOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGMLOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:14:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EB56AE3BE
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bWMkKjPV4Nd8SsBqqmrTOMauXj+aqkwTTcjEsUpuP7A=;
        b=NpDQVNCemY4aovFVyzm2d8Oqoc5uQYXLOz5dJyGqCzw66E7jOTeYxpuWtE6dCyx6rqSAGN
        lWtQa9QpEfaf2t5cCCmGxn+0MBOGFT2d6Z/z53E0aWy4XSEqZO3QvJJK9Uhip6i5YZ/q57
        t4LxPPuXQFHHTSjyY77Qsc3fbhiW4+Q=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-_AQ7bhpgMySzTRQMy1XUGw-1; Wed, 13 Jul 2022 07:14:38 -0400
X-MC-Unique: _AQ7bhpgMySzTRQMy1XUGw-1
Received: by mail-ej1-f70.google.com with SMTP id qb28-20020a1709077e9c00b0072af6ccc1aeso3216243ejc.6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bWMkKjPV4Nd8SsBqqmrTOMauXj+aqkwTTcjEsUpuP7A=;
        b=hCFAagTgv5V50xO3Tiq/QRRrljTgHgsBg/ceDzvvN5ukOqOh9dlwY6/H76pK2zClPd
         6tCAkHC8oigRR/gvyGcLKk4jyQPpCp11LGOj1XmpAUAxJIanMtxRvU7wpEW2Jr9wECvB
         tdE/2eSyU+vhJtll2PhR/m48FbcL8lIaQlTHw8KyRydu64TzE5WSmptlO1aPuI3J0VEI
         Wy7CGBdnVN7+WZlfPumN7+2J9/8Yk4Se/KZnniX5oaqeyThv7144fpXjQczv0b0UtBOJ
         zWQQJOmjhdQNshAgnv+hnJ6bfWf+wkrAdIbw+S3Xfem5bHgAXWIx2sOfn3/g13ex2DyF
         1I8w==
X-Gm-Message-State: AJIora+EbbKNL8KS/chlo53Fg7p8mWFUr/i3FNP/CFfxXm3AryHcrcYl
        P5y5T+mtjB6sJ8fk39tN49lFSnKdqUP725bxPtGik0q2FTCd+Fm/vWAaSpx+mxqtTJy4FayleF2
        gBPM5HCkjyudJ/ode
X-Received: by 2002:aa7:c2d7:0:b0:43a:78af:6e57 with SMTP id m23-20020aa7c2d7000000b0043a78af6e57mr4115926edp.163.1657710875078;
        Wed, 13 Jul 2022 04:14:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1toYCJgxCFQePChPTgb0ddDwHTSvI13EZhuFWasHBao1NAdsCA/T33L5bSGuT5go7T9KW8NIg==
X-Received: by 2002:aa7:c2d7:0:b0:43a:78af:6e57 with SMTP id m23-20020aa7c2d7000000b0043a78af6e57mr4115781edp.163.1657710873752;
        Wed, 13 Jul 2022 04:14:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s10-20020a170906354a00b00705cdfec71esm4868046eja.7.2022.07.13.04.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A05944D98FD; Wed, 13 Jul 2022 13:14:32 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH 01/17] dev: Move received_rps counter next to RPS members in softnet data
Date:   Wed, 13 Jul 2022 13:14:09 +0200
Message-Id: <20220713111430.134810-2-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the received_rps counter value next to the other RPS-related members
in softnet_data. This closes two four-byte holes in the structure, making
room for another pointer in the first two cache lines without bumping the
xmit struct to its own line.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a3cb93c3dcc..fe9aeca2fce9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3100,7 +3100,6 @@ struct softnet_data {
 	/* stats */
 	unsigned int		processed;
 	unsigned int		time_squeeze;
-	unsigned int		received_rps;
 #ifdef CONFIG_RPS
 	struct softnet_data	*rps_ipi_list;
 #endif
@@ -3133,6 +3132,7 @@ struct softnet_data {
 	unsigned int		cpu;
 	unsigned int		input_queue_tail;
 #endif
+	unsigned int		received_rps;
 	unsigned int		dropped;
 	struct sk_buff_head	input_pkt_queue;
 	struct napi_struct	backlog;
-- 
2.37.0

