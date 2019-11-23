Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3272107D35
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 06:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKWFwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 00:52:01 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:44462 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWFwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 00:52:00 -0500
Received: by mail-pg1-f170.google.com with SMTP id e6so4450721pgi.11;
        Fri, 22 Nov 2019 21:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zQ92mgVm1rR2M+K2diP3O/4E8CY55ARRKTkfWyR8vrI=;
        b=QrKD8w2mOZdURS7pS0D+C/Xhcfg7c/Ko3nX8quIuijWzwhHbpPH0QnN4wX7uyTxT8C
         oLxFfwVV6LOcWjhuuFtNOVkbL2WIR1Lh1SEtpFz5dTSajlrObEp/qH9B4PU6U1R4qHPj
         ha5/D57P3K1pXEesqk2062pTYFWdxmjkEEXYNq5OwHBgUO1uR1jgAcDaT+mnaED6PTD2
         Hx51insCJrKHwaqO3bqBZiX+O1OQDAEHlswI2pxbxQUtUS46OM105VGQwgdxDeM1DQ+f
         vyRWv0VMx/m/spESa+6a0k70MvzlrBxmjY1G5eH00q0hCJlhh0RgCQccEwNkw1ThxyXL
         4Log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zQ92mgVm1rR2M+K2diP3O/4E8CY55ARRKTkfWyR8vrI=;
        b=JsfrOR6lNFHH2hznGc0OO2f7B6EZ+IntRJLoVohBFuz2WvUY4e0p1RNrC1ZGJ5lsnn
         W91G6NBze4V3fnl75Qqxw7MnulafGmxMRvZiX+eBcJPh9PRG5enL+pgyBzINJSV/cofa
         20NHkR7zPnGLLaxLIVAfJ1WdCUxevDeo7IGc1ptyBEo0UH2qI8kSRhRy8jkD9+5zSTGr
         dms3d3AIjGK/y3Iiqx0fExCpoCF3LmWzK3CGhIAYMUsl6547bSZXFxkdQX9dn+Pgj7Ei
         m1kAe2EATxxTDe8BRasvZoPnKXfPYjofdhAZ7xY9rk5768O61FsiBqap25JQ+uaeSGUU
         GaQg==
X-Gm-Message-State: APjAAAUoTYgfqrvmbBMcQljBVDLrBAFHspnt8Dq9h5bBvugfhOvp93GU
        23+i1bbxasQfs0JQZlnGiw==
X-Google-Smtp-Source: APXvYqzkMPk0vfE207LlYDSPcq8crGI33mkH1kcUkDBr0U0qD/QIqMfXR1IDdhlzbFDUy9m7KAsTdw==
X-Received: by 2002:a63:ec03:: with SMTP id j3mr20470249pgh.212.1574488318574;
        Fri, 22 Nov 2019 21:51:58 -0800 (PST)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id s22sm738350pjr.5.2019.11.22.21.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 21:51:58 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next 0/2] Fix broken samples due to symbol mismatch
Date:   Sat, 23 Nov 2019 14:51:49 +0900
Message-Id: <20191123055151.9990-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there are broken samples due to symbol mismatch (missing or
unused symbols). For example, the function open() calls the syscall 
'sys_openat' instead of 'sys_open'. And there are no exact symbols such
as 'sys_read' or 'sys_write' under kallsyms, instead the symbols have
prefixes. And these error leads to broke of samples.

This Patchset fixes the problem by changing the symbol match.

Daniel T. Lee (2):
  samples: bpf: replace symbol compare of trace_event
  samples: bpf: fix syscall_tp due to unused syscall

 samples/bpf/syscall_tp_kern.c  | 14 ++++++++++++++
 samples/bpf/trace_event_user.c |  4 ++--
 2 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.24.0

