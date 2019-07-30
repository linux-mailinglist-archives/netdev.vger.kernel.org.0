Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620797B292
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388100AbfG3Ssa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:48:30 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:47023 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388035AbfG3Ssa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:48:30 -0400
Received: by mail-pl1-f174.google.com with SMTP id c2so29211775plz.13
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WcUHzym1gbeR/y8wly4UNAAsBumEa/S3PgO1brIS+UE=;
        b=trwG9JGtz3jj+lojTLLXSquM7XmtUwp9iXd1994h5lRDPPwmwTMGEbgkkMGN73MPim
         kycLhwzMllJPNfp+R/ko/1yRHs27HARGIINs1/wdHJ0hh4G5CuQ1UZl3vowe5oUdCnTU
         XTZ/LjeTkMdog9npgwCXAcmEY4+6lRXN/zMVyc6BQOtVfYJI1Hf3SkGuf1hiDx9CEiP3
         eWiBU/oL0tUWlTDcyA1BqpyLn0V2HY5fiPDWl/x1GobO3FiUnEjxk2K/hfbWlktkARcX
         4WKD0kXfndy1AaMqf4sg5fG7Gj3bYun7i7X0bXZZghFhvR2S+x+tOjHEwI7rTJGyG1sA
         Mi3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WcUHzym1gbeR/y8wly4UNAAsBumEa/S3PgO1brIS+UE=;
        b=sjyCqvybA7WzNrotj27BQK+D6OiGVfouazTC4pggZ0FzKbuJMKkKhMh5NoT7tZCgCL
         eUaBHgV44HqJWjaH3ZzSK/Fy6PNR51DVtEz8HjuTTmLSmJsQaGZpsPe2TSVk7VuBcuR2
         7n3QczqydRD5dl92v4TnZHJv04ksMx8qfeNcgQ0jjNmHFVfzDokcUGmqJbCOeMurpKbk
         CD1d4jMp5qQfyNJBbhehpY0X8/dEH4k4hPjFPOHMK+rClXLS6p6FdeXTjMZqc9oDkO9O
         lu84D3f1Wn/TuI9tUXfNLO9JlEyZjpdNWZRe3o+OT5asv/QTHOIzbMixsbvgiIYMJA0A
         VaGQ==
X-Gm-Message-State: APjAAAW4omYROu6CNthVLaCedoIbXi0cqytBhexvzmW41ZtcpmSjk3tZ
        JYdkewtkbAsTcZ6rcBbJSZfQw8c=
X-Google-Smtp-Source: APXvYqwqDrVBJG8bWQzRMtstOhsIZymRCvUvnFxwUFAl3p6nLoUO5pGrKLWqcj5kvBl52QSWAXMxzg==
X-Received: by 2002:a17:902:20e9:: with SMTP id v38mr19702749plg.62.1564512509887;
        Tue, 30 Jul 2019 11:48:29 -0700 (PDT)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id 143sm102878183pgc.6.2019.07.30.11.48.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 11:48:29 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 0/2] tools: bpftool: add net (un)load command to load XDP
Date:   Wed, 31 Jul 2019 03:48:19 +0900
Message-Id: <20190730184821.10833-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bpftool net only supports dumping progs loaded on the
interface. To load XDP prog on interface, user must use other tool
(eg. iproute2). By this patch, with `bpftool net (un)load`, user can
(un)load XDP prog on interface.

    $ ./bpftool prog
    ...
    208: xdp  name xdp_prog1  tag ad822e38b629553f  gpl
      loaded_at 2019-07-28T18:03:11+0900  uid 0
    ...
    $ ./bpftool net load id 208 xdpdrv enp6s0np1
    $ ./bpftool net
    xdp:
    enp6s0np1(5) driver id 208
    ...
    $ ./bpftool net unload xdpdrv enp6s0np1
    $ ./bpftool net
    xdp:
    ...

The word 'load' is used instead of 'attach', since XDP program is not
considered as 'bpf_attach_type' and can't be attached with
'BPF_PROG_ATTACH'. In this context, the meaning of 'load' is, prog will
be loaded on interface.

While this patch only contains support for XDP, through `net (un)load`,
bpftool can further support other prog attach types.

XDP (un)load tested on Netronome Agilio.

Daniel T. Lee (2):
  tools: bpftool: add net load command to load XDP on interface
  tools: bpftool: add net unload command to unload XDP on interface

 tools/bpf/bpftool/net.c | 160 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 159 insertions(+), 1 deletion(-)

-- 
2.20.1

