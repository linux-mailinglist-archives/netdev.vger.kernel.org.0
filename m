Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEFD124F7F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfLRRil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:38:41 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43701 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLRRik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:38:40 -0500
Received: by mail-pf1-f194.google.com with SMTP id x6so510818pfo.10;
        Wed, 18 Dec 2019 09:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JeVljfXt+9SF34AxwW1FoItcy/91qpaXVmwI2wwDlZE=;
        b=hA1Jj2cp6fHyCmFC77gPBW+M2nPOY4jjdTasBDMyHW9pbCG0c8B3It+PP1YJKlJuKN
         XcHHZqulBNXpRgR6jALnkvhaJVsPwZSV2O0xAr1Pirh0tQVysSpJVCFMjHAdBpqq3L1g
         jglxPWNzlMvWAbYulNQL09kyIZd4Qpi8FW/eKLPEcRnPS0HsQ7h+N1a9NmDE5BO2Mqod
         ZLhtDF/CbJRs3J7vj+JXbK8/m12vWsestIkP5+iIgCo0FrQUkcSfuKqL7OtL9/g4zzOY
         QQcr6loFxN0tRI6VWqNGJbKB23nhYvxXXroXcFnhWThhZJEmio1G4F/n7XTke3R3KJ5c
         efGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JeVljfXt+9SF34AxwW1FoItcy/91qpaXVmwI2wwDlZE=;
        b=ds9BuCcLuq+18oFbiZP7xpx0iOs1wznzM33aBJU9skKakMWHbbRehDjLPjgvdgfAj1
         wf69/brvhgUEsl1Qdd8fHTq7ar45DJJvQkOElQtJs98hkB60dSEC4Mqajz6CSPRLarlj
         1jLJvN8d7h5YaZ4Kw530jK7vnTwC0F8gHd7evZayuEXCd6PPsij5RunPMCSSA/km3r2F
         jqwhdMrxBoswdDQjYCuv6YGmk3jVHlYKCt6IE10sjps7j80BpD84F9U0hEZV/xAJH1Ei
         xU4JZnebyt5z56bn/7hFCbBsioqIDMsbyLn7W55/iJC2d/UsjZMxX8VtDnAEQAUFm1la
         5wWg==
X-Gm-Message-State: APjAAAVArs8ZfPNACvaBDcSUIpm698TnmydJO2nYFbgv/D2RodBlMB18
        6rr+JLxZuJdhixSqgaZDfa+W1NOv1r4=
X-Google-Smtp-Source: APXvYqxfi0bZ0D+y9AQIuGRFklFuGMv6JQbcerF/mzxLcsvBagLz/gWJ719T91FWTg/QGg2an3p7vA==
X-Received: by 2002:a63:4e06:: with SMTP id c6mr4265578pgb.187.1576690719711;
        Wed, 18 Dec 2019 09:38:39 -0800 (PST)
Received: from bpf-kern-dev.byteswizards.com (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id s15sm3991925pgq.4.2019.12.18.09.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:38:39 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v16 0/5]  BPF: New helper to obtain namespace data from current task
Date:   Wed, 18 Dec 2019 14:38:22 -0300
Message-Id: <20191218173827.20584-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
scripts but this helper returns the pid as seen by the root namespace which is
fine when a bcc script is not executed inside a container.
When the process of interest is inside a container, pid filtering will not work
if bpf_get_current_pid_tgid() is used.
This helper addresses this limitation returning the pid as it's seen by the current
namespace where the script is executing.

In the future different pid_ns files may belong to different devices, according to the
discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
used to do pid filtering even inside a container.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>


Carlos Neira (5):
  fs/nsfs.c: added ns_match
  bpf: added new helper bpf_get_ns_current_pid_tgid
  tools: Added bpf_get_ns_current_pid_tgid helper
  tools/testing/selftests/bpf: Add self-tests for new helper
    bpf_get_ns_current_pid_tgid.
  bpf_helpers_doc.py: Add struct bpf_pidns_info to known types

 fs/nsfs.c                                     | 14 +++
 include/linux/bpf.h                           |  1 +
 include/linux/proc_ns.h                       |  2 +
 include/uapi/linux/bpf.h                      | 19 +++-
 kernel/bpf/core.c                             |  1 +
 kernel/bpf/helpers.c                          | 45 ++++++++++
 kernel/trace/bpf_trace.c                      |  2 +
 scripts/bpf_helpers_doc.py                    |  1 +
 tools/include/uapi/linux/bpf.h                | 19 +++-
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 88 +++++++++++++++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      | 37 ++++++++
 11 files changed, 227 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c

-- 
2.20.1

