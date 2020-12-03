Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9FC2CE103
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgLCVpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:45:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727513AbgLCVpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:45:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607031868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFBdM3j73KJlJPyM9dITVEEIkfrsFpAKD2VpIUN73oI=;
        b=M3QACRJonSQFQsRbVkyLlr0ZDmg1/SjAGRZdz/4Aql/7i1vQDH2vISwYV/jYH5h/s8YEJw
        lbcNWWhbtvhbfznfVvHoQx4OxWrp2OY8jIwuqkCaDoA7DpowrjqKe9VoSsg0NjAPiDHQfo
        ClYkqWNBA7XOgR6JAOjVzAO+JQ82GoQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-VT9myripOLeptq4yu0OspQ-1; Thu, 03 Dec 2020 16:44:26 -0500
X-MC-Unique: VT9myripOLeptq4yu0OspQ-1
Received: by mail-ej1-f69.google.com with SMTP id z10so1296490eje.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 13:44:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZFBdM3j73KJlJPyM9dITVEEIkfrsFpAKD2VpIUN73oI=;
        b=RR12GN9Bsv7aYQduOtu7KhNo63gXJ61UOroijx9L5bVCHSm8JnypUkcVepFs1oT90I
         MMwFq8TVldyv7etcibaQGdlvW/g+s01bwJ6T04aUiTuksJeYR3Olcgn0gTS4EOJt0WnH
         TKdSoDkmhYjCdQkBf4vVE1Bxb5qdx09zMsit/LVc+rKD68Uzf81sTSNsGCa6pNg13QmO
         K2IDoXW8KCaTIk3KsgpBdnQn/dQ+MXzq7yB/JhAjRmH+matrxtlKX2tn7vy/m/Ul+HkF
         2O75GIc+zmG29XPlXpopToLrE5NHTZMWEDK2omGpOBEbUWBk7QZ4DC2HTskIKvz+pIrB
         GWPg==
X-Gm-Message-State: AOAM5315/miEgw6Ct6nBbBf5tw/NQ776qZ8E51zEY1/eofZliRCfolxf
        8bzb5ZVvADasxMfgpfO8bn3msgUfRmiDPVlQ+9k/gTLyjwVpnyNdf84CyESp+7bsSVed3WqAZ+S
        BdUTZFCpp9YAKomFQ
X-Received: by 2002:a17:906:17d9:: with SMTP id u25mr4495633eje.34.1607031864630;
        Thu, 03 Dec 2020 13:44:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyAUSoCcFBxGYA901oiYO8Zd1bujjZOi0w7vxH6KOq/I+aubewMo+Rplg2pAC8w3lRC9GabQ==
X-Received: by 2002:a17:906:17d9:: with SMTP id u25mr4495604eje.34.1607031864244;
        Thu, 03 Dec 2020 13:44:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z19sm1567256ejj.101.2020.12.03.13.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 13:44:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CA1CD1843EC; Thu,  3 Dec 2020 22:35:24 +0100 (CET)
Subject: [PATCH bpf 7/7] selftests/bpf/test_offload.py: filter bpftool
 internal map when counting maps
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 03 Dec 2020 22:35:24 +0100
Message-ID: <160703132473.162669.16627304955343580502.stgit@toke.dk>
In-Reply-To: <160703131710.162669.9632344967082582016.stgit@toke.dk>
References: <160703131710.162669.9632344967082582016.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

A few of the tests in test_offload.py expects to see a certain number of
maps created, and checks this by counting the number of maps returned by
bpftool. There is already a filter that will remove any maps already there
at the beginning of the test, but bpftool now creates a map for the PID
iterator rodata on each invocation, which makes the map count wrong. Fix
this by also filtering the pid_iter.rodata map by name when counting.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/test_offload.py |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index f861503433c9..be2c7e3f57c4 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -184,9 +184,7 @@ def bpftool_prog_list(expected=None, ns=""):
 def bpftool_map_list(expected=None, ns=""):
     _, maps = bpftool("map show", JSON=True, ns=ns, fail=True)
     # Remove the base maps
-    for m in base_maps:
-        if m in maps:
-            maps.remove(m)
+    maps = [m for m in maps if m not in base_maps and m.get('name') not in base_map_names]
     if expected is not None:
         if len(maps) != expected:
             fail(True, "%d BPF maps loaded, expected %d" %
@@ -764,6 +762,9 @@ ret, progs = bpftool("prog", fail=False)
 skip(ret != 0, "bpftool not installed")
 base_progs = progs
 _, base_maps = bpftool("map")
+base_map_names = [
+    'pid_iter.rodata' # created on each bpftool invocation
+]
 
 # Check netdevsim
 ret, out = cmd("modprobe netdevsim", fail=False)

