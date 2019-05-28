Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BC62CEEB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfE1Srt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:47:49 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:37102 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfE1Srt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:47:49 -0400
Received: by mail-pg1-f175.google.com with SMTP id n27so11514403pgm.4
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bfW8Ch56pKuDc8FWEN4QlfkBm/dSo1h6NKmQey0jCc=;
        b=jV0qtqClV+CIN3KOkLYBkzI9rMBcjTrsy/0vRYBS3jhh+NRr0EY776/hFDTGefQpz0
         LhUZHv6d88/Y3YbLKj8Zs3D2msWXrFKqtpJ01EuQeYYMJWonW25I5LuBe/mcXlUlVhB3
         z4aOK8ZrQN0ufqDuanfIt41BwTarc+i6LLEeiLuOedA3uLZBWFXnwcXyZzlZLjrJrffa
         PtIeSVTFDsx75hEUGbEWKeySoULmRJ5MHIVauy488yYxsm5FTccQU7PQdV2VjXlyzlGH
         WUDxc6BJuB8Y/ItrCzG6xmRMl0BUsIouT4XSz50KIyW9vrUvZfdcAbmZx7NwDrteo0f5
         agyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bfW8Ch56pKuDc8FWEN4QlfkBm/dSo1h6NKmQey0jCc=;
        b=d6sFt4tXVd0n0Go9mZrZkx+1OZ2442yEsQxjsNC5a9xSSc6I0BETJ0eP2CcayKqpoa
         9pAEb340oBroWPXZnY701w8oESRHqWMGGE4xFTDaVC49R4E31c9cUcEqHdqsel4eH2Ex
         ecfX/mj+nQyq1NunRmS0ga0rwFbz3A1Cxrwow7UeJcBwkCVFdTwP/kyy2DKlg+SPhknc
         JZDibd49s4JXL6SZ3F/3Tsvn/VLaVTj91G5oZS58WsZ1AV2KeUALMY+Lkvz+4xQwoany
         7LVibk9YDM9F9BZ2iAi1TuTfqT5C48NtmdeA1KguJHk9O8Crs8EVF/9aeg7ze7t8/aU1
         HvRw==
X-Gm-Message-State: APjAAAXM5h3wZuqY+PLA+abcZhzYvj+Es7OXx1zZbhdCYtBXFEPjdjvy
        H47p8y4EFaDaJfUA94M7x82snc7ttTI=
X-Google-Smtp-Source: APXvYqzZaI5O4zWqtjzHKbmUxaaPGpRHbBwqtZ+zD6WZo9vZPw6gWNwhgz3KSZ4bo8U3ZFAn7KSU8Q==
X-Received: by 2002:a63:2d0:: with SMTP id 199mr76352480pgc.188.1559069268408;
        Tue, 28 May 2019 11:47:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n12sm14213608pgq.54.2019.05.28.11.47.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:47:47 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     davem@davemloft.net, saeedm@mellanox.com, jasowang@redhat.com,
        brouer@redhat.com
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH PATCH v4 0/2] XDP generic fixes
Date:   Tue, 28 May 2019 11:47:29 -0700
Message-Id: <20190528184731.7464-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set of patches came about while investigating XDP
generic on Azure. The split brain nature of the accelerated
networking exposed issues with the stack device model.

Stephen Hemminger (2):
  netvsc: unshare skb in VF rx handler
  net: core: support XDP generic on stacked devices.

 drivers/net/hyperv/netvsc_drv.c |  6 ++++
 net/core/dev.c                  | 58 +++++++--------------------------
 2 files changed, 18 insertions(+), 46 deletions(-)

-- 
2.20.1

