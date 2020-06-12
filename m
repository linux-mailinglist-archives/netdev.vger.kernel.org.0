Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E571F7B57
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgFLQCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 12:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgFLQCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 12:02:00 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E93C08C5C1
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 09:02:00 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id p5so10239543wrw.9
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CFpEfyDCKd+ROB+iqmoyjwPMNPUKHkA0Y5oDot+dn0s=;
        b=qAABzAjm7oyQ4y1NqFm33ALKrsWUTBS3S09jG4BqvwbL0xCN56LMsAbtG51HFlJJAZ
         3lEuMT+JxCIBTR/jTJile+umYMucfLBAk2oSartCDjmFOPV8RlhVnJYKxMHsbyjWFfDw
         7eX9x99JBypZN8IsO8/xQR9TZ/5a98L1iUGqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CFpEfyDCKd+ROB+iqmoyjwPMNPUKHkA0Y5oDot+dn0s=;
        b=HqXxMoLBlafN/B1Hj+eUlPtps/qnCPVvUs2uExEfFiicIkC8RkcOIEwDbD4Y0LT0X/
         ehCs+3SOzmck2Ux2nYghSFPAclywUKJxZeXgDAO/JZu79S0FD87/Yu24AaY4RGf5ZPX2
         fpx8pIPr5cRWCm0BBel7FeC5QTLCRvx0/1x72lDuoh2NXtmA47M7eiyTgJ/U+vFL34Fy
         MACBdaTp3YHk6NsS0DDqP1VutR0sdDaI+TOMXSK+s8oRLs6mOlSWWFzGTdm/LUgVfvEa
         HalJQRkXiA3Rs36QAto8NSNOn3iX+ALRxY3eKlMkPsN2F+7l1rjSN1QmbI5M+5iCi8Ky
         C6Eg==
X-Gm-Message-State: AOAM531DDMUVUbF3iZ6MFRa4MsnA2hZZbkGny0oaUkvYyZwgSCh62wUE
        qEVRStbDUlhppNjWg0bOtqu3pw==
X-Google-Smtp-Source: ABdhPJzJqYbDDGNdygvO/gn5chT5tfnHECzwSmpvROBRkZCI0/ho0BoMfKX6FdsDVl3UTVhkTu/MAQ==
X-Received: by 2002:a5d:498b:: with SMTP id r11mr14866701wrq.328.1591977718846;
        Fri, 12 Jun 2020 09:01:58 -0700 (PDT)
Received: from antares.lan (1.e.7.e.0.1.3.6.1.5.d.2.f.1.0.9.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:901f:2d51:6310:e7e1])
        by smtp.gmail.com with ESMTPSA id k16sm11169941wrp.66.2020.06.12.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 09:01:57 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf 1/2] flow_dissector: reject invalid attach_flags
Date:   Fri, 12 Jun 2020 17:01:40 +0100
Message-Id: <20200612160141.188370-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using BPF_PROG_ATTACH on a flow dissector program supports neither flags
nor target_fd but accepts any value. Return EINVAL if either are non-zero.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Fixes: b27f7bb590ba ("flow_dissector: Move out netns_bpf prog callbacks")
---
 kernel/bpf/net_namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 78cf061f8179..56133e78ae4f 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -192,6 +192,9 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	struct net *net;
 	int ret;
 
+	if (attr->attach_flags || attr->target_fd)
+		return -EINVAL;
+
 	type = to_netns_bpf_attach_type(attr->attach_type);
 	if (type < 0)
 		return -EINVAL;
-- 
2.25.1

