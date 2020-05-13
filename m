Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B811D1EB3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390586AbgEMTMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390542AbgEMTMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:12:45 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02603C061A0C;
        Wed, 13 May 2020 12:12:45 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id n11so828270ilj.4;
        Wed, 13 May 2020 12:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=OUd0GDQJahLBtNJE0ibxQ4AsLs8pJTnCoEKD4ekKERM=;
        b=Ri5D/2JSxUyE2kVo+sDGkfltvvW6yhfyKr36d/SjvF/v5r5rJki4ESozSPu3D3yGKn
         6PyJxHa1UkguwCiioWCpWyxtIB07WccN5mtm7WfkLZOxxAkUq3cYegWOiqoZB3PiKHTD
         pzaCcC5Yw7NQmgojJP3ugEZ14HJe1btZhLovzvU9s0SYx7zylIIZIVrYA1NjvsZHO6Jb
         iIlO2t5YWzFdj3eFSxNnAhY5yX9Fs1bzmIM7lOe6MAd+MgPe66V1AmSOQTLY/7rcoKrX
         L0qB3ZSs4gNTnguK9neGCloq5Hqi8Go4QDSuA6UlTt4QrN0qAw0kpBpb/Td/9venZK1X
         W8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OUd0GDQJahLBtNJE0ibxQ4AsLs8pJTnCoEKD4ekKERM=;
        b=W6Z2OqVhWmCYJ/GAYLm3ariGd7BKJ12UF62JgBRK0QXKg+/ZgaS5zBVWrztiwOz3gE
         a47FPD/hgmhXXq+BFe7fxF7SHKQmLA5lA3+5j9W/WL68yxMK9mmpSwlXgTNKEaTy2Nww
         vHnhvCco2KhHVLPUtud/0AYaJ7C3tiMDjdfqG9vKwHLQqKLVuL5C17D38w2WdP409AU0
         KOioGJMhU876nPXXTss+DuZmDsvipKyArfdHqHonmvGlz5M/srxA+Xxa0HOKhR7jywSG
         BD9qFXMEg7ArbxiJV1lqZUvBL+IOKx5SSZyWybDbYsFrOTR9gbmTQZOsEz7Tgd2xSW1P
         K9yA==
X-Gm-Message-State: AOAM530AQzvqwMhDrUTOML97/6atkrbdEf4a6pY/1DZs/9EgCbeWzdPv
        zSITUKnbeX6CU9rS0iD2XXptczlJ
X-Google-Smtp-Source: ABdhPJzKNz6IHv8oHpTbS+xXyI7yK8O4B77HcJYJ8MuWbVtgzDkKoDBWbhPa0RH5mlBwJzYndOPzJA==
X-Received: by 2002:a92:d20a:: with SMTP id y10mr923506ily.17.1589397164289;
        Wed, 13 May 2020 12:12:44 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q13sm206718ion.36.2020.05.13.12.12.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:12:43 -0700 (PDT)
Subject: [bpf-next PATCH v2 01/12] bpf: sockmap,
 msg_pop_data can incorrecty set an sge length
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:12:30 -0700
Message-ID: <158939715042.15176.13948401431530778597.stgit@john-Precision-5820-Tower>
In-Reply-To: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
References: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sk_msg_pop() is called where the pop operation is working on
the end of a sge element and there is no additional trailing data
and there _is_ data in front of pop, like the following case,


   |____________a_____________|__pop__|

We have out of order operations where we incorrectly set the pop
variable so that instead of zero'ing pop we incorrectly leave it
untouched, effectively. This can cause later logic to shift the
buffers around believing it should pop extra space. The result is
we have 'popped' more data then we expected potentially breaking
program logic.

It took us a while to hit this case because typically we pop headers
which seem to rarely be at the end of a scatterlist elements but
we can't rely on this.

Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 0 files changed

diff --git a/net/core/filter.c b/net/core/filter.c
index da06349..dfb4f24 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2579,8 +2579,8 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 			}
 			pop = 0;
 		} else if (pop >= sge->length - a) {
-			sge->length = a;
 			pop -= (sge->length - a);
+			sge->length = a;
 		}
 	}
 

