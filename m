Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56243BF40
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbfFJWQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:16:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43442 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387661AbfFJWQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:16:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so660695wru.10
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IKIq02XJnd4doip+1T4XIktccTpOsQUMyChN9DGfsPw=;
        b=ZcFZxfVMLI65vHyscCOsB3ovqOwdZdIsaBdwc07xA3ZlcxYwlQvsqiZ3mglGSIcVxc
         hyigTk1I5fVaXesbjA+mzIbcbp5C5XHwRTxwxhA4tM2Mrbh8zmptGOQKKd2vc2UGSFd9
         MlmM/xIwsAyzs2YYb1Qn+1FfUev8zQfTJrpVu4CfUcTsZjugsxsOmJ0XYYjRl+G8vbTt
         ZxYwEZIJX6PCEeYrK0ME15OGZPsT//nwwtdBw63O0Ka8q2MCFPkida3X/eVVeo1rNGf4
         Rp62yu69Wox/WBXs1qdZx5rB55g99MuL1k2CSdFrOOSX7wYv0WqLzZ+XBtmG6sO3cW3+
         aK6A==
X-Gm-Message-State: APjAAAVsvxQCazWBp2bH2EO3i9J3Nf3qwk/f4WfGP0TcWOQz2ExgqV3N
        P/RIc4mw6PsX9xXwoLOubjlI+aeL634=
X-Google-Smtp-Source: APXvYqzipazRmBqYqqYtTEN2yZAzJeQvSN8KrlpVdaLS2Z8RNABKxmvNiGOw6JT2uQCBhwXeenL+pw==
X-Received: by 2002:adf:efc8:: with SMTP id i8mr19172882wrp.220.1560204982919;
        Mon, 10 Jun 2019 15:16:22 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-152-91.cust.vodafonedsl.it. [93.144.152.91])
        by smtp.gmail.com with ESMTPSA id w23sm581674wmc.38.2019.06.10.15.16.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 15:16:21 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 0/2] refactor the 'ip netns exec' command
Date:   Tue, 11 Jun 2019 00:16:11 +0200
Message-Id: <20190610221613.7554-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the netns code so less steps are needed to exec commands in a netns.
Also remove some code which became dead. bloat-o-meter output:

$ bloat-o-meter ip.old ip
add/remove: 0/5 grow/shrink: 3/3 up/down: 159/-358 (-199)
Function                                     old     new   delta
netns_add                                    971    1058     +87
cmd_exec                                     207     254     +47
on_netns_exec                                 32      57     +25
netns_restore                                 69      67      -2
netns_switch                                 838     822     -16
on_netns_label                                45       -     -45
do_netns                                    1226    1180     -46
vrf_reset                                     55       -     -55
do_each_netns                                 57       -     -57
on_netns                                      60       -     -60
netns_save                                    77       -     -77
Total: Before=667505, After=667306, chg -0.03%

Matteo Croce (2):
  netns: switch netns in the child when executing commands
  netns: make netns_{save,restore} static

 include/namespace.h |  2 --
 include/utils.h     |  5 +----
 ip/ip.c             |  1 -
 ip/ip_common.h      |  1 -
 ip/ipnetns.c        | 49 ++++++++++++++++++++++++++++++++-------------
 ip/ipvrf.c          | 16 +--------------
 lib/exec.c          |  6 +++++-
 lib/namespace.c     | 31 ----------------------------
 lib/utils.c         | 27 -------------------------
 9 files changed, 42 insertions(+), 96 deletions(-)

-- 
2.21.0

