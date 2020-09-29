Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE5627D7A0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgI2UII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgI2UIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:08:07 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A22C0613D0;
        Tue, 29 Sep 2020 13:08:05 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y13so6195241iow.4;
        Tue, 29 Sep 2020 13:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=FrpoEbpxZzdi3cWKxwCMZ4kZIRe3phRouK1F0UX405s=;
        b=uffnpnuV5G5mBq1SkYeRzEkAvXfx7RL8m8YNGPAMBERb0VEMNONoIFR0kXbYktZW7A
         8VKCK0BrzlIXFq4l2GAa7pihWOI3mA+BGIg5fspJQa2Z+aUkFllxRnFPhJIdUA7Dhz0l
         LUo4xxp01r3mSKzl3uUZjUY9Tiucw27nSHlP3pAzOD9ZRfp8rIV8v96MQyA++4n/yv0Y
         jcKjmKwuFoeNKGzZ8RD4CLa9VZFSyk8loMux5qj0lkZpS+iriytta+bBPAXt5/0STSwR
         PSo+zDh4nYZHK05py1NmTRQlwM+QNqD6XLFbV4LyCOPoJSq7mOtaD8f/9Cp1ANW4Kuc7
         2yAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=FrpoEbpxZzdi3cWKxwCMZ4kZIRe3phRouK1F0UX405s=;
        b=b+TfuvRgp6BFBaApCoPm60KPYKzYT5XcSqOGJnUEvNrFr45+mN5Q0R0Ys6Ia3KQtpS
         9cAZ9+15GHKx01Tyetbq54eTj6g05D2migsldmUJ3V/lZqLgBSJN2UStT3vdf6uPG7S7
         11jZXx7rcrfvr/NrsLU751PwNk0iHxN/vfserxpByS4KxdsgAOKLKwodxourmdoKkskr
         dFC530fLO3jxOo8Za1456SMIB/0WlU2azsWaEKOEeMOtCzXXriQguHb6sXS5uZj7PHNQ
         iWMhSjz6ylJjK5g5/iUbofsmEeG1/iI2x6++QfGRNFPGjPt4zCvIMqWFsa4kkz2hrikv
         tSXQ==
X-Gm-Message-State: AOAM5331QaB3+bvshYqddPxG7uKPstSqxcREMlvKaLRwv0AuZ3PcPVGO
        dAxNKaopjw85qZ2dapyowVE=
X-Google-Smtp-Source: ABdhPJzkfTLe3V1vjwtVVpUZS7tU5gOO1IrbCHaGEwkrDafSzY3ob7+0tUGMNKfMRcTK9SAANGj6fw==
X-Received: by 2002:a05:6638:d96:: with SMTP id l22mr4332783jaj.97.1601410085175;
        Tue, 29 Sep 2020 13:08:05 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q9sm2910436ild.4.2020.09.29.13.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 13:08:04 -0700 (PDT)
Subject: [bpf-next PATCH] bpf,
 selftests: fix warning in snprintf_btf where system() call unchecked
From:   John Fastabend <john.fastabend@gmail.com>
To:     alan.maguire@oracle.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 29 Sep 2020 13:07:49 -0700
Message-ID: <160141006897.25201.12095049414156293265.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On my systems system() calls are marked with warn_unused_result
apparently. So without error checking we get this warning,

./prog_tests/snprintf_btf.c:30:9: warning: ignoring return value
   of ‘system’, declared with attribute warn_unused_result[-Wunused-result]

Also it seems like a good idea to check the return value anyways
to ensure ping exists even if its seems unlikely.

Fixes: 076a95f5aff2c ("selftests/bpf: Add bpf_snprintf_btf helper tests")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/snprintf_btf.c        |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c b/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
index 3c63a7003db4..686b40f11a45 100644
--- a/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
@@ -27,7 +27,9 @@ void test_snprintf_btf(void)
 		goto cleanup;
 
 	/* generate receive event */
-	(void) system("ping -c 1 127.0.0.1 > /dev/null");
+	err = system("ping -c 1 127.0.0.1 > /dev/null");
+	if (CHECK(err, "system", "ping failed: %d\n", err))
+		goto cleanup;
 
 	if (bss->skip) {
 		printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);

