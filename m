Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1903B63317F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiKVAnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKVAnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:43:19 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E5615731
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:43:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id o142-20020a257394000000b006eae582c285so5514533ybc.12
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2bE/mLf+nOfHNFsCRZfaf2kiP5Cm8eykOLtuGJbYlh0=;
        b=VrSLxV7EkHpcYSf6Edz3Re+WhH6H84625hnQfMmK/dgBTtAt8rpuAgDOYS91VKrs9o
         w+7S8vHb5fDZYKq1Tyc8GAk3IS3ehyR5vGUIFy48bo0+evzNkk+iUhjWIc0VRm/xlvs3
         W5an8UABS+Q76k3fYSdWJsRXK04dg1tC3aQ4MutrL9B80OgeRXQKIAe2W+rCpZyU09Qy
         B6ko3IamgQR0R3yYjP4tdNhqTwRh8NyqurM35tRrojnCd2HYkicQ+HS4Z7n3rCyne7Wc
         a+Ck20lisdp6UkMbSsnlKsY0q4uQ+UxV0HBo62sCTmH8EFnhAuHAoRksmkRJ6f5Jujzg
         Mslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2bE/mLf+nOfHNFsCRZfaf2kiP5Cm8eykOLtuGJbYlh0=;
        b=uY+P+6urW//anHIu26zJhIHD6D2ry8PCvHFT9+SbopiAQwikR5YYGkerrsMsx2Nwdq
         4HBMhyifbDISn7ytmNspYP4JyMSJX5RulHhJYgEAhvgtNkJmVjeKkAZ3BxpFU2kDOAu7
         Z6ML+Bqm0Gc2ZsG+lMO2EKK7UdWM4zPMzqN6enRR26lOCMbR+9viVWPbHjeZMy5lb3uU
         9Uwe8L9oHg3L5r8Kf0uG8AY3vCMRzPNeJou2HA420Tw8ftECoEcZskDfTRK6Nt9SvkiP
         /AEg/pZJN0OKHubYrAVkGnXetxuzymOB1Y/68/7+Wy65AK18gBheq8FTWIXmQBvcoGCv
         Fh1A==
X-Gm-Message-State: ANoB5plnUh4rEy9gzgWMKdcTqJd2FvBaubePqoWS8NFVDgN5l+sz8Om3
        RM8KCpWRdb7NgA47278rwDXqDsmxLxgTqao=
X-Google-Smtp-Source: AA0mqf42Oy2vLfPUsDneaNnyWBeX+zdd7smD7l9V6NHuDrrJ4MFBYK+vGZLvJdN7GW72O+iNXbRIcwFZnW0RTkk=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a25:2555:0:b0:6de:4963:9673 with SMTP id
 l82-20020a252555000000b006de49639673mr559629ybl.507.1669077791994; Mon, 21
 Nov 2022 16:43:11 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:42:43 -0600
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122004246.4186422-1-mfaltesek@google.com>
Subject: [PATCH net v2 0/3] nfc: st-nci: Restructure validating logic in EVT_TRANSACTION
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

st-nci has nearly identical code to that of st21nfca for EVT_TRANSACTION, except
that there are two extra validation checks that are not present in the st-nci
code. The 3/3 patch as coded for st21nfca pulls those checks in, bringing both
drivers into parity.

V1 -> V2:
  - patchwork bot: fix most the warnings exceeding 80 columns, except the
		   table in the comments. Able to reduce the table
		   width only partially to prevent clarity loss.
  - Guenter's comment: remove unnecessary parenthesis.

Martin Faltesek (3):
  nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
  nfc: st-nci: fix memory leaks in EVT_TRANSACTION
  nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION

 drivers/nfc/st-nci/se.c | 49 ++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 13 deletions(-)


base-commit: 2360f9b8c4e81d242d4cbf99d630a2fffa681fab
-- 
2.38.1.584.g0f3c55d4c2-goog

