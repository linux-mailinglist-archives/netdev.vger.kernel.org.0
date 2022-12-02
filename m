Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B359641023
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiLBVoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbiLBVoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:44:18 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BBBEF897
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 13:44:17 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id w37so5419756pga.5
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 13:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3TlcMvyiugRHE5Un3yCASIxHYhR6LVV5Y+KI6j8Z1T0=;
        b=XVs59mQbP2h7EnLbN+vedMs/PV47A/jaXIlLX7ddlpm9VBPtoEDS9hVd0watpk/OfX
         rl+Mb39pMpDBA2SMBfZBKWiwlkTHvgYRTTWf9GxsTkU75vGz8hsiuGo2HDFJfYqzWw3l
         DhDVm9GzfgsauMxGu7P9PVJYDuTtdupqk0YkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3TlcMvyiugRHE5Un3yCASIxHYhR6LVV5Y+KI6j8Z1T0=;
        b=kuVesHirc6wvdYWf9tQ6aZ2SpfTvJxo0BlHoPqDs2fmkvMfj2p1bfa7eWXaFm6jUsv
         wkwg5d3FqguziVTS1jb2IsqnDg58eJ2xV4n2y4zkt6hqpcQKKcxtd2OlnXxDwP2OnsKq
         HUOR/WwSR7alhriMl51FYp+Efh2KMzwRt4D/RrzV4GsO2yunAouQNdfUNYBuqKW5i7Qo
         SH1BHdK9pQLvhHq88tXerbTZJM12hymY2U20KOnUQ/jHRAqdwPVeYpDsX8hdyAHfwQ6I
         RDcluvnnxJVgy0ozcas+l3QWjn0+M2MG4/HAOiqZGmttG+WovMOTASiS/d3KbPXZOri+
         xdMQ==
X-Gm-Message-State: ANoB5plPeDeAiivCe2zKpu4pXgfJpO/TbBJukZAfwlG+zzLeupYXcXeA
        wyMpcf6FAW8sWL4ZLUPoOoqVWg==
X-Google-Smtp-Source: AA0mqf7ZOGMMRaYLBOza1ULS6lopJC4lfMiEe4wjG+jiiUWAJkQM3HPvVM9A3P1Z5k4BO6QkRI0MoA==
X-Received: by 2002:a05:6a00:10cd:b0:567:546c:718b with SMTP id d13-20020a056a0010cd00b00567546c718bmr54124080pfu.17.1670017456817;
        Fri, 02 Dec 2022 13:44:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l11-20020a170903244b00b001896522a23bsm6079889pls.39.2022.12.02.13.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 13:44:16 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Kees Cook <keescook@chromium.org>,
        syzbot+210e196cef4711b65139@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Ilan Elias <ilane@ti.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] NFC: nci: Bounds check struct nfc_target arrays
Date:   Fri,  2 Dec 2022 13:44:14 -0800
Message-Id: <20221202214410.never.693-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2256; h=from:subject:message-id; bh=n38/3uuX4410R1aGCzc71edAU/gWj6X1zXWrsLo0q5E=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjinGuw9AiLTFgZ2UDY++dtaynqpFfMyigMIt160pK ee1aIJKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY4pxrgAKCRCJcvTf3G3AJsegD/ 9N+U73mJr9v0gHh/kToM/CJ+NIvX2uOd70w9qQx+80nvu6s8mAimVc/WqdKgKiGaHwI/MB7MeX3680 M3TTlhY0zPpxQmE1YqEinfwgJA/fPSEeLZTOOZTv//2I55qEQlCLeLhXgsDBjLugwkSAVuPVm42cN/ 7H7qHMJbWKQMtKCQq+m6DnWny0yJ0HVg/U/S4P/gm3yrmucn1lQVwgjPz/mBYlCZB4034RK/hB4uSM ezB89qAqeEYsr8VMUax8G9Fa7XpRqYEFP1631YQnAOGa1MarRDPj3D8CWYh3EGAeWSqgaBfJy5bGo4 n7p6K/f9kmhPj7nOmTkOvQQoybaoI+Du0SPz/EcyZ2T1CsvXDgN3Cf/fb8PnaQIjapBRoID9s/vbll 5jjtI/kD2gfRN6g1en+nLqsg1h5xBuvKxD/RqahO+7hjl4wsdVjqsKfllgP5T6lOvAElrWa81NEoUC msimSI7M5BeWLg8UWduhC5gzjWkqdqXqidvCNCYW0ZLFaEqReGgLlEJAlNW/ovQZ3fvFJtqZdZQmZ3 /zGoY12Jgtth1OHHrKhp8Zt9Mp/PDkuJdL8ng6eHYxwzC8epuC7EikoXcNja3br3WN8YC2vGOiERy0 eH5BIcNgglzTcTiGsBqRK4mqvOylDhDTmFz+hw+eST+SF2hu7PNVavvwTHkA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running under CONFIG_FORTIFY_SOURCE=y, syzkaller reported:

  memcpy: detected field-spanning write (size 129) of single field "target->sensf_res" at net/nfc/nci/ntf.c:260 (size 18)

This appears to be a legitimate lack of bounds checking in
nci_add_new_protocol(). Add the missing checks.

Reported-by: syzbot+210e196cef4711b65139@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/0000000000001c590f05ee7b3ff4@google.com
Fixes: 019c4fbaa790 ("NFC: Add NCI multiple targets support")
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/nfc/nci/ntf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 282c51051dcc..994a0a1efb58 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -240,6 +240,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sens_res = nfca_poll->sens_res;
 		target->sel_res = nfca_poll->sel_res;
 		target->nfcid1_len = nfca_poll->nfcid1_len;
+		if (target->nfcid1_len > ARRAY_SIZE(target->nfcid1))
+			return -EPROTO;
 		if (target->nfcid1_len > 0) {
 			memcpy(target->nfcid1, nfca_poll->nfcid1,
 			       target->nfcid1_len);
@@ -248,6 +250,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
 
 		target->sensb_res_len = nfcb_poll->sensb_res_len;
+		if (target->sensb_res_len > ARRAY_SIZE(target->sensb_res))
+			return -EPROTO;
 		if (target->sensb_res_len > 0) {
 			memcpy(target->sensb_res, nfcb_poll->sensb_res,
 			       target->sensb_res_len);
@@ -256,6 +260,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
 
 		target->sensf_res_len = nfcf_poll->sensf_res_len;
+		if (target->sensf_res_len > ARRAY_SIZE(target->sensf_res))
+			return -EPROTO;
 		if (target->sensf_res_len > 0) {
 			memcpy(target->sensf_res, nfcf_poll->sensf_res,
 			       target->sensf_res_len);
-- 
2.34.1

