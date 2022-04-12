Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11A4FE2AD
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiDLN3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356712AbiDLN2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:05 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563984CD79
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:11 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id p15so37305086ejc.7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uUhhwavoelOAutf6ZINYv5+4TG3VETWVUGFixQHcuak=;
        b=tLBOr9wUBkhPXAsBErczu7jI2Hf9tNdIWN6672jBjWl09l6oei62gKrRcjRCmtpBdO
         QYiUTa+9xRSvvG8KLnpbFIBIDKVHeHpmgD9+0dHxFCZtzs5AoXBWJKpcXFs4NHQI/ZyO
         JY0AZHS/d6lNQC1igzWeSohKzeYh4+mSSg6NKx2SZgSnSBJYAI1iGGBoxcPeUlYwDHNM
         zTqI4igELqHbQ15BCq0qGXaKwu1T1UlxIutjyWeatLZSEJW+Pf0evVabkYV+lJQ0J1fA
         LVBHw38hevuwNm3GPP5vgrhCJlMnCfVbwLCekONEpzMRrw6JPLeu17PiEGMxOPtrrGF0
         udFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uUhhwavoelOAutf6ZINYv5+4TG3VETWVUGFixQHcuak=;
        b=0I43LskB1bkBacVhk7lWxQAuPakYHT8olLuAj3Ap3hHwQT/VqNJ0LDaI4yhTtrEkkW
         EVj3alRS4wGdGRLu8k8Ttf622AMDqglBEnkcs/utsOq+TBBX9EsCJBgNU7s6fX0kgWqz
         nXJrSc/tY7mDV53Sur7Shzrnlv3LHxbtRKvtAjKVR40qCj3TpjA9rDWiauaj0z7sDywS
         iGAo6mVn4HhbKswUmf6q8vYx3B0PWSj9RKqH1kZ5dO6E0mywpt79F7/ZkT9BIadtRN6L
         GHlTrya5DNhH946xQKv5jz2vgGtkXu+zOnOkAOlBAums49+D2YHM73tXWbv1n9bxaO61
         sFWw==
X-Gm-Message-State: AOAM533R4LTj8ujzSJKusC3iHGa6+MP7BHbVCc54hOzepyFFrxCuDQEw
        4x0XoDRnMkcpNCK75SHufxWDj3kNr6GkpcwG
X-Google-Smtp-Source: ABdhPJxqGZgcn+OKL/uY1gOsVDHVyOtHRA3JfORbCy0PEaxBIutufAWEsMK8sV0BmV2FQIYFhylzBg==
X-Received: by 2002:a17:906:c1d7:b0:6e8:4f18:fede with SMTP id bw23-20020a170906c1d700b006e84f18fedemr19124588ejb.95.1649769789466;
        Tue, 12 Apr 2022 06:23:09 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:09 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 1/8] net: netlink: add NLM_F_BULK delete request modifier
Date:   Tue, 12 Apr 2022 16:22:38 +0300
Message-Id: <20220412132245.2148794-2-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
References: <20220412132245.2148794-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new delete request modifier called NLM_F_BULK which, when
supported, would cause the request to delete multiple objects. The flag
is a convenient way to signal that a multiple delete operation is
requested which can be gradually added to different delete requests. In
order to make sure older kernels will error out if the operation is not
supported instead of doing something unintended we have to break a
required condition when implementing support for this flag, f.e. for
neighbors we will omit the mandatory mac address attribute.
Initially it will be used to add flush with filtering support for bridge
fdbs, but it also opens the door to add similar support to others.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/netlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 4c0cde075c27..855dffb4c1c3 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -72,6 +72,7 @@ struct nlmsghdr {
 
 /* Modifiers to DELETE request */
 #define NLM_F_NONREC	0x100	/* Do not delete recursively	*/
+#define NLM_F_BULK	0x200	/* Delete multiple objects	*/
 
 /* Flags for ACK message */
 #define NLM_F_CAPPED	0x100	/* request was capped */
-- 
2.35.1

