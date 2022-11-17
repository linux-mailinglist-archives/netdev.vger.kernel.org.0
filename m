Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475B862D6C4
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbiKQJ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240057AbiKQJ0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:26:54 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47F7635F
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:26:43 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-373582569edso14159307b3.2
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DshYkYOEBtMMfkL1bLgUQC2c2Rhoe0BBsfF39A6p1Zo=;
        b=q21z9LfTEliq048CMqwXjq+x4SwA+GmUUo5K5KcL45Atb9g5FvbRyJddK0r1DuwTKm
         pq7F1CU5xKnbx+CmC+dI+a31EddEt06bi9kuuP3HFFTEQdM0G3q/H8KCLiCq8m+2sb/b
         ehFGmkhbzJVkgmkF7AWcJ5F5V8N4vIr4/KWU+J8CFD/s7Hrh16Hz1Fh22u9xc4G5K4Hy
         SGEiMA0QXJ4g+PMS/puWQeR7GFPZWEL5I7agFFI5wCm2Bd8rJ4nzqvllO1TW0W18Dg9S
         0u6glwA5PTOei769Lb/lohmYSwujKAxQuPKgculJjBoksi7nCPNQT2e1R+9eznq1R0sn
         RgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DshYkYOEBtMMfkL1bLgUQC2c2Rhoe0BBsfF39A6p1Zo=;
        b=axW00Tsvr1mVifXwKwV5A5M6S1QATEFu+2jfQN/QcKkSvvKgI2Txz7v5VubKbrBHRM
         LzF8AwNHGZQaewdNE2pHL+AmlK1TliBt7R3hzewQ/ci4HpZXsLY6bACibTma6m9B7+/C
         6o8MPOayV+mA90V4TspfaV8Qa+5tDVKYNY9/uTAJV9Y2tXygfrYhOHwXZMUVUQl1qlQa
         iPjh8UJFT7UIyeShNoJ687GLuvWNc2XtEkVyxphydHOmtbe7fkYFsk75FFRkExof7yyi
         HlOWMi+Qzpj4W7s3eWIqMrFoleVDeyD3vD1nTAesp2uA0NlXLu8zWk8Yr90McKDfNWBP
         Ac+w==
X-Gm-Message-State: ANoB5pm+TEGl50E7Cdo4Mc52oT/jfmSC6gXBsgvinM5K9ppi1Z9qU+T6
        XScNUffMBCQMiUvLbiMgPFyuNOhgkXTFjA==
X-Google-Smtp-Source: AA0mqf6k7EN/AVyFBLV2UnEog0fsXQ2IuSz5aJ52d0EiNkwjHm9tf/ZY0xyxUep8ebUmmQ2dndndaTBn7mZkaw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:e80f:0:b0:6df:927f:38c9 with SMTP id
 k15-20020a25e80f000000b006df927f38c9mr1302451ybd.92.1668677203180; Thu, 17
 Nov 2022 01:26:43 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:26:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117092641.3319176-1-edumazet@google.com>
Subject: [PATCH net-next] net: fix napi_disable() logic error
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan reported a new warning after my recent patch:

New smatch warnings:
net/core/dev.c:6409 napi_disable() error: uninitialized symbol 'new'.

Indeed, we must first wait for STATE_SCHED and STATE_NPSVC to be cleared,
to make sure @new variable has been initialized properly.

Fixes: 4ffa1d1c6842 ("net: adopt try_cmpxchg() in napi_{enable|disable}()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d0fb4af9a12611c7f82798a700205604730e4d10..7627c475d991bfeb7138e0868d423e654d46f036 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6399,9 +6399,9 @@ void napi_disable(struct napi_struct *n)
 
 	val = READ_ONCE(n->state);
 	do {
-		if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
+		while (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
 			usleep_range(20, 200);
-			continue;
+			val = READ_ONCE(n->state);
 		}
 
 		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
-- 
2.38.1.431.g37b22c650d-goog

