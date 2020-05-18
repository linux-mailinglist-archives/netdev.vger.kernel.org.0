Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C781D88BA
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgERUC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:02:28 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2FAC061A0C;
        Mon, 18 May 2020 13:02:28 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b71so11140519ilg.8;
        Mon, 18 May 2020 13:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=qG6CzFspXTrW0Gr3aKl9tJJqH+iWUrU5Shey0sxH0PY=;
        b=P2iHXiPEQ0/dvDS0ct4fm5s5M712XvhvqDSyPB62i3RIN/zP3xVutH4gG47lAK+ap+
         EkttrG4s+UN/cVJhYwO80JQHvpt8moVs2u8bsAGNhENEg1ZwGEgf1QSW6UweftiCW+oF
         rmDeqWfLvRKDmYzDG/5p8zXVBUTbCUwTg+R3WR7LP786qKnD+sBtbwQg+LnCUtwiHzNI
         lZBkY2K5vuydjWV25M1qgDCKhGIkSB/yp1wPPbc6FqzXHg4OMyLnculZwibIYFuW0TY3
         RzMO8FpGYr/HhjIP0l440nJvVIOEaqNWxe3s13XILXaDfiGkkDajXWGAEYBKNHZJLI9B
         7axA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=qG6CzFspXTrW0Gr3aKl9tJJqH+iWUrU5Shey0sxH0PY=;
        b=Ug4yV3RtbyeyLqKo9iGSjIo2qVbd5LDQKClrEdkv+KnbZ5vR1FmbqdX7Qt60ITeWp5
         KK5w9wyg0wBEvUnPIgPj7ZEWxLOW8Hu+GXSk2MwcWKETGPqvda23xsd2BCc/PUh4N6UN
         nUWWuOf/c+PDGZMermpODmIlJ3GLbS2xRQZ+NLR6Fq4m59bIdqENJw1YoP0WGWfHIRmZ
         gw4aN5WSdBDBW58GeMexP1Z4QpZWo20ZyHDqCXfJoAxHqfdvQDiFzGiBAvYf4BYkNRsz
         Og9VChYpcVKn4u2WjxJNRmnizaAu7EiloJz/6pt35AoweZJ3MsuzOZSf+NDIrnKVCZCI
         tXWQ==
X-Gm-Message-State: AOAM533/31wvFM4U6K6KU09RWOZJ5IKfak39bgwF1GpSlgbn7d9IUy1V
        NRaDOMqKyNTAFGDIu9y/xHE9T5WU
X-Google-Smtp-Source: ABdhPJzcWxm8u0Gzi+rDovlHbrnaCBT4uodLPGQosd8SQvbKQ67eweTo2lY93OBvAGVXsFhIetauXQ==
X-Received: by 2002:a92:9e16:: with SMTP id q22mr2015345ili.17.1589832147580;
        Mon, 18 May 2020 13:02:27 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t22sm4288295iom.49.2020.05.18.13.02.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 13:02:26 -0700 (PDT)
Subject: [bpf-next PATCH 0/4] verifier, improve ptr is_branch_taken logic
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 18 May 2020 13:02:14 -0700
Message-ID: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verifier logic to track pointer is_branch_taken logic to prune paths
that can not be taken. For many types we track if the pointer is null
or not. We can then use this information when calculating if branches
are taken when jump is comparing if pointer is null or not.

First patch is the verifier logic, patches 2/3 are tests for sock
pointers and map values. The final patch adds a printk to one of
the C test cases where the issue was initially reported. Feel free
to drop this if we think its overkill. OTOH it keeps a nice test
of a pattern folks might actually try and also doesn't add much in
the way of test overhead.

---

John Fastabend (4):
      bpf: verifier track null pointer branch_taken with JNE and JEQ
      bpf: selftests, verifier case for non null pointer check branch taken
      bpf: selftests, verifier case for non null pointer map value branch
      bpf: selftests, add printk to test_sk_lookup_kern to encode null ptr check


 .../selftests/bpf/progs/test_sk_lookup_kern.c      |    1 +
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   16 ++++++++++++++++
 .../testing/selftests/bpf/verifier/value_or_null.c |   19 +++++++++++++++++++
 3 files changed, 36 insertions(+)

--
Signature
