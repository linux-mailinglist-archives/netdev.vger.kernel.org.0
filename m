Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCC0B5E74
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 09:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfIRH5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 03:57:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36108 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIRH5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 03:57:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so3845564pfr.3;
        Wed, 18 Sep 2019 00:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ioXkqSJj3i8cLvyWdFqME9j4e4wdtFZPBcH/Mkz1bBY=;
        b=dTHqRDVhsKgFcRVz+hkGEQ44QEfeE2afW48CiLk6S8wEZ7mgWJF3biDZPYf0OIgH+z
         e/1PCSnP0+UVetLnJA2q+0OdQTW2aG8SyERWqal1bBHMKVoKc8GTfzPE0RNCDmTpvqp8
         z/z6AX9EH8sMhJNTqWOrLSlXQ1TkM03CTmGrkFCInm1L06XoPYY7yLkYYpAxDf5hhrX+
         k99TZ8ZFRg1klJcV3Cmn1ugqkRQb5cKxi/No1myncWI3q0gRSyobjximMOORpEPuc14K
         Cmsycaen3OCPC01gTWEOnAX3eRalmdK80QfTio3JxNlnfAF76kI1aloHW+zGZR+KpBvn
         82jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ioXkqSJj3i8cLvyWdFqME9j4e4wdtFZPBcH/Mkz1bBY=;
        b=IUf1mIEh40bjvbpXzAxRk5QHgx/pelDCwFaBO3NhvlyMo/NV0VM5mIqxQ6v6BDsuev
         oZUyim5IlRYzsHAwowro4veHoveCbrbHaEi8lfpPutGhryhjGO7hN3EzjGk7C8RFNiAt
         JPtTrMYrC+MpONu+tG6bjAQdpS7uDQ4QXnFf+U2nk9017+jXCm9ncfpmNLOtRchmzWcg
         Aopm+TNhPkgMALSMWd6yYvnm1rixHEhUB45f75BUVJ24JN59na4cNViL2LwkJSUIrdg4
         qh8lE883OzR9lY7ydINF5+EIMpV8gQxH8ZiBYKFcjNzbBuq4MpbsRjZfV/JatsvLck6U
         kaxQ==
X-Gm-Message-State: APjAAAVHbEzeC6D7wb/gA+/dz2ducjJfCDMxOLp40HE732XSc9zqIhJQ
        Xwo1FWe4EIKIUVudqvrJPFg=
X-Google-Smtp-Source: APXvYqxctC8BCdUXhJW8s8rIWlrpZNFi/8Y/YQ4VGOiN+K3G0YR/3wv4cz9G7YeMERCZRk/mqb4vhA==
X-Received: by 2002:aa7:83d1:: with SMTP id j17mr2717473pfn.35.1568793472713;
        Wed, 18 Sep 2019 00:57:52 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id b2sm5800888pfd.81.2019.09.18.00.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 00:57:52 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf] xsk: relax UMEM headroom alignment
Date:   Wed, 18 Sep 2019 09:57:39 +0200
Message-Id: <20190918075739.19451-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This patch removes the 64B alignment of the UMEM headroom. There is
really no reason for it, and having a headroom less than 64B should be
valid.

Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xdp_umem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 688aac7a6943..0e81a7fd2df7 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -335,8 +335,6 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (chunks < chunks_per_page || chunks % chunks_per_page)
 		return -EINVAL;
 
-	headroom = ALIGN(headroom, 64);
-
 	size_chk = chunk_size - headroom - XDP_PACKET_HEADROOM;
 	if (size_chk < 0)
 		return -EINVAL;
-- 
2.20.1

