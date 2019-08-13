Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEEB8B578
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbfHMKXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:23:48 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33632 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbfHMKXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:23:48 -0400
Received: by mail-lf1-f65.google.com with SMTP id x3so76488799lfc.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 03:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=QNDFND62EBxa/CZRfT2L528o2r4UiKoyt1lXZ8Vl8r0=;
        b=Sv074q9r6jjjV52+0QfZzuE3FVJ3Gnln117xHMSh0yUvexXHce7Ca19L/ufyAwW2HO
         GIClTLInezjob7m5kYcfJp06RDsK5LbIt1PVa0yyOiPjYGT1MX0emf5Qw+8LsdQmqD4G
         i7TyVRxmOnXFrQ2F1yS5yYC1UD4dqbZoqyS8f1FFm8zfVPnI/i10qZFH7zRYx62ei9PA
         ouW68VPvY60rLwI0xusK8FygNzR41KW2tS6pxLqHVQUr1qWFq5yzk6VczQGboJWjG7lI
         7+bMfcre/Fj5GJ8/+vMBLq84HkDazNq5iFBJTRQXEf934J6KXvaTZe8jxZMyBQKNoSGU
         V00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QNDFND62EBxa/CZRfT2L528o2r4UiKoyt1lXZ8Vl8r0=;
        b=WDMar9LK2K5Aj9IxGPl9/ssyfSWPdgbpnxYyAhug1CvVc0b6ac27F5hfTALx7oj67I
         eMWlmk2ePlBqvJ3njp2wbwAzSUP4BCNrhw1zfrtWysx6P3jVsUFmh4wSy9ftD2kIoFAC
         dGWftWtApZDeEODcjp+1I5BmmeuNXjsnhjZES1cs26kQ+U/GCAYAtXRizQzFUxR3SeMd
         erXfPUrafk+mDhcFkXmy8gzR83i50sU2T1m94jmgsBameHPR2NOofvP1+0CzoR7NfPSO
         G4js27C/hKMlH4sRbRAcJ8YpUgzkC8uNAKPQwpKKsWgzDgT8RqM3dknIqbZcwsZD/M6F
         +/uw==
X-Gm-Message-State: APjAAAVRjxk0BG27LVPjj6ni84Qv5vWviDfj8H0t0BqmThuRBMCN3dLP
        iTLvbIYSXjBPqQrcR3dJMYDaEQ==
X-Google-Smtp-Source: APXvYqzIeZP4BTswUMbAIKKYK0uFCs4Sn6L/wWwzKIQ+KwsGx46yWPFum+AePDpFDtH7gV8rVc/mKw==
X-Received: by 2002:a19:c213:: with SMTP id l19mr21590844lfc.83.1565691826113;
        Tue, 13 Aug 2019 03:23:46 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id e87sm24796942ljf.54.2019.08.13.03.23.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 03:23:45 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com
Cc:     davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 0/3] xdpsock: allow mmap2 usage for 32bits
Date:   Tue, 13 Aug 2019 13:23:15 +0300
Message-Id: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains several improvements for af_xdp socket umem
mappings for 32bit systems. Also, there is one more patch outside of
othis series that can be applied to another tree and related to mmap2
af_xdp umem offsets:
"mm: mmap: increase sockets maximum memory size pgoff for 32bits"
https://lkml.org/lkml/2019/8/12/549

Based on bpf-next/master

Ivan Khoronzhuk (3):
  libbpf: add asm/unistd.h to xsk to get __NR_mmap2
  xdp: xdp_umem: replace kmap on vmap for umem map
  samples: bpf: syscal_nrs: use mmap2 if defined

 net/xdp/xdp_umem.c         | 16 ++++++++++++----
 samples/bpf/syscall_nrs.c  |  5 +++++
 samples/bpf/tracex5_kern.c | 11 +++++++++++
 tools/lib/bpf/xsk.c        |  1 +
 4 files changed, 29 insertions(+), 4 deletions(-)

-- 
2.17.1

