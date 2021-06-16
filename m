Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267853AA715
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFPW5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhFPW5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 18:57:40 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B296C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:55:34 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id s26so962604ioe.9
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 15:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=KgcDupNr6WzckA/mD3zDMlYk7N37gqCIpQ3Xwu0Qvtc=;
        b=DCHWGrfhDE7QG2ybVwvdLsjflOHljDqYk/q3y9A6pUkHQ4wdy9inFN3ugjG8Fxt6zU
         4RNzWEhUfxBE4c5u9XxUiwbSyQobBgSZksF7RkyIcm8DOil0zL0SoWcV5N5uEFpCuoJx
         8F3K3NIJk9kwAva+s9IHnuqWfcMlheM1gGibrEt9r/vKf73uR/26V8iU1aiUNLMWa7MH
         k8yixSUHg8TqYr5ALQUiQxQD+gfJA0QuOPNxhn6NXvco45Bc6qp3qEog2HKTPE10ZdZk
         OXTSmpviqwAG8C/ddvXzk5CDjPLWu+C1PtVx97MQxeU/uUF8kXhraObCzqMayjxmW0U9
         YE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KgcDupNr6WzckA/mD3zDMlYk7N37gqCIpQ3Xwu0Qvtc=;
        b=ShsbwudCBPRWaBxjPSjPryqhKFbQJukbFcBZL+nqWMS9C8+tEG/INdKq6I1BuXmJ7U
         8su/loHUlNPG/QQXh7njUKhI3JhlBknKaJtub/Xp8EvIOF3d2fhh+psXL2HlvF1e7/MM
         4OwRzlOVgOs0Z3x8kxDM3PMRka3CNxp0GZ7Ubdt4nSl755mqR+P2LCxiEkb4CFKjs17A
         RrSrZsQC0LW8IdG9zTFbXF2zzAra2Ey+BNf7J/kpfec7lRA3sRjWu4GSStUg5FNVEN5P
         nhmuXbdyHPUFtHkqqnxmrVgaAtWTIRp8iOyaSxKJO27yxcMYgfpkw36nXB0qxMDuqDWy
         j0Gg==
X-Gm-Message-State: AOAM533cSnsGRs7N8Z2noLj9I/CkRZYMRrxFOnivb7aTh2lrnoR/NUEH
        GuyxFJmnfTu8bL61KWSfGZw=
X-Google-Smtp-Source: ABdhPJxNazkXRdv4QQyBCHnj3N4TKx0Dj8NSwwNKV5JSbe4zxk5T2tvld3bmsGo0tRcfiHAhc9nVlw==
X-Received: by 2002:a6b:e40a:: with SMTP id u10mr1336978iog.200.1623884133700;
        Wed, 16 Jun 2021 15:55:33 -0700 (PDT)
Received: from [127.0.1.1] ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id z14sm1827639ilb.48.2021.06.16.15.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 15:55:33 -0700 (PDT)
Subject: [PATCH bpf v2 2/4] bpf: map_poke_descriptor is being called with an
 unstable poke_tab[]
From:   John Fastabend <john.fastabend@gmail.com>
To:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 16 Jun 2021 15:55:19 -0700
Message-ID: <162388411986.151936.3914295553899556046.stgit@john-XPS-13-9370>
In-Reply-To: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When populating poke_tab[] of a subprog we call map_poke_track() after
doing bpf_jit_add_poke_descriptor(). But, bpf_jit_add_poke_descriptor()
may, likely will, realloc the poke_tab[] structure and free the old
one. So that prog->aux->poke_tab is not stable. However, the aux pointer
is referenced from bpf_array_aux and poke_tab[] is used to 'track'
prog<->map link. This way when progs are released the entry in the
map is dropped and vice versa when the map is released we don't drop
it too soon if a prog is in the process of calling it.

I wasn't able to trigger any errors here, for example having map_poke_run
run with a poke_tab[] pointer that was free'd from
bpf_jit_add_poke_descriptor(), but it looks possible and at very least
is very fragile.

This patch moves poke_track call out of loop that is calling add_poke
so that we only ever add stable aux->poke_tab pointers to the map's
bpf_array_aux struct. Further, we need this in the next patch to fix
a real bug where progs are not 'untracked'.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6e2ebcb0d66f..066fac9b5460 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12126,8 +12126,12 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 			}
 
 			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
+		}
 
-			map_ptr = func[i]->aux->poke_tab[ret].tail_call.map;
+		for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
+			int ret;
+
+			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
 			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
 			if (ret < 0) {
 				verbose(env, "tracking tail call prog failed\n");


