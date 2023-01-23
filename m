Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30156774F3
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 06:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjAWFcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 00:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjAWFb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 00:31:57 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23698EC7B
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 21:31:57 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d3so10333515plr.10
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 21:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWC1KMyV1A6Rl/COql8OC8fu95Avmd8JBknQzjt01sI=;
        b=Zf/NDMEwvDxlPca3OM3Bm9bWcAeHNm9tS4PI2VKNDzm/pxcYYTLfLQM8A3HFvzwvM5
         gkBMQkSHGAwcIsVvaQPaJvEpSS0hok9QhRgy/gGOywslUMfjbTfP7kPNiZNwmHrFPIuk
         NxZDOEx7ySl0Ed1NqnAVdO+07VrDoZqPMKApA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GWC1KMyV1A6Rl/COql8OC8fu95Avmd8JBknQzjt01sI=;
        b=Ptx8QxNJ7xDR9H0xeE0pVOwESYOnh5/nvwwAUq1QdbJ96T1G1UXLlK5A0FEOp9Si4P
         RBDUP/FfebVDds979OIP+4ksNXljevSiNzWTzHRNuBiVzvK3ljFkwuIEtoPbX2dzdDGu
         AX8fI8ZVphbVDEGCZ6rGdIoKTdVhCNdCk/zCksM4pt0FBWNiHQo2EgjaeD3jUbcbAR0y
         H+tbgx21PMn6lsvV90RqKSx1fD9ZkoXiGsZREM24BYTb8Li94DA5zlQYZvbW7/Vk/NcW
         T+0GaHdmt1T79+sOCWEvUsTLYN5Qp7cj3/5qf+Bq9E8rd3oXOUaAplh/buNI0wZHzwWp
         qq0A==
X-Gm-Message-State: AFqh2koumzcraw3pZNFmqi9woZmcv+VZ7IteVpex6zYqHnw/i3JSqL8E
        U3TSVIPsMMwmUoZ4AFOLaiBmbg==
X-Google-Smtp-Source: AMrXdXuSnQEOljzY6lLfs+YGvp3fwfttCOozHsP9CcvWI1/0DsVhUuMOFjvhBsEacS82f57FARAOSA==
X-Received: by 2002:a17:902:7fc2:b0:194:7ae9:c704 with SMTP id t2-20020a1709027fc200b001947ae9c704mr20251416plb.36.1674451916492;
        Sun, 22 Jan 2023 21:31:56 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id m3-20020a170902db0300b0018963b8e131sm9125244plx.290.2023.01.22.21.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 21:31:56 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dan Williams <dcbw@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH v4 3/4] wifi: libertas: add new TLV type for WPS enrollee IE
Date:   Sun, 22 Jan 2023 21:31:31 -0800
Message-Id: <20230123053132.30710-4-doug@schmorgal.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230123053132.30710-1-doug@schmorgal.com>
References: <20230123053132.30710-1-doug@schmorgal.com>
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
index de60becaac12..bad38d312d0d 100644
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

