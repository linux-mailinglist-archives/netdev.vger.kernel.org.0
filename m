Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E854E2796E2
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 06:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgIZE1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 00:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZE1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 00:27:00 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA4DC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 21:26:59 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id x69so5021660oia.8
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 21:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=wWYHO9gA850tTcEE2d5sVOLFoekcrBikSrj3VJ6jQVA=;
        b=eFt8y8YSSkln6NfC8eXCFToHvyUnzdoCagCgg12edRgC0zcxIL5J0UhDqj01g5n+U1
         IRDrbrtAysIodLHli/VRqp3+k7AXUgwOk119bZUaqVKmptCYDrAq90Lpgnkb/xJD48Gr
         N24IHcsPjI5JIBH5k3/UwAOih9BQ/AkF3eK0m/68NGo0UcVec7R+PuCFEEN2Ci5JDjUC
         7P8cyET6hHxQJXNzpSyvlR2M/K09i3pd6rn/50S5cbr4fIhGe+3jWZ0dKCDxFVSbSWYc
         yhJvPDbT1TxfxxfaWXi1y+uw7KaMH9fX+kL+A4yHyhXbqwFOVb17oUPS0eV514+pPG4r
         eE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=wWYHO9gA850tTcEE2d5sVOLFoekcrBikSrj3VJ6jQVA=;
        b=e4HVqpMlZT/bsfcFHWhauf96n4B9H1Q/8eS2Z/urBefVvE9Mx9++VbqV5qA7uKtfPX
         6mFF3VV6ZNubDBdY57eOPmP1D7QL0IHpkZOt+/UqBGkBeBYAc/Jcr44fKnvbrow1wQVQ
         pObh90A8LsAsCFmeV9lUOGatwwYLJFdaaA8/yX3xW3NVMEfthccm3lWOv+PRlcOViJSA
         2q3/qiEbMh+qW6FI346eQ+gKubPWAp+ZbV7U+kyrpPmSSg3YZDX05Cjhodj0o3Yop5Cp
         QZX86tTtrJyi2ic29n1ieSRHZIGo4keNlJ3KGLTelXO1i+LJVdxOCeSrOeBwcY6JjW84
         0SKA==
X-Gm-Message-State: AOAM532arebNDTChDx4F32GbKLVR30wb2zSx9wt3Mq2E5PE//8AiIlF0
        Cb4BqlDvZ9XsdFo+58LsdJSYhe9AydIO/Q==
X-Google-Smtp-Source: ABdhPJzsr/yCs8R5Q7RkCemSA61DYDmO7SzPKFbpW+D231qGXX+wUqbc2/yitUau3tflkAX0zE187w==
X-Received: by 2002:aca:c144:: with SMTP id r65mr453960oif.166.1601094419099;
        Fri, 25 Sep 2020 21:26:59 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r62sm1095432oih.12.2020.09.25.21.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 21:26:58 -0700 (PDT)
Subject: [bpf-next PATCH 0/2] Add skb_adjust_room() for SK_SKB
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, lmb@cloudflare.com
Date:   Fri, 25 Sep 2020 21:26:41 -0700
Message-ID: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements the helper skb_adjust_room() for BPF_SKS_BK_STREAM_VERDICT
programs so we can push/pop headers from the data on recieve. The
obvious use case is to pop TLS headers of kTLS packets.

The first patch implements the helper and the second updates test_sockmap
to use it removing some case handling we had to do earlier to account for
the TLS headers in the kTLS case.

I have a couple more series to flush off my stack then I'll work on
modernizing the test_sockmap tests themselves. It was created before
global data and a few other nice things so its a bit more verbose
than necessary.

Thanks,
John

---

John Fastabend (2):
      bpf, sockmap: add skb_adjust_room to pop bytes off ingress payload
      bpf, sockmap: update selftests to use skb_adjust_room


 net/core/filter.c                                  |   51 ++++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_kern.h        |   34 ++++++++++---
 tools/testing/selftests/bpf/test_sockmap.c         |   27 ++---------
 3 files changed, 82 insertions(+), 30 deletions(-)

--
Signature
