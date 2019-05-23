Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D879A2855C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbfEWRyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:54:41 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:45263 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730987AbfEWRyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:54:41 -0400
Received: by mail-pg1-f179.google.com with SMTP id i21so3507680pgi.12
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BvOULGBqE2NTWy6VEn5Gi/1+ry3s4FryQizUO7IXJ8s=;
        b=M4EKiraUZFPhiXlDfsUPcZ1zUUz4duK68ynA8AYKSNZyLMyU4LA0NBu03fFKkL4m/s
         n1Szkk1QUpHBXQEiux688e2oCXaxvPDgDZ1vWfvN8NdNKjDtF7rKwJUbJxP8t4mceHgQ
         Jex61YGclh8kBuWFwz7WR2Mp1/2mWRKbDChSh5oVyCIVVAkWuHbESFE/nuQpoqzS50Rn
         d1DWu1vY6kjdBK7YzjgXq8Sfp6S75iDwJ26w6Bav0MY+cL86usAlv42ROf8AeZBsmZG3
         le4Zv4fuZbl3PkYto2RVptvI6ZIY+o3nev5uYq3ud0PKjRfwmN+0vxWxtXbuwqP0+zjn
         FhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BvOULGBqE2NTWy6VEn5Gi/1+ry3s4FryQizUO7IXJ8s=;
        b=SOCbww7gPN+Sdkk/aYfLv3+0DeV9mK2+T9IqCI/Or7/givAIxs1rV3dPjkpddw+QU/
         dZzB75g6TNxf9XOHWp0TImeVdjKijPl2HEZAd6RPmUCqwH1nlClTIRl90nivIYXF7EF/
         U6bnHxz6gMT06AOXR4EmJPDY0uU6HKKNfPFCVkxMgvq1q4dlnQz8Ky+8H2hZVemb65CK
         YFhzieakhXKtGkENP9jkUV3VnCLoaLhDXnFuUt/sQcm2ThI3Yh0FQDlAOsnFDcZSzqq5
         eAxqJUDJPVFgqNmhqcYtEoCnIQziv0RMMhX/GhMN3tbLyQD3Mz6LY9Gp3gH7K6Facw2k
         3+yw==
X-Gm-Message-State: APjAAAU14GSm6vCJev7ABHTobpB+PZwoW4H0DRvGdYrpbxd/hjpk0PHL
        DZlVlx0I/ZLrsMskKImUoztoyQ==
X-Google-Smtp-Source: APXvYqwLfYDkAGo4pACPxRO0ADU4Llhav0I1DmtsOrCp6+J3pmkNBC0RHA2+mdUTmEs7Fvru/WxuqA==
X-Received: by 2002:a17:90a:d14c:: with SMTP id t12mr2997549pjw.120.1558634080244;
        Thu, 23 May 2019 10:54:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n35sm4942pjc.3.2019.05.23.10.54.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 10:54:39 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH v3 0/2] XDP generic fixes
Date:   Thu, 23 May 2019 10:54:27 -0700
Message-Id: <20190523175429.13302-1-sthemmin@microsoft.com>
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
 net/core/dev.c                  | 56 +++++++--------------------------
 2 files changed, 17 insertions(+), 45 deletions(-)

-- 
2.20.1

