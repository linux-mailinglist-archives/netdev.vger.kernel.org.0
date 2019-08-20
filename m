Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D3F95B05
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfHTJcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:32:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38272 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbfHTJcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:32:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so11654960wrr.5
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 02:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oUulDxxErU+azL0tyiV8vMBrr8x0fQefqueBCWkNWVg=;
        b=lLusJsP/uhZq7gKn1G6pJLEpYyMT2ewSVGUZw/It5XaKb8l7lTulQlwagc8UvdkJ7v
         H4IzMMJfu7ZEORMQgMDO+AvNPXYPtza+Ovk283Uk2Fq3R2olwrgSWgFiO7/o/eUzLB7n
         grklnlkdUULQAMj10LgH8UslEQGNTMJetpqyegn2nIsJQKVXAyTGymgTohjTAIaeMyeW
         /5xlDKllFzGJ4BqBi5CXqZAJIZvDvjYhlp23R8RnLs7LbVrJR3lTym4dy/0rN5qNGHLQ
         /wDb8qyNMYSpcsFRp7nYlUfKckPimXON+zYAien0FsLiHeyyls8tqe3LtIx8AuqQ1aZ/
         RoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oUulDxxErU+azL0tyiV8vMBrr8x0fQefqueBCWkNWVg=;
        b=f08AMeuaF2z/2mjXE9GktNxjxjLJCD96GiR4OlVDmj+FNiVlIR6GUfUYO14mTc4Qg1
         5mnxDXtKHKvQcDiNOZV8nl4x+pELn2Dj/VmjcjWfYtUVWzrq9rosBumC03YG0aZl61k0
         F/j40HgdtIrHjPeYaY68h62D7EY/ZvBFWVh+3JL/C3/qoaM+j0JcoHHZJPfqYF67g7vk
         2uixvmIUnQPfayQ+7MXqxc1R3Vm09gJ9IRxX5QUVLymlCu+dfCy1pJ6Iz+v6baJP062J
         fFBXTJDhwt8my1FLzpmwY77KLQDzHGtExMS5BTnOL9bPyzSQ0GiJkGH9gwHWZtOCQvHA
         DxNQ==
X-Gm-Message-State: APjAAAUMUuMeDd5BnRGZnfPzcForMgAn1pZk3rKoYivwWV+W+pehQISL
        8/BQRdnSeibWHT7o7IoOPGWjcQ==
X-Google-Smtp-Source: APXvYqw8+jcJrECTST+tSd5IlSgPP6vyYHYwUO0U0jzqrrvWwcCO6GkDGip7FaY3kpdN+7RuimrFeQ==
X-Received: by 2002:a5d:634c:: with SMTP id b12mr31890572wrw.127.1566293528225;
        Tue, 20 Aug 2019 02:32:08 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p9sm16128190wru.61.2019.08.20.02.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 02:32:07 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next v2 2/5] tools: bpf: synchronise BPF UAPI header with tools
Date:   Tue, 20 Aug 2019 10:31:51 +0100
Message-Id: <20190820093154.14042-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820093154.14042-1-quentin.monnet@netronome.com>
References: <20190820093154.14042-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synchronise the bpf.h header under tools, to report the addition of the
new BPF_BTF_GET_NEXT_ID syscall command for bpf().

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tools/include/uapi/linux/bpf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0ef594ac3899..8aa6126f0b6e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -106,6 +106,7 @@ enum bpf_cmd {
 	BPF_TASK_FD_QUERY,
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
+	BPF_BTF_GET_NEXT_ID,
 };
 
 enum bpf_map_type {
-- 
2.17.1

