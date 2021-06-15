Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34E43A73B5
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhFOCZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:25:45 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:33499 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhFOCZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:25:38 -0400
Received: by mail-qt1-f181.google.com with SMTP id e3so10191215qte.0;
        Mon, 14 Jun 2021 19:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z52yKO5K3X5Hvoq0tYlNwZhMPzpoNySZf4mcZZAiaZU=;
        b=vN5+Wa+lJHNtFFHVR5feQYsws83JHCxtaSuRqWSqaTNwHQaD4RzcseqFUtJNCZ7U3s
         dZK1UmSg+dmv5gHARFTZoSaYJZMQvezr/cYkC2ooKdJsuR5m0Yjdnv5SwOLNnvCG4RHg
         9ekfBi4xRyoNQnyV5uyU3X8M4auqIDwCGGMp6Fzqx5/FjG5hiZ+EIfFWyUSTE1hQjghW
         pvZisqijUYmGZomY24jpcPq/lBvrX2O7MOjlOyHPeEbewqV3gmDvbu2zM5y2jWYSLPPG
         el1c0LcDJf/TPbNWglMejgWuSoa6VBlucKb0sMhYhcu1UJMtaa0UgXepz9oxvfwIOxiR
         zdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z52yKO5K3X5Hvoq0tYlNwZhMPzpoNySZf4mcZZAiaZU=;
        b=Eir+9Qly9T7lC4WO3s382bqdhHpKMGT3lakMdq4q+jWBXNQbp6EzutwIU+qbo/k0Eu
         DGbnSgDP5O8xOaCQDMbiXnZKDfgZbAjsSDrEcxqPTmEU1gOXneMZ48Mwcx+IrFu75DDv
         G79pfv0uH5C0fIQT6C99RwZa4fw8gueZnDWdiwrWIWbFsSBHCBwx/lnoQq6jCnBZNqVT
         8KInqVBMhcqao2d3/ZioWvOtMuX2ex6GNDxyJasYDK4Tcn9R5UWHmalg2NFq4QX7p8+E
         XZzGgBWtW87YVwyR6boC7YsLxbB0MpTqOPwdAJSNd5V138GsjwyWlkZcyUlbu8fWIG7w
         G13w==
X-Gm-Message-State: AOAM533xcgnwxDLzKzluWkVhl0UYLPwgcZg5mH+y6YwgKnqllfAwCLnc
        Cs3d+s/4+KxjQteUAars4Bfvtu/usX4Iwg==
X-Google-Smtp-Source: ABdhPJxR6w1DdVT90D/Rp7NsKchb++POdLW4kgPio3Fljc270AHLvsqVOuJ6Z8EfWpYSl+nWg2jaWw==
X-Received: by 2002:aed:3071:: with SMTP id 104mr19587096qte.119.1623723241624;
        Mon, 14 Jun 2021 19:14:01 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:14:01 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf v3 5/8] skmsg: fix a memory leak in sk_psock_verdict_apply()
Date:   Mon, 14 Jun 2021 19:13:39 -0700
Message-Id: <20210615021342.7416-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

If the dest psock does not set SK_PSOCK_TX_ENABLED,
the skb can't be queued anywhere so must be dropped.

This one is found during code review.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4334720e2a04..5464477e2d3d 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -924,8 +924,13 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
 				schedule_work(&psock->work);
+				err = 0;
 			}
 			spin_unlock_bh(&psock->ingress_lock);
+			if (err < 0) {
+				skb_bpf_redirect_clear(skb);
+				goto out_free;
+			}
 		}
 		break;
 	case __SK_REDIRECT:
-- 
2.25.1

