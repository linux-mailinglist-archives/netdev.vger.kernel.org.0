Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FF98426B
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfHGCZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:25:20 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:33769 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbfHGCZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:25:19 -0400
Received: by mail-pf1-f181.google.com with SMTP id g2so42568554pfq.0
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 19:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekOgQIBsMwnrAjxkyOsz/hK2IP4FxPL2nZk2m1Uz9kY=;
        b=LNX0pJpIOxQkvrD5XdBv9Q9zI4jlCu1mN1gn1skIn1JFzJGclLXjfvj0SI/bAw6snY
         lAfrs/wLgtMz/fwQoWu5K7EmHXUgsL0g/PDNOyQkJ/NpehjvliQpMZF6DDibW+8nv5y+
         opM80qgVkATnMDFG0AE4p487FlYgQRgTNfitHX5ATs9Mcj9sNY+3/e8s5V6FkisON7t3
         2WBvJW0+29kPboa+X6pgQYcaIh72yxlcBqI3/u6aSjIobp4aWpgfdy+YsSVcIHldEL2E
         t3k/CgxxEXnxWKC8yTA2efwCdNqveVuVwJq0D3QRw863VVg41DrH1AKy/0GQsfQrTpeV
         LoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekOgQIBsMwnrAjxkyOsz/hK2IP4FxPL2nZk2m1Uz9kY=;
        b=ZK03Jn/x6ZiLw7aTG0UCSOS47sQhDCCH+tqXsIUkSFhnsTy8SjcyVtxkkzv2JLKijd
         B2YwMuQ8AJo5Sg8aJCtWFQrt9GuJJ5hNo2q4xtCvEUCnJSCNKYxCOX9fRF1sGwSLlIiE
         /f0Pq442QS7jmvhRcHXyv59SqIrHJddqqUDOxFcgGRJse0oz/cd7hH/c6cK1QchyeA+U
         esvI1dlw9DkU8V5n8pHkKb/RskhvkiE4T/tcsGpd1Pu9xqNJcLjGTDMHMyjoNoCq4MUd
         BDYahX59tHPMIO5gTiTkZL+IlQ6GeAhRPZwMB43yZDW1/LbQ0jMqPEttpG41xRjUwm2h
         9Sgw==
X-Gm-Message-State: APjAAAWZzv2urdDGgm2L2MnO1WuI1alI/EK4hM3x0zIlW6b36Pi7RSym
        yR2wd+klWBMs2ljIbJWgGM4oPMRZjg==
X-Google-Smtp-Source: APXvYqyHt9ZoL14ybVH9rrRn6xMdMJ2Clmc8cn6o4JDSrBinN31/GvjgvkL82/Hyp/u41J8MC1WNIw==
X-Received: by 2002:a62:1d8f:: with SMTP id d137mr7050346pfd.207.1565144718767;
        Tue, 06 Aug 2019 19:25:18 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id b126sm129275991pfa.126.2019.08.06.19.25.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 19:25:18 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v3,0/4] tools: bpftool: add net attach/detach command to attach XDP prog
Date:   Wed,  7 Aug 2019 11:25:05 +0900
Message-Id: <20190807022509.4214-1-danieltimlee@gmail.com>
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

 .../bpf/bpftool/Documentation/bpftool-net.rst |  51 ++++-
 tools/bpf/bpftool/bash-completion/bpftool     |  64 ++++++-
 tools/bpf/bpftool/net.c                       | 181 ++++++++++++++++--
 3 files changed, 273 insertions(+), 23 deletions(-)

-- 
2.20.1

