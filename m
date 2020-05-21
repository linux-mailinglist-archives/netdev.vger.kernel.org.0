Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EC01DD7FC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgEUUHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUUHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:07:21 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5B3C061A0E;
        Thu, 21 May 2020 13:07:20 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d10so3775751pgn.4;
        Thu, 21 May 2020 13:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=6d13EMYazFjX1LgdWbBRghhkZbK0Ab5O1+6Rr/1em8M=;
        b=M8kNnCYVDTx0bIrZhMD5mlR+8tMD5skL3BH+a8a49cRAQmFnbz8KJsznbBrdD8/7yo
         MHbfdVo/sFg3TjQTAd9+H89tTnlyhVnntJ5pDXmDlICJ7sMiYStO+jBSQvxbtrmTdboc
         ebWed0kxGm1J6k1l8iWtFQP27+1cyk7WaNPnca+hRpd1lHYp+fcixovIWzAz2Z/MYWQs
         fThAhYXUtSm1ITAUHjCW9+IikE3pm/GQFZMntaWTaSa2jD0mYuxzzrW80JfKU/v4xCEV
         +RkBkfIxYeB4fPAJ7W6MfRPAOVjUgCMEYGOPEfCCo3NfdCFO2aeT8I0YJk/pogvNMOdR
         kvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=6d13EMYazFjX1LgdWbBRghhkZbK0Ab5O1+6Rr/1em8M=;
        b=GBSEVcCdSSGrt7Zw4vk0NMgzWLw+yl3nsY68WKRxtm8hdhePdB6LdpoIz7lEZf0260
         CdWuSNWlGPZAM6AW1cmykWoMT+VsQlYEDFLT/HSvCtr+u/6oShXaowhPnKFxxkCjmmU4
         eTDRzfYT5mHwSAcAkPwtAMub//hVOQl2lSdsokl5Dna8BxlcLxvyDJ4HetNIiaQssKwu
         D0vDP3ZfhynFKMnbAPkJcSR1Tr2VXLPZGaIiAPaB3B1ZNM+KE+Q95ORSbOSkMHjH6F4p
         5YAt0DhxTXiQMi5v85ZvaPHZx835pqbQUVN/cmgUTMIkOqXfqoHPs/HU2TZMhkGIgqHz
         Ytmg==
X-Gm-Message-State: AOAM531dLe2UTfb+mvGLIir2zVBugdyAPUbM2HHVc6pPaazhLuXWv7Zz
        5ewHGnW9LZvbMnOBhOveJ8g=
X-Google-Smtp-Source: ABdhPJy96qTwcfvIzVwaoeOHubCptt4iLp9Oz+q8rf8VJORp7xETrZdN6xnpkYtoaWFBtlgAkZHOqA==
X-Received: by 2002:a63:de06:: with SMTP id f6mr10886470pgg.238.1590091639664;
        Thu, 21 May 2020 13:07:19 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q193sm4978383pfq.158.2020.05.21.13.07.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 13:07:18 -0700 (PDT)
Subject: [bpf-next PATCH v2 0/4] ] verifier,
 improve ptr is_branch_taken logic
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 21 May 2020 13:07:04 -0700
Message-ID: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds logic to the verifier to handle the case where a
pointer is known to be non-null but then the verifier encountesr a
instruction, such as 'if ptr == 0 goto X' or 'if ptr != 0 goto X',
where the pointer is compared against 0. Because the verifier tracks
if a pointer may be null in many cases we can improve the branch
tracking by following the case known to be true.

The first patch adds the verifier logic and patches 2-4 add the
test cases.

v1->v2: fix verifier logic to return -1 indicating both paths must 
still be walked if value is not zero. Move mark_precision skip for
this case into caller of mark_precision to ensure mark_precision can
still catch other misuses. And add PTR_TYPE_BTF_ID to our list of
supported types. Finally add one more test to catch the value not
equal zero case. Thanks to Andrii for original review. 

Also fixed up commit messages hopefully its better now.

---

John Fastabend (4):
      bpf: verifier track null pointer branch_taken with JNE and JEQ
      bpf: selftests, verifier case for non null pointer check branch taken
      bpf: selftests, verifier case for non null pointer map value branch
      bpf: selftests, add printk to test_sk_lookup_kern to encode null ptr check


 kernel/bpf/verifier.c                              |   36 ++++++++++++++++++--
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |    1 +
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   33 ++++++++++++++++++
 .../testing/selftests/bpf/verifier/value_or_null.c |   19 +++++++++++
 4 files changed, 86 insertions(+), 3 deletions(-)

--
Signature
