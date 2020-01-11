Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A398B137BC1
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgAKGMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:12:24 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:35198 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgAKGMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:12:23 -0500
Received: by mail-io1-f68.google.com with SMTP id h8so4445805iob.2;
        Fri, 10 Jan 2020 22:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O9cAtZX+jQRLW+3bJ03zk7zXTO3mItghIEmHM4zbesk=;
        b=AxjPdH9ozmLvjdarCcxEZtGPiHW/o/LiG4DXoaQuD0hJngsy9Uow+Essg6c0zOOqlF
         CnhDX2+BoTepKq7sYJpn+BhaE8gQRGEg2rNUBCK0OMivUaaLZFS7dr4FoGI3HrhAt/ea
         PKb0033RGN4vu9ZQAwz8vB5fp4eSlELMRVIxShUxuzv31tYmos6nynDYR6XzXDe/j8kV
         5YqQHHSF5ku9pH85CUwtMJxMVL1m0d6kRJqpFtBlm9eMwLoQE7twbP3CoFudylxQ5UkH
         k5rdoGJVW0qTTBtOJcxoXmuEwFy6+/0LAZQvLPH1twD9aHn914qGz4jLGVVJEJi0sUy8
         lzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O9cAtZX+jQRLW+3bJ03zk7zXTO3mItghIEmHM4zbesk=;
        b=Q7w70uGqQ8KNuQXd/7nvuy8fiLZZgkrdBuzjD1z46b1jULstP+/+lY/eC23ZcfRXEf
         0GLGy+nLMuNOGdZzoawjbFXz5mK2UZRxKeSA7mIeTFeRnWpHj773BTk69taLOrnFcu20
         Icsecweej95Wc9ub4bq4J40LXHb/DwvYqYlQ8P/E7V6cQMMWfgkEDuJJMh/w52luz7J5
         c3gab6sWkJvLN6TQl1NHlbEPj7FgHcVNq63RXLJO8PONjR74Bu17az4VyXFHX9pJykw5
         RIrZXARFEve4fh9Z8WRbJuBL4NbOxpBmxzw/GrX21qn5IJCOCy1SuGIYIO4MiNkfuYDS
         8YAQ==
X-Gm-Message-State: APjAAAWP/T3GMq/p3aLBczuUUFt+Mw85HO1PbZVslq6Xd/5wYRjlD5Cx
        QlWC4xlkmrrC4TYUI4lHcqUb4agh
X-Google-Smtp-Source: APXvYqxeZUGKKtjK0vKJz5AEOlrGYfIVXBom2NgMs7+uqFSLD3uD2+zchF00M/jta+cG8cuL2zrfjw==
X-Received: by 2002:a02:13ca:: with SMTP id 193mr6322567jaz.54.1578723143062;
        Fri, 10 Jan 2020 22:12:23 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:12:22 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 0/8] Fixes for sockmap/tls from more complex BPF progs
Date:   Sat, 11 Jan 2020 06:11:58 +0000
Message-Id: <20200111061206.8028-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To date our usage of sockmap/tls has been fairly simple, the BPF programs
did only well-defined pop, push, pull and apply/cork operations.

Now that we started to push more complex programs into sockmap we uncovered
a series of issues addressed here. Further OpenSSL3.0 version should be
released soon with kTLS support so its important to get any remaining
issues on BPF and kTLS support resolved.

Additionally, I have a patch under development to allow sockmap to be
enabled/disabled at runtime for Cilium endpoints. This allows us to stress
the map insert/delete with kTLS more than previously where Cilium only
added the socket to the map when it entered ESTABLISHED state and never
touched it from the control path side again relying on the sockets own
close() hook to remove it.

To test I have a set of test cases in test_sockmap.c that expose these
issues. Once we get fixes here merged and in bpf-next I'll submit the
tests to bpf-next tree to ensure we don't regress again. Also I've run
these patches in the Cilium CI with OpenSSL (master branch) this will
run tools such as netperf, ab, wrk2, curl, etc. to get a broad set of
testing.

I'm aware of two more issues that we are working to resolve in another
couple (probably two) patches. First we see an auth tag corruption in
kTLS when sending small 1byte chunks under stress. I've not pinned this
down yet. But, guessing because its under 1B stress tests it must be
some error path being triggered. And second we need to ensure BPF RX
programs are not skipped when kTLS ULP is loaded. This breaks some of
the sockmap selftests when running with kTLS. I'll send a follow up
for this.

v2: I dropped a patch that added !0 size check in tls_push_record
    this originated from a panic I caught awhile ago with a trace
    in the crypto stack. But I can not reproduce it anymore so will
    dig into that and send another patch later if needed. Anyways
    after a bit of thought it would be nicer if tls/crypto/bpf didn't
    require special case handling for the !0 size.

John Fastabend (8):
  bpf: sockmap/tls, during free we may call tcp_bpf_unhash() in loop
  bpf: sockmap, ensure sock lock held during tear down
  bpf: sockmap/tls, push write_space updates through ulp updates
  bpf: sockmap, skmsg helper overestimates push, pull, and pop bounds
  bpf: sockmap/tls, msg_push_data may leave end mark in place
  bpf: sockmap/tls, tls_sw can create a plaintext buf > encrypt buf
  bpf: sockmap/tls, skmsg can have wrapped skmsg that needs extra
    chaining
  bpf: sockmap/tls, fix pop data with SK_DROP return code

 include/linux/skmsg.h | 13 +++++++++----
 include/net/tcp.h     |  6 ++++--
 net/core/filter.c     | 11 ++++++-----
 net/core/skmsg.c      |  2 ++
 net/core/sock_map.c   |  7 ++++++-
 net/ipv4/tcp_bpf.c    |  5 +----
 net/ipv4/tcp_ulp.c    |  6 ++++--
 net/tls/tls_main.c    | 10 +++++++---
 net/tls/tls_sw.c      | 31 +++++++++++++++++++++++++++----
 9 files changed, 66 insertions(+), 25 deletions(-)

-- 
2.17.1

