Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977112968BF
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 05:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374845AbgJWDaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 23:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374835AbgJWDaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 23:30:22 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBD6C0613CF
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 20:30:22 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id d16so115302qvy.16
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 20:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=q84jJ3bGQh9hixZvKUeeIGN3DtugPKTamoF/dyrHLFI=;
        b=tz+FVd1pN36tw1bBQmvqr+Y2n0MIU+W7R+izbV8oJ8fgeAKPZoplKAvJcLYPYctDkN
         FiltZT50WLAaR4aspJVHloJjO6Yw1L1Qo2/gY707fc0byoSUHUFN4+yUOfmvLN7b7BLf
         dFvtLW5stbWzfFZn3avsXzwdQ5dlSZJ8ADvMW8xLX8kg/cMUonSvv0jYUXn/Y7Ax8PvG
         3hAzTfDOVNGkgm+apl6pysVZC+xovU7QLo3krg1eUDk/srcG7SOLFJaiJleL6ahNbCxA
         DCkMacJ9RvSY6jYKBxMbCsMGmthYVsXsNzmhdmF9SZIZlLoeQ+5G6/o8OcyIVvsEkQaw
         U9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q84jJ3bGQh9hixZvKUeeIGN3DtugPKTamoF/dyrHLFI=;
        b=ItmNai/SLupHB8sfKnkHIiAK2O2TcGRhpT4gmYimn7NpceEPoHkCst0UCnr3CrOHd6
         muBxmU267Fw0OIdZN2FXaqoB9yUQNmnWJ6/vQwVpwpsGC4WkchWUGR0cIl2cyhUZ2z2z
         G46am/LTKEI5v4e5alYVR2/zs0ViTfnMuAv0Cn6dASQBh6krTmnNsolYJKufV5epnQq2
         FtcAAO1SzxhbSYA0nNj+wOo91vIQ4FH+vEmRV4h7IqwYD2LpaCJBIJV4fWDZIMebRx04
         xuc2hpyhaWLOjufc/snPdF1Dz5D+Q5Wkwwj5ESMbOFmU4OgSfznGAfhKIAPvrqb0e72c
         IgXQ==
X-Gm-Message-State: AOAM532x5IbuMnga9uZgXeR/1iaXbp7loF/4rSN+Uzty6nnK76jNLcLI
        6AroVIIHizFGh/75o2M/6jeUOD+Ock2L
X-Google-Smtp-Source: ABdhPJxbtFDCbtjPjdxOYTFaImtDm6yGGHc8tKKsm9bUQfUsi1wM/ldih7BglY7z7cH9xMS1lGGikQ0vDTOY
Sender: "joshdon via sendgmr" <joshdon@joshdon.svl.corp.google.com>
X-Received: from joshdon.svl.corp.google.com ([2620:15c:2cd:202:a28c:fdff:fee1:cc86])
 (user=joshdon job=sendgmr) by 2002:a05:6214:122a:: with SMTP id
 p10mr488108qvv.0.1603423821912; Thu, 22 Oct 2020 20:30:21 -0700 (PDT)
Date:   Thu, 22 Oct 2020 20:29:43 -0700
In-Reply-To: <20201023032944.399861-1-joshdon@google.com>
Message-Id: <20201023032944.399861-2-joshdon@google.com>
Mime-Version: 1.0
References: <20201023032944.399861-1-joshdon@google.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH 2/3] kvm: better handling for kvm halt polling
From:   Josh Don <joshdon@google.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Josh Don <joshdon@google.com>,
        Xi Wang <xii@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the new functions prepare_to_busy_poll() and friends to
kvm_vcpu_block. The busy polling cpu will be considered an
idle target during wake up balancing.

cpu_relax is also added to the polling loop to improve the performance
of other hw threads sharing the busy polling core.

Suggested-by: Xi Wang <xii@google.com>
Signed-off-by: Josh Don <joshdon@google.com>
Signed-off-by: Xi Wang <xii@google.com>
---
 virt/kvm/kvm_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf88233b819a..8f818f0fc979 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2772,7 +2772,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
 		++vcpu->stat.halt_attempted_poll;
+		prepare_to_busy_poll(); /* also disables preemption */
 		do {
+			cpu_relax();
 			/*
 			 * This sets KVM_REQ_UNHALT if an interrupt
 			 * arrives.
@@ -2781,10 +2783,12 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				++vcpu->stat.halt_successful_poll;
 				if (!vcpu_valid_wakeup(vcpu))
 					++vcpu->stat.halt_poll_invalid;
+				end_busy_poll(false);
 				goto out;
 			}
 			poll_end = cur = ktime_get();
-		} while (single_task_running() && ktime_before(cur, stop));
+		} while (continue_busy_poll() && ktime_before(cur, stop));
+		end_busy_poll(false);
 	}
 
 	prepare_to_rcuwait(&vcpu->wait);
-- 
2.29.0.rc1.297.gfa9743e501-goog

