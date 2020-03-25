Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1751F192761
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCYLln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:41:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46194 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgCYLln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 07:41:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id q3so901058pff.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 04:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n1Ru/dmAFG/0Ivl+UAkyateVtitHPjSvCGQ9A04AWXI=;
        b=smf8CKciNX2y/tWhh5Dx9lhGEfiMJMuajr1JcnFlNkWRUj0CMrDxUXt8zxGmwsMsb+
         gWQqjjH/9Z6dBKhOoXwMhIvKbTkuYMW6vofGdh41m0qytPPIpLz7NHON4ncRomPFEznm
         eZgkV3kHyd5plSetn7PFC4b5+NHE29LgYgUtce3qtK2FanUhPJ9wLqDHW83fDESflOCH
         O8ZYeeoCQuIdTYItx4vCHbPc1p+duxDszdQwfZt1aXFeCCsdMH/oT0Ii+hYnocJi0adx
         HNBU7A8T9vSUFeoSqhqyfNnNeuICKksgPA9NL+6wGnMGO6HNDdWQ3+WQXb1rZfWbWJUK
         mceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n1Ru/dmAFG/0Ivl+UAkyateVtitHPjSvCGQ9A04AWXI=;
        b=d0FlvC5I425AeSDLcTZh29OfngUOcyPPl6hBhYP7vDApCvdmjXNt51JVVYPQHFDdY8
         CG3LEDN549mwOCn2cQ7cyACEWb/6ud3RyeqHgtLOVjaURHD6Xv1pQHeBhk6HgqTFRhKZ
         SHXHNz4gldB8kIVaRmcfGDWvmIyZwrPhGhVY5n4sV2J7gdmmGLJhlB38yL9yzvmSQh85
         2jcbGU01efQjkIjYfakukZNO3Y/LoLVZY5DzCD02CKk09QISmB0Ew57HVwu3rkJ8O1Ul
         L/wboxL0UxnfGGrpOvLMsgtCy/kh9XGHXrRU/FCB5Sd69S74frRXPQLp9VLutdDscrG5
         cG+Q==
X-Gm-Message-State: ANhLgQ3B/GM9Eq+8AEPGdmZDryaNMZMNlbHAyBhH3MR5tyulpFw0Rv1R
        YqhGYYZkO6B7zB7O2p3fZ3RWXHtrqaI=
X-Google-Smtp-Source: ADFU+vs/fAXTZ3wbYGQWqSKq2mTWNAfifTDbyywGM0jy3Kr0pYq7Tgrmt4ilAh+eu4DcUhY7If5kFQ==
X-Received: by 2002:a63:cd12:: with SMTP id i18mr2648566pgg.98.1585136501458;
        Wed, 25 Mar 2020 04:41:41 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id h11sm2846632pfn.125.2020.03.25.04.41.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 04:41:40 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 1/2] octeontx2-pf: Fix rx buffer page refcount
Date:   Wed, 25 Mar 2020 17:11:16 +0530
Message-Id: <1585136477-16629-2-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585136477-16629-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1585136477-16629-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Fixed an issue wherein while refilling receive buffers
for the last page allocated, recount is not being updated.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 94044a5..45abe0c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -304,6 +304,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 		otx2_aura_freeptr(pfvf, cq->cq_idx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
+	otx2_get_page(cq->rbpool);
 
 	return processed_cqe;
 }
-- 
2.7.4

