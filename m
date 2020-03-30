Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86EF1986A8
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgC3VhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:37:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46443 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728819AbgC3VhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:37:15 -0400
Received: by mail-pf1-f194.google.com with SMTP id q3so9237596pff.13;
        Mon, 30 Mar 2020 14:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ZODOCevdbPgNdKresCLXbD/qYb6fAITjGgEiIl1xRWU=;
        b=OS3yx4psp2yvcRycX8hcP4b5fixaIaCP+1d9CQ7ZRsGhlZPC/0LnE708qTRU7+d3AO
         kMCqVoAR3f20YXjWFwc1VSd9KNgEVlMF5bgH58HsCCVFpzmpcV6KsfySA5TMJyF+jlo6
         Uih0xpWe2aO5BJeceGbkej94Jw4n7PoQR8ZTezXSzc95ZUYBtiy+yTA4UVwvE1Re75W8
         4wLY/ysuh1CCHELpWAiDQlrCxsOpQJtPqTpVGhTxDS63aXVaZf8CSWTvigksqDkZ2yk5
         iFLNo/tqceoa/Z0qmCzyOJGUJY69OfKJ0GT92EMnYHM6FnVxZgFE4R3eIosXtoqCwbiZ
         l3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZODOCevdbPgNdKresCLXbD/qYb6fAITjGgEiIl1xRWU=;
        b=EFpUjh+GSxM5HBG5L070fsVReyzmiIP+ppoaF7DWvVPhClcwO3jPWc277x9i2lfD2O
         IwykCyvZENLvkzcl/OANYz1+ifxj8TG08eMXozlfTFnctcv/ydD27dZhfotPpzZrXP7j
         kChv1UzTCkFAbVma36IARUr11hHXoa/d6obGimyRekL9nvokPCftl7JyxV+goCjbfKmp
         BoV8b/iM0HyqEDuf6b17xEj4bFY8ZLzyGLLg9m58kvKiftJ2CfCePVq+vfLDhxdbw5Bi
         LEujsx80TPu5eX9gyy94wr7JmYXugmNbtPqyQKrAdIZD8tuu7aSL5Z8IBIgYRTFPsO5+
         dfdQ==
X-Gm-Message-State: AGi0PuYAX3HJgw6CDnNpl9GduhFU+/Yofg1q4e1QfIHC1i38cbg50YB6
        rk9MsqW1aO/x7xZmb0+5BE0=
X-Google-Smtp-Source: APiQypIl59wICNoMPu8l/x4yLXbCRDc3rthV3VQzXefK5jE/WW7daQu8pUqXwCmjGN2dy4DPyJIWpA==
X-Received: by 2002:a65:68cb:: with SMTP id k11mr1031553pgt.78.1585604232842;
        Mon, 30 Mar 2020 14:37:12 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m29sm10065043pgl.35.2020.03.30.14.37.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 14:37:12 -0700 (PDT)
Subject: [bpf-next PATCH v2 3/7] bpf: verifier,
 refine 32bit bound in do_refine_retval_range
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 30 Mar 2020 14:36:59 -0700
Message-ID: <158560421952.10843.12496354931526965046.stgit@john-Precision-5820-Tower>
In-Reply-To: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
References: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Further refine return values range in do_refine_retval_range by noting
these are int return types (We will assume here that int is a 32-bit type).

Two reasons to pull this out of original patch. First it makes the original
fix impossible to backport. And second I've not seen this as being problematic
in practice unlike the other case.

Fixes: 849fa50662fbc ("bpf/verifier: refine retval R0 state for bpf_get_stack helper")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 804a39a..cddae95 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4335,6 +4335,7 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
 		return;
 
 	ret_reg->smax_value = meta->msize_max_value;
+	ret_reg->s32_max_value = meta->msize_max_value;
 	__reg_deduce_bounds(ret_reg);
 	__reg_bound_offset(ret_reg);
 	__update_reg_bounds(ret_reg);

