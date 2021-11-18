Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EC7456441
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhKRUfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbhKRUfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:35:43 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0CFC061748
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:32:43 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so9192073pjb.5
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KYX4Z2exB3jwtaqcfI8gZcFYfqs7exom+PHX0M7oQsE=;
        b=WtS8ExWj/v7fj4+FuOYEI4WmiHmOEsDoSEqfWE+gOpcnWHPw5lUtiGgsIT5v07RaI8
         YkB+DyBIFcQBFAi/+aFHWUkQHa1dlrlcFvTMm8Dr/r0zMgz6J4KzIk2PBZIFrzUVmoEv
         XPS13oYdYcZJsYJkoZISyaT83c2uHEwCV16Mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KYX4Z2exB3jwtaqcfI8gZcFYfqs7exom+PHX0M7oQsE=;
        b=V2Pvksa/sA3SNA84RVx/CcYtZvs3Xy+E5lRT7B0vfTU4MK5TC/6IUwC+gScD2kobN4
         CEvxbcV7Bbj3E54lLTmYtkQWVKNxOW3yVrHfBwj08p08Y+9hSWbGZnAE4hUVI05XzCDB
         V/dNM+zMo1IUbrngAGvLqcuWT2IGTZeS/tuKwfd78GJrtFrwe0Gi+Bv+VtbxjwzaO9h+
         BPFMa/qlKpahhB7zdVvaA81G0JgQUVpbTN/clvzTebjevGAAL4mLfYj/M+WQ+iH3BuAr
         ovNmqlJ9EOkWo/4GrX331sbSooyOD4D4wX2Ibs4R76Mo9ZtzSN9UkxjHF0CawfFKFI0B
         HJZw==
X-Gm-Message-State: AOAM532hxd0zn9h3r7BIERx6Cgvr5qXRMvqn76ZCysPFxFZTDxfoGH69
        uHidciMwT7S6qJ9cdLfqHh1TMQ==
X-Google-Smtp-Source: ABdhPJz+6CMtLisvghnTrLjCObiLbIPTpDt7QNLisEDJycYs13b/WcjKuguDRYR+9vb7ucQ/c706AA==
X-Received: by 2002:a17:90b:351:: with SMTP id fh17mr14200484pjb.19.1637267562836;
        Thu, 18 Nov 2021 12:32:42 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y8sm472069pfi.56.2021.11.18.12.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:32:42 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] ipv6: Use memset_after() to zero rt6_info
Date:   Thu, 18 Nov 2021 12:32:41 -0800
Message-Id: <20211118203241.1287533-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=847; h=from:subject; bh=yNLj0JvA8w3tbHCKTH2NRjDpod/tQGXj33yCFFSnwHs=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlrhovJJ6+6q/2apZn6MVU1adP4a3K12BQjadQKIF rqvdvuGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa4aAAKCRCJcvTf3G3AJj28EA CzOjycg1txLJwXW53E9yu8IMaRzAevuaRC5WjA8Ml179IkuCXmybvPChwJTjIa3zdqOS+J4+Udh6KF Kb/79IcZw+tE53TMesKftH/xEW3QMIpdGvP8jlv9EllD+HQI0Gbn0v8HDmou21qYz2suowm7wPJQBP ymEUEkmkykB77NjbiC18qeP0sWfPjP4S51Nt80NeId0Dxo54mxFGs6ophDiX6IWMrnktpDSRvlmLJe YJKvQU/AXJkZYY9YcSEGmfKTIzr93Y1RSR6NFxtHfoeOq5QcdJGpNXOTP7MrfxU557TtdjoQHEamW1 OJi2MoGayWzqDU+9vC2/qmfhGN1Iiu7h1rZhe+Q6IOgs8vn2YTxqLpQSxaqQH1v3nrq9rT9TGSAhuy o8gumzFGqLSg1/tM+1rKUtwylRPvHcql4vV99B41szGLp85RsfJy8eZwZxpqrcTpY3bXiL8MKvuy32 LUmfFHhVjrp5cylQq43MvXL2rtyHhQjePzlsiBH8i/grQUGV5FngU4XMK66aKalDO9l8HJgz8nzcsD Rqm7kYy7aSMK92fQxjthHk2m9Nwg5aRLOOri+FhtMdUskIu5iaT7hDm8gKhp1jlYXk0OXYOTRk5rTA /g73bZ27I7cjY/QGMmWFsdCKgN1WNA+uSrN654B5xKDqGIr72b1qpQ09QM1Q==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_after() to clear everything after the dst_entry member of
struct rt6_info.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ipv6/route.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 3ae25b8ffbd6..0cf616b2d013 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -328,9 +328,7 @@ static const struct rt6_info ip6_blk_hole_entry_template = {
 
 static void rt6_info_init(struct rt6_info *rt)
 {
-	struct dst_entry *dst = &rt->dst;
-
-	memset(dst + 1, 0, sizeof(*rt) - sizeof(*dst));
+	memset_after(rt, 0, dst);
 	INIT_LIST_HEAD(&rt->rt6i_uncached);
 }
 
-- 
2.30.2

