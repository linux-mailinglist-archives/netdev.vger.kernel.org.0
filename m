Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726072C8872
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgK3PnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:43:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgK3PnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:43:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606750915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MB0dQS9W+QfK4D+jrMjOtyy9jil1jA7MHiVKKrSVCKc=;
        b=dr/q3WmCHvRS/lkMaKGmOwB7pqJbQxCS7UVXod7dy+NNw/IE2BDJrjzExUUvqxtHETtnoL
        9rU+1Doi0f+dGOaIcUWfsG7XZ5akLd5J3B8oRwOKtMYImvjKagAt7mV0ikMZftv/krPtAT
        ht/PlBM/Y4gKEsBR2ai89xWcKsXAOhc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-VMxd6BYGPeKDZxPlg8qa8Q-1; Mon, 30 Nov 2020 10:41:52 -0500
X-MC-Unique: VMxd6BYGPeKDZxPlg8qa8Q-1
Received: by mail-ed1-f72.google.com with SMTP id b13so6983697edy.8
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 07:41:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MB0dQS9W+QfK4D+jrMjOtyy9jil1jA7MHiVKKrSVCKc=;
        b=JuBKZfYo96YJZyuqeLYb0ZtJY/m7+4DzxhPxzvU+2ogIm0r97nvtDbcBVRF2gWwTm5
         hLPUkaNW+0d2wcavtBb2MPxdQZhKdvZjY2ZjpQPIZFCDrrz/TBMWOL0lvOZYVTAtYXsk
         ncuCJXZaN5+CvwAi3Qt3t/CcYvAnDckDyfra9xfrYO+bSls9Mt/fcBBvVS7lPMoAmflm
         PcDVjyfLBJSQL0+6U99CrObQoGjWRijHKLlM7O8Az8iP7xdCgMmdIR3CO0MzvksL3mRW
         Tekjxi1f7AhER+PMb0YgKBqtC3MQ8Q9D/RiE23Rsa0I+zMGtGwBHh4AAgpwX5Ba1lg/W
         6kSw==
X-Gm-Message-State: AOAM533DW/9gug4NzmOjHpQx1Evl6aSzEVjtVUsqP/hkjnneAI/HuDgl
        Z+iRY//RzVBiZwvphnjBHt8d7eaHsTGtE1Nr9EFLw0/G9OdBJcbLvNdUoAuyVJ508Hw9T3DcesU
        CgR8taQc/BFYd5lyT
X-Received: by 2002:a17:906:40d3:: with SMTP id a19mr10614035ejk.98.1606750911585;
        Mon, 30 Nov 2020 07:41:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweJhueAkfKb6oGnEAuKis10sb37ls5KczPoiyHR4HeQIV+Cf1wea1+G1mnEu2AkfWZcLtJyA==
X-Received: by 2002:a17:906:40d3:: with SMTP id a19mr10614026ejk.98.1606750911438;
        Mon, 30 Nov 2020 07:41:51 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s15sm9292438edj.75.2020.11.30.07.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 07:41:50 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5CF55182EE7; Mon, 30 Nov 2020 16:41:50 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com, andrii@kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf] libbpf: reset errno after probing kernel features
Date:   Mon, 30 Nov 2020 16:41:43 +0100
Message-Id: <20201130154143.292882-1-toke@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel feature probing results in 'errno' being set if the probing
fails (as is often the case). This can stick around and leak to the caller,
which can lead to confusion later. So let's make sure we always reset errno
after calling a probe function.

Fixes: 47b6cb4d0add ("libbpf: Make kernel feature probing lazy")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 28baee7ba1ca..8d05132e1945 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4021,6 +4021,8 @@ static bool kernel_supports(enum kern_feature_id feat_id)
 			pr_warn("Detection of kernel %s support failed: %d\n", feat->desc, ret);
 			WRITE_ONCE(feat->res, FEAT_MISSING);
 		}
+		/* reset errno after probing to prevent leaking it to caller */
+		errno = 0;
 	}
 
 	return READ_ONCE(feat->res) == FEAT_SUPPORTED;
-- 
2.29.2

