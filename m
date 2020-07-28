Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59913230E3C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730967AbgG1Pnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730679AbgG1Pnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:43:41 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDC7C061794;
        Tue, 28 Jul 2020 08:43:40 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id k23so21179007iom.10;
        Tue, 28 Jul 2020 08:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=cRPvwMW2JfqeqHjNgK7oh8ZaPEnU+AXN1XSwCrtOsuk=;
        b=Z5rJnO+OrgVXn9MaCcSajRq+SH4XAH6HhD2c2PIEOi6/z8npkab8Ayebs8UXtYvLWK
         jdtX4PSoeXwr35GZw0J9LA5JXFkdgglUq3hlJIzRZ46hDtsVAnS+8HC7KjUzlV/Puo6+
         8HnfX9zF42GPKDri4ee0k0f6FSQCFheFnIF42rS57+Z4W4Dqyw7W+DjYHH/IT0J8anaF
         bTPuP0ZjElZ0k0CMM3xlepGDkNXnfbbW8IluJbbW4MqOD/j1saYs2gFO0vw9B0o/92YI
         zwzmWa0XaqjF+ReW84cPRuCxxtmiBcAs+o11gO5vVim/LrhmMnepxxS/OvaD9jHThXRW
         u9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=cRPvwMW2JfqeqHjNgK7oh8ZaPEnU+AXN1XSwCrtOsuk=;
        b=FQdkLmcbRhuHZx1YsYmwuWUjEi7IH8WWwfRJPoWNne5TTOovIFTmEC0Q+InC8wy9Kd
         gKDOdplDmOdVyy/fllHC2Dq24TqdHMOTGNJP8h/a8AsFJNnfpNKNUwct59sK4AwH1Ti8
         0p7tLuLJ358zTkCFNnW9M9dfemffN4YqiScTZksBoydLa2L9+8RARPymED6CyL+Ym3D6
         RI+CwUThb3+tRJ0fLmY3gbeKdd5nzM8OdeBI2yEeluonm4AOYzEaAx3+MqnxIb3hJc3s
         hUfD+oxEpxvDM2O64eX6MlvvV7t4O9RRrTJkgjPdljZINXeFYnyrsCdvD5mcRMTC5NTW
         H7Cw==
X-Gm-Message-State: AOAM5327Bz8lO0UV7iT7ojTzIIUsuuCzXGTCmodQbVohkKO0GvHKajOn
        KyIaB8RRpKZp4l+7SaV9DQQ=
X-Google-Smtp-Source: ABdhPJyCXi55PHJrhFejYVB4luKCJ1QOFgZhCI1N0+DqAsACcsVqT9n81WOLLpGODbUzCYmpT+WBaQ==
X-Received: by 2002:a6b:4e0e:: with SMTP id c14mr13454917iob.8.1595951020348;
        Tue, 28 Jul 2020 08:43:40 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u6sm2830732ilk.13.2020.07.28.08.43.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 08:43:39 -0700 (PDT)
Subject: [bpf PATCH 0/3] Fix sock_ops field read splat 
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Tue, 28 Jul 2020 08:43:28 -0700
Message-ID: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doing some refactoring resulted in a code splat when reading sock_ops
fields.

Patch 1, has the details and proposed fix.

Patch 2, gives a reproducer and test to verify the fix. I used the
netcnt program to test this because I wanted a splat to be generated
which can only be done if we have real traffic exercising the code.

Patch 3, is an optional patch. While doing above I wanted to also verify
loads were OK. The code looked good, but I wanted some xlated code to
review as well. It seems like a good idea to add it here or at least
shouldn't hurt. I could push it into bpf-next if folks want.

---

John Fastabend (3):
      bpf: sock_ops ctx access may stomp registers in corner case
      bpf, selftests: Add tests for ctx access in sock_ops with single register
      bpf, selftests: Add tests for sock_ops load with r9,r8.r7 registers


 net/core/filter.c                                  |   26 ++++++++++++++++++--
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |   20 +++++++++++++++
 2 files changed, 44 insertions(+), 2 deletions(-)

--
Signature
