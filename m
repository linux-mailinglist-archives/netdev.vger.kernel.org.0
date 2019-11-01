Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060E5EBC36
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 04:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfKADHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 23:07:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41894 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbfKADHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 23:07:12 -0400
Received: by mail-lj1-f193.google.com with SMTP id m9so8759228ljh.8
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 20:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9YjtUu+ZjBUpJQENL1NViWSeyjL7FzrnZoX2E0Dq1O0=;
        b=gk6PoWf6ZXUa6579VGeypvSp4C/K6mNANQBb4tcmQkX6dvtZSZ34TzwohmOP6ZKOTc
         yI2zVzM1p6A5omsx/w3LB/K8p7bHFBaIBapdzxh8ZQjSmhgZDdm9nQRNZ7s+LnrLKj7y
         K6VDH3NV+FnkRVRTTfXfj6JQMJykdHCALOx7GmhgLth14vV+BxmHHzdFvoCzKveVQoHF
         a1Y2P2JG3diLgCGQvJ7YAVDeEne5EwFbeA+hWYxq7yv4O0u8mtJCPAFzl2tvshSWc5xq
         LmV+glrUysJXth9xi+SuUpU5t2IDftsgo30B0GzaeEor4M72n5U0jdq0y37gjyDG2Npn
         dMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9YjtUu+ZjBUpJQENL1NViWSeyjL7FzrnZoX2E0Dq1O0=;
        b=VfrV63j7A+p2nVMn6DyN5Oh4vGTRiv1GMv8118ovD2aEoESZ5OUuYNdZPm2dVYmhxc
         /FpVDM05HSoChR79dGgyH9IWDZGoPVqdkY/C9uZeytkjQdEAxTEVcUf/ahFcl4GkrdbS
         9A9Z/wW28lHZTbtbEIsJtShgeh/gxVCHteIKHduZ3v73zM/B+BLax+A525xE1lZR6eb0
         EjCnboxShoXUDSkihaBBCSD1f2fcqwytyw+TH9xQQLKRjSb+hzz1AjohMP089HOn1KDU
         JSFof5kjLEHe6KVo79bGGo8dOszhqBIsQEAGKLTXoW3ANiUNAnoWFH8JkoicSlhw9epD
         e3XA==
X-Gm-Message-State: APjAAAVLI9mwC+9E7reFvEzQxoi5KxadMe+uI03etZ/l2BM6DTsc1fyE
        OaLIOUMXHmltb1y2wm+XY3JHgQ==
X-Google-Smtp-Source: APXvYqxBgStPWBSoVB7roZSG+OwDwgB8iap4XvkdoTiqNOC9zDQxJ8xPS2ZnA0FZbY47bi/cZihz+w==
X-Received: by 2002:a2e:8694:: with SMTP id l20mr6374058lji.64.1572577630658;
        Thu, 31 Oct 2019 20:07:10 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v6sm3926282ljd.15.2019.10.31.20.07.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 20:07:09 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/3] fix BPF offload related bugs
Date:   Thu, 31 Oct 2019 20:06:57 -0700
Message-Id: <20191101030700.13080-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

test_offload.py catches some recently added bugs.

First of a bug in test_offload.py itself after recent changes
to netdevsim is fixed.

Second patch fixes a bug in cls_bpf, and last one addresses
a problem with the recently added XDP installation optimization.

Jakub Kicinski (3):
  selftests: bpf: Skip write only files in debugfs
  net: cls_bpf: fix NULL deref on offload filter removal
  net: fix installing orphaned programs

 net/core/dev.c                              | 3 ++-
 net/sched/cls_bpf.c                         | 8 ++++++--
 tools/testing/selftests/bpf/test_offload.py | 5 +++++
 3 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.23.0

