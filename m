Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC36195DB7
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfHTLrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:47:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTLrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:47:51 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A6E2811A04
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 11:47:51 +0000 (UTC)
Received: by mail-ed1-f69.google.com with SMTP id l15so3995060edw.15
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 04:47:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XEHdTPsjEcpT7ruldkyNBMFu11A5CwGXpLLZPpnNXEI=;
        b=kjWE8ZH+Tly5ZVGJYUJ4GAMWLt9M+XEu6TafTy1JfgIOpOUg4jRpSyHNORg6/WQHov
         pfd5SU56pjeclH2l3BEXRWv299a0ZoTsPYxmfaJv4Luca5zKZy5YGz7zZU/U2D5ielWL
         S/7gzB4DCIrMWlcM64xpIUi23RTPkpZsx9FbI0rRt1ZdjvUY+/KPLa5dzHfzH4ILGzv6
         ASlTeCIu5hLEYaLlt9bBH762yxOMblnX8GUkfcIRsOx0m0bVwmCEUV6znqPjQIqMENAe
         h96d1EHy8YMKk3tYxfkvfLr5Mdv3IQ60RxYlwTemWSFSLprb/7jtQWmTeSN+cQ4MdFfo
         7yPg==
X-Gm-Message-State: APjAAAWUl9dmSSTr/6YQWhl3VHGx3UVjMWFlMxZxL/jr9HbTWuoj0pBA
        KnD7Hac/G41S37hvrlUfJBMPzGSngjBqq6yZnQcdYW0KNuWiikATiZreO3B7vvGRqDFQp++HqqR
        5IhMz+P3McZhNUv+F
X-Received: by 2002:a17:906:4ed8:: with SMTP id i24mr25174047ejv.312.1566301670481;
        Tue, 20 Aug 2019 04:47:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzC//6tGQ55dwHqqgULetgweZHNAuG1DD1BRHZMXXoW/gMPEe4p/dwYt3bf0ajdIxZNQXMA4A==
X-Received: by 2002:a17:906:4ed8:: with SMTP id i24mr25174034ejv.312.1566301670272;
        Tue, 20 Aug 2019 04:47:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d29sm3336318edj.59.2019.08.20.04.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 04:47:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4CEB5181CE4; Tue, 20 Aug 2019 13:47:49 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC bpf-next 1/5] libbpf: Add map definition struct fields from iproute2
Date:   Tue, 20 Aug 2019 13:47:02 +0200
Message-Id: <20190820114706.18546-2-toke@redhat.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190820114706.18546-1-toke@redhat.com>
References: <20190820114706.18546-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The iproute2 bpf headers define four more fields for map definitions than
libbpf does. This adds those fields to the libbpf headers, in preparation
for porting the bpf loading functionality of iproute2 to be based on
libbpf. Subsequent commits add the functionality needed in libbpf to be
able to port over iproute2.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e8f70977d137..5facba6ea1e1 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -289,6 +289,10 @@ struct bpf_map_def {
 	unsigned int value_size;
 	unsigned int max_entries;
 	unsigned int map_flags;
+	unsigned int map_id;
+	unsigned int pinning;
+	unsigned int inner_id;
+	unsigned int inner_idx;
 };
 
 /*
-- 
2.22.1

