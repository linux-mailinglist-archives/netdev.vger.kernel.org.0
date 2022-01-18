Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E579C4919E5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343915AbiARC5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345808AbiARCsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:48:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACE6C0612E1;
        Mon, 17 Jan 2022 18:39:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6ADC611F1;
        Tue, 18 Jan 2022 02:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B29C36AE3;
        Tue, 18 Jan 2022 02:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473567;
        bh=TElkjlzuCBV3Gc3JqGNMR1z/jwiZxTMPgmvaZtwLM8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBezdbPkcVrepUvg7wRmaMzioOrSPHTCiI45/LtOdQG5561V7l6bX79TJJt/meVn/
         cB1QJO+esTevI8jMONtAcYzET7vNIR+89fBvgH7hXTsGUXsPc8Lm9cUz8pKanwZYbk
         3by+pLYSjIGILaKPdxxGQ/ay/MxKBGPDfA5HA/qr3O8EHVC6VgpI7OxZ/SFFI4hN1q
         vmsooVRB3sdfGnktPArJB8nA+lWiKa4zo5kUNd43HMVej7QW1A3z0DpWJcS//DISD7
         F62yQBbpIjwCktSZ+0Fklp49Enbjrj2Cyeew9bY6k9SlAry18ImLPTMViQraO9pliX
         mkM1ecMVjAWFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        ast@kernel.org, andrii@kernel.org, yhs@fb.com, sdf@google.com,
        sunyucong@gmail.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 170/188] bpf/selftests: Fix namespace mount setup in tc_redirect
Date:   Mon, 17 Jan 2022 21:31:34 -0500
Message-Id: <20220118023152.1948105-170-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

[ Upstream commit 5e22dd18626726028a93ff1350a8a71a00fd843d ]

The tc_redirect umounts /sys in the new namespace, which can be
mounted as shared and cause global umount. The lazy umount also
takes down mounted trees under /sys like debugfs, which won't be
available after sysfs mounts again and could cause fails in other
tests.

  # cat /proc/self/mountinfo | grep debugfs
  34 23 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime shared:14 - debugfs debugfs rw
  # cat /proc/self/mountinfo | grep sysfs
  23 86 0:22 / /sys rw,nosuid,nodev,noexec,relatime shared:2 - sysfs sysfs rw
  # mount | grep debugfs
  debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)

  # ./test_progs -t tc_redirect
  #164 tc_redirect:OK
  Summary: 1/4 PASSED, 0 SKIPPED, 0 FAILED

  # mount | grep debugfs
  # cat /proc/self/mountinfo | grep debugfs
  # cat /proc/self/mountinfo | grep sysfs
  25 86 0:22 / /sys rw,relatime shared:2 - sysfs sysfs rw

Making the sysfs private under the new namespace so the umount won't
trigger the global sysfs umount.

Reported-by: Hangbin Liu <haliu@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jussi Maki <joamaki@gmail.com>
Link: https://lore.kernel.org/bpf/20220104121030.138216-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tc_redirect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index e7201ba29ccd6..47e3159729d21 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -105,6 +105,13 @@ static int setns_by_fd(int nsfd)
 	if (!ASSERT_OK(err, "unshare"))
 		return err;
 
+	/* Make our /sys mount private, so the following umount won't
+	 * trigger the global umount in case it's shared.
+	 */
+	err = mount("none", "/sys", NULL, MS_PRIVATE, NULL);
+	if (!ASSERT_OK(err, "remount private /sys"))
+		return err;
+
 	err = umount2("/sys", MNT_DETACH);
 	if (!ASSERT_OK(err, "umount2 /sys"))
 		return err;
-- 
2.34.1

