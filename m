Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67FEBE91B
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 01:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbfIYXnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 19:43:20 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:54205 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732369AbfIYXnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 19:43:19 -0400
Received: by mail-pf1-f201.google.com with SMTP id x10so358170pfr.20
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 16:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=letqQmLXhJ26rePJwfyNH6mOlQABi2YzpNRsxYXK53E=;
        b=gmrYnfSyTw1f26hABnX/14Tb9gHphBFSw9ysWsgslFndsIS/thnap2A+ID8uNwvGyr
         F7l1E+w5g3Hr1Imb/26usjnR+JYI70d9JOEXVJz4ZMI/wCTVSWWtM7AXAD0TpMP+Z6XM
         ASQTuWmoxQxoN/2VnRYGrfqpewkdqCwkbBsmhFCWZnCbYu4jWNlMSCV+iLV8uW0Q0Lif
         Ik3IeqlI2VjdwTtVN60S+lOApHVsy6ljioP7tLO7E+d94Pe8dMcMQ7iCbSfTOXez8EYh
         ugWmWP4uscscHN/HxOLgxnwxQQKqIVsRMCdzmFiETn6bUHWpv3JptiifMAgF+TJqPenD
         tb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=letqQmLXhJ26rePJwfyNH6mOlQABi2YzpNRsxYXK53E=;
        b=eQUDesibCIOIwLhbAwLoZ73Ly4QfV0IngmdEZaaO3ZEOLIDlXf6Agb5g/+aJhPbUyd
         YbakYU1XofPTItsBSKYF0DUQv6xEksTEby8MoepNEkTao6Kt6WjujwBN339DpkNpulVy
         1NcqcLVrXESIkRqXcaFYWiX0i99DZTlLIc4pUNP2o2bnFcmCDGOey/3XnCB+lpbKqO6D
         uE/2k5zYJTEcR5WoEB/C2/f8nXjYpZ2MX0mW+erT8QRaoPC+E9BVYtU+pyNkDlg0x7ex
         M34ioPMDOhfQQd8h56sStyJh7euhLJIXdxMYq4dzOXc88zVAjl0MNNmjWONdnZXerH/Q
         BkVw==
X-Gm-Message-State: APjAAAWCZwwceaOS1uOCJCBAygk0X5gWf1rZ6pMbkY2X3srTGExMm7la
        Hnu1xazXfDJYTKWJCFYtb5t1zUZLCYggCxTl
X-Google-Smtp-Source: APXvYqxQVs372ouu+aLaaayQVqtcE03MHqaadSJn7DSgd+z9iXf12wBvc9lGG+0dcKkpCNi+16J0Keb/KJRGd+Aa
X-Received: by 2002:a63:2104:: with SMTP id h4mr428099pgh.295.1569454998771;
 Wed, 25 Sep 2019 16:43:18 -0700 (PDT)
Date:   Wed, 25 Sep 2019 16:43:11 -0700
Message-Id: <20190925234312.94063-1-allanzhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH 0/1] bpf: Fix bpf_event_output re-entry issue
From:   Allan Zhang <allanzhang@google.com>
To:     daniel@iogearbox.net, songliubraving@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Allan Zhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_PROG_TYPE_SOCK_OPS program can reenter bpf_event_output because it can
be called from atomic and non-atomic contexts since we don't have
bpf_prog_active to prevent it happen.

This patch enables 3 level of nesting to support normal, irq and nmi
context.

We can easily reproduce the issue by running neper crr mode with 100 flows
and 10 threads from neper client side.

Allan Zhang (1):
  bpf: Fix bpf_event_output re-entry issue

 kernel/trace/bpf_trace.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

-- 
2.23.0.351.gc4317032e6-goog

