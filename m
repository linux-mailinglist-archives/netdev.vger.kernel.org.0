Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FA5E977C
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 08:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfJ3H7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 03:59:55 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43839 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJ3H7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 03:59:55 -0400
Received: by mail-pg1-f196.google.com with SMTP id l24so925583pgh.10
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 00:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=rAzoIDK3AoGba24FjPXotkcITvrcFg5BdkCIglDFzm8=;
        b=aAtxrt2djRBWrAyxLUG5QrbIK8zH3bEmDQEzs99eh/C2fwE924VxJFZXqmMb1CLu0j
         s3yxX2QUMOR/sFZHNu6jvYqZQjZLdzcs8E9RiYpwHJFIHXb2jQtF86Smu14RG41LHe3i
         CSGvX3ruKffx4Sh3c8KX25zPOLql6C+aGxkgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rAzoIDK3AoGba24FjPXotkcITvrcFg5BdkCIglDFzm8=;
        b=SjVrugO7OSwphldVY4+sPR7WOWDGaO7Qq3ZA3puqZHBSvK7iKHjPwlLXzYmFG8rI8g
         Edj+7oGM1HhhiVab1GXfr7w47am2rnLnTxhM1qPItcGwwZ1zTE0hj1XHfbVQz0Ae94wU
         5nBZOBIXJ8fpf0n9kvpYZhA/vXHpUdqnWrPNPN92BBB6rCVy0P8JaiorSvmdYJxipVjY
         QTw7R/Vq7TjaWfExzEW/DwTetv9b5LV/6nNSvSATE53Y+7Q/aXff51/n/BzPjagw97th
         5ov2/sioMnUxS5P+RnBhKVarO13BfBZ1x++45t5MPcvJHI7q3Jg7z5eHdyE5nXeRA3if
         JwjQ==
X-Gm-Message-State: APjAAAWhRXtVZ4k4wHvu+urs+l9FnOAsMs0f8csFK4AvJcfoKJjVI6n7
        Mk8y0fAS9/kxp2fXYne442OaKd/7jyE=
X-Google-Smtp-Source: APXvYqwPjSevv9S199NwBiWTgvS9JdVbLdfNX48qSkmp18RfzkKQOxGUxa87yT9KBEpJWGLCHAEM2w==
X-Received: by 2002:a17:90a:730a:: with SMTP id m10mr12472864pjk.78.1572422394524;
        Wed, 30 Oct 2019 00:59:54 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r21sm1960649pfc.27.2019.10.30.00.59.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 00:59:53 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/7] bnxt_en: Updates for net-next.
Date:   Wed, 30 Oct 2019 03:59:28 -0400
Message-Id: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds TC Flower tunnel decap and rewrite actions in
the first 4 patches.  The next 3 patches integrates the recently
added error recovery with the RDMA driver by calling the proper
hooks to stop and start.

Pavan Chebbi (1):
  bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during suspend/resume.

Somnath Kotur (2):
  bnxt: Avoid logging an unnecessary message when a flow can't be
    offloaded
  bnxt_en: Add support for NAT(L3/L4 rewrite)

Sriharsha Basavapatna (1):
  bnxt_en: flow_offload: offload tunnel decap rules via indirect
    callbacks

Vasundhara Volam (2):
  bnxt_en: Improve bnxt_ulp_stop()/bnxt_ulp_start() call sequence.
  bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during error recovery.

Venkat Duvvuru (1):
  bnxt_en: Add support for L2 rewrite

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  45 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  12 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  | 415 +++++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h  |  20 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 +-
 6 files changed, 482 insertions(+), 23 deletions(-)

-- 
2.5.1

