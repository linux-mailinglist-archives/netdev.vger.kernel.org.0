Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECEB4C2F8
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbfFSV2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:28:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34559 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfFSV2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:28:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so5497258wmd.1
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 14:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2W+A8exQdTLW2o/0GNC5h3yhth+mAF462dKpVE0akAo=;
        b=KPt+kATM0pNRSxDxTYwGPefvmQU9t7J7bsC+3A3g/U5Mj89z8dRxUMsb/AkxX8jSOW
         ra/zd3KFE0bcd4xTrpuFPudTXz/nrJyJ8mVzYYIlItjbyJc9r8IumkGxh+GhRELWpba2
         6/ISjeN9QEY9vTiIeqZ0d8C8qy5yZBiMjXw5/PTsR418SUFfkszAMzFhNdfyj+zig4s9
         LtqCCVmv9GxLRV8aEKz3NtHTDAUntfWfpr6S+pJ8uq5O1CDPtSIN/U6P1lWHSdHeDdG2
         79g8VeGyeqtnSn5F4+eeQJApe/4ZjEvk+q9jXPF2GcUXYHEzPS0Y8RaKw/wC7quaRPLr
         K6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2W+A8exQdTLW2o/0GNC5h3yhth+mAF462dKpVE0akAo=;
        b=IqV66DIuL3Twj8X1Sp/7i+3wFWYEFy/Bz4BUdo8wk7QDZQToPH8YVDKVTBSG1Bsd7X
         FcEjHxM99aNlYgC67ODWAo4ZWIMXnb70an3vKxW+E9vID9SWFLD5VCTDfcEwejDu5zzt
         niDlwehggwa+Cj8aSOYEo/WhjepyKZAUm719QTqoTyghGWS9gGAneJ5NT5PAIS98dZ85
         U1fvSceRZyMRghYvL7B2vzPtwWcLNje0jQ3BMNb8AckqYVjgqMa0HLYm7hZDBIwJaXF9
         iJtLycXURArbgv3+EdE+4Erw1IYIOeo9ZwfwlJGJPuBKuKr+46he3kD6UkaNI5pQFq3d
         FWuA==
X-Gm-Message-State: APjAAAVV8NmCRJjMfiNeBbMLWySjqzO+r0vFrXUt9WegyZBsr2byjE9B
        ucVuITD673C6RhZ1pBGKXSOn30zlQS5MGQ==
X-Google-Smtp-Source: APXvYqyxUgE++9OcJ5aJ72TNsTVML/ORHguL1JiMQxHDKyoU+EBRxgAojh853qZXoQpVy0TqDIKmzg==
X-Received: by 2002:a1c:dc45:: with SMTP id t66mr10179970wmg.63.1560979682493;
        Wed, 19 Jun 2019 14:28:02 -0700 (PDT)
Received: from e111045-lin.arm.com (lfbn-nic-1-216-10.w2-15.abo.wanadoo.fr. [2.15.62.10])
        by smtp.gmail.com with ESMTPSA id e21sm24975786wra.27.2019.06.19.14.28.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 14:28:01 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH net-next v3 0/1] net: fastopen: follow-up tweaks for SipHash switch
Date:   Wed, 19 Jun 2019 23:27:46 +0200
Message-Id: <20190619212747.25773-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some fixes for the fastopen code after switching to SipHash, which were
spotted in review after the change had already been queued.

Changes since v2:
- add missing pairs of braces in compound literals used to assign the
  fastopen keys

cc: Eric Biggers <ebiggers@kernel.org>
cc: linux-crypto@vger.kernel.org
cc: herbert@gondor.apana.org.au
cc: edumazet@google.com
cc: davem@davemloft.net
cc: kuznet@ms2.inr.ac.ru
cc: yoshfuji@linux-ipv6.org
cc: jbaron@akamai.com
cc: cpaasch@apple.com
cc: David.Laight@aculab.com
cc: ycheng@google.com

Ard Biesheuvel (1):
  net: fastopen: robustness and endianness fixes for SipHash

 include/linux/tcp.h        |  2 +-
 include/net/tcp.h          |  8 ++--
 net/ipv4/sysctl_net_ipv4.c |  3 +-
 net/ipv4/tcp.c             |  3 +-
 net/ipv4/tcp_fastopen.c    | 39 +++++++++++---------
 5 files changed, 28 insertions(+), 27 deletions(-)

-- 
2.17.1

