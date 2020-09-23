Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3318D2762FC
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIWVUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgIWVUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:20:10 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9D1C0613CE;
        Wed, 23 Sep 2020 14:20:09 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id u8so1513756lff.1;
        Wed, 23 Sep 2020 14:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=i18jV2syVLvCKChyqzKAI8824Uz2eiQhh4mO+fZVAi8=;
        b=H9JqNiP35fVUTaKc+q3aqoYQRpVbIszUjQ9iuMTpgdNpIq4oTosbtxzynZEt+3osdH
         VfgPKU4Tx1jgpeES/8K2eJ/ydslS8Z5mzkkvtbkFru4NgyozNCJiBOX0Qd2b4KMuQP20
         zo91JpQ+Z29VoVULzPsrqmtlANSHqJQMr98R99Xtt4s8B2vcFxjlXPgojdv269TV1oJ1
         8IOBKCVPN5oVVdqsUymjTkcJXVPRCoZSG+3GJsMlmukT0DB3rPOCJl1vbQJ5ZsideQwC
         ozck69b1Ld0zfkS/hwX328YHQpa5sgsQ2SJWDYPIvwcUfZt1e2Zidf+OtbaqDaHn7To5
         7f2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=i18jV2syVLvCKChyqzKAI8824Uz2eiQhh4mO+fZVAi8=;
        b=CbA7YcSQR0YUPOhA3o7V6MrHEO8IGIzXYFBCBSHCuOVNdyfBn+zUDeY3rGXGq9sL36
         PnyMKTG7RXJgQXUqCswzJzpJjk0FzvOtmKcKxvNBiqgcQqVq585qKALceiXFyCIhNFS0
         3+azDJxAGvcuDOdB0YITCn6maF96tQwaXcS+1Qrlt5LwkXqhNtwnS/ZkProGxvt1ctPY
         +DlIMoT3osd6O2SI64evt5044hVmmdGfnnjvG/ceN2So9LHGx6684azFP/zYBgEcKWWu
         ZW6qR8k5t10l4iPdI7sexbWkkr0ZKSGuhawMPE4nmlsfvz8BMejwxaKIWPnlkM5rfh58
         4ZDw==
X-Gm-Message-State: AOAM530gjKaSiCkFnZfFFFimKJJZtwt2i15l7H21XVVqo08ZD68upXFv
        MoY64TjUGG6ImKETEHVmWuBjAk7MRtmJbGOKk7dqU13/bmc=
X-Google-Smtp-Source: ABdhPJz5XkHdzyclIi7QjyIOS+Yq1b9OYNs4KDnodlEWQUcd3FalJiEE+GAM9cA0T071sgD/gQC507WPALgGMhSJ70k=
X-Received: by 2002:a19:9141:: with SMTP id y1mr503180lfj.554.1600896007358;
 Wed, 23 Sep 2020 14:20:07 -0700 (PDT)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Sep 2020 14:19:56 -0700
Message-ID: <CAADnVQ+DQ9oLXXMfmH1_p7UjoG=p9x7y0GDr7sWhU=GD8pj_BA@mail.gmail.com>
Subject: Keep bpf-next always open
To:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF developers,

The merge window is 1.5 weeks away or 2.5 weeks if rc8 happens. In the past we
observed a rush of patches to get in before bpf-next closes for the duration of
the merge window. Then there is a flood of patches right after bpf-next
reopens. Both periods create unnecessary tension for developers and maintainers.
In order to mitigate these issues we're planning to keep bpf-next open
during upcoming merge window and if this experiment works out we will keep
doing it in the future. The problem that bpf-next cannot be fully open, since
during the merge window lots of trees get pulled by Linus with inevitable bugs
and conflicts. The merge window is the time to fix bugs that got exposed
because of merges and because more people test torvalds/linux.git than
bpf/bpf-next.git.

Hence starting roughly one week before the merge window few risky patches will
be applied to the 'next' branch in the bpf-next tree instead of
bpf-next/master. Then during the two weeks of the merge window the patches will
be reviewed as normal and will be applied to the 'next' branch as well. After
Linus cuts -rc1 and net-next reopens, we will fast forward bpf-next tree to
net-next tree and will try to merge the 'next' branch that accumulated the
patches over these three weeks. After fast-forward the bpf-next tree might look
very different vs its state before the merge window and there is a chance that
some of the patches in the 'next' branch will not apply. We will try to resolve
the conflicts as much as we can and apply them all. Essentially bpf-next/next
is a strong promise that the patches will land into bpf-next. This scheme will
allow developers to work on new features and post them for review and landing
regardless of the merge window or not. Having said that the bug fixing is
always a priority.

We've considered creating a bpf-next-next.git tree for this purpose, but decided
that bpf-next/next branch will be easier for everyone.

Thoughts and comments?
