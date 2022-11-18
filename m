Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4DE62FFAC
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiKRWEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiKRWE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:04:27 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC09D725D7
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:04:25 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id y5-20020a056602120500b006cf628c14ddso3288397iot.15
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Th6gFfrMHggSNhHkQoasdFGOI7fW1QieEyayq4qUQ5M=;
        b=Sw6xyRaisT1MXICUaXZHhvsetsa/SvCy7qLE5PklKIAXUHqivYkop9rNdsLUWSselv
         i1RhI3hk/x9kZC8xku95kjr6tfE8UNjOBcUABoJ1xhUSyaKO1MgshVS9TQLdD9TkrXNh
         3dZuMVi367J6dHPB1Srx4reR254nFJ/AFpXBLs3aCkdcoIlafBpCOEeRKhDOZTvffCEv
         5WNZr6YWhmyGuK96E5iUSeWPGPFkhXF9iArH+uGjYMJZKu8Gzz4dyiRmsfecTBIDkPZO
         qeUgcUxlBtO5ppGSI7UAKDW21F3zP9jwgGKKgJ98Q/HrlGKdrDkzQW9tYi4mXU7GBq+g
         yOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Th6gFfrMHggSNhHkQoasdFGOI7fW1QieEyayq4qUQ5M=;
        b=gsal3Ep8scHUTG3udgsUIa30wyzHgUFbtdDfh6QmG1IcCOTrfNKa/VdLniWmOPAYRR
         EtkHfStkel7lB1/h1vAh3O5ygw8FQAj67lp8iSUTK+2+Am6tia2CA0s/nXdaVjUUCNiO
         3Sf545zyDkGQshMMcoejxaAwmcijtxspyNvxqlP2KkFSMi43WiZ5M8Yba4S/eRLO+MaL
         LbhATMFS/fvOQiQQnAHF28V/ODN6zpnv+r6xtZjzpkG4SwsowQJ34g8/oKBMOw/WmMn/
         6okYUh3GfOrFlZKhyfQxEobRDvfCX1RXtWCTVYiuBhmrrFS/MraxBqG+qlHquCnj7FDK
         dbiw==
X-Gm-Message-State: ANoB5pnZn1NCd98UtDnPdPDhRCnOvrulp+1JZj19MxenlZVDQY1Q14RX
        7ibkux/5ndc3bOm/D/sZSdKgcJOpcgys0y0=
X-Google-Smtp-Source: AA0mqf7xQjCF5Iu3XHRADBrM7Pmc1N0rfvqQIAHMXTfKeBYHKdO+5zlDHsAWau09PrkMibNTr5eu9+39U8cVCU8=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6e02:4a3:b0:2fa:b811:ed3b with SMTP
 id e3-20020a056e0204a300b002fab811ed3bmr4036387ils.288.1668809065370; Fri, 18
 Nov 2022 14:04:25 -0800 (PST)
Date:   Fri, 18 Nov 2022 16:04:20 -0600
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221118220423.4038455-1-mfaltesek@google.com>
Subject: [PATCH net 0/3] nfc: st-nci: Restructure validating logic in EVT_TRANSACTION
From:   Martin Faltesek <mfaltesek@google.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, linux-nfc@lists.01.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net
Cc:     martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        mfaltesek@google.com, sameo@linux.intel.com,
        theflamefire89@gmail.com, duoming@zju.edu.cn
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

These are the same 3 patches that were applied in st21nfca here:
https://lore.kernel.org/netdev/20220607025729.1673212-1-mfaltesek@google.com
with a couple minor differences.

st-nci has nearly identical code to that of st21nfca for EVT_TRANSACTION, except that there
are two extra validation checks that are not present in the st-nci code. The 3/3 patch as coded
for st21nfca pulls those checks in, bringing both drivers into parity.

Martin Faltesek (3):
  nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
  nfc: st-nci: fix memory leaks in EVT_TRANSACTION
  nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION

 drivers/nfc/st-nci/se.c | 45 +++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 13 deletions(-)


base-commit: 2360f9b8c4e81d242d4cbf99d630a2fffa681fab
-- 
2.38.1.584.g0f3c55d4c2-goog

