Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CE31ABB4F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 10:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502210AbgDPIdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 04:33:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23765 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2502374AbgDPIcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587025919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HIBVUWRIsV/qazqAU495189NhJZ420AbGHQkZjYAHHo=;
        b=C5HD558KsUwy9Ify9k55DWDUwO5sSUN6DVXVPZoHogMVARNEQZ2mlxRRSFv/9UzxsZS30f
        TqPOgaOq+Eyzmx6ArJxMP2DrtpBRbF8l6Dr5HUgMDQovilpnrdIWVUxvlrGDXQitUIyG5p
        gLN6ypvgj8cmP8yV7ThUvXcfL+zKDig=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-7_i5AKnHMmKikugbU0Y5Uw-1; Thu, 16 Apr 2020 04:31:57 -0400
X-MC-Unique: 7_i5AKnHMmKikugbU0Y5Uw-1
Received: by mail-lj1-f197.google.com with SMTP id m4so1350445lji.23
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 01:31:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HIBVUWRIsV/qazqAU495189NhJZ420AbGHQkZjYAHHo=;
        b=Mct9kHFCSne50jxrIbSpGTG8KyxTNcIgMqH5tp7V04z0/53gjopCbhzF3m7TQ92vmk
         HZot16Uw0RW+1XBQuHhtXOK98FekSZ9ommux6rPWuAWJHp47cg86gp+NiIgzGqOHYZGS
         qwF/elj6t1Ofs2gBwsT41+BhGWZMXqF79P2ozILepuj5/Eb0+znrw2apVe7QOT9ZosxN
         imDQQQMmZ6XhMiGvmj74m6GF75LHAPwxQiofRuV73NL7vdv5pXJ3HzROs83asRvMXHrw
         JXlLHHv4V8obTAu8cN54Ax2S2mkZ/84p9W8c3HA+tTwUdgSkb4nbjwedG30R396GI5jV
         SiaQ==
X-Gm-Message-State: AGi0PubK8T7diFhL1ANaR+3m9iQ1z55CHQKLabWSWK3VCMF4hN7QgU5l
        gfsDSUwnm6gXyqg42HRKsPHZPmLCOkLzymPk2oollYdo+h9H3al7TqYq5MvXa78jJfPRaDHDL4D
        VaPdv430VE14zc65q
X-Received: by 2002:a2e:96c2:: with SMTP id d2mr3954515ljj.214.1587025915590;
        Thu, 16 Apr 2020 01:31:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypKDyVa3XUtpM7z3Ajy5dj8yl+ldoiTPJwndGMYeskS7zXeadH6p4Vd1h/0K8Sq5xc1fRu4MXg==
X-Received: by 2002:a2e:96c2:: with SMTP id d2mr3954508ljj.214.1587025915395;
        Thu, 16 Apr 2020 01:31:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k11sm14663063lfe.44.2020.04.16.01.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 01:31:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3958E181586; Thu, 16 Apr 2020 10:31:54 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Xiumei Mu <xmu@redhat.com>
Subject: [PATCH bpf v2] cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS is enabled
Date:   Thu, 16 Apr 2020 10:31:20 +0200
Message-Id: <20200416083120.453718-1-toke@redhat.com>
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

Fix this by explicitly checking the supplied key against the
nr_cpumask_bits variable before calling cpu_possible().

Fixes: 6710e1126934 ("bpf: introduce new bpf cpu map type BPF_MAP_TYPE_CPUMAP")
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Reported-by: Xiumei Mu <xmu@redhat.com>
Tested-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Move check to cpu_map_update_elem() to not affect max size of map

 kernel/bpf/cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 70f71b154fa5..3fe0b006d2d2 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -469,7 +469,7 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EOVERFLOW;
 
 	/* Make sure CPU is a valid possible cpu */
-	if (!cpu_possible(key_cpu))
+	if (key_cpu >= nr_cpumask_bits || !cpu_possible(key_cpu))
 		return -ENODEV;
 
 	if (qsize == 0) {
-- 
2.26.0

