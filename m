Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474366612E8
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 02:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbjAHBbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 20:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjAHBbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 20:31:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A2137266
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 17:31:01 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso5731787pjo.3
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 17:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gauNsz6s5kFu95ogUSHoB2HkvdwI2Yd7FgOC3hoCgaY=;
        b=d7jWKen1UBmJo4xKDMqEumwrLLmvakr7YusikAYbcgcpPa9q295WFntzAmuHeUN1VD
         3MID3tH/XlEQesAsft43vpTTBnvQneZz4iQbnKeFUeDpUqIfhyG3khwsXfHRV3dA2IvD
         5//lOkMbdGQPBHdJxupXrMiBje8XbtNe/sQ6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gauNsz6s5kFu95ogUSHoB2HkvdwI2Yd7FgOC3hoCgaY=;
        b=mGyMXXjwe5N/dH5n8TvVfBsnSm/wxO0d27UxV6AztE0KES4gZdvyY9daai3jucmAey
         7UGtKyArn/FFgeaTJMkMHXmzeALB6WayCsvLbMuNjzTNCq3FJMjgl2DiVVSOZ4wuDLKl
         K6Tk6L7bPB8OdM6fv2ygXireJZGxWWTaw7YpsVZzrHXC2tm6EsoMYfURQErOF5sZbQnW
         VpcXp1zPGIlTkkWIO1FGDPpLnDk/cHWMyMPJ/uV6+l1UKkYQ1D+2ef2jHNw+l4+/i/fh
         qh39yISHXpEgL3RMGmNGkoNO8AG/5HURiJkK0kfFjYNhIf5H5/lIjC5ro7I720ydG75q
         vkhA==
X-Gm-Message-State: AFqh2kp8/fg8hOJ3oCYqugjP1fpDmhguKSPwxal8AQV/DCWs/YqSe1KS
        FuirWt4/Ax+15CPjX6E6pbgB1w==
X-Google-Smtp-Source: AMrXdXvcEJL08ILiRjMh3tq2yXtYlomndnblK8Cn6RILuziDx19TkGZBoy724VK5Lx7/9OBtxUuz5A==
X-Received: by 2002:a05:6a20:3c8f:b0:a3:bdd3:8cb0 with SMTP id b15-20020a056a203c8f00b000a3bdd38cb0mr88573133pzj.56.1673141461188;
        Sat, 07 Jan 2023 17:31:01 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b005811c421e6csm3323714pfj.162.2023.01.07.17.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 17:31:00 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH v2 3/4] wifi: libertas: add new TLV type for WPS enrollee IE
Date:   Sat,  7 Jan 2023 17:30:15 -0800
Message-Id: <20230108013016.222494-4-doug@schmorgal.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230108013016.222494-1-doug@schmorgal.com>
References: <20230108013016.222494-1-doug@schmorgal.com>
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

Add a define for the TLV type that will be used to add WPS enrollee
information to probe requests.

Suggested-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Doug Brown <doug@schmorgal.com>
---
 drivers/net/wireless/marvell/libertas/types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/types.h b/drivers/net/wireless/marvell/libertas/types.h
index 398e3272e85f..39deb2b8bc82 100644
--- a/drivers/net/wireless/marvell/libertas/types.h
+++ b/drivers/net/wireless/marvell/libertas/types.h
@@ -93,6 +93,7 @@ union ieee_phy_param_set {
 #define TLV_TYPE_TSFTIMESTAMP	    (PROPRIETARY_TLV_BASE_ID + 19)
 #define TLV_TYPE_RSSI_HIGH          (PROPRIETARY_TLV_BASE_ID + 22)
 #define TLV_TYPE_SNR_HIGH           (PROPRIETARY_TLV_BASE_ID + 23)
+#define TLV_TYPE_WPS_ENROLLEE       (PROPRIETARY_TLV_BASE_ID + 27)
 #define TLV_TYPE_AUTH_TYPE          (PROPRIETARY_TLV_BASE_ID + 31)
 #define TLV_TYPE_MESH_ID            (PROPRIETARY_TLV_BASE_ID + 37)
 #define TLV_TYPE_OLD_MESH_ID        (PROPRIETARY_TLV_BASE_ID + 291)
-- 
2.34.1

