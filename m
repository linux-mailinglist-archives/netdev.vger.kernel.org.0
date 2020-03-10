Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FD817F104
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgCJHcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:32:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39533 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJHci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 03:32:38 -0400
Received: by mail-pl1-f194.google.com with SMTP id j20so5096020pll.6;
        Tue, 10 Mar 2020 00:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=s0zEJebkaQaphBbo9A8dUhgJs1fcUTVttAj+f7LO9b0=;
        b=lMJ8zGD/Qrj8Vf/qmKN+UWUvSKfEor9DooAYTZ9OEeMeXdj4df2FTWVJ8u0p9S/5Q5
         VGsMuC8Lt6bpuFG6Zqgob+tXdKq0+lreA+Uch+Em7WTRB9o5rrweGNLiSpqAIf6c3NsN
         yB+0b7mEZjYy9Mffq/cw63vB9RjypcRFo5xxwZyR+rzhxxZHHJ+p52TidpZ4kr2iiTVF
         DNZMYuXKkPl9h1GrXknqbMlfXd/repo8oBP1Frr9iFwVihaF4/MTmH3KHr4WVQo1Lwes
         RAkgFWtu65Nx+6mzT3vZK8XaG7GswYyT0ElVFKecEaE5wmjcOyvVPlVOWE09wo2SiMYr
         urZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s0zEJebkaQaphBbo9A8dUhgJs1fcUTVttAj+f7LO9b0=;
        b=lYbQSTcwzjbaYO/21gJ7C7Pys9/z5BzZH58+wtCmrUBfH5Yi/6aRcnV7BC9FV+w7IS
         8BuvpoA8+Ofq23j8zxCuG0EHx7GVNtE112i1MdPwGFl326vvfU+4mFB9ahPWAFDU9+FF
         ne0nz1FC/3hrbU6KVAaJ2/fooaWXoXTOBRlpY3O91t5pVA5gZmG6RDaUq6Nt12EKrNzl
         iey2IV2QOOHb5dH+HYMjfJFNi4YmRZlTMzEVLHNce7FnoVs8knUD3gKvH9QMzmkys26K
         hFEbPda/Y72q6p3n3Ic+YEzHfAuYGXv/sBlidDXRPS1x/2D3uYyCVZJ05k4CdzoZ7M+O
         rRPA==
X-Gm-Message-State: ANhLgQ1teV+rDlQ3Bu0nhKkWa8G4ACUOa5dZ/QzqZIFcOs2/ClvuhgL2
        jDnws69FjXH1sVeWUFo4Zs4=
X-Google-Smtp-Source: ADFU+vvPAYZn0IBsxVjvSjO3NoKQF8kbOwBaYJcPa//3Xj5dWlNwqSoT09+mdJ9SHKaPcEYXoS5Zmw==
X-Received: by 2002:a17:90a:1912:: with SMTP id 18mr387104pjg.124.1583825558088;
        Tue, 10 Mar 2020 00:32:38 -0700 (PDT)
Received: from dali.ht.sfc.keio.ac.jp (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id t8sm1075109pjy.11.2020.03.10.00.32.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 00:32:37 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 bpf 0/2] Fix BTF verification of enum members with a selftest
Date:   Tue, 10 Mar 2020 16:32:28 +0900
Message-Id: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_enum_check_member() checked if the size of "enum" as a struct
member exceeded struct_size or not. Then, the function compared it
with the size of "int". Although the size of "enum" is 4-byte by
default (i.e., equivalent to "int"), the packing feature enables
us to reduce it, as illustrated by the following example:

struct A {
        char m;
        enum { E0, E1 } __attribute__((packed)) n;
};

With such a setup above, the bpf loader gave an error attempting
to load it:

------------------------------------------------------------------
...

[3] ENUM (anon) size=1 vlen=2
        E0 val=0
        E1 val=1
[4] STRUCT A size=2 vlen=2
        m type_id=2 bits_offset=0
        n type_id=3 bits_offset=8

[4] STRUCT A size=2 vlen=2
        n type_id=3 bits_offset=8 Member exceeds struct_size

libbpf: Error loading .BTF into kernel: -22.

------------------------------------------------------------------

The related issue was previously fixed by the commit 9eea98497951 ("bpf:
fix BTF verification of enums"). On the other hand, this series fixes
this issue as well, and adds a selftest program for it.

Changes in v2:
- change an example in commit message based on Andrii's review
- add a selftest program for packed "enum" type members in struct/union

Yoshiki Komachi (2):
  bpf/btf: Fix BTF verification of enum members in struct/union
  selftests/bpf: Add test for the packed enum member in struct/union

 kernel/bpf/btf.c                       |  2 +-
 tools/testing/selftests/bpf/test_btf.c | 42 ++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

-- 
1.8.3.1

