Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADA9800CF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392199AbfHBTQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:16:57 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35694 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391984AbfHBTQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:16:56 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so154528624ioo.2
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=h7nhEm78V7WmFGfIhMkfh2EorlV6SVL+Qv2JXWnayVs=;
        b=aips4NfXUlPP1ToR3kyenU37WDZw2YisLqA4wULW7ugRiqwE59uHF4YUQ0tnjutOe/
         g5eaSTmXxLewa3BbNdb+FcFxKUL5YztmRg/8t15ARqP61VrNzB9zZbVd3FG9Pe93yRF8
         JUlMdcyhr1hhgC4Gc59TBcrySli1w8A4L9apclu/kHiHwl+M4MX17e98dKKvGAxKXhmT
         +mR/05DMtCa9+5Mjpa5TpzMQf3ohOWsMI3My696FzDFrhZmjW+1sPd9ujSWRnTmDfxPn
         kfylH/0duTjUToIfaogFfKgbhbaEsTDjeTvrLJsbHroukugXVYDJS3OGf3MQPmTkTNag
         a6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h7nhEm78V7WmFGfIhMkfh2EorlV6SVL+Qv2JXWnayVs=;
        b=npULktAVV0yApJDNiLVwzMlBiWgLmVail6jdyDPCTBpEye91LtQCkti1Ddk5u8hqxZ
         rWCdKdm4mTXEgMj+89GpFNhfBTD415fWGtmGGBO4bOMFtbbjeHfMyQketcymo+Ba2fZ9
         38yL1vN58mfVvIL1v4GoK5VdZ93xxkCNVuEgOsNU4VuJsOLsqwIxE9N1GhqEyf4GoUdG
         v50hFPJkuXhoCHmCbyF+X2rm1Fny2x4To+pC6iQeoUTBkdYX8/Sivz9VkMsyXbUbKFrx
         XpF7oxeZ6MmUGqbbfw77pI9eLVKZ8Ik0ERxECYiwuj2ZQJTy5drVaTI7c0CMyD3AL6DW
         oJOQ==
X-Gm-Message-State: APjAAAVP6NJfrgmRcjRs0Pq/7g1D8F/1gPBQuSxECoNIG+84/DXPtHxd
        vpSxPgfskADSc4X+8X9xFP/KrlZQ
X-Google-Smtp-Source: APXvYqzhLTGq0NCLt8vMDJmq4mRn9GJO7K+IP3ve3tBPjxPzmh0g6nYtPUH2qyTIncEW8PT+xw6QlQ==
X-Received: by 2002:a5d:8c87:: with SMTP id g7mr28360543ion.85.1564773416061;
        Fri, 02 Aug 2019 12:16:56 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id n22sm117987934iob.37.2019.08.02.12.16.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 02 Aug 2019 12:16:55 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 0/2] Fix batched event generation for vlan action
Date:   Fri,  2 Aug 2019 15:16:45 -0400
Message-Id: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
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
supported vlan parameters (in order to maximize netlink messages size):

% cat tc-batch.sh
TC="sudo /mnt/iproute2.git/tc/tc"

$TC actions flush action vlan
for i in `seq 1 $1`;
do
   cmd="action vlan push protocol 802.1q id 4094 priority 7 pipe \
               index $i cookie aabbccddeeff112233445566778800a1 "
   args=$args$cmd
done
$TC actions add $args
%
% ./tc-batch.sh 32
Error: Failed to fill netlink attributes while adding TC action.
We have an error talking to the kernel
%

patch 1 adds callback in tc_action_ops of vlan action, which calculates
the action size, and passes size to tcf_add_notify()/tcf_del_notify().

patch 2 updates the TDC test suite with relevant vlan test cases.

Roman Mashak (2):
  net sched: update vlan action for batched events operations
  tc-testing: updated vlan action tests with batch create/delete

 net/sched/act_vlan.c                               |  9 +++
 .../tc-testing/tc-tests/actions/vlan.json          | 94 ++++++++++++++++++++++
 2 files changed, 103 insertions(+)

-- 
2.7.4

