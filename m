Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55DF45D121
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345177AbhKXXaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344629AbhKXX37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:29:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D819B6052B;
        Wed, 24 Nov 2021 23:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796409;
        bh=ExMikSjcQW3Y1ITiVzQmyeIkXXwc8f1LxOM+/YDeuJg=;
        h=From:To:Cc:Subject:Date:From;
        b=WY25gDyrLzS21U2/5oQnoXUrOS0WM0dK+ZM6SxfTuqr4nnQnqq/J19imKC9Bjxqrs
         cas55MRtmumwueZ1iwhXgc6hihF833hnxEayUwY+M5iOtnBtdwO/XIiu+eHDuunEp1
         ObYA3oea267fO/JkZZjyd7djGKlv4Qr34u2sL7flIW43gOf1raVwvSMsXJUPnKvRqM
         rjONzDoTdyFilvpZmV+eCpvukg6FP7qP/MZbCTnt5MbGyr8vs4YFkp3ixMreNFcCf6
         blZNSQ8T4npqa7FfL3qfFyeEARueAEYyh194TnHFLkQ4T5N8HgcCvvVyMvry6YV+qv
         pZiu6qyq0fnWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/9] tls: splice_read fixes
Date:   Wed, 24 Nov 2021 15:25:48 -0800
Message-Id: <20211124232557.2039757-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As I work my way to unlocked and zero-copy TLS Rx the obvious bugs
in the splice_read implementation get harder and harder to ignore.
This is to say the fixes here are discovered by code inspection,
I'm not aware of anyone actually using splice_read.

Jakub Kicinski (9):
  selftests: tls: add helper for creating sock pairs
  selftests: tls: factor out cmsg send/receive
  selftests: tls: add tests for handling of bad records
  tls: splice_read: fix record type check
  selftests: tls: test splicing cmsgs
  tls: splice_read: fix accessing pre-processed records
  selftests: tls: test splicing decrypted records
  tls: fix replacing proto_ops
  selftests: tls: test for correct proto_ops

 net/tls/tls_main.c                |  47 ++-
 net/tls/tls_sw.c                  |  40 ++-
 tools/testing/selftests/net/tls.c | 521 ++++++++++++++++++++++--------
 3 files changed, 456 insertions(+), 152 deletions(-)

-- 
2.31.1

