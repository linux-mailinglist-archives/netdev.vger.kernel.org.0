Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8EF63F739
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiLASMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiLASMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:12:05 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BA6A1C0A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:12:04 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id x13so1087455ilp.8
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l3glljPevHLdaoBzLBWNwFXRN7RcGOCNYiinqEgq4/0=;
        b=JS8Sj1+i5nHW2tpMIxi+z4ilQRStIWB7+Fq6pamNnjajP6dr9/CgROQGQANaTp+NvE
         SWwAYvEE97hgruJDAF80n93mtjhVOSPt7U+JNdZXvaU4JqVKkOoTfEHXsrqgJmwux2Qp
         GOXX+lv/d/Tvwzwfwj/lbas8EMhh1NwFms182hiED2Dctmrq5ct6SkMTOprnCc0i6OEg
         iZz5BFRfhv5O8M20rbdKm4MJQ4ixmUi7JRnyp3aHONC9CstCIo5h9g3B5Ma0PhJv9eFf
         NC+Y+6k5pNvTLu5pmD0Rk0XeetV0HA5cFFn53D9IOIkSSHBNKnepm784rDG/MAd1U5hh
         rtGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l3glljPevHLdaoBzLBWNwFXRN7RcGOCNYiinqEgq4/0=;
        b=11n/ZgyT8DUL0gGaQY3G8ZPD2BaQJu2IChp0C3JTFlHg6TGlHa84/WRaYRJcDm14c9
         EArjhQc6M+EEcWsk/ypprAAVtLw15RH2q2tb8si4um6SCUoaIqfWhBzJOgYd6IC+edbt
         +h8ZfPJCoTBSY6e90oG7oSWuE7jeN0qcUO2gOhCVSaYRsQIdEeonAum7yqo/7H4wRNT0
         6NMT7bbp6FjTwDvEFnfdaNG9u8acNg9hkOXqsZMoapx+/44DYCVGDUqygUqUwY6MDqpV
         T50NnGt2fTf+oybiBlDx5XxkqQ6f+UnaE3vNbWmtfQ0y389kWVfRYWGcs7kVWvWMX/IU
         ENGA==
X-Gm-Message-State: ANoB5pl8yu8m08OhomLqik4xsGCXQkWPUWj1ECtajH+knVIeAEecpxw4
        VbEXb+P/QJcVBCZhy4QWXvi5xw==
X-Google-Smtp-Source: AA0mqf4IEbw5mAd3F2JAgfJ0NkI2GvjVcFlcGoc5Y1ZoUFTwW8k9WWBsV8tyuXRM1MkY6++S7yr9+w==
X-Received: by 2002:a05:6e02:1a63:b0:302:a682:485e with SMTP id w3-20020a056e021a6300b00302a682485emr21887861ilv.168.1669918324027;
        Thu, 01 Dec 2022 10:12:04 -0800 (PST)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y21-20020a027315000000b00374fe4f0bc3sm1842028jab.158.2022.12.01.10.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 10:12:03 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     soheil@google.com, willemdebruijn.kernel@gmail.com,
        stefanha@redhat.com
Subject: [PATCHSET v4 0/7] Add support for epoll min_wait
Date:   Thu,  1 Dec 2022 11:11:49 -0700
Message-Id: <20221201181156.848373-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

tldr - we saw a 6-7% CPU reduction with this patch. See patch 6 for
full numbers.

This adds support for EPOLL_CTL_MIN_WAIT, which allows setting a minimum
time that epoll_wait() should wait for events on a given epoll context.
Some justification and numbers are in patch 6, patches 1-5 are really
just prep patches or cleanups, and patch 7 adds the API to set min_wait.

I've decided against adding a syscall for this due to the following
reasons:

1) We, Meta, don't need the syscall variant.
2) It's unclear how best to do a clean syscall interface for this. We're
   already out of arguments with the pwait/pwait2 variants.

With the splitting of the API into a separate patch, anyone who wishes
to have/use a syscall interface would be tasked with doing that
themselves.

No real changes in this release, just minor tweaks. Would appreciate
some review on this so we can get it moving forward. I obviously can't
start real deployments at Meta before I have the API upstream, or at
least queued for upstream. So we're currently stuck in limbo with this.

Also available here:

https://git.kernel.dk/cgit/linux-block/log/?h=epoll-min_ts

Since v3:
- Split the ctl addition into separate patch
- Gate setup of min_wait on !ewq.timed_out
- Add comment on calling ctl with wait == 0 is a no-op

-- 
Jens Axboe


