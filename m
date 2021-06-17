Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453853ABE41
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhFQVjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:39:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbhFQVjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623965846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V+K4Rzii9x9DcPIEElTMZYJsTVD8g+UmhuIcex1BLcU=;
        b=iy0RQ42oSxyAWuNLaDe3zANnlZ1ty8ssmtHdf/4yPwKpfDqIeZpgtrri2V8A+GL93FKRN7
        yCYhK3a3914EGO1eT/4X3M0ipNyrKnifNd0kBd7r2u2d6wYOP3HzMX/ahxRay7uOROEU/3
        VSTCaf+HRTIY1FoxY6ZDrmKao22g714=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-hAZh_o_pMamlFaoXON7GvA-1; Thu, 17 Jun 2021 17:37:25 -0400
X-MC-Unique: hAZh_o_pMamlFaoXON7GvA-1
Received: by mail-ed1-f70.google.com with SMTP id cb4-20020a0564020b64b02903947455afa5so599154edb.9
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+K4Rzii9x9DcPIEElTMZYJsTVD8g+UmhuIcex1BLcU=;
        b=b9ak4D0e62oEaTmxIzEJJilxsxsUSlXQWC0QttTpwk/W1IWTT9mpuPkxYSbs89QaK5
         a0qTG5pChfwwY1qrBgqEa6wwet2iHA88CVrdBmtvldd/TKWpH0peyihKISeMH+aPbwzN
         vGPT+alXfXOjwHyw8DSvzwfMwNForcVzqoSn3qVetInKY97VSbwn3ex77Ss2CdEy7g/Z
         Rzuocfhah0q/SjS8fnZq2TRKFpDMDYZTVSNcrEYbrNbqnIZoBdMOZIYkbxWRF8Yx1/dv
         Oi0mDc1DLfVNVitCpwyN/vRmMP/Dj9wi2lbSLNJ7/2aqBVMgn8d/maroG583HdhFEcFi
         2inA==
X-Gm-Message-State: AOAM533QJ5DvQNOLR++ZE916na8KQmYs0M3w3qViRFIDGWm9oZFDEfOT
        cHj7SYdsFp3c2M/tcsWMy25sZBFN4RAx8AEJrfj8fsHKXCZSbacIf4Y52K/T+v8U0NuQz3H8DSD
        07OsxnJ42/U26KQ5T
X-Received: by 2002:a17:907:7b9d:: with SMTP id ne29mr7692193ejc.167.1623965844476;
        Thu, 17 Jun 2021 14:37:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT3fEGEihEGarB3fpS2Al0EXij4hKluNygNZjVN8leQ1wAJxPYopgkOlxKigP3A1jBe4lPvA==
X-Received: by 2002:a17:907:7b9d:: with SMTP id ne29mr7692177ejc.167.1623965844289;
        Thu, 17 Jun 2021 14:37:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q9sm5018510edw.51.2021.06.17.14.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:37:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9A79C18072F; Thu, 17 Jun 2021 23:27:54 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH bpf-next v3 06/16] thunderx: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 17 Jun 2021 23:27:38 +0200
Message-Id: <20210617212748.32456-7-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617212748.32456-1-toke@redhat.com>
References: <20210617212748.32456-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The thunderx driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
turns out to be harmless because it all happens in a single NAPI poll
cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index c33b4e837515..1d752815c69a 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -555,9 +555,10 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 	xdp_prepare_buff(&xdp, hard_start, data - hard_start, len, false);
 	orig_data = xdp.data;
 
-	rcu_read_lock();
+	/* This code is invoked within a single NAPI poll cycle and thus under
+	 * local_bh_disable(), which provides the needed RCU protection.
+	 */
 	action = bpf_prog_run_xdp(prog, &xdp);
-	rcu_read_unlock();
 
 	len = xdp.data_end - xdp.data;
 	/* Check if XDP program has changed headers */
-- 
2.32.0

