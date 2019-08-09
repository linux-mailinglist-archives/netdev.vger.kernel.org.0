Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2960387B2C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406992AbfHINdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:33:01 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:45088 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfHINdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:33:01 -0400
Received: by mail-pf1-f173.google.com with SMTP id w26so808503pfq.12
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 06:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mj8zOEJLehxhwpmimz0j7s8vN7Fm8n73QrYr7XDAlPE=;
        b=DIobLYjqPNlfRv2OqhYWImOuTDwKXsjMQ5LfRaJpdzo30csmVrNDlayB0C8EF5SRaw
         4misOKtHCPfySJ0efcj01oUNwXgT59COwwyIMoyZtZ6SyRn6gtpoyDCUAgEro3kTUvcI
         +5g3jP6t05nNNwwE+c7SsyZs8vXF/huqo6PnRD6d4T9a0PuGH6hWUMHZu2AoLASxTIYp
         L4nDmySizLnqn/nBN6M2Y94AhHrJD0g7bR6+WVjhSalQIOue65nSJPA67PYY7o2nNAt0
         0fyMi/ASwfS0BiRRSKM1SlfTPsRcICrnrmB+KMJxqpreZZROLEPzJYwUJBMl1syrzSar
         gO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mj8zOEJLehxhwpmimz0j7s8vN7Fm8n73QrYr7XDAlPE=;
        b=k9OoGAfcNABKOMiA0bQRQbp/KxTkccLvTMPt0Lp3GMHr4UEexotMtyJR2sw6Fr5sLA
         IcQlBx1+m5k+uwtM8Y9IEMt+fyvu0CrFgjEC+zL+j1wkja+H66CsQtFaiJVYXKeF6c+C
         g203HN82DeFHHy33TbeJpZQYvjBxv9huo1JoGuV9q+7k7bLIBDTqVVdcbx0GR/OIGEBB
         udmjnC0EdB13PwzZhRQd19kC2HKX40UjyvcB+wB/2JMKgzpAPCwyNvfnAe9MaHPTK4rY
         /kH1O0/Y+bYNhumbJxEPOSX8KeJsUwWObzAFbu6RqjIhAxTZaGTj0HxGqi/BOFJf3ftQ
         rPpw==
X-Gm-Message-State: APjAAAUmyt/qVhBuaL4f8yDxpFWarw8UNh9gFiR9HWWJ6T8v7eN4uSws
        b+Qr1SgSjCGEOnXabF6sTA==
X-Google-Smtp-Source: APXvYqy3CBpxZhgTgF5rbWBKC3su90k2N4CpJxQYIevJyLyJgolQAcPMeMl1ichKvB5hQ2au+DvP/g==
X-Received: by 2002:a63:de4f:: with SMTP id y15mr18098875pgi.239.1565357580546;
        Fri, 09 Aug 2019 06:33:00 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f15sm7242912pje.17.2019.08.09.06.32.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:32:56 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v4,0/4] tools: bpftool: add net attach/detach command to attach XDP prog
Date:   Fri,  9 Aug 2019 22:32:44 +0900
Message-Id: <20190809133248.19788-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bpftool net only supports dumping progs attached on the
interface. To attach XDP prog on interface, user must use other tool
(eg. iproute2). By this patch, with `bpftool net attach/detach`, user
can attach/detach XDP prog on interface.

    # bpftool prog
        16: xdp  name xdp_prog1  tag 539ec6ce11b52f98  gpl
        loaded_at 2019-08-07T08:30:17+0900  uid 0
        ...
        20: xdp  name xdp_fwd_prog  tag b9cb69f121e4a274  gpl
        loaded_at 2019-08-07T08:30:17+0900  uid 0

    # bpftool net attach xdpdrv id 16 dev enp6s0np0
    # bpftool net
    xdp:
        enp6s0np0(4) driver id 16

    # bpftool net attach xdpdrv id 20 dev enp6s0np0 overwrite
    # bpftool net
    xdp:
        enp6s0np0(4) driver id 20

    # bpftool net detach xdpdrv dev enp6s0np0
    # bpftool net
    xdp:


While this patch only contains support for XDP, through `net
attach/detach`, bpftool can further support other prog attach types.

XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.

---
Changes in v4:
  - rename variable, attach/detach error message enhancement
  - bash-completion cleanup, doc update with brief description (attach types)

Changes in v3:
  - added 'overwrite' option for replacing previously attached XDP prog
  - command argument order has been changed ('ATTACH_TYPE' comes first)
  - add 'dev' keyword in front of <devname>
  - added bash-completion and documentation

Changes in v2:
  - command 'load/unload' changed to 'attach/detach' for the consistency

Daniel T. Lee (4):
  tools: bpftool: add net attach command to attach XDP on interface
  tools: bpftool: add net detach command to detach XDP on interface
  tools: bpftool: add bash-completion for net attach/detach
  tools: bpftool: add documentation for net attach/detach

 .../bpf/bpftool/Documentation/bpftool-net.rst |  57 +++++-
 tools/bpf/bpftool/bash-completion/bpftool     |  65 ++++++-
 tools/bpf/bpftool/net.c                       | 176 +++++++++++++++++-
 3 files changed, 278 insertions(+), 20 deletions(-)

-- 
2.20.1

