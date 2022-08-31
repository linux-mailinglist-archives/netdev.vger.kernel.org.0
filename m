Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3785E5A8912
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiHaWk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbiHaWkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:40:25 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7613774CF3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:40:22 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id t11so5561109ilf.3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=RzIT64p7dHEXl2Ie7DkQuJYbktQ+VKOmk+ml8MCajzM=;
        b=n4rgmiRDSvpPLrm3XvCtz4qVxUEwBIVN8mugPBdfcVLMZ5DBGUrIFYUlnjZTcT3XCP
         6lLzTlcC2SLWhFTbdh3npZc+dNq4Pj0k8s5PVwOwtoggWn4yAWxy94yRaffVqRusyImY
         SnYGdGz4tFYog64KJ/BI6m9tQz2DtXUMdzSou/4uaqQgupenyjXG2uPyPFQW1V/zbuzi
         aQBOVfpeMLZoeiBIFkfZiQnNw7F1bcu2LqhsBW7EJDLHaZZYDUQxHJQFzT8P3P3wF5z4
         bqdrn9QTXAII1eQkq/5kUM7R27yO4BtyJmDbOkB9sY4B/6q77c/re+X7TDd86qKXloMt
         7rgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=RzIT64p7dHEXl2Ie7DkQuJYbktQ+VKOmk+ml8MCajzM=;
        b=ypKogcVxkjzlPnZRZ8Gh8J958bRkkoHH5ml9isuZnO4inNmukUP8Lus4D/MtJpY3+H
         nLlIEIzOiWs/fEeaWHml+jD2rxEqIC4ast7cv8mhUQ2Yy16X0+UfCmpitXPhIq0pF89a
         6CzoninLFwkRlATl3eOpey2BbxMnjllyWX+sNr3+dlwqVbqv++1yvnbN7ivxKhylDvA7
         qW7l4bvqREr63QYu3rFu3aXLY18sbDIrj3vgq2E3eJ+N82oVNwcdUxQpAlA+Msgp99Qe
         vGkICeC/mphi+Ztz5dOXNJuJ8A8OfSa35LZBnelGW1d0SNnWjhhSkIw6hu/kDntUQwY0
         kPiw==
X-Gm-Message-State: ACgBeo2by0ZFVEiaY18eW+g4veo8OOUTNm0ypzMKrEXw2tjtIyxd2rqY
        uFbS8pMxB97eE13aHyQSuVc9qA==
X-Google-Smtp-Source: AA6agR7L7tTfSzUelsBqHqLUqZa5knZ+7yNZbZJBEePFT25qTk929vQ83PM4YjLE9I56evt27PhHOw==
X-Received: by 2002:a05:6e02:1b89:b0:2e9:3065:ea94 with SMTP id h9-20020a056e021b8900b002e93065ea94mr15401590ili.279.1661985621819;
        Wed, 31 Aug 2022 15:40:21 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n30-20020a02a19e000000b0034c0db05629sm1392005jah.161.2022.08.31.15.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 15:40:21 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: use IDs to track transaction state
Date:   Wed, 31 Aug 2022 17:40:11 -0500
Message-Id: <20220831224017.377745-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is the first of three groups of changes that simplify
the way the IPA driver tracks the state of its transactions.

Each GSI channel has a fixed number of transactions allocated at
initialization time.  The number allocated matches the number of
TREs in the transfer ring associated with the channel.  This is
because the transfer ring limits the number of transfers that can
ever be underway, and in the worst case, each transaction represents
a single TRE.

Transactions go through various states during their lifetime.
Currently a set of lists keeps track of which transactions are in
each state.  Initially, all transactions are free.  An allocated
transaction is placed on the allocated list.  Once an allocated
transaction is committed, it is moved from the allocated to the
committed list.  When a committed transaction is sent to hardware
(via a doorbell) it is moved to the pending list.  When hardware
signals that some work has completed, transactions are moved to the
completed list.  Finally, when a completed transaction is polled
it's moved to the polled list before being removed when it becomes
free.

Changing a transaction's state thus normally involves manipulating
two lists, and to prevent corruption a spinlock is held while the
lists are updated.

Transactions move through their states in a well-defined sequence
though, and they do so strictly in order.  So transaction 0 is
always allocated before transaction 1; transaction 0 is always
committed before transaction 1; and so on, through completion,
polling, and becoming free.  Because of this, it's sufficient to
just keep track of which transaction is the first in each state.
The rest of the transactions in a given state can be derived from
the first transaction in an "adjacent" state.  As a result, we can
track the state of all transactions with a set of indexes, and can
update these without the need for a spinlock.

This first group of patches just defines the set of indexes that
will be used for this new way of tracking transaction state.  Two
more groups of patches will follow.  I've broken the 17 patches into
these three groups to facilitate review.

					-Alex

Alex Elder (6):
  net: ipa: use an array for transactions
  net: ipa: track allocated transactions with an ID
  net: ipa: track committed transactions with an ID
  net: ipa: track pending transactions with an ID
  net: ipa: track completed transactions with an ID
  net: ipa: track polled transactions with an ID

 drivers/net/ipa/gsi.h       |  9 +++-
 drivers/net/ipa/gsi_trans.c | 99 ++++++++++++++++++++++++++++++-------
 2 files changed, 89 insertions(+), 19 deletions(-)

-- 
2.34.1

