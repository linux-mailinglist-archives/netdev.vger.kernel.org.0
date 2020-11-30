Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB95F2C7C17
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgK3AWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgK3AWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:22:36 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76838C0613D2
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:50 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id x15so5497899pll.2
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tSQCaHe9eHAYQ8w7aCqFlbQul1fr8oCPecfQJAvAlxU=;
        b=iJz8meKPna7wJxCP5NIKE7tAyyXNq3bykaNzq2fFmlVlih1DfupvGcMvBVci3aJV74
         OHCnNZeae1sARqJuM+GNq7tLpUGwtZu2er0s9Wnb5agof3izImPkhHIWv9timdtZw+vJ
         FknUkp2++FLxpDZ0VQ3OnUWMQyppItrOsOlQRuJtUDpor2kGo5WH60lXfWskBRTfBnG+
         F7wkSm+6/SSJaFHBo2OK+DEemBaKabeSrrfPlLMvMCp6YIAjbsQ2olG2T9043s4HddH3
         fXsl/m+3fvLKoD+PY3uqMJiZoVHlrAaRYlX/mjRwDa7AijbHuK8ZLWWPPZKkppfU5+zj
         sy6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tSQCaHe9eHAYQ8w7aCqFlbQul1fr8oCPecfQJAvAlxU=;
        b=O/2hLue7LqCDjXc4wdxPq0yZQNtzf+bvrVIrXntkHgpZiEXE2YYTyE1dqAz1Pup24o
         rAvwL3/CwSAeIcmPbfDWcgjRqwlpyKTE+kfHZLjR42Cy7VLKRGuEIFYy1DrLqxY8/xeK
         FpQj4onBBpEl1joA5CQ4xmWpigZWBf7X+X89WwuhpopylCrsf+aDkbNvPB1Y/sNeQYsq
         Lwcs4Q80T7n7ECxc2CUP5A95l/J75Gep0foWwwMBcKrytexClcwmpRYNyi9FRiUAO2E1
         Pd4wlJJyzdKiBQG2W+UA440SPPXET70FDqcmYHl9KICyIGifyOdphj03JGUCaE9qHesv
         Hs3w==
X-Gm-Message-State: AOAM531bBk6O8uxF7EOM7JwYl8ygkrYy2izgcEtnL33B2ddnCrswdBNP
        fEOaYQGt5iZ+dCU1WAAoFOIEh/Hdl8ep9a9X
X-Google-Smtp-Source: ABdhPJzH00LHTn//hPtaXRYXjy7Q4gros1gHEWSqOjnyHGB0DTQxXMVZ/sh7OlEoEp5TltGo3cvjKQ==
X-Received: by 2002:a17:902:c104:b029:da:5206:8b9b with SMTP id 4-20020a170902c104b02900da52068b9bmr11106990pli.46.1606695709630;
        Sun, 29 Nov 2020 16:21:49 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d3sm20746129pji.26.2020.11.29.16.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 16:21:48 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        shalomt@mellanox.com
Subject: [PATCH 1/5] devlink: fix uninitialized warning
Date:   Sun, 29 Nov 2020 16:21:31 -0800
Message-Id: <20201130002135.6537-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130002135.6537-1-stephen@networkplumber.org>
References: <20201130002135.6537-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC-10 complains about uninitialized variable.

devlink.c: In function ‘cmd_dev’:
devlink.c:2803:12: warning: ‘val_u32’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 2803 |    val_u16 = val_u32;
      |    ~~~~~~~~^~~~~~~~~
devlink.c:2747:11: note: ‘val_u32’ was declared here
 2747 |  uint32_t val_u32;
      |           ^~~~~~~

This is a false positive because it can't figure out the control flow
when the parse returns error.

Fixes: 2557dca2b028 ("devlink: Add string to uint{8,16,32} conversion for generic parameters")
Cc: shalomt@mellanox.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 devlink/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 1ff865bc5c22..ca99732efd00 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2744,7 +2744,7 @@ static int cmd_dev_param_set(struct dl *dl)
 	struct param_ctx ctx = {};
 	struct nlmsghdr *nlh;
 	bool conv_exists;
-	uint32_t val_u32;
+	uint32_t val_u32 = 0;
 	uint16_t val_u16;
 	uint8_t val_u8;
 	bool val_bool;
-- 
2.29.2

