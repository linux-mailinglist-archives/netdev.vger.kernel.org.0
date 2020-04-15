Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A984D1AA952
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636341AbgDOOCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:02:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48183 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730833AbgDOOCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:02:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586959324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DIieFSIFXcNK3bF2pki6xVm8oWsV0b5ZkJCX9uZyw50=;
        b=KZ33e0VLavyY76tWRwTCyv7IBK8ZsFKWbDrw+yEyPOCXV45LplXZ8gwmseTWvgrlsolICL
        llT0Ep0eCsM0v8StXe8rrrRJcaa4XXGVGyspwP7klp2Z/fLZM0kT1uRsQDVVT1qm0dvGOS
        VRwBwr6WPX4Vu3gTPi33pqonc514UFc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-O30OYCnyOVe8FZC5UOe6Yw-1; Wed, 15 Apr 2020 10:02:02 -0400
X-MC-Unique: O30OYCnyOVe8FZC5UOe6Yw-1
Received: by mail-lf1-f71.google.com with SMTP id 17so1340372lfo.12
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DIieFSIFXcNK3bF2pki6xVm8oWsV0b5ZkJCX9uZyw50=;
        b=efyrfeMWP2Mf3ooDT715rgoHmLgiPV95F19ZQ9eQL3Fv+3ypuXUE4NXdnnkcqfE9JS
         HrWwuNZoZHc2fq4hycG+HRvHsfjuGar5+GUkJWZ0z4qgtigLnf3GMSc6AAvUKFr8uQp6
         L5dTbct/y10I592RPAqn/eb0O/saEUVFk5bkUL6EcsAVREqlUgIRakgM5EPtTxTGEQfa
         EumClQcQyJYJOgxphurrT1DG1APuYN2NHBEdktoPuMewTxPHrEzcEtTsONsLgKhDC2nI
         gDCeoX8KTJoZMSZGXfr1Z6T3yM//HVj1tAMx4SqhxQTkV9xReai57qpml9ALet0878Yj
         pvgQ==
X-Gm-Message-State: AGi0PuYbwChDHR8RFv7ysKd6FVGbTO6PBrfVvuMm2mK4Nw01pMdlGZZb
        aYqQIGVDGOU7nfC0NzQSWM+3LAy7eVqWe3Z7t9e44vHIMMWfc/fVMfcVOaPMExmCIsaP16qX1OK
        wgnSeWDnz76+vDUYd
X-Received: by 2002:ac2:43c6:: with SMTP id u6mr3294388lfl.170.1586959320623;
        Wed, 15 Apr 2020 07:02:00 -0700 (PDT)
X-Google-Smtp-Source: APiQypKQVrVF1keziwDymILwDFZQB1YR2QERfd2wejuW+1DEDbm2plwNgF7XGhJrMenNXH6bM9yzZQ==
X-Received: by 2002:ac2:43c6:: with SMTP id u6mr3294372lfl.170.1586959320382;
        Wed, 15 Apr 2020 07:02:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u3sm13345180lff.26.2020.04.15.07.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 07:01:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9171B181586; Wed, 15 Apr 2020 16:01:58 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Xiumei Mu <xmu@redhat.com>
Subject: [PATCH bpf] cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS is enabled
Date:   Wed, 15 Apr 2020 16:01:51 +0200
Message-Id: <20200415140151.439943-1-toke@redhat.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the kernel is built with CONFIG_DEBUG_PER_CPU_MAPS, the cpumap code
can trigger a spurious warning if CONFIG_CPUMASK_OFFSTACK is also set. This
happens because in this configuration, NR_CPUS can be larger than
nr_cpumask_bits, so the initial check in cpu_map_alloc() is not sufficient
to guard against hitting the warning in cpumask_check().

Fix this by using the nr_cpumask_bits variable in the map creation code
instead of the NR_CPUS constant.

Fixes: 6710e1126934 ("bpf: introduce new bpf cpu map type BPF_MAP_TYPE_CPUMAP")
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/cpumap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 70f71b154fa5..23902afb3bba 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -99,8 +99,8 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	bpf_map_init_from_attr(&cmap->map, attr);
 
-	/* Pre-limit array size based on NR_CPUS, not final CPU check */
-	if (cmap->map.max_entries > NR_CPUS) {
+	/* Pre-limit array size based on nr_cpumask_bits, not final CPU check */
+	if (cmap->map.max_entries > nr_cpumask_bits) {
 		err = -E2BIG;
 		goto free_cmap;
 	}
-- 
2.26.0

