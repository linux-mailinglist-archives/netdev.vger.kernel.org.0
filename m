Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A6659EBB7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiHWTBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiHWTAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:00:38 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F10118476
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:31:35 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 15-20020a63020f000000b0041b578f43f9so6433741pgc.11
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=I6bMwOogiDnVs957h7gTrEm/KH2DteHWZdYaUy0awII=;
        b=rdInFjbHwlhVn7+i3nZ6Y12p5lXLrwsbNkPcgncgA7HvITdYAiDyEnC0kjbOnjkXUP
         pLYZLdPOWUr0/n6ojM5/Qe4akp/Jf0brbN4tkyI45ztB6F9OfRyuTKzqQs2ffQIBi/VN
         iHtv0YzIQfsPSgNSpagswtPxKHOJA9+n8O+QNjB0mW1MI3WczSUVwrqvKzwaD1OmxuC5
         iOBqYqnIz0BsYXRiy0bICYqW4ntgny9Vm1a648eDXS3+IfghTn9ERmUKQ+h9fE85E3Hb
         1OA6joKJtlg/9fI1evThuF8fJehMmbskQrbfvXsqlnAYh1paxIgCQ73PDpqE1/VNfmLF
         hBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=I6bMwOogiDnVs957h7gTrEm/KH2DteHWZdYaUy0awII=;
        b=yRiCevWIOl2PwhaJ3xDoEXW+w1oiOi3iPXp09dsADKTOHVKMZtgGXldrxumXH/OhyC
         ISfNYefTz69ebZJ6sSlU98P9tXt6HMZ0EJvl9XBseldvdgtXNXAOvKjeCo1j7pdh8W3g
         TV51IPa3DtSERwW9KKfFGOuh7LgFzWhZ5DsGFBeAlbJf5F1E53MNtp6Wk8eqmDeUjtmn
         AKICzfraHTLrnZATkhaeDGqlRqHS7G/JdOv1+K8ItapHo3TSyWdgtVKPMG0Qa6llFTDU
         3LFLayejffuAocVY2ss5tMWokRmuv9LcCPeqtMS9UqIZUdun8iFCoq+Efu4hp8owsNuO
         wsng==
X-Gm-Message-State: ACgBeo2DOODcSellyBo8t7XFfEgQPmLKJJqq1OUulPylqO6I2gO6PfLE
        0EQ9seUGcvUARaJ+SMt/6lF3nTWNSF26
X-Google-Smtp-Source: AA6agR60ZyeTBw6tZHFNcbprgIuARloWgtV1XU8puB3UATvbmBX359d3oKeDBQw+t5yfz66Q9bup5ekspmsR
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a62:55c3:0:b0:536:729:71d8 with SMTP id
 j186-20020a6255c3000000b00536072971d8mr22486752pfb.53.1661275692394; Tue, 23
 Aug 2022 10:28:12 -0700 (PDT)
Date:   Tue, 23 Aug 2022 10:28:07 -0700
Message-Id: <20220823172808.3477638-1-jiangzp@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [kernel PATCH v3 0/1] Bluetooth: hci_sync: hold hdev->lock when
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

Changes in v3:
- Remove an empty line in commit message between Fixes and SoB

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

