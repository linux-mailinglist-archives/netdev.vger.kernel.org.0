Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838E08EEE8
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733301AbfHOPAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:00:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32930 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733294AbfHOPAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:00:35 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so2518628wrr.0
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AMLCV3YzxdATq/4eGHOKLDLXG9C3cKBdYE1r3RyBJ+0=;
        b=KLl3BXkVBJpfnKeUU3H6k867vHag42Ex9+v9AEx81+dRf4yk4pCDSMXI+bLv93GQ81
         YtCbU1BWam10D8THgpjZXR/LgYcx1GTIWT1c/N3668Iw6UXjrIDmpyEG1gEtlX+1yOAK
         L4fHF2IcmUvRqEJ5P1Q+fyDcBe76wvE44/+62dqAsC2QP+nAHAK7wqKwGh6R1G3B9KLz
         zg9m9do2LUWKjsGRXIBl1Xchoz8CqW9XOcw7tdO6JI1FrNEq6c7zuGtArtmsYVm3fGxS
         XicoR/oDCXCSbYusITcT+8dk7Qcl872DXn7X/YyYS8CrT3obFSl0uvDvDXnV5BWipkx+
         SqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AMLCV3YzxdATq/4eGHOKLDLXG9C3cKBdYE1r3RyBJ+0=;
        b=KyXYvcyHQhpyQlHceYmtbLjbrY2XXnToxhkpreqHqhOUhn7M88+rjCbHo5uhP4eSnD
         Nv5u97geC+HZjmcQphQrrnd/7YLw6nv6mQD+R/aKGS3j/lnO8sCpZoJ1ke0z1etQLMDT
         dKxfh6Gwxb3Cd1rNTRjk9zeonVuHZuaSro6u2Ng+G+aADpEmP09fIL5zjK7kHBt13QSk
         MV/qw9q3e7SsanqKtExkFfF+PIhGDAGu3iHRkEHiI+ez4K8UTbN/nk6g41JaRbwlxUuD
         3LcfNK4crC7YE2pHpdN5q4z0ru1sTuu6Iv3U5aHYda1xbpkUSKB86DQATm2q7RNXRg0f
         OQHw==
X-Gm-Message-State: APjAAAUGVV6RNXWd+9iwTTwvLCPrUl02sPdfXxhtR0CCXsCQpyMb6ZnU
        eV5SrGZ/AI3wms9nSy0ON/LtBKYGvUSkwg==
X-Google-Smtp-Source: APXvYqzSPMZMQ36wQTI/IEQUqZqLLwIv9BaYuThd3wcWPBg+IUtwvRQObrrPHz97lsiTdetQriR2Lw==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr5727220wrs.108.1565881233814;
        Thu, 15 Aug 2019 08:00:33 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a23sm2794857wma.24.2019.08.15.08.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 08:00:33 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 3/5] libbpf: refactor bpf_*_get_next_id() functions
Date:   Thu, 15 Aug 2019 16:00:17 +0100
Message-Id: <20190815150019.8523-4-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815150019.8523-1-quentin.monnet@netronome.com>
References: <20190815150019.8523-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the introduction of a similar function for retrieving
the id of the next BTF object, consolidate the code from
bpf_prog_get_next_id() and bpf_map_get_next_id() in libbpf.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/lib/bpf/bpf.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index c7d7993c44bb..1439e99c9be5 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -568,7 +568,7 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
 	return ret;
 }
 
-int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id)
+static int bpf_obj_get_next_id(__u32 start_id, __u32 *next_id, int cmd)
 {
 	union bpf_attr attr;
 	int err;
@@ -576,26 +576,21 @@ int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id)
 	memset(&attr, 0, sizeof(attr));
 	attr.start_id = start_id;
 
-	err = sys_bpf(BPF_PROG_GET_NEXT_ID, &attr, sizeof(attr));
+	err = sys_bpf(cmd, &attr, sizeof(attr));
 	if (!err)
 		*next_id = attr.next_id;
 
 	return err;
 }
 
-int bpf_map_get_next_id(__u32 start_id, __u32 *next_id)
+int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id)
 {
-	union bpf_attr attr;
-	int err;
-
-	memset(&attr, 0, sizeof(attr));
-	attr.start_id = start_id;
-
-	err = sys_bpf(BPF_MAP_GET_NEXT_ID, &attr, sizeof(attr));
-	if (!err)
-		*next_id = attr.next_id;
+	return bpf_obj_get_next_id(start_id, next_id, BPF_PROG_GET_NEXT_ID);
+}
 
-	return err;
+int bpf_map_get_next_id(__u32 start_id, __u32 *next_id)
+{
+	return bpf_obj_get_next_id(start_id, next_id, BPF_MAP_GET_NEXT_ID);
 }
 
 int bpf_prog_get_fd_by_id(__u32 id)
-- 
2.17.1

