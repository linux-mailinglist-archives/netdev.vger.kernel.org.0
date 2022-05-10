Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195E8521460
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbiEJMAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiEJMAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:00:46 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68F1419AD;
        Tue, 10 May 2022 04:56:48 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x18so23507113wrc.0;
        Tue, 10 May 2022 04:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MZTg/nMPigS6d2pOObRKGjuMt8TC8vkLfQKsTnZcnUY=;
        b=m3kRFmJTwqljKnmEfwPxntoju+Ht87mQel0hj/TAYXsJ4ApMkSZ+GYFbZJMbsQc9YQ
         Ajq67jiUZ1zLEWa0vxM5y0EzQoEfxczkTugva89n+J0KxgfN7meBxBN/I4D/c19PTkIT
         imlTpltsjgyAzHrOeSE6iJGJkoe+CxD92tdjlbzWSPHBol8Y0YZhbadsZqhjzvSHSB+x
         IqwtZ/b2THM/5DXsEjxZly50cwez4XQd36Zy3tg0+iRX/MMadQupCDGek/jcYPN3aqb0
         j8ajB5Xx2jCn/cdrl4Jx+hQdXI8uzjf4qM3MuDyH+YZ4KUrKeG1JVCDO3hgYs2uAVhia
         Zg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MZTg/nMPigS6d2pOObRKGjuMt8TC8vkLfQKsTnZcnUY=;
        b=Rv7avqtXbK+t0w4Ut54P78+gngOMNqKmpB8lrkAIGqUCqSw/hdrpetBCFUC5SLQ+Bs
         KuxOASgq4VfymanTETCUf8mt5XZeQawISvje/sznYBn4OWcIMSInsLz2umsNi2KwCvcT
         +ar1fawrZTzwHD1rYl80wPkFi5WRNh2pwqJX9Z3AUzI6AUI8nTkAaVKX7sLogCUSUecY
         /TVQH6ZrkW7XJnUDEc9uLaSoJCbkVDcx4kNA2+BsmYcpLIIPardvexZMTk7mXfKAfQ6m
         +nTzk7oJphfWlv+pcP8vG2QYCB59j13GiMNoT8BfqF3LOu01ynlZiM4XpNcXu8jhI4Lq
         5mUg==
X-Gm-Message-State: AOAM530UgiZ1Q9GKZvmUViskFp7DAYIqRrBxkcAHeadJq0BDrd92Q1S0
        Fsvf5E/OCzpAof23EusaTnD+nPN6s1kmp9GY
X-Google-Smtp-Source: ABdhPJz0fGmke9Mexk0IZgRu4YU0Vk995I7ou0+QUjHpJVOY4JVgPE04no0W6qY8eCPoRCpDn7tA6Q==
X-Received: by 2002:a05:6000:156b:b0:20c:6ffb:9588 with SMTP id 11-20020a056000156b00b0020c6ffb9588mr19154790wrz.49.1652183807257;
        Tue, 10 May 2022 04:56:47 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.56.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:56:46 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/9] selftests: xsk: add busy-poll testing plus various fixes
Date:   Tue, 10 May 2022 13:55:55 +0200
Message-Id: <20220510115604.8717-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds busy-poll testing to the xsk selftests. It runs
exactly the same tests as with regular softirq processing, but with
busy-poll enabled. I have also included a number of fixes to the
selftests that have been bugging me for a while or was discovered
while implementing the busy-poll support. In summary these are:

* Fix the error reporting of failed tests. Each failed test used to be
  reported as both failed and passed, messing up things.

* Added a summary test printout at the end of the test suite so that
  users do not have to scroll up and look at the result of both the
  softirq run and the busy_poll run.

* Added a timeout to the tests, so that if a test locks up, we report
  a fail and still get to run all the other tests.

* Made the stats test just look and feel like all the other
  tests. Makes the code simpler and the test reporting more
  consistent. These are the 3 last commits.

* Replaced zero length packets with packets of 64 byte length. This so
  that some of the tests will pass after commit 726e2c5929de84 ("veth:
  Ensure eth header is in skb's linear part").

* Added clean-up of the veth pair when terminating the test run.

* Some smaller clean-ups of unused stuff.

Note, to pass the busy-poll tests commit 8de8b71b787f ("xsk: Fix
l2fwd for copy mode + busy poll combo") need to be present. It is
present in bpf but not yet in bpf-next.

Thanks: Magnus

Magnus Karlsson (9):
  selftests: xsk: cleanup bash scripts
  selftests: xsk: do not send zero-length packets
  selftests: xsk: run all tests for busy-poll
  selftests: xsk: fix reporting of failed tests
  selftests: xsk: add timeout to tests
  selftests: xsk: cleanup veth pair at ctrl-c
  selftests: xsk: introduce validation functions
  selftests: xsk: make the stats tests normal tests
  selftests: xsk: make stat tests not spin on getsockopt

 tools/testing/selftests/bpf/test_xsk.sh    |  53 +-
 tools/testing/selftests/bpf/xdpxceiver.c   | 547 ++++++++++++++-------
 tools/testing/selftests/bpf/xdpxceiver.h   |  42 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh |  47 +-
 4 files changed, 439 insertions(+), 250 deletions(-)


base-commit: 43bf087848ab796fab93c9b4de59a7ed70aab94a
--
2.34.1
