Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C907D79B83
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388888AbfG2VvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:51:15 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:44823 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388890AbfG2VvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:51:14 -0400
Received: by mail-pl1-f201.google.com with SMTP id n1so33885464plk.11
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ky51eWLkWqKn9vu5XgFYadpIqkYzkr7aTFdFnNTQm0s=;
        b=MFkx4MeFQBofsS1qaTHjIDBKc57vd+P4SE7zguji88eHPTh5dHAbyt0Wj8MHWUhRIy
         bGIZK0mzCbLdKDFDx5S+/B5GiconXVgjxvUDZ1u6WjHLNp4qC827KCLx9I0Y84ET2Q/R
         JCABlHwuAN7Iv75sGV/3in5j88iY9cKEJ+mw9XP9YVUB22qEJ0TYyM8qIaDpU7xC18YY
         ca/bL1OJkRfiHBmB1XL63yktzBXcoQJ3kkjbf/kdM+CDn0rxmPE5IVqQpdMPhQOAESUX
         BkbU0DA3ChotuIBVK7iCyrdArSZCRxFgMO51R3oTxNtAlSRF5SzKlHz6hL/hJsjch0yX
         NnTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ky51eWLkWqKn9vu5XgFYadpIqkYzkr7aTFdFnNTQm0s=;
        b=NUmdbWH/uvmOd0Zm/mIET/OWJ1uJ8kD3dV9du1SXLioNlwk7ndynZKT0QNT9kkbJ8b
         ktpvKe33rp60J+ENXSsDu2e4jt4dCzsz+eexRhBGNQLGxJxl28kzetvUaAtbOwxjYh0H
         VXa4Nav1nESSvCyA3S+uLsnOVupuduxFQDlBpzu617cCgSDxfm12KqhedvEvNbrtQyuV
         59GRRuWoSYCYI31eSUuhPX2b3eq9CQ9wsBqUoOkFVf8b6lejwwu6POGy1xu8bqyokpTa
         f58W1F1wv9e6dKTkAQTN5Soy0+Kxlg4lGG3BizM4GoJ9qRMCT8i/XtS0Eyi9X2FB3RsE
         tpzA==
X-Gm-Message-State: APjAAAWuOeYvRapRjaXff1xDV5BvfFYVcYA6yBVL5LOMGFpiZtHfX+cy
        fxneT/VLscnw3ziJFlQLM2o6NlaptHizSeaKelWxUmRQ5VG4EQT8f3WC/w4vvmDvxh0VtzdViT3
        pKxCZBRqytNtBcy2fxsuPyYv4b9FFnWfa5zwdJw05viBE1EP1jguybA==
X-Google-Smtp-Source: APXvYqyFxOxYQ67UvP3oT4a6QlvXzPKBxO+TGpvCE3BuhjhqfW2WM1GR+PmaoqJFc002MDt4vtWnjns=
X-Received: by 2002:a65:56c1:: with SMTP id w1mr104359426pgs.395.1564437073710;
 Mon, 29 Jul 2019 14:51:13 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:51:09 -0700
Message-Id: <20190729215111.209219-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH bpf-next 0/2] bpf: allocate extra memory for setsockopt hook buffer
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current setsockopt hook is limited to the size of the buffer that
user had supplied. Since we always allocate memory and copy the value
into kernel space, allocate just a little bit more in case BPF
program needs to override input data with a larger value.

The canonical example is TCP_CONGESTION socket option where
input buffer is a string and if user calls it with a short string,
BPF program has no way of extending it.

The tests are extended with TCP_CONGESTION use case.

Stanislav Fomichev (2):
  bpf: always allocate at least 16 bytes for setsockopt hook
  selftests/bpf: extend sockopt_sk selftest with TCP_CONGESTION use case

 kernel/bpf/cgroup.c                           | 17 ++++++++++---
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 22 ++++++++++++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c | 25 +++++++++++++++++++
 3 files changed, 60 insertions(+), 4 deletions(-)

-- 
2.22.0.709.g102302147b-goog
