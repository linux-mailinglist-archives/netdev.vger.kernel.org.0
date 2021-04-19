Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C072364526
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbhDSNli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:41:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242025AbhDSNht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618839439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BBf1Nxj5erqlDJNTuzs4e7olpX+wS5exxMu397gD5cE=;
        b=UY9OJ69bCfFQNuxhRTRu+yckY7Qc5BvEoa5Os3o0jL6RaL7kxk2OSX9POBwUo1Dqp1SJ3O
        nfhzzSoHXk6JthVypwQLdnyWoOcmjPIvBZ40RyHmupmrjSiuJISRIaokBbdWaR7Q5rNTuw
        lX66zTxXmlPx2uvWWLdn8hfa5FVvAJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-eq2RziwtMJm8Mmw45o6z3Q-1; Mon, 19 Apr 2021 09:37:17 -0400
X-MC-Unique: eq2RziwtMJm8Mmw45o6z3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49EF8107ACE4;
        Mon, 19 Apr 2021 13:37:16 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46FC5610F1;
        Mon, 19 Apr 2021 13:37:15 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] tc: e_bpf: fix memory leak in parse_bpf()
Date:   Mon, 19 Apr 2021 15:36:57 +0200
Message-Id: <61ec0f2e5054f0d98fe870b5ce995b9b82a09ff4.1618839246.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

envp_run is dinamically allocated with a malloc, and not freed in the
out: return path. This commit fix it.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/e_bpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tc/e_bpf.c b/tc/e_bpf.c
index a48393b7..517ee5b3 100644
--- a/tc/e_bpf.c
+++ b/tc/e_bpf.c
@@ -159,7 +159,9 @@ static int parse_bpf(struct exec_util *eu, int argc, char **argv)
 
 	envp_run[env_num - 1] = NULL;
 out:
-	return execvpe(argv_run[0], argv_run, envp_run);
+	ret = execvpe(argv_run[0], argv_run, envp_run);
+	free(envp_run);
+	return ret;
 
 err_free_env:
 	for (--i; i >= env_old; i--)
-- 
2.30.2

