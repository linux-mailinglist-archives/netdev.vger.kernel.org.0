Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F08FCDAD4
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfJGDxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 23:53:41 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39099 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfJGDxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 23:53:41 -0400
Received: by mail-qk1-f195.google.com with SMTP id 4so11347903qki.6
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 20:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y776qBavRQFUqAS2URydT3RTV+ivGdZq0JkpV7lAqaQ=;
        b=RquB0NiKWqhQOST5/g+c8exselpQDnrpph389vxlEbqty5Um5AzTRScBMf7JS53Lp8
         P9RHPjI9unSdG/w24cH9ZotwTgfhD4VXGO9VoLLAQCL4TpcgiBrZtoUzRhceKYTawX4c
         ZM6ss4YVrKwPjbEd/V0tUquEet0AnBt6l10o1hNi74adDy2s8aVKmjP8eMAl1RyWipcL
         AsrNdme367NgrB9byR0YazeA6C39NOaEVqoaQgSGPan2rY2YccyGLtFAY2Mc3+mdkTZF
         ZJbI/MXQC0HCfM7fMiSqstM9fRvW4wK4pw8gF/ifbNwjDbeKWW3rdsX7XzunSeANIBXD
         rWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y776qBavRQFUqAS2URydT3RTV+ivGdZq0JkpV7lAqaQ=;
        b=OPFBsV5vJt055yRyrDbMT+3pk7dbc9b20D2fFinmbNPCkdS8LwPvLc31GzIECoOmWW
         z8bXMWG+NKoHFYsI246N7HbK7RmOGour5nVYq8K8vOPz+3VSDIBaSrBq82mttr9iBsKq
         DZ00pDUs12JIH3fci9pECm81RQYMbUk2sTb9R8eTQIPfDdVuSM3k5mG0pO9XzS1AP3J6
         s7ddPHIlxJiqMlKBsIZ7v2ng22UAcaFEbvQAMw+KHOdIE1XzgQZM2mUAY+nLkDadUQCb
         FqGYOGuoAYsmGCmPau4qh/WnRcJ9xQ3H92KucvJd+EgDGyOwQqA/TdbWLeFgKFjx0pL+
         Uwng==
X-Gm-Message-State: APjAAAWvJpOsZ01tytKfqyNSugaXiltXCuqhROxUd/Marc+RPfuA+D1a
        yZN0rhkyORS7r2syOJCoqz4ykGgkAnA=
X-Google-Smtp-Source: APXvYqwD5/uV13kalniwvap9Z8uAn2HDDuORhZj6mP7Pz4tO18dredG8X+VCcLNVTcb1QzDyAkFFgw==
X-Received: by 2002:a37:7086:: with SMTP id l128mr20957258qkc.433.1570420420235;
        Sun, 06 Oct 2019 20:53:40 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 4sm7469863qtf.87.2019.10.06.20.53.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 20:53:39 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        willemb@google.com
Cc:     oss-drivers@netronome.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [RFC 0/2] net/tls: don't block after strparser error
Date:   Sun,  6 Oct 2019 20:53:21 -0700
Message-Id: <20191007035323.4360-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I was investigating the correct behaviour around small receive
window size and were slightly surprised to find that currently,
if the recv buffer is too small to fit the entire record, TLS will
report -EMSGSIZE once, and then block indefinitely on a subsequent
call.

Perhaps naively I'd think that the error should keep being
reported since the error condition is never cleared.

One way or the other I'd like to engrave the correct behaviour into
a selftest so I'd appreciate guidance on which one that is :)

This set makes the TLS socket keep reporting the strparser error
until it gets closed.

Jakub Kicinski (2):
  net/tls: don't clear socket error if strparser aborted
  selftests/tls: test the small receive buffer case

 net/tls/tls_sw.c                  |  7 +++++--
 tools/testing/selftests/net/tls.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

-- 
2.21.0

