Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15F8215C73
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgGFRAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:00:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55191 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729537AbgGFRAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 13:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594054819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NRhtPMhqlhqnOe1hdlLHWlYessgAjO4kXt3vnlCbry4=;
        b=cox0+52zwPNarVWeMfndzhffSvChL3l3ScXpWBjXC5GTqzfvtvmjcyRwBL+Njw8NBMPYKc
        xrqBEo4NRjHcZ990hYC0hGr3N/HtOxbagbM7b9Iyk2Ld51Wad96NNVvxDmknsA5JrWUAHG
        7Y05anroDp5TjSfkMrB2pps1onH8XII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-d6f8FbxVNtKsh-rbiHNnXQ-1; Mon, 06 Jul 2020 13:00:18 -0400
X-MC-Unique: d6f8FbxVNtKsh-rbiHNnXQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90D8B107ACCA;
        Mon,  6 Jul 2020 17:00:16 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A541E5C241;
        Mon,  6 Jul 2020 17:00:12 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 83E743002D737;
        Mon,  6 Jul 2020 19:00:11 +0200 (CEST)
Subject: [PATCH bpf-next V2 1/2] selftests/bpf: test_progs use another shell
 exit on non-actions
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        vkabatov@redhat.com, jbenc@redhat.com, yhs@fb.com, kafai@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 06 Jul 2020 19:00:11 +0200
Message-ID: <159405481147.1091613.18095872509921723823.stgit@firesoul>
In-Reply-To: <159405478968.1091613.16934652228902650021.stgit@firesoul>
References: <159405478968.1091613.16934652228902650021.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up adjustment to commit 6c92bd5cd465 ("selftests/bpf:
Test_progs indicate to shell on non-actions"), that returns shell exit
indication EXIT_FAILURE (value 1) when user selects a non-existing test.

The problem with using EXIT_FAILURE is that a shell script cannot tell
the difference between a non-existing test and the test failing.

This patch uses value 2 as shell exit indication.
(Aside note unrecognized option parameters use value 64).

Fixes: 6c92bd5cd465 ("selftests/bpf: Test_progs indicate to shell on non-actions")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/test_progs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 104e833d0087..e8f7cd5dbae4 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -12,6 +12,8 @@
 #include <string.h>
 #include <execinfo.h> /* backtrace */
 
+#define EXIT_NO_TEST 2
+
 /* defined in test_progs.h */
 struct test_env env = {};
 
@@ -740,7 +742,7 @@ int main(int argc, char **argv)
 	close(env.saved_netns_fd);
 
 	if (env.succ_cnt + env.fail_cnt + env.skip_cnt == 0)
-		return EXIT_FAILURE;
+		return EXIT_NO_TEST;
 
 	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
 }


