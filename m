Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DCDD3013
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfJJSR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:17:57 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:43364 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfJJSR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:17:57 -0400
Received: by mail-lj1-f178.google.com with SMTP id n14so7166908ljj.10
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 11:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5tkv7J2E4M+jPkGxyjFNBxMyy+SZ1PuNIvOUG2qBR0I=;
        b=fEySpYW9c/B3ki5Ej182OSxCs2hWv28c06E0d893hiaGWEQg7Mnyy7orJO1AwPRaYV
         Q6i0sWtRqJ5shFiXBZtNgAwHA1spUdkFgoJqcCnIgG8oqR6NuuVj5gq0VIl+yTOsjAG/
         zWQqNP0yUqlof7MDI7RsJHY6vKFZ5iPteoSFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5tkv7J2E4M+jPkGxyjFNBxMyy+SZ1PuNIvOUG2qBR0I=;
        b=SaDRD6vO0rldcvKL4WiJixs6PPgfWHJ0h2eeM2+gtscf682tP3dJhtuaosBNxRsepr
         u2iC8Rs5ocMHcJVL2KhkTpV9sTT9e8vn0BK0OcmPd8g/+kJoxZKyZP+E9O/O4HZmgaZP
         yoisrGfMC1cgR3fpY+YLwT9rPEQ2UA6+fPQ1+QBTORZpBSY+AtFOR2Ns4wXe6js8mQmJ
         O6Qs8GQQnAMD7RlunrlSv0kmAUSOtHMb64/6Era68ioOOjHN3AuZ6qmK89VqV2QgPJez
         pQ0Szk4pM5f+Cnz6MC7bb7U5YKM5h2OCUhdecTr8kQlTs9m7WGhNoQ4aHQb9XLiFgQXs
         uBzg==
X-Gm-Message-State: APjAAAU1WQZmmAyf6yLaMkSTzc0ekuyaIGlFtGU9rKwVxt54JcKzD9q3
        nsWoEFEJZKQ5QX8AunhjDfLvbRGmKfAhrw==
X-Google-Smtp-Source: APXvYqyYCLJbJZ+iWszeoF4t8dUj66NGan7cEpj3Ut4Q3tmwqx+YSPrCEJOBU5OXjNYy2fjO4WzCMg==
X-Received: by 2002:a05:651c:20b:: with SMTP id y11mr6914222ljn.211.1570731473424;
        Thu, 10 Oct 2019 11:17:53 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h5sm1533883ljf.83.2019.10.10.11.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 11:17:52 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [PATCH bpf-next v2 0/2] Atomic flow dissector updates
Date:   Thu, 10 Oct 2019 20:17:48 +0200
Message-Id: <20191010181750.5964-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set changes how bpf(BPF_PROG_ATTACH) operates on flow dissector
hook when there is already a program attached. After this change the user
is allowed to update the program in a single syscall. Please see the first
patch for rationale.

v1 -> v2:

- Don't use CHECK macro which expects BPF program run duration, which we
  don't track in attach/detach tests. Suggested by Stanislav Fomichev.

- Test re-attaching flow dissector in both root and non-root network
  namespace. Suggested by Stanislav Fomichev.


Jakub Sitnicki (2):
  flow_dissector: Allow updating the flow dissector program atomically
  selftests/bpf: Check that flow dissector can be re-attached

 net/core/flow_dissector.c                     |  10 +-
 .../bpf/prog_tests/flow_dissector_reattach.c  | 127 ++++++++++++++++++
 2 files changed, 134 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c

-- 
2.20.1

