Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AACA103CC
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 04:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfEACGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 22:06:45 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44930 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfEACGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 22:06:45 -0400
Received: by mail-yw1-f65.google.com with SMTP id j4so7427863ywk.11;
        Tue, 30 Apr 2019 19:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=0SHDTFhjH7cZQ91Z6WPZuOs1xrOchCbCtM/fhIHXXfg=;
        b=vKCWH2bgItNVeyL7vD18OPUzknY0+SQfyIRYjQww4y5ViFYsOi7/DiM1mPZf4wYppT
         kI0/Ma28ViWD4A7DAhIwO/DI+qrdFgvmAK+RMWLy58WEG5+gpb4jlrqlEYAUX2EFM83k
         2g/61RraF4iBFg0U/0nQBAGJPy3IdDOsu1qnLIu+3/YlXBY+VI1YA8lH/3/4qw/6MohO
         PKUZ4Hrp74iJtzTy7lJfiJyW3WO0BttkJ1wf1xaQHGR/3U43F5iSRQpTYV8CP0/006OS
         UHNLDpBwRtCZ/fef2wNilAbFp4h+ZiYrc0gdbfKvx1jj7LEtmM5du/wYO8Ko4ZqtnMvc
         Ng3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=0SHDTFhjH7cZQ91Z6WPZuOs1xrOchCbCtM/fhIHXXfg=;
        b=lvqJj0hML2FX5oY+wg58J90icfQHO5NQE8WTH41EABUsRy/uHirP6B7O/kTxM7IdIN
         t9/PWgyR8QIgKvsBD/tVk1i7QxZXHYUV3pcJLMuY3NfEKKumAk8FZVmYOv3rDDsXI9kE
         ukKoODyAcYvR2BadXoQCzJ/ROSytEkrExxDqqZ+gwQhdoCIaVQcXOP8DWC7ETOKzsk4L
         G2ACzB8oR5Wf1FxeaozeLzRApDovy0K6b4fNHeYiiqGWYKMMgf2wyOkKSwa/5nZYIYH+
         jIYzZVNzdu/896bxOVoFmffcShiUAzXl0btfzg5O/OdadMlHAoriEyDVhwm/m9weg3Qt
         1p8A==
X-Gm-Message-State: APjAAAVjto9hx24GniqNu32GTraj5tkotjJokGDRZAAEXXv2AtRiocoL
        CCUpBuOK0+JKcjZMn08gh9E=
X-Google-Smtp-Source: APXvYqxkuWGs3uAyX46jXKCtiEm5ayZycWle7yUGI/xC+sSZC+q8gSiZ/Wjop3rhktth44rmaCo/WQ==
X-Received: by 2002:a81:5f54:: with SMTP id t81mr57519738ywb.171.1556676404232;
        Tue, 30 Apr 2019 19:06:44 -0700 (PDT)
Received: from [127.0.1.1] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id d135sm7372111ywd.16.2019.04.30.19.06.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 19:06:43 -0700 (PDT)
Subject: [bpf-next PATCH v3 0/4] sockmap/ktls fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 30 Apr 2019 19:06:42 -0700
Message-ID: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series of fixes for sockmap and ktls, see patches for descriptions.

v2: fix build issue for CONFIG_TLS_DEVICE and fixup couple comments
    from Jakub

v3: fix issue where release could call unhash resulting in a use after
    free. Now we detach the ulp pointer before calling into destroy
    or unhash. This way if we get a callback into unhash from destroy
    path there is no ulp to access. The fallout is we must pass the
    ctx into the functions rather than use the sk lookup in each
    routine. This is probably better anyways.

    @Jakub, I did not fix the hw device case it seems the ulp ptr is
    needed for the hardware teardown but this is buggy for sure. Its
    not clear to me how to resolve the hw issue at the moment so fix
    the sw path why we discuss it.

---

John Fastabend (4):
      bpf: tls, implement unhash to avoid transition out of ESTABLISHED
      bpf: sockmap remove duplicate queue free
      bpf: sockmap fix msg->sg.size account on ingress skb
      bpf: sockmap, only stop/flush strp if it was enabled at some point


 include/net/tls.h    |   24 ++++++++++++---
 net/core/skmsg.c     |    7 +++-
 net/ipv4/tcp_bpf.c   |    2 -
 net/tls/tls_device.c |    6 ++--
 net/tls/tls_main.c   |   78 +++++++++++++++++++++++++++++++++-----------------
 net/tls/tls_sw.c     |   51 ++++++++++++++++-----------------
 6 files changed, 103 insertions(+), 65 deletions(-)

--
Signature
