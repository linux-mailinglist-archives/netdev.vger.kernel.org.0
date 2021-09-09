Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B89404E87
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347482AbhIIMMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348284AbhIIMJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84630619EE;
        Thu,  9 Sep 2021 11:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188088;
        bh=h6FqXYCR30wR/rITiby2miwzaK5galCFD9iDPMZKP1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSiv51kpNUnei+v6LD+IWvsU4fSbDg/5cUzIWVOl6THGEgaM0NMSo0YQehGA7+MbO
         O8+7t8AFOgdNIHpWJvHZys6xQFtNUn7Mpvxim6+5KkQBgMw9SA1gmLQzTqWNAbfBEH
         Lj+aMo6wdAC4bW7VVee3wUG/A2zw+xutqKn80/QSTCOUwsNXQeJvYm7k3Pk8s6uhMs
         hVvTbnxc/pF5UyS77KyPC9h6D0RAZQ+Kemcm+WgtJgInYjsuMSL8yXd2NsbXCshzn2
         zfgw9MAL27rZx6uOPpFDjRU1FFUQA52MnKd0wNi5+T5r70gNT6NPEDrkKoeHWt1SkY
         v7aiJS8a6dZtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juhee Kang <claudiajkang@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 072/219] samples: bpf: Fix tracex7 error raised on the missing argument
Date:   Thu,  9 Sep 2021 07:44:08 -0400
Message-Id: <20210909114635.143983-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juhee Kang <claudiajkang@gmail.com>

[ Upstream commit 7d07006f05922b95518be403f08ef8437b67aa32 ]

The current behavior of 'tracex7' doesn't consist with other bpf samples
tracex{1..6}. Other samples do not require any argument to run with, but
tracex7 should be run with btrfs device argument. (it should be executed
with test_override_return.sh)

Currently, tracex7 doesn't have any description about how to run this
program and raises an unexpected error. And this result might be
confusing since users might not have a hunch about how to run this
program.

    // Current behavior
    # ./tracex7
    sh: 1: Syntax error: word unexpected (expecting ")")
    // Fixed behavior
    # ./tracex7
    ERROR: Run with the btrfs device argument!

In order to fix this error, this commit adds logic to report a message
and exit when running this program with a missing argument.

Additionally in test_override_return.sh, there is a problem with
multiple directory(tmpmnt) creation. So in this commit adds a line with
removing the directory with every execution.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210727041056.23455-1-claudiajkang@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/test_override_return.sh | 1 +
 samples/bpf/tracex7_user.c          | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/samples/bpf/test_override_return.sh b/samples/bpf/test_override_return.sh
index e68b9ee6814b..35db26f736b9 100755
--- a/samples/bpf/test_override_return.sh
+++ b/samples/bpf/test_override_return.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
 
+rm -r tmpmnt
 rm -f testfile.img
 dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
 DEVICE=$(losetup --show -f testfile.img)
diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
index fdcd6580dd73..8be7ce18d3ba 100644
--- a/samples/bpf/tracex7_user.c
+++ b/samples/bpf/tracex7_user.c
@@ -14,6 +14,11 @@ int main(int argc, char **argv)
 	int ret = 0;
 	FILE *f;
 
+	if (!argv[1]) {
+		fprintf(stderr, "ERROR: Run with the btrfs device argument!\n");
+		return 0;
+	}
+
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
-- 
2.30.2

