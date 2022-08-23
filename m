Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D343F59D025
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 06:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbiHWEom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 00:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiHWEoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 00:44:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD43E52DED
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 21:44:38 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c3-20020a17090a8d0300b001fb287cc2e3so3215618pjo.6
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 21:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=lUCov81UkiL3yx2Zk6OCNHheGGSC+JEtAVpS5cfgjxg=;
        b=VQQRSuwFAryakFZN7o3XBnaC86NJb8BJN0kRwrV1UIIXqU6A4bnuxTOScxrfAYh32h
         AFsHq3EqIR/7SXFP72lFWxUyEZczBThvbRXWGVEegkJk2vJM6nV72YXBmf1+lxt/IGvP
         yXHwxpKfsThjjhWZzQI8//FWRXgDqOU4sUnkrhBRsXHHnzbZnB/tLEREshRyt8/D0K1I
         3K9o2H+mau3uY9LNULYduQ3LmFi8GnYNe9PwfLPaMjcivIR+H6Df56RSEu4sVvSlr/Gi
         lp3ApSG31oiReNNTdWxh1fI/2LArEf/6HjkzgcakX6PVq9Qzl1VXfuYHcq3FTJ+tRX8k
         k2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=lUCov81UkiL3yx2Zk6OCNHheGGSC+JEtAVpS5cfgjxg=;
        b=SSDcCl4qELdbFLm6e4en2KMxKGp4ZSX68aTvDKSs8pWJHFMdCkvSGlf7Vlc1WjqL13
         G1cuDCx+87GMIRkJ6JYeVGnNqBDJ4LnJ6Ke559G+jUf0AaZdEVn2RiuE2EwKktJ4L/Ra
         vWK4fv1CExpPs2zgN7qMJS2bnjIQDZhLmo+kdhqIxLROM7LFguo3/H+VTx4GiHYVldbd
         Gj0rZLnBOEvja+jm0MbM+BcU3hf+/z1oZw8oh4IpKN/GFRQ9Yq/0ND7g0zfMLjt2YSOv
         KcIscGOCYGN4zUL0HuY3s4IX+ZE5U9uNV9v1tOTDPERak/JbUJrSmpGdHM3t2JMxE2U3
         9BuQ==
X-Gm-Message-State: ACgBeo1U2Sk0Jjexa277MCdGFbIq4CNH8SsjbJyAoKYzVtoEpCKIb+iQ
        crGgn2my0upd9ZTv5DKvhjoxWEZjreQN
X-Google-Smtp-Source: AA6agR7/lhkKKG625n3CGJmIMAJbr4gWG/sOy8pBi23P52QZoLOqIdbElGQtnBsHGCnel8Lni/KVxBZY9r4L
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a17:90b:a14:b0:1fa:bc6e:e5e8 with SMTP id
 gg20-20020a17090b0a1400b001fabc6ee5e8mr125775pjb.1.1661229877885; Mon, 22 Aug
 2022 21:44:37 -0700 (PDT)
Date:   Mon, 22 Aug 2022 21:44:33 -0700
Message-Id: <20220823044434.3402413-1-jiangzp@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [kernel PATCH v2 0/1] Bluetooth: hci_sync: hold hdev->lock when
 cleanup hci_conn
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hold hdev->lock for hci_conn_failed. There are possible race conditions
which may cause kernel crash.

Changes in v2:
- Update commit message

Changes in v1:
- Hold hdev->lock for hci_conn_failed

Zhengping Jiang (1):
  Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn

 net/bluetooth/hci_sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

