Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221802AA7B1
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgKGThu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgKGTht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:37:49 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938A6C0613CF;
        Sat,  7 Nov 2020 11:37:49 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id i18so4685484ots.0;
        Sat, 07 Nov 2020 11:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=mK8EcpMsyTZuMSNqvmeAlfQ0aQLRFp87PX4fdIGzBn4=;
        b=gjWxp80gZgE+YGHoTOKnq9YD637wot/YEeto+s1gcMnTYmWKPHYmpeHSszRE196XCI
         Q1JcP73RP31aT7UbmK50KAHwVC7cNFmajQCFs6tV++dzWJRsXFGnQwWgh2KktJ5lnBFv
         tlheWaA4+ki0Vh87WTXJgPyB4qY66j6unDSeJshxzzLU8tawo2sOCoIrNb4fhBBjWpQE
         bV2LVSbg9+yp9Q+XvtJJICfpu+0nQYGybg7X9cL89FK4R8WNmCD/iicnA6F42yrD/2Mi
         QjFsWeaFiV+/x5CMgD41lugLd319jc4+sSurFPLX6lr6HMk8oZ++5SzMyAy+flKmVMZg
         ItFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=mK8EcpMsyTZuMSNqvmeAlfQ0aQLRFp87PX4fdIGzBn4=;
        b=WhjOhMnw3Yfp4jGSmvfCqm0qp7wKk8EMiSfAGO5Wz+TD9liIP83snmFxSEjA+JA+o/
         K7H6i7cDZwB5F1jpk2g7ukuYUfXGNbrfEPqPP2O57W27CBpv79XCvXPm5FcPSONzbPus
         5P4G/MRW3j4WBmwt7sVyQjPvbUIjq1HbEpEb7jVfC+yWqKgw1hwqHkHbH89C/DP7BlPx
         RouVU77zWsPM8FdBUuOdCEM181hNQQSyPZROtyAcvqkLHtmlVXPb1b+xTeyl5UI9GYSg
         kieDbI7PQ/z0aN3Ttc9bDoBFmRTOnHOeE2FbRzZailaGz/bdTjMJnLPSbE4/f5ybnnri
         OsuQ==
X-Gm-Message-State: AOAM53396PGfFjXcAnx/4truZxu3OmVPaQuZ6kLIY8kCBWJOKopa3u44
        YDHZLXGICgkaNGw+jfuomFg=
X-Google-Smtp-Source: ABdhPJzTnPbzt8Hxvsh8eVn/z3rxy8SpPgdpqcFqmJP89l+xT1cTRiYjl2IlZ7i784STDv4EXcTvXg==
X-Received: by 2002:a9d:896:: with SMTP id 22mr5289552otf.55.1604777868857;
        Sat, 07 Nov 2020 11:37:48 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w79sm1233977oia.28.2020.11.07.11.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 11:37:48 -0800 (PST)
Subject: [bpf PATCH 0/5] sockmap fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Sat, 07 Nov 2020 11:37:35 -0800
Message-ID: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This includes fixes for sockmap found after I started running skmsg and
verdict programs on systems that I use daily. To date with attached
series I've been running for multiple weeks without seeing any issues
on systems doing calls, mail, movies, etc.

Also I started running packetdrill and after this series last remaining
fix needed is to handle MSG_EOR correctly. This will come as a follow
up to this, but because we use sendpage to pass pages into TCP stack
we need to enable TCP side some.

---

John Fastabend (5):
      bpf, sockmap: fix partial copy_page_to_iter so progress can still be made
      bpf, sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
      bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self
      bpf, sockmap: Handle memory acct if skb_verdict prog redirects to self
      bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list


 net/core/skmsg.c   | 84 +++++++++++++++++++++++++++++++++++++++-------
 net/ipv4/tcp_bpf.c |  3 +-
 2 files changed, 73 insertions(+), 14 deletions(-)

--
Signature

