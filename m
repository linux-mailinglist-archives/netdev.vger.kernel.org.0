Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3305A2845A8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 07:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgJFFvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 01:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgJFFvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 01:51:51 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BFAC0613A7;
        Mon,  5 Oct 2020 22:51:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d6so8372978pfn.9;
        Mon, 05 Oct 2020 22:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ERNSfxgas2DII8SXjODRY6IOJVbvcgjIrZFOFrxw68Q=;
        b=nDgd2YQZUqL1nttwrXO/U6M6W5KPXo1VoEtVnvgRmrLNFmjE95JOVRQjsslmvw++Gj
         HoRjvtDIglVlfpBwITfh7XOZVu3LZIoWKlR5faIe1yR1TgZt7LGCJINGiBoM3+PpF2NQ
         2NKyHnZyqTGOkqK956vfN+nXXFsntorWPYR2/bfdsy7aGa/lXr94bq+/bvHII9/JspQH
         dXWdI2PZ+QeSCDe/Sh0hdisJue0hCS6W6SV6SISSy7sNpbxPkVpCq+CfXzOzXmQ+IOai
         WgFPgOeAP4MRRBZRIE+sd6qNmQ6rCKdkxrdkfjLDcQnSY6N5b7NLXSLPVw68n8S3lnoW
         4nJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ERNSfxgas2DII8SXjODRY6IOJVbvcgjIrZFOFrxw68Q=;
        b=WYxtL9B8ihNec7T5r08Z0IJ3i7+RUtrwEvZxRMS8hX6XMmfjkxg3smOw63gQB9uALh
         QAz+5XjPL3cO4mSfJxv/zu8vgP2Z+EROb7HVnCmlv/8cueaoPUDTx8tBiBnJusrJhHcm
         zRuhNwA6F8C54Dqtt20wEOArT9eJe8f50v76+iMqUbAo+TNaIqBrHmkVEAririq9lkXf
         qJPclVCPlhzNZn1Zy5Teko/5NTD2Bxlu5B+6DkXFuOoEf1k/5AYZJVa33G9AuQCaqMCE
         amRSm2L3MaZuI8lK+CQUu0dX3h/wCEGwoK8vxtnuA5E8ekh+T6P5IYMWe6fIFl2jYnvc
         vaQg==
X-Gm-Message-State: AOAM532daVnqEDqWIWBVUjKvq+T6lXnAfxf/LzFjmTulP9XDO+AIFtln
        CHB+NLR8FPDYyAa3kmXrI/w=
X-Google-Smtp-Source: ABdhPJwAbleMDsb1ZTQ4D/iBDyR3wegYp8LU5qODIJJrXN18xWqRoW+fRBqbmGYZjN4f3cXrm7tS1A==
X-Received: by 2002:a63:465b:: with SMTP id v27mr2580914pgk.318.1601963509151;
        Mon, 05 Oct 2020 22:51:49 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id x6sm1413685pjp.25.2020.10.05.22.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 22:51:48 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        ath11k@lists.infradead.org, linux-mediatek@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>
Subject: wireless: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:21:33 +0530
Message-Id: <20201006055135.291411-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

 This series converts the remaining drivers to use new
tasklet_setup() API.

 The patches are based on wireless-drivers-next.git

Allen Pais (2):
  ath11k: convert tasklets to use new tasklet_setup() API
  wireless: mt76: convert tasklets to use new tasklet_setup() API

 drivers/net/wireless/ath/ath11k/pci.c              |  7 +++----
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  3 +--
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   | 10 +++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  7 +++----
 drivers/net/wireless/mediatek/mt76/usb.c           |  6 +++---
 drivers/net/wireless/mediatek/mt7601u/dma.c        | 12 ++++++------
 9 files changed, 27 insertions(+), 30 deletions(-)

-- 
2.25.1

