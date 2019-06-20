Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EE24C7BE
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 08:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfFTG60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 02:58:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43238 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfFTG60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 02:58:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so1051891pgv.10;
        Wed, 19 Jun 2019 23:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5tq+X4wXXrZG/wbS6SMtHzkOdEnpgI5MI2Re6q1RlzY=;
        b=kQTPnYOo24zaVfkMSvmceTasBcY1+Fa4BgqJpcnvR4ft3F4lz3Feod/vAHtj2Gf/PK
         lzoDy9jUETyt3/rJSPOyd+YsCTNuJtQley+Wfz0x4dFrukJkpKWhAD6xHT7zaYDXqK5N
         SJFttAcv/I9wk0iae5Qe0Z5OCnHaD/xL6OC8x8DXSmJdFkrjCSStz5NfotSbVaBr128s
         5HsLZ2ZofOefY7S1KRjL0uHCcOwTetPzlDjs7+rlskLPpoo+7To8HjCflYIzEtC4UaPD
         Gb5lIg6JblGqSZdHpKow/MyomKtK5IE1UW7YCAu1aSjlohTxxawnqGAVxCiXz3tTzF11
         9b9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5tq+X4wXXrZG/wbS6SMtHzkOdEnpgI5MI2Re6q1RlzY=;
        b=NMYxv7AROVUt7BZqp7BfzQVoTtrdnWdISR5IcvQ5nWVP9GrPKtYuuRVf9wlN5ZjDb/
         79lgmSX3UgRyyf1RhU2ig9X4VtbdZvhgfSpPWe7/rjZ996kuLmyDtbsMw1AsvhZ90l4i
         o6vP/WtCGRQoXUgUM1XEds4Cn9VOF7/7kyAM0UO+VGSJ28bxI3sTt138B8Ze/Ka3D/D7
         KLAnHe6l7Y+SrQ+wcxY+O3ULlvRRu9YkqM+14nW7/Bw98QrbXstBXdovrFJIqSjWTK8X
         S5C8Y33WPyPbTrSp5cC0o2gg7gvIDWfuyFGimj5cd0zbiwpXZFMKQAFvWw5VLXzuo3bP
         v+ug==
X-Gm-Message-State: APjAAAW5wAPtw0SJGlp3kufO6O/fGX0qUv1iXVjXIqb7sQ5hRndvQCUo
        ODGPoazkL3xR68usQ99iY8Y=
X-Google-Smtp-Source: APXvYqyMJEY7PxlxA1/4Q8uaahhdBJwmbXOc6UbM+Z4zfMfygklvdBTS1l+bCE78VCyjJ0onYTHtyg==
X-Received: by 2002:a17:90a:7148:: with SMTP id g8mr1508670pjs.51.1561013906103;
        Wed, 19 Jun 2019 23:58:26 -0700 (PDT)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id t19sm3574203pjo.11.2019.06.19.23.58.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 23:58:25 -0700 (PDT)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] samples/bpf: xdp_redirect, correctly get dummy program id
Date:   Thu, 20 Jun 2019 15:58:15 +0900
Message-Id: <20190620065815.7698-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we terminate xdp_redirect, it ends up with following message:
"Program on iface OUT changed, not removing"
This results in dummy prog still attached to OUT interface.
It is because signal handler checks if the programs are the same that
we had attached. But while fetching dummy_prog_id, current code uses
prog_fd instead of dummy_prog_fd. This patch passes the correct fd.

Fixes: 3b7a8ec2dec3 ("samples/bpf: Check the prog id before exiting")
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 samples/bpf/xdp_redirect_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index e9054c0269ff..1299e0f61dad 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -197,7 +197,7 @@ int main(int argc, char **argv)
 	}
 
 	memset(&info, 0, sizeof(info));
-	ret = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+	ret = bpf_obj_get_info_by_fd(dummy_prog_fd, &info, &info_len);
 	if (ret) {
 		printf("can't get prog info - %s\n", strerror(errno));
 		return ret;
-- 
2.20.1

