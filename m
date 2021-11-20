Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9EF457BAF
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 06:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhKTFWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 00:22:53 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:37637 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229655AbhKTFWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 00:22:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yunbo.xufeng@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UxMw1x3_1637385585;
Received: from localhost.localdomain(mailfrom:yunbo.xufeng@linux.alibaba.com fp:SMTPD_---0UxMw1x3_1637385585)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Nov 2021 13:19:46 +0800
From:   Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>
To:     jolsa@kernel.org, kpsingh@google.com, andriin@fb.com,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, yunbo.xufeng@linux.alibaba.com
Subject: [RFC] [PATCH bpf-next 0/1] Enhancement for bpf_do_path() helper
Date:   Sat, 20 Nov 2021 13:18:38 +0800
Message-Id: <20211120051839.28212-1-yunbo.xufeng@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background:
--------------------------------------------------------------------------------------------------
This is our scenario:
We restrict process to do certain operations in LSM hookpoint based on user specified security rules, 
and one dimension of the rule is the process’s executable full path, so we use bpf_d_path() helper to
get the path, and do rule matching in hash maps to make the allow or deny decision. However, the
returned buffer is not our expected, there is always noisy data at the tail of the buffer and makes
hash map lookup fails to work.
We have tried several ways to workaround this problem, such as using __builtin_memset() to clear
the returned buffer, but it does not work because __builtin_memset() cannot accept variable sized
buffer; and we also tried use a loop the iterate every byte of the buffer and clear the noisy data,
this works in simple bpf programs but makes a lot of trouble to us for complex bpf program cases,
e.g. reaching 1M instruction limitation or stack overflow.
Thus, we want to enhance the origin bpf_do_path() implementation, clearing the noisy tail buffer
helps a lot to us.

Appreciate for your suggestion.

Xufeng Zhang (1):
bpf: Clear the noisy tail buffer for bpf_d_path() helper
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)
