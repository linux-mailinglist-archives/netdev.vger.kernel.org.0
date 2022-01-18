Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19294917BF
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343727AbiARCmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345785AbiARCcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:32:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24622C061574;
        Mon, 17 Jan 2022 18:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3282B81235;
        Tue, 18 Jan 2022 02:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07862C36AE3;
        Tue, 18 Jan 2022 02:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473068;
        bh=UD6Ht1hPoWlejkDH/Gzpu/erG3jhCpBQYjkRtuiDRoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YY2PPF1YKEL1WvF4w9OqHK/Lz1WYGHSDwlrlbyGBNs7UQI9sMB7j/+iicMgcexGTt
         trvanExfZ7CGL51fdRsxXf91AnOeIMogVDJ1rd5CuwRV3PwBJRgypS6V9dY4aCpcNr
         Qbu4yZWST0gxt2go+aqglQ33rrRWsvqA0AlFdRded8mclpE/nGCHP4EsUXIuzLkuB8
         mtKUWoVTfTAOGriDKynt1VVP4nKX8rFwY8EvAnHEAEncb3vmv7Dd+2Q7BjxkZtq7lF
         NgZVvxrV1SOsgXgWiG59N3A6cL5I0kghaVWc+FeKEJMX8GcijNLEzvKHGwXJ9Ij33a
         kB3JMCXGA+UIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        ast@kernel.org, andrii@kernel.org, yhs@fb.com, sunyucong@gmail.com,
        sdf@google.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 199/217] bpf/selftests: Fix namespace mount setup in tc_redirect
Date:   Mon, 17 Jan 2022 21:19:22 -0500
Message-Id: <20220118021940.1942199-199-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 4b18b73df10b6..c2426df58e172 100644
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

