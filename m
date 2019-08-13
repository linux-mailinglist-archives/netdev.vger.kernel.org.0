Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A9D8ACD2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfHMCq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:46:29 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:37275 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHMCq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 22:46:29 -0400
Received: by mail-pf1-f180.google.com with SMTP id 129so3796430pfa.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 19:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rRYJBOBSuAmbaEQo+FCrwb6VNNcrNmWkU/JGGzwEodo=;
        b=RVqiRXqKuFkH/KXDF6H/Va5kUnbT3u4knp1x7gghAZlAW6PhpLRIUpx0KhoIxlwXKb
         gk4TrgH7Zzr7h7VLPS7mXYtGxR9TQfrMuwVXIK7iNisHEsZaAK312CwVJFiRCzEedN+q
         vN5gyAaGsN5j+DU8z1skpVk15FS7sky4R7czfXAqqkzNo+a9OtF+AnwsDRl8AjUp4nGL
         l1y9DPc6XWylCbrHIIyIeKtn+ReiEXxtEnIOK9ppZahVs1gcSNnEVFOTxiEk/gu/K+P/
         o0FWuHU1a1duKrX1nJX4QULzpUDKj2TkChTcoeD1/RHJ6WxnxxSKd6bn9oNZ12/fqkxx
         eNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rRYJBOBSuAmbaEQo+FCrwb6VNNcrNmWkU/JGGzwEodo=;
        b=WeofbziI/MOjcHuq4mxH9t0AhZN92mgiwwoD8fMhXthRLQ5SPijJMYXBWf1t61vEJo
         qIFapTf6lIHbUSgL3s9f+cW5t3GzgrdQWkwMbFDX92nG+ekzq78LMhGUF2rVitpDsIwH
         UrbHMlj0mLI+ewTtnedPZzcl6BFYgVjLGtfqReChhiVwwLlDHPNv14ptf4n9mKEFoYZK
         OQETqiZ//jmNX6Ip6WZLX9cRN45TKCdeaBh1RftIC0QKtxOUZaxNpY4tT24kQ49vKSmX
         Ev6M2+CSiLTWEFZCBCa8dINQczPA4UOii8W9zufVRlibj/v0kkip8v6lVjsDcXiT7fv7
         DVYQ==
X-Gm-Message-State: APjAAAVeY6jO9e5rutlws36DINmkFycNLcndBdhSeWvpa8o3O5W1EhfF
        2HQYVcGs6c7nbwoSPeHm2NDQwqXizA==
X-Google-Smtp-Source: APXvYqwAPQ/j+OGXNCnjluX9ugsLbLqmZVTeZHWUaD9vQ+KBhnC4HzlkWdu2u3Rai+Mw4uoWifeWMg==
X-Received: by 2002:a17:90a:5884:: with SMTP id j4mr125766pji.142.1565664388595;
        Mon, 12 Aug 2019 19:46:28 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id h17sm6359826pfo.24.2019.08.12.19.46.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 19:46:28 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v5,0/4] tools: bpftool: add net attach/detach command to attach XDP prog
Date:   Tue, 13 Aug 2019 11:46:17 +0900
Message-Id: <20190813024621.29886-1-danieltimlee@gmail.com>
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
Changes in v5:
  - fix wrong error message, from errno to err with do_attach/detach

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

