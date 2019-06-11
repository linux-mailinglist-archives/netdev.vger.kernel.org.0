Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDF3D4CC
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406730AbfFKR6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 13:58:46 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33185 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406663AbfFKR6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 13:58:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so7931631pfq.0;
        Tue, 11 Jun 2019 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LBBPbHNbMLxHuXtvkfP18Wlm24ucalIiwEp6yuzKVrw=;
        b=odYoI1GawxMsPF+9fsdFAGR5icuHDBePosT3W/x2jCUoF7YiA3NvqO/0TMdgOKiNMd
         9pQImhSQIAWI/SEq5MILFDCvA3yxyb1vwWAJNh4mZ3knbs+4LTaXfst5TsPBAxtIL//G
         a7Df57BSqIl1Sr7aHblVMhMLV5xC5iYxoYs/NIYzSbnGJTIQZeU9MVEohKjPyFtqkXlc
         1yKYQm7+ESdtLGWMFEpqEDzXFHjqk7FqjqE53AZDzAnwxyj3i9TSnIHjqaS4xOHWMio0
         GF6Adcru3dvscDEQiWac9qsA/uZ8gQ9jnGR7JAuQSkPqzoDGo4Vbm46b2M75srka9rIP
         56Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LBBPbHNbMLxHuXtvkfP18Wlm24ucalIiwEp6yuzKVrw=;
        b=IalO44xRN4wXftC869WwwgHWEeToIGHc2uCJMA0XrPGHQ4+HCFnkoNrwg8Mc+N2ZOq
         XSxE27H3OS4a0hekdTeZzCrEkLdr7brKylu46noC0ckugpNcZzOc83FFFGlqdUCp8kQ6
         CjjeFWiQVooxkf8iRBEj7P7l2UUV58VJ2G/cbio1kcVffG0wf2lA3bDnshUnao4W2VDj
         N9w4jht72r6aYiEEO5ZHse+X3nE1rqOAC+fJMNYf+J+eVD49t9KEsrTg4BXrmE2oppoQ
         nK3DceZemp5XMuiCfV/5xOg4LTTo1zxThNiSXwVKEFzI2GPRI8PeGl0GgxqVDXVxTZnv
         cmgQ==
X-Gm-Message-State: APjAAAUKRyZiWahIYl3sWBOVsupO4ZZa0H+WSotc2eAiBqOj+4khmWNM
        HXSCmULz4/CZkwuZrlFWdFwZH2jG
X-Google-Smtp-Source: APXvYqyTpBNB7eZvWW9ncZHcnns11TIDIARcKZGd/45wmVobCvkg5guWjJ8EwPqyjaoefy2cKPJqDg==
X-Received: by 2002:a63:295:: with SMTP id 143mr20557837pgc.279.1560275924507;
        Tue, 11 Jun 2019 10:58:44 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s24sm15991182pfh.133.2019.06.11.10.58.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 10:58:43 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        iommu@lists.linux-foundation.org (open list:DMA MAPPING HELPERS),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 0/2] swiotlb: Cleanup and consistency fix
Date:   Tue, 11 Jun 2019 10:58:23 -0700
Message-Id: <20190611175825.572-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

Still with my contrived memory layout where there is no physical memory
the kernel can use below 4GB, it was possible to fail swiotlb_init(),
but still not hit swiotlb_map_single() since all peripherals have a
DMA_BIT_MASK() that is within the remaining addressable physical memory.

The second path could be backported to stable, but for the same reasons
as the one we had just discussed before, this requires a very contrived
test case that is not necessarily realistic or would warrant a stable
backport IMHO.

Thanks!

Florian Fainelli (2):
  swiotlb: Group identical cleanup in swiotlb_cleanup()
  swiotlb: Return consistent SWIOTLB segments/nr_tbl

 kernel/dma/swiotlb.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

-- 
2.17.1

