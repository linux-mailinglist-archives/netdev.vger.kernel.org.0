Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC458E5C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfF0XNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:13:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35155 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfF0XNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 19:13:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id l128so3283459qke.2
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S5gB09VLIO/ltunJZwBpp1AcCPOwa+p492WFcMNQMNc=;
        b=ZN2A3A4HYOybSZJYrfPkUSxcOjEQfUoLm47Vruuvi7YY5d+8L08o2H05N8rgs9znBQ
         17kesImdlTY0PSw8/jYfvDBAE807j0YDInXtWs5+FOboxNSSatBPE8ja/343DakNABtE
         X8vRot6KsNK8o6VHPcstoqWmByOPUzIiriy8/e0R3ezPz9UnFi/PLKrYDP3OXHoDXcQ8
         vTbxYbkjbIp7NFfCl/IfD3/zMwdwqe6ruHbpMIrrTgkHojOxBEvNPgKIfYgm0PKqWc+R
         8mFSc9vFGEAcJxVTUcrLvbuyaTyzqYuNiYwk80GxAspNj9rQ17YPAY49Loj2gmKRKBrr
         cwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S5gB09VLIO/ltunJZwBpp1AcCPOwa+p492WFcMNQMNc=;
        b=toGrCx9KYnid8AzsFlsCYLBroetZ5VsixkzdGoxlt4vH2EyIyveD3MOHvMsQkYKcOt
         zdJJUOqKdfFHDFraUllVm4TBOgPRapGNI99YJuoMAOq6gqN+wCHKLn8MSbyKHhInLj9y
         yzP8/6blwAA1+dUnVC4An9kGhtTbQMEd47oH5nBEWTu9OwFECa53NxRbpB+ixUr5T9Lv
         WNQEf6mWABjRj96nFQxxUUOLRZLKUsF7Ft763FO17nLYPG2ERyAwNSO1rtICq4fj2hsS
         H4L9KuCc+s5O2lQYJaRrpHQFwByLNvwsknLuE6BJjHWcwLQpMC8eWXcV2mPtzMPhp8jC
         vOSQ==
X-Gm-Message-State: APjAAAVW4wUBvfzOLgBywj2STgfse/I6sbaz6RGsO43pwUqd87XfrMjZ
        GW/o+v8bG3U3seu4ieeb3KpL6Q==
X-Google-Smtp-Source: APXvYqwD8IXFjb/+WU0On7DlII3GSj3WD6sLG+rnDWA5W4lvKMcRsNIMjNLzcOW0iZZ8+BlInFsWTg==
X-Received: by 2002:ae9:e887:: with SMTP id a129mr5860514qkg.347.1561677185448;
        Thu, 27 Jun 2019 16:13:05 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o33sm253518qtk.67.2019.06.27.16.13.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 16:13:04 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/5] nfp: extend flower capabilities for GRE tunnel offload
Date:   Thu, 27 Jun 2019 16:12:38 -0700
Message-Id: <20190627231243.8323-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pieter says:

This set extends the flower match and action components to offload
GRE decapsulation with classification and encapsulation actions. The
first 3 patches are refactor and cleanup patches for improving
readability and reusability. Patch 4 and 5 implement GRE decap and
encap functionality respectively.

Pieter Jansen van Vuuren (5):
  nfp: flower: refactor tunnel key layer calculation
  nfp: flower: add helper functions for tunnel classification
  nfp: flower: rename tunnel related functions in action offload
  nfp: flower: add GRE decap classification support
  nfp: flower: add GRE encap action support

 .../ethernet/netronome/nfp/flower/action.c    |  59 +++++---
 .../net/ethernet/netronome/nfp/flower/cmsg.h  |  57 +++++++-
 .../net/ethernet/netronome/nfp/flower/match.c | 103 +++++++++++---
 .../ethernet/netronome/nfp/flower/offload.c   | 133 ++++++++++++------
 4 files changed, 263 insertions(+), 89 deletions(-)

-- 
2.21.0

