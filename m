Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7702CC966
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbgLBWLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387442AbgLBWLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:11:01 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CFCC0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:10:21 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w6so2147585pfu.1
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=774IxFvxtEcksvpFGz8hbT30bXwYiShxKYm2dingbMk=;
        b=TW8kQCxtvvRlOObspD8xhhcwj88oCOFqlogHS8gyrEFgV4GiTUATzP6ZNZQ1gP5XKr
         LUJTo/miQZzooD5/oa0ai5ujWLKZehAFuWFx5VbbzUcMf3cQoBy26rkkjiw+q0Q9QBVc
         65tT5zMvbWCEBpnPgunEsgjSK8eYCZlfDUWmknnlPvPD7KIxqeM1kcapeezpzPIv/28r
         24OMjcrzHh7+RX7ahE9M9Oy5oRKM2p5NYNhLhqi58MY4tlSgJpdhFRxrMPwiErW5ob5o
         d08cjjor6AAzhmpzrfsoHKoS9I7Mg9JQWoG49I1DyFJri1s2H+LlnLi73MtIvcCx+sAD
         xzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=774IxFvxtEcksvpFGz8hbT30bXwYiShxKYm2dingbMk=;
        b=E61d+Ko2d6c4Bpxy8Bbpht/f7HcjqWQR2LuxYiqqWE7E6MTQ2ABWagmaziJKc/ONN1
         w7OaqLc4AQTtG+HeQQWHY8ssEbh0tzvkhPsMVcaEbCxgs7HHaYdvf/OzGhW0klcaARgk
         1i1JHxvkCUEzdAFXAoRQUnm8Jt0Oy+gtgoitt153CGmDHaKiOVbC+lhTJyhpmJS3jrUq
         tx1/INHwpIz9FnhUgowKoR5J6LZg7CnpYfOz5cX2EVeA5PpmI5yRcRgrGQ9z6+ly/zAN
         RU5XE8/mpklvAsbhkqHJuEz2c0SDzHmd+uV+90mUwNJC5e2/0KKrbtVBV8w6egQWDziI
         ob0A==
X-Gm-Message-State: AOAM532SWkQHl0V9jBT6ycWiUr8n8QVX3d3YHCL32NRhaU4ULM+kkXN+
        2PsJWnoT+u9DuLsTbiOUxRk=
X-Google-Smtp-Source: ABdhPJyFl8A35N+CSf54h4dRapovfHWobauiF0A6lExmXTRhVaovb9DkBDow6zRYw2MpZrMwr9zLCg==
X-Received: by 2002:a65:4346:: with SMTP id k6mr322787pgq.83.1606947020673;
        Wed, 02 Dec 2020 14:10:20 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id p16sm4872pju.47.2020.12.02.14.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:10:20 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v2 5/8] net-zerocopy: Fast return if inq < PAGE_SIZE
Date:   Wed,  2 Dec 2020 14:09:42 -0800
Message-Id: <20201202220945.911116-6-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Sometimes, we may call tcp receive zerocopy when inq is 0,
or inq < PAGE_SIZE, in which case we cannot remap pages. In this case,
simply return the appropriate hint for regular copying without taking
mmap_sem.
---
 net/ipv4/tcp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4bdd4a358588..b2f24a5ec230 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1889,6 +1889,14 @@ static int tcp_zerocopy_receive(struct sock *sk,
 
 	sock_rps_record_flow(sk);
 
+	if (inq < PAGE_SIZE) {
+		zc->length = 0;
+		zc->recv_skip_hint = inq;
+		if (!inq && sock_flag(sk, SOCK_DONE))
+			return -EIO;
+		return 0;
+	}
+
 	mmap_read_lock(current->mm);
 
 	vma = find_vma(current->mm, address);
-- 
2.29.2.576.ga3fc446d84-goog

