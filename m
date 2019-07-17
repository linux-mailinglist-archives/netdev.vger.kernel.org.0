Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB4E6C077
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 19:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbfGQRgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 13:36:40 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39582 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfGQRgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 13:36:40 -0400
Received: by mail-io1-f67.google.com with SMTP id f4so47070373ioh.6
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 10:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=siSAH3elZRfbOKhNiI+jb+Cv36f2qsbbwpjf7J9k0Z4=;
        b=1aZYwNdPO/ImAUZzkl5Oelx39YAAG3UsY8VyCKdQ4f+z+nGT5JzL90gQ6oGBc2O7x9
         mOeq3ILuep0nwhw/duz9A2u4R2XPYqfr0ItNdVeR4wYQ5gpIRDNrlYft+NIy2MAf+K+f
         VWME4YlmlKE92nY5Ilrgx2j+vl7a8Z6AcMtxGH2LX5T2PsEnO/6VgNtkG82NnxBjWdlz
         +AC1w3bBayr4XOA/n9c9TdgxlC9/ZfJ8AizhGtbGvBlb84CqPs4DEiLGLmsOR0kTPpTE
         p1D5UOPYO1FMr9tN+D8tJLXSpY4hryLg5hf8KQeDNyqXu316HcZ/FwDCZif/cNa+7ZkR
         FPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=siSAH3elZRfbOKhNiI+jb+Cv36f2qsbbwpjf7J9k0Z4=;
        b=gP+NO4KJrgVXvhGAvFOoTI5TgGAeNcMmDNfGSAvx8BqmOXhKyaCPIc4y9715HblqMN
         6coQdm0U2TOL+qi5vew3qsPjjSdn4VmYXw4YGA8bzb40QptJBS5uxr4J5tAAKqgZvha5
         8gEKYgZTeXMmKDQehNgtMqNBg8BXaesV4IuxK30+n5CUXt/slWDN64RyLz3yphwzyqvi
         quKuEVslSKRRFaUVM2ZA/+aTVTFOFbidEke7q/hMXlz21Ff4HZIhLggnh0Z8TlL4VpAG
         XOUG2vX8HhPjdi0BfWx4E/vZ4SYB768LJnDtQdYneNfy1OhJVykeK0b7ocUxVEmqgZnt
         I0Sw==
X-Gm-Message-State: APjAAAVftwdPx1QVn0MnQy7kryAQAIebISSg+9WbLdJ/FAGPzxLGYfPR
        LqTdvYi6Xb7opCJGamgZw6o=
X-Google-Smtp-Source: APXvYqylaT0nrKZ5HXdHZHb2/c+CBBeRlFQ+dofPh98M3tv4kxw6G6fAbr06odkQktNYoJkXTAyMwQ==
X-Received: by 2002:a6b:4107:: with SMTP id n7mr34497593ioa.12.1563384999424;
        Wed, 17 Jul 2019 10:36:39 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id 20sm29052967iog.62.2019.07.17.10.36.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 17 Jul 2019 10:36:39 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next v2 0/2] Fix batched event generation for skbedit action
Date:   Wed, 17 Jul 2019 13:36:30 -0400
Message-Id: <1563384992-9430-1-git-send-email-mrv@mojatatu.com>
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
supported skbedit parameters (in order to maximize netlink messages size):

% cat tc-batch.sh
TC="sudo /mnt/iproute2.git/tc/tc"

$TC actions flush action skbedit
for i in `seq 1 $1`;
do
   cmd="action skbedit queue_mapping 2 priority 10 mark 7/0xaabbccdd ptype host inheritdsfield index $i "
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

v2:
   Added Fixes: tag
   Added cover letter with details on the patchset

Roman Mashak (2):
  net sched: update skbedit action for batched events operations
  tc-testing: updated skbedit action tests with batch create/delete

 net/sched/act_skbedit.c                            | 12 ++++++
 .../tc-testing/tc-tests/actions/skbedit.json       | 47 ++++++++++++++++++++++
 2 files changed, 59 insertions(+)

-- 
2.7.4

