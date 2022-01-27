Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAEB49D6C9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiA0Agk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiA0Agj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:39 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4111C06161C;
        Wed, 26 Jan 2022 16:36:38 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id c24so1427257edy.4;
        Wed, 26 Jan 2022 16:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0AmekTP4r21rkMJ7bRtsO4g7zQcP+aSNIpQGg0GQSv0=;
        b=fvlE3FDiaBlj44JWLlSKmuQjeuwYs4Iv6sic6KaupAGxfmXkX0tSd1sBUnvq6YBvyI
         ISk4V5Yl8AiB9hU1U0WvS4Zk9V1XUlNth4S9AmgRBjY/93ASNNeajnyOtwACxRY/OmvN
         CN+Fz+YhYkYMtPfYKtWDxZ0fACqN5Qr4WtHwBhlj4yrklD2vknkjIgw5uacV+zNxEdTS
         CzzT34SIOLeiHKb9c1i+1sog4C1FQEqq0EI+Y0W//XrWSCgYP7EwQXpNJLTVlVPxdMlg
         fcfVqNQ6NEow+jPeIAZ4WD4bG0wCE7LTGQhTG7hh3TuUAgL17cvZIRnQjHvTMWrAlQfZ
         riYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0AmekTP4r21rkMJ7bRtsO4g7zQcP+aSNIpQGg0GQSv0=;
        b=WMmIZOM3eE6jmN2In2BNCQq8q7foKK321dN42UgvOKjGttuCh2zIdl6cRKXh+y3Y61
         tc8EeOHbaL3zD4ETh7ZAiLogpX+6ptJ31IBTxnvXpIX7EG1XOkoNbs5bszu4GT1ZtBpY
         876JcKwatdI2lwqpZp53UUim+WyoCr5RfK1Djqh61dCZkJ8BdAfKhXyuftiFdSCa56sT
         vKzFa9lVKKpC7Y8Yq1rGSbwCN8S3bD8RyloTcuXU3U7t5kPcPHqvYSsyEzyFLGxBiamu
         ulLR5V87YBuluq14xtNJHW0lckYDWowAPQUz6E9eLRT+AdwRCpum9azDK6z5aHZD4ws6
         SkPg==
X-Gm-Message-State: AOAM5337PdcEB7b8STuCfSrEGRnd42RlDegLdOCsSvpG2G1vQt8Ut+6q
        hIh+U/bz7B1jGehlUh3RwixA+dwAhsk=
X-Google-Smtp-Source: ABdhPJzZD9jc5NkO18zKcLkWVyXpyBx7C8TJx38rETb3bU0mu9yNqercdqrq16y2yYJZi1ZOk4tRnA==
X-Received: by 2002:a05:6402:548:: with SMTP id i8mr1457024edx.60.1643243797146;
        Wed, 26 Jan 2022 16:36:37 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 00/10] udp/ipv6 optimisations
Date:   Thu, 27 Jan 2022 00:36:21 +0000
Message-Id: <cover.1643243772.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shed some weight from udp/ipv6. Zerocopy benchmarks over dummy showed
~5% tx/s improvement, should be similar for small payload non-zc
cases.

The performance comes from killing 4 atomics and a couple of big struct
memcpy/memset. 1/10 removes a pair of atomics on dst refcounting for
cork->skb setup, 9/10 saves another pair on cork init. 5/10 and 8/10
kill extra 88B memset and memcpy respectively.

v2: add a comment about setting dst early in ip6_setup_cork()
    drop non-udp patches for now
    add patch 10

Pavel Begunkov (10):
  ipv6: optimise dst refcounting on skb init
  udp6: shuffle up->pending AF_INET bits
  ipv6: remove daddr temp buffer in __ip6_make_skb
  ipv6: clean up cork setup/release
  ipv6: don't zero inet_cork_full::fl after use
  ipv6: pass full cork into __ip6_append_data()
  udp6: pass flow in ip6_make_skb together with cork
  udp6: don't make extra copies of iflow
  ipv6: optimise dst refcounting on cork init
  ipv6: partially inline ipv6_fixup_options

 include/net/ipv6.h    |  14 ++++--
 net/ipv6/exthdrs.c    |   8 ++--
 net/ipv6/ip6_output.c |  99 ++++++++++++++++++++++------------------
 net/ipv6/udp.c        | 103 ++++++++++++++++++++----------------------
 4 files changed, 118 insertions(+), 106 deletions(-)

-- 
2.34.1

