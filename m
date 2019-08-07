Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E1C85425
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbfHGT5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:57:39 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35302 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729712AbfHGT5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:57:39 -0400
Received: by mail-ot1-f67.google.com with SMTP id j19so32551040otq.2
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Pwv8R6yxqJM2Qo0OjcqD1m4uxYSO4HZLJoRy2eDfy24=;
        b=UW37y5cnwq9WXIAd/e28er2Z9E+2mH6uwtP0QFf9al+cQ2NadrP7iyAvFGJvS/0XVo
         cYMEUOf0Qo/mzB28HdWn6iDzxKliWW+2c205g0dxi1KGiNMpwq/E2gKp9BTXU3q0G9LE
         751TNvJX2DkbXadmi7F6D6re1XHLcUiKdBtWem/ad5saRQLN2iWU65HWoUuLyEsDcUfA
         gtP2/uOa2jYSwNgVNZJw+pTjqWcghXVlO+d04OTRlQLzddT0UD2OsqYaMQO3oCJfP57P
         ffoisnKMgPOr4oUg2bX6fXAZUt2gdD1WYwzTp//gPmbuWywAkr/t1DntB0u0pBXtlq7e
         MmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Pwv8R6yxqJM2Qo0OjcqD1m4uxYSO4HZLJoRy2eDfy24=;
        b=FV3bpox3iFJ60Pe2BwQtyKzoc1gD6sM87TEA/3Jf1u/gw7ijxn2IdwB3Y8pLzEBvzM
         b5oXd3xO8ciWE6KrvP5Gs8KNPBxxCYiRvIctdyHkNAPiNcuZOglEfK/dujopwNqklr8t
         WJF13MOocSPRoWy+drd0cyGdoSU/GqfaAKbzyZW+2WHgH7Q8gC5VR9D4+Mzsb9Xxhu91
         IPpZL/sXoyBrgL1kjhUkdPZs9RPC20WWZYvrSGAKW1x4hdpwOcxPkh/53qtrUIAV90+m
         BlEsKvqHC02PEqhIEq14xe7ZjCWd4ahopbsNyvRtax8feAc4EXdVbqDB0MOMM0z+YsZ4
         Qopg==
X-Gm-Message-State: APjAAAWY1ysx7a/kZzDg8Zaf7nrrSfpMHtS4r/8lpAw9CXxUGcM5IirU
        LTqOwP18E+sRXsMY78Nc1U7P1e6QyMg=
X-Google-Smtp-Source: APXvYqwZYytds0asMiO8quReTN+ZYrLIKkociHR/fBznmynq3aKfNKKlc3oUyzxWOWzuo6pLe6wZig==
X-Received: by 2002:a02:b914:: with SMTP id v20mr11978918jan.83.1565207858161;
        Wed, 07 Aug 2019 12:57:38 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id n7sm68971618ioo.79.2019.08.07.12.57.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 07 Aug 2019 12:57:37 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 0/2] Fix batched event generation for skbedit action
Date:   Wed,  7 Aug 2019 15:57:27 -0400
Message-Id: <1565207849-11442-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding or deleting a batch of entries, the kernel sends up to
TCA_ACT_MAX_PRIO (defined to 32 in kernel) entries in an event to user
space. However it does not consider that the action sizes may vary and
require different skb sizes.

For example, consider the following script adding 32 entries with all
supported skbedit parameters and cookie (in order to maximize netlink
messages size):

% cat tc-batch.sh
TC="sudo /mnt/iproute2.git/tc/tc"

$TC actions flush action skbedit
for i in `seq 1 $1`;
do
   cmd="action skbedit queue_mapping 2 priority 10 mark 7/0xaabbccdd \
               ptype host inheritdsfield \
               index $i cookie aabbccddeeff112233445566778800a1 "
   args=$args$cmd
done
$TC actions add $args
%
% ./tc-batch.sh 32
Error: Failed to fill netlink attributes while adding TC action.
We have an error talking to the kernel
%

patch 1 adds callback in tc_action_ops of skbedit action, which calculates
the action size, and passes size to tcf_add_notify()/tcf_del_notify().

patch 2 updates the TDC test suite with relevant skbedit test cases.

Roman Mashak (2):
  net sched: update skbedit action for batched events operations
  tc-testing: updated skbedit action tests with batch create/delete

 net/sched/act_skbedit.c                            | 12 ++++++
 .../tc-testing/tc-tests/actions/skbedit.json       | 47 ++++++++++++++++++++++
 2 files changed, 59 insertions(+)

-- 
2.7.4

