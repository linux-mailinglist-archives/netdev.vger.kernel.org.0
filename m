Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF94CEA1A
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 09:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbiCFI63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 03:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiCFI62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 03:58:28 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA4E1276F
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 00:57:37 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y2so11372526edc.2
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 00:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4tpRDlVpoM3YR6pw/CRsfFETA4WrdcR4DFtWFWhIyko=;
        b=qf82AtZNyc5+PaP+vKwFH2u0eaA1DB7aenGFLEoGm+Qfdch859M+3BLLpv92S3/Of5
         1TVh/fbkvPVh1NSOaYG/7PYYk+MHMA6lhe0b/YkkK6v4lDYh4JYXRUB89FFYlm6ds5rz
         tEowu6XPEby9FpSTter5InYNlEOPf64WaUrV7/W74OCRr6M4eMWkGtuncMsqEcR6coUt
         69msjkK4z/UOWWOGBJxCHQr52dVn2mXF19lquUxYNyE2qJyu56t0hToqyfAcPnFcj8VB
         FsN2WZpYHw8NgXx4CbJIEnxcze3S9hwH+mcWCsg1rfBNqc229m8+vH3A5lBP0N/uR6zF
         5Eaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4tpRDlVpoM3YR6pw/CRsfFETA4WrdcR4DFtWFWhIyko=;
        b=tCEaJlh6N23qMrEwz49/HAAbUCPRUeTf73nv4Yp6K4V2unMF+SK0/Ie36GkuTO1Wnv
         V0yeuxkGz0ccfZdZM21z/GPym+cliE6GXrUn8gMNLWu3IRTYarRFA89spwKZdKsDLxHq
         HeYLM/zeurBzcT6LlVjLcRXAllsLNDbkufqOlHcL/Q4RGK0+WXwU2WKqfUZnPGkfV/iT
         /rJDDSeCAMk2xoff6MfDo+ZvL2/gd/EYisci16nD+LmdGw4d4Eq0+mC+JcQDf1uQJe26
         QCTN8EUFEd6QfEGCZIKrSNsGtDyW0u5FDoCiFndBBysV9U+0il640H1rKVqlCUxCwqpH
         Z5Nw==
X-Gm-Message-State: AOAM533liNz9o4fv4WH0bgraef9h0gNclmzbp8BHWpfSXK0iG5yLFkqk
        ZGuEbyeBcnIOuYeAyV0pRYDOIA==
X-Google-Smtp-Source: ABdhPJyVFpGCc30KTKxZXHEIKBTFpmHvD+qieWtZO6ZknZHSlAjFSGtgHwfN+M8Qb/vKLlJEi+oNpg==
X-Received: by 2002:aa7:d403:0:b0:40f:739c:cbae with SMTP id z3-20020aa7d403000000b0040f739ccbaemr5978606edq.267.1646557055916;
        Sun, 06 Mar 2022 00:57:35 -0800 (PST)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z24-20020a170906815800b006dab4bd985dsm2663423ejw.107.2022.03.06.00.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 00:57:35 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [RFC PATCH net-next 1/6] bpf: Access hwtstamp field of hwtstamps directly
Date:   Sun,  6 Mar 2022 09:56:53 +0100
Message-Id: <20220306085658.1943-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
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

skb_shared_hwtstamps contains only the field hwtstamp. That property is
hard-coded and checked during build in BPF. bpf_target_off() gets the
whole structure as argument (hwtstamps) instead of the actually accessed
field hwtstamp.

Access hwtstamp field directly and allow future extensions of
skb_shared_hwtstamps.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 net/core/filter.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 88767f7da150..09e202b60060 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9364,13 +9364,12 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		break;
 	case offsetof(struct __sk_buff, hwtstamp):
 		BUILD_BUG_ON(sizeof_field(struct skb_shared_hwtstamps, hwtstamp) != 8);
-		BUILD_BUG_ON(offsetof(struct skb_shared_hwtstamps, hwtstamp) != 0);
 
 		insn = bpf_convert_shinfo_access(si, insn);
 		*insn++ = BPF_LDX_MEM(BPF_DW,
 				      si->dst_reg, si->dst_reg,
 				      bpf_target_off(struct skb_shared_info,
-						     hwtstamps, 8,
+						     hwtstamps.hwtstamp, 8,
 						     target_size));
 		break;
 	}
-- 
2.20.1

