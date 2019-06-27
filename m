Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BB45888B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfF0Rgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:36:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38704 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfF0Rgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:36:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so1584069pfn.5;
        Thu, 27 Jun 2019 10:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=zR/WUBBfrjbEn9Tu3MfRf1HdtbxxKKgyIURMwnf0Q6k=;
        b=bwLcenCKBLeGJLe21WHTtD1qQ6RUxxrgW1QLwsAXjpMV0oKetMd910rB/w3kREqkHg
         +P6G9ZKodbWHRCB6bXLKELjk//ehSao17hfBeWWMMpZcmLrVwKucKuHCGBJG8fkRNRVY
         y+vj3b8watM10ISaLeXp/4b8p4pbGLoo6pzgxbpD15TyhI39KVERy6942hI2cImBf3rE
         pnnBwA4zpHAJLFcdpegEBYrYWoe72VHNQG1dor5pXS6KWRXhW6RDu8pBwxAmEI+BpR0U
         1djKESOey9SmmyXd9JXwgHTmH1yvLnCYTivv4GcaOXaEQce5rP1eLn7vim7owrd9caZd
         QHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=zR/WUBBfrjbEn9Tu3MfRf1HdtbxxKKgyIURMwnf0Q6k=;
        b=bxTQ0BJN2T23dOPLH8DBwpb8jLcxIgHESVFR+USgT1cskWMCFqdaqhfOof1LmhmwZh
         Q8Ip9uEBTuZFjRJ6zqXH96vxPzLfWGv3w6q6A5mzMph2Ztxjhlwk7S2lTQr47yxTyrSm
         xEKRXv0brOstSfd/8US2hfbfY3mXlTZ7UgLNESW9Jq8wcTqnwZafyt6Y2knztT636IFI
         r6RHzsLC6vaSxMyLQhUKtvdrfDJQTSJfOsxqHwp0vgOQ3aj1rqGqDkmi0b4vbukE2+NB
         Ch9D1u2hXplzVHnyPDx+5KmMpFJhejMINNn+6LAJ1UtX99x0BcJwOkMAd/k5H26FXK0H
         GQgQ==
X-Gm-Message-State: APjAAAWdn1UhgTNqU3/zFbI5GoywEhUwrwv3i6OMBXkqLLmvSlJ7/y3x
        7vGUjRAS+1D0r5VdQMIGcaE=
X-Google-Smtp-Source: APXvYqy7dKvArq0y44xc+y9LzlAVq7gO8+LntpvM4eg3sBIEI/1pjf7NKmAuGOseSpY00TumqO80Ow==
X-Received: by 2002:a65:454c:: with SMTP id x12mr4877226pgr.354.1561656996886;
        Thu, 27 Jun 2019 10:36:36 -0700 (PDT)
Received: from [127.0.1.1] ([67.136.128.119])
        by smtp.gmail.com with ESMTPSA id p23sm5229455pjo.4.2019.06.27.10.36.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 10:36:36 -0700 (PDT)
Subject: [PATCH 0/2] tls, add unhash callback 
From:   John Fastabend <john.fastabend@gmail.com>
To:     daniel@iogearbox.io, jakub.kicinski@netronome.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Thu, 27 Jun 2019 10:36:35 -0700
Message-ID: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resolve a series of splats discovered by syzbot and noted by
Eric Dumazet. The primary problem here is we resolved an issue on
the BPF sockmap side by adding an unhash callback. This is
required to ensure sockmap sockets do not transition out of
ESTABLISHED state into a LISTEN state. When we did this it
created a case where the interaction between callbacks in TLS
and sockmap when used together could break. This resulted in
leaking TLS memory and potential to build loops of callbacks
where sockmap called into TLS and TLS called back into BPF.

Additionally, TLS was releasing the sock lock and then
reaquiring it during the tear down process which could hang
if another sock operation happened while the lock was not
held.

To fix this first refactor TLS code so lock is held for the
entire teardown operation. Then add an unhash callback to ensure
TLS can not transition from ESTABLISHED to LISTEN state. This
transition is a similar bug to the one found and fixed previously
in sockmap. And cleans up the callbacks to fix the syzbot
errors.

---

John Fastabend (2):
      tls: remove close callback sock unlock/lock and flush_sync
      bpf: tls, implement unhash to avoid transition out of ESTABLISHED


 include/net/tls.h  |    6 ++-
 net/tls/tls_main.c |   96 ++++++++++++++++++++++++++++++++++++----------------
 net/tls/tls_sw.c   |   50 ++++++++++++++++++---------
 3 files changed, 103 insertions(+), 49 deletions(-)

--
Signature
