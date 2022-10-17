Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC60360143A
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJQRD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJQRDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:03:46 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238686FA1A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:45 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a10so19364877wrm.12
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ulr0pv0RSk8i+OHflqNwbgKxTewZenJOsVk21xY+qK8=;
        b=uw20U2BSBs9eDfSNTFWIfrPc5iSJOXxf9AVWnmVZWKXNnp47zqMRklSKYe57yP2eB3
         bNUwXOipJ9Nrrju9TVCzO/1BdWv5VxRDvQWi2WWwsRxsbAhx85YCmeYemdUh7xiAtQlh
         drsShEuJH9dIYqxx06w+cX/TPy1jkRJrvIjRbD2H8qWbvsfJpS7qnt0QbII/aANvNT+a
         sDRg14HCY0uhjHbcgcTHCHlbfMTj88TFEnZJDBdX+OLI/cqdOpFvQz+ByZbvX/FJEcEf
         g2pCoC/l0HHKBPREmzwg9pGXiAjNT1zG/YOGZLeiXmuVViBYx0Z2QwVIKyVyDqOfFnn5
         DcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ulr0pv0RSk8i+OHflqNwbgKxTewZenJOsVk21xY+qK8=;
        b=RmcVvAbNfo1og7ht8TM8Mw3jpf2iCPsX9O0rqPYhH4ewEBclGdAm2ZBUqvBs5dPwyv
         VFFU1FvrXyX4e2Zp+gStsRlXE7X8DxXsp/bNwDg1s8o3AThVYpWKkkUvmGy1fjUOKvFa
         y0r1+CT2kLGkpXcTrxdylhXAUSCIK0zsZr0Wra2OKRQ8JcTr8VsnBF7qQs+6vYFA2MVw
         ykgaR/nzLmxKb/1Erm5KkjlSVfIxPcyXojfh44tP7xPm7FvOmjcdKqpobR3lh2MAJANs
         azxRB17DuXbmT4AtGwDKrq/zTNe2Z1c1cCIinfW7E9TZ2+Shi2uBS5+BhyXMRodV8jNA
         /JIw==
X-Gm-Message-State: ACrzQf2Ip3huBw4bVAIPqfVdA9lozUGZQWn1PJmqXyHHX4l42QezzzjF
        lW4TiZJhbPzk2Za4IZF7LUOlNQ==
X-Google-Smtp-Source: AMsMyM4g8YAQul5Mlho3iC4FP6XPAhCE+2n00e3t4axDfcMEDbXb/7IXC3+CseCL2pDLyjN9qAzjKA==
X-Received: by 2002:a5d:648b:0:b0:22e:ee60:db37 with SMTP id o11-20020a5d648b000000b0022eee60db37mr7207185wri.116.1666026224651;
        Mon, 17 Oct 2022 10:03:44 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id w16-20020adf8bd0000000b0022f40a2d06esm9079196wra.35.2022.10.17.10.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:03:44 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH iproute2 4/4] ss: re-add TIPC query support
Date:   Mon, 17 Oct 2022 19:03:08 +0200
Message-Id: <20221017170308.1280537-5-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221017170308.1280537-1-matthieu.baerts@tessares.net>
References: <20221017170308.1280537-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TIPC support has been introduced in 'iproute-master' (not -next) in
commit 5caf79a0 ("ss: Add support for TIPC socket diag in ss tool"), at
the same time a refactoring introducing filter_db_parse() was done, see
commit 67d5fd55 ("ss: Put filter DB parsing into a separate function")
from iproute2-next.

When the two commits got merged, the support for TIPC has been
apparently accidentally dropped.

This simply adds the missing entry for TIPC.

Fixes: 2c62a64d ("Merge branch 'iproute2-master' into iproute2-next")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 misc/ss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/misc/ss.c b/misc/ss.c
index bf891a58..ccfa9fa9 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -424,6 +424,7 @@ static int filter_db_parse(struct filter *f, const char *s)
 		ENTRY(packet_dgram, PACKET_DG_DB),
 		ENTRY(p_dgr, PACKET_DG_DB),	/* alias for packet_dgram */
 		ENTRY(netlink, NETLINK_DB),
+		ENTRY(tipc, TIPC_DB),
 		ENTRY(vsock, VSOCK_ST_DB, VSOCK_DG_DB),
 		ENTRY(vsock_stream, VSOCK_ST_DB),
 		ENTRY(v_str, VSOCK_ST_DB),	/* alias for vsock_stream */
-- 
2.37.2

