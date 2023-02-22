Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D86B69EBA7
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 01:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjBVAJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 19:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjBVAJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 19:09:28 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5956D2BF30
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 16:09:23 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z64-20020a636543000000b004fb4f0424f3so2448927pgb.14
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 16:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UL0yRbeKpZcUS7oK0Keg6M2sHdVnxq6xd5IYXope5uY=;
        b=nK8EhIa3on6tNIjcrLIcrc+52eoe1UNMPTBON95D+w8PUIMo0Y8J7N+EwAb5a+Nq2m
         zUuXEIK63sTwf9iAVYoWXIyQPQvwgpnDmNiMlYRWjtiKdWtNIYMWc78gayh0KdsZw9Ke
         z/j3T07SMoF1qWbhKRV2WJbkSuCuWIjsse9WsBFwz/5hdaImod85lG/N3L6Kqdf3omnC
         op6n+uexiIQuhqwrEB9jZZEg2jUcB2+aL3Uig8LQsv/Rjm6etP4j1YdxgVY/Hn4F9c6r
         IEAC8yomjq/DyciVjxvRaPaTSIAzT0LVWUO486m/KUIOh46qVNlyTCbmK3UQrhLjSQwY
         lM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UL0yRbeKpZcUS7oK0Keg6M2sHdVnxq6xd5IYXope5uY=;
        b=FFJaBlrt9DEs7MsJeOBn+wVIEdYDUAkzg/iKCYBJUKjVtOajiuVKmUtD7fVnKnXDCL
         567LAArLsxQ/Z218BjPgbtevVyczruJwd08I+2RhwMgF9GONFIus0I6hcJwDD4KHq1gM
         GMtI7UKnQt2WeHJyKeKCBVsrBW2UAe+d2sahdgl5hocyBAAUvCLJO+3y0AfSYNy/Z3N7
         N9xeEC0hwk0UrEwK0ocLgHt6oroMYkXZkV+q/Q632Cr+r3E1LNhVohxJlOjJMQQTg3YF
         T687u1P112LSASYjWt95lVQ/4AGRFVGYbMVpKHTM93KNhWDpT8GzATLyXWPVUWuD7ehZ
         AFVQ==
X-Gm-Message-State: AO0yUKUAFNk8OibSly1R07Ei5vwVQgL8/nUIx3RMpcJQZEPxwYNyYdWY
        HBpP3LOeyvrCWuCm8fDkLEjloPnJg7o7
X-Google-Smtp-Source: AK7set9uUrJFSUvsKgKPY2E5kYay1tfSQR7nxQxSfHMsjQJNToCgtmPwuLDiapTw9S5iadiMFd4jTr/vbUkb
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a63:3e41:0:b0:4df:6f34:48f8 with SMTP id
 l62-20020a633e41000000b004df6f3448f8mr874990pga.8.1677024562362; Tue, 21 Feb
 2023 16:09:22 -0800 (PST)
Date:   Tue, 21 Feb 2023 16:09:13 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230222000915.2843208-1-jiangzp@google.com>
Subject: [kernel PATCH v1 0/1] Clear workqueue to avoid use-after-free
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org, mmandlik@google.com,
        Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


After the hci_sync rework, cmd_sync_work was cleared when calling
hci_unregister_dev, but not when powering off the adapter.
Use-after-free errors happened because a work is still scheduled
when cmd is freed by __mgmt_power_off.

Changes in v1:
- Clear cmd_sync_work queue before clearing the mgmt cmd list

Zhengping Jiang (1):
  Bluetooth: hci_sync: clear workqueue before clear mgmt cmd

 net/bluetooth/hci_sync.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.39.2.637.g21b0678d19-goog

