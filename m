Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A8F64B754
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiLMO2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbiLMO2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:28:44 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FCF1EC7A
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:28:42 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id h33so10517842pgm.9
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5bhVXCRoki5Re75spJ03V2VLrmMJ2Da66c5dnySjFvc=;
        b=QywvA6nlvn3op51gJIGhdn4hekABuLQ4//xScLCRUBdP8NbcdoosMLkwoq6KuFgpGU
         o0qiyRVrd34Y4CU3W6lifVjAyZsQk0/eUNmXkj/WlOAEXbYFMnFbJaKAAuTAYIitpqvj
         03vvo5eE80Q0qEET/CzlBisbf0NAWOkl7L7YUsYGFVSfAQw/Q21Q1VQDQ9z6EtoAQGn7
         TMglcho0bvXjzmZ5hgJ8Zwi6GDC6FH9ZSoxqnnTmgHuBHBmSUu55WmP18gRnSFMttP8T
         x2SyUjci0syQqWEj5t9Ndr7CWa/IMEz1VcehinFEja7XSsj1FQmygvnkrJQ1JWX+I4wk
         g5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5bhVXCRoki5Re75spJ03V2VLrmMJ2Da66c5dnySjFvc=;
        b=6QEj1sZCoNiFyqI245DI1uiSw1qBhUIKwj0jGl+DqHTxV8RLrFsltqEFS27SxGUydE
         Xu78ZFWenBmbXmBlk69h3K9I+SRqd1J0zzSWAeCFrr8/qDYGsfCysOtq3CuHvYMGfrd+
         9kZccFaHyVmUIBMxWmowlGjMUHpVfl5qIJfNwFTK4yJi3oxI+c829y5owevsd08kU5KA
         XLjVdI+cJuEO/qSv5/gLracmwhjuKUjngROaZHJnbdL6/xXSY5w6j6IlSe8lhHCPEkoV
         wSB3F7KtuOwVgP8SPNzKN951dOXsDvRdh7x4TnK8kT9PltDBE7Y11vk8CODkGQHmNFR3
         cPlQ==
X-Gm-Message-State: ANoB5pnignr5bcFU7/s6T9X37RwubDzUXaR0pGpxNV9a/N8ZGnES8TF8
        PvzgN1a0wBbca6l++UCU/L9ZOQ==
X-Google-Smtp-Source: AA0mqf71haV4LFeTPfguKUnmrmCBB4d9USvWtEpJKofzjwXvzdHGi/OMZ7zuEB0ZEKQbtN6H+IJSfw==
X-Received: by 2002:a05:6a00:1acc:b0:56b:ad3b:7f5b with SMTP id f12-20020a056a001acc00b0056bad3b7f5bmr27754447pfv.1.1670941721958;
        Tue, 13 Dec 2022 06:28:41 -0800 (PST)
Received: from localhost.localdomain ([165.132.118.52])
        by smtp.gmail.com with ESMTPSA id f67-20020a625146000000b0056be1581126sm8021902pfb.143.2022.12.13.06.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 06:28:41 -0800 (PST)
From:   Minsuk Kang <linuxlovemin@yonsei.ac.kr>
To:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr, Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Subject: [PATCH net v2] nfc: pn533: Clear nfc_target before being used
Date:   Tue, 13 Dec 2022 23:27:46 +0900
Message-Id: <20221213142746.108647-1-linuxlovemin@yonsei.ac.kr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a slab-out-of-bounds read that occurs in nla_put() called from
nfc_genl_send_target() when target->sensb_res_len, which is duplicated
from an nfc_target in pn533, is too large as the nfc_target is not
properly initialized and retains garbage values. Clear nfc_targets with
memset() before they are used.

Found by a modified version of syzkaller.

BUG: KASAN: slab-out-of-bounds in nla_put
Call Trace:
 memcpy
 nla_put
 nfc_genl_dump_targets
 genl_lock_dumpit
 netlink_dump
 __netlink_dump_start
 genl_family_rcv_msg_dumpit
 genl_rcv_msg
 netlink_rcv_skb
 genl_rcv
 netlink_unicast
 netlink_sendmsg
 sock_sendmsg
 ____sys_sendmsg
 ___sys_sendmsg
 __sys_sendmsg
 do_syscall_64

Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
---
v1->v2:
  Clear another nfc_target in pn533_in_dep_link_up_complete()
  Fix the commit message

 drivers/nfc/pn533/pn533.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index d9f6367b9993..f0cac1900552 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1295,6 +1295,8 @@ static int pn533_poll_dep_complete(struct pn533 *dev, void *arg,
 	if (IS_ERR(resp))
 		return PTR_ERR(resp);
 
+	memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 	rsp = (struct pn533_cmd_jump_dep_response *)resp->data;
 
 	rc = rsp->status & PN533_CMD_RET_MASK;
@@ -1926,6 +1928,8 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 
 		dev_dbg(dev->dev, "Creating new target\n");
 
+		memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 		nfc_target.supported_protocols = NFC_PROTO_NFC_DEP_MASK;
 		nfc_target.nfcid1_len = 10;
 		memcpy(nfc_target.nfcid1, rsp->nfcid3t, nfc_target.nfcid1_len);
-- 
2.25.1

