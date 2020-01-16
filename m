Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3B13D63B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 09:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgAPIzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 03:55:22 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40379 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgAPIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 03:55:22 -0500
Received: by mail-pf1-f196.google.com with SMTP id q8so9892476pfh.7;
        Thu, 16 Jan 2020 00:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5NzqbBEkxkSuYM/ZGLsJo0QW7Wfw6a+IQ0AAbdm2SPc=;
        b=rJeGioyvDXR7+57VG8LYw4QyGKiI8K6ViFt2imTXCY2GKgCIdnVSQAyhNEbVAneeyQ
         y+5UH03jIDTYfqUxCqqUYkBQ7m/C4BtlVnZgLolWtOW7MktgZY/KH0DX8jJO1Lao0T1V
         6SbiK4YJ+TwyP2jxI5w0/GPxkXRMjzp0+MG+YciMAWwj4DXUYTiy1XVJ/eRRevTJMPJb
         kV7Pimg3KCGLNXpQpI1EYXID92DF3dv6/J2oh8mmORdM6Pa7yPPDAakuxijhbAYr4Xi1
         q6sMtkD8vjSaTzJ0X0aPKEdAXOfiGAp/prOJ29njiY8mmh4NSVU0xY44hrfCu3Q1paiz
         wTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5NzqbBEkxkSuYM/ZGLsJo0QW7Wfw6a+IQ0AAbdm2SPc=;
        b=Vwj8b0O59s6wlmE+iJIph/RM4BiJm0ZfQfgbGKKs7vTjaO7LD49wCZgSozQQE/6Nuq
         VMxK4GBYIGi4zPkdyivWl+oYPW1MK06iCYZedfMYJZB3ONaOSf83h6vWh+pKyMQqXGqC
         xNXbVCC/7VcPgQdrO2k1+jI45uMYY1+Sgb/XV6l7rDxa6kan6pVAZNDyWgn8aTr5428K
         rqlonfkRheUb+iiNk12GQ4ma4W3GmYAEPJ9tXbEQZKbGRc0u0ZaOYPPocdg85gS8yvi0
         g9Jx37RpUZLMiycx+9rC7ELNX3sEHW8DW1qDqnszJgrNDXPJNbuzyCN8bjAfbN0cHlXf
         7Lkg==
X-Gm-Message-State: APjAAAW6KCylma0Bn1CchZBEuH/jrN2iXIIftVSQcu7BUv8ewSbwC1KL
        Qai+pvn7jYlg9uHY6YQnzOA=
X-Google-Smtp-Source: APXvYqycZ0RIsMDQtbgKih2ubyZyzIgHSW8DfFSVQqld83PKuEE4rx0fWIyCIcvKR6YUVvW+YF09Bw==
X-Received: by 2002:aa7:90cc:: with SMTP id k12mr36660748pfk.105.1579164922140;
        Thu, 16 Jan 2020 00:55:22 -0800 (PST)
Received: from hpg8-3.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id h3sm2643746pjs.0.2020.01.16.00.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:55:21 -0800 (PST)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf 0/2] Fix the classification based on port ranges in bpf hook
Date:   Thu, 16 Jan 2020 17:51:31 +0900
Message-Id: <20200116085133.392205-1-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I tried a test based on the selftest program for BPF flow dissector
(test_flow_dissector.sh), I observed unexpected result as below:

$ tc filter add dev lo parent ffff: protocol ip pref 1337 flower ip_proto \
	udp src_port 8-10 action drop
$ tools/testing/selftests/bpf/test_flow_dissector -i 4 -f 9 -F
inner.dest4: 127.0.0.1
inner.source4: 127.0.0.3
pkts: tx=10 rx=10

The last rx means the number of received packets. I expected rx=0 in this
test (i.e., all received packets should have been dropped), but it resulted
in acceptance.

Although the previous commit 8ffb055beae5 ("cls_flower: Fix the behavior
using port ranges with hw-offload") added new flag and field toward filtering
based on port ranges with hw-offload, it missed applying for BPF flow dissector
then. As a result, BPF flow dissector currently stores data extracted from
packets in incorrect field used for exact match whenever packets are classified
by filters based on port ranges. Thus, they never match rules in such cases
because flow dissector gives rise to generating incorrect flow keys.

This series fixes the issue by replacing incorrect flag and field with new 
ones in BPF flow dissector, and adds a test for filtering based on specified
port ranges to the existing selftest program.

Yoshiki Komachi (2):
  flow_dissector: Fix to use new variables for port ranges in bpf hook
  selftests/bpf: Add test based on port range for BPF flow dissector

 net/core/flow_dissector.c                          |  9 ++++++++-
 tools/testing/selftests/bpf/test_flow_dissector.sh | 14 ++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

-- 
1.8.3.1

