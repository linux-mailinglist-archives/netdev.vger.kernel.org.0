Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A882280BD8
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbgJBBJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387511AbgJBBJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:09:48 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5018C0613D0;
        Thu,  1 Oct 2020 18:09:46 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id n16so285144ilm.8;
        Thu, 01 Oct 2020 18:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=/6qquKajl0gAA1Z+sC84iA1iNgeVYcBko2LRfw/2OV0=;
        b=SaqQ7QNIjK525BFIT19QiFSzMkQid5wwGmNp2ywj9Jwug+YCqJ6fHyehIBsyRu9TxF
         E7JLV5wK+rSHqxnXhg/2chWbyOhYgQzOrsVU21qkPhSdsxcnCgOMztlEx7iGLrFyTVZX
         V0Slo7h5zyhELmKa25j0fSjZFMpSfAHw82CZaGviNsn7MxHzi3kfRAWK05r1f0bejc3R
         0Gk752yPZxoLK+BF4X9FqsMn1vOpFtcRPtJfUvYmiqCIThlkB58vXcbSGAIu1uGegtPW
         LEV2r7+if02Rq/HIXY9c1vULnXlsVhyPWMCDZrPo2IUTCoQzbQSnFLtluVgGDyjBhuFc
         hV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=/6qquKajl0gAA1Z+sC84iA1iNgeVYcBko2LRfw/2OV0=;
        b=Rw5H/EcgUSEn5ByfyeZ+7wahg8p9fWwVBThajPU9d65MfYRyYSAzBYdKFNqAjKFUYl
         1Aer2/Zkb0O3t7CiYhYn+NpuGCrc4lw4hsM9LVvWpyYcsZr5PYuxpKhJWxVNKM64sVm6
         s3WUwaMqZYiBvuigkiutyZEzmNfSSrwiYuIrgZcp5qLmQ45dHQ68cy8//++dWbPKolRj
         ydbtJ/e6phQXCEGJHsvvlU4XD0ljrX7UqwZgpOpvwxj64doEVNLJyLf0a404C8aKUpWk
         lHghTZtW6paS4RKHM3Zqq2W5fPEkAirSZj0N6Mf84Cvh16QBLUgLy9z4d9XlEUp0rVDh
         uE+Q==
X-Gm-Message-State: AOAM5304jn7xdJmk3XJsf5vwbodyhpZXavMXWsPsQ5gRkymPwKNKH7af
        lsy6oh2gZwlndIPGdfY3SXQ=
X-Google-Smtp-Source: ABdhPJyg7THg0YHqyIeyHmbtwOSh98aoabUhFQW2zHsVScwXWh8snBWcDy8kL3/6miAYt/UHMLWIXQ==
X-Received: by 2002:a05:6e02:8f:: with SMTP id l15mr4743219ilm.119.1601600985928;
        Thu, 01 Oct 2020 18:09:45 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n138sm1495156iod.40.2020.10.01.18.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 18:09:45 -0700 (PDT)
Subject: [bpf-next PATCH v2 0/2] Add skb_adjust_room() for SK_SKB
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 01 Oct 2020 18:09:34 -0700
Message-ID: <160160094764.7052.2711632803258461907.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements the helper skb_adjust_room() for BPF_SKS_SK_STREAM_VERDICT
programs so we can push/pop headers from the data on recieve. One use
case is to pop TLS headers off kTLS packets.

The first patch implements the helper and the second updates test_sockmap
to use it removing some case handling we had to do earlier to account for
the TLS headers in the kTLS tests.

v1->v2:
 Fix error path for TLS case (Daniel)
 check mode input is 0 because we don't use it now (Daniel)
 Remove incorrect/misleading comment (Lorenz)

Thanks,
John

---

John Fastabend (2):
      bpf, sockmap: add skb_adjust_room to pop bytes off ingress payload
      bpf, sockmap: update selftests to use skb_adjust_room


 net/core/filter.c                                  |   46 ++++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_kern.h        |   34 +++++++++++----
 tools/testing/selftests/bpf/test_sockmap.c         |   27 +++---------
 3 files changed, 77 insertions(+), 30 deletions(-)

--
Signature
