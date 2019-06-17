Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7D847F14
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfFQKDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:03:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33013 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfFQKDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 06:03:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so9281625wru.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 03:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q9iC2zpNvR/4/vuqpkuL60ZklxwtOn8GN+5QGFE3xZ4=;
        b=hAJwRQmQ9IAmrWU80aGo4/X3dMrgVgO+TdbdDG0mAyYAAZn22Uincvu8BDLNfvxCK0
         0FMPmiW5c9iw02zScaLrE04jjPu4KDgq/Jm4KOSF8Hbh2JcOMdSZVHIBYzKMFDRPNhf6
         WmPFh03H6mM7jz7kyePqFCi9qZn0eFK60CfvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Q9iC2zpNvR/4/vuqpkuL60ZklxwtOn8GN+5QGFE3xZ4=;
        b=V1lEqW1dEGOLkBPtVlW0z4q9KUNnCcCuaXCSqZUOpYyFyPxSvOQh27nfLl4ZN04oW6
         j8JQzHWvo9FQCzTfNxB7j2u52qZc8mjc5SC8zkdA4dxwD0pTVtpIivBiBTCc2jX0nSCW
         EUrOkwo4MO8VarNkQV20S3Gzq1Vjyt+wZwEhtHChBuG+hsy4eOnaTicmsguISA8ajNf8
         ZzpnIDIikpYFnfhdPqUNZgFLxceKRWFyDDFbNoBNWh4SZz7elsBZE5u9lBzWG1tn/N5m
         lJu0xoMpyTauycb4eRCjQY/djXaXZpUIlgKS6j3ccE8hAeJ7sHsFcEDZ9GPikv+uJJNj
         JT1A==
X-Gm-Message-State: APjAAAUQ7tGDeLyY0FUWGBvti6Jt4XKJLOBatAVV60jQQzMjb2L0Tq8B
        YROfbqVE2bXQjWyvCR8evvhaPLj2yXwgYw==
X-Google-Smtp-Source: APXvYqziWscC5ejsyLBeJCAfUnKKgXp+r/OxAjczqTtiVsu5yF2HAKfmsxVk3H2sku0DnjtoZwS06w==
X-Received: by 2002:a5d:4950:: with SMTP id r16mr30730920wrs.136.1560765828045;
        Mon, 17 Jun 2019 03:03:48 -0700 (PDT)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1268:6500::dc83])
        by smtp.gmail.com with ESMTPSA id n1sm9791302wrx.39.2019.06.17.03.03.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 03:03:46 -0700 (PDT)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     netdev@vger.kernel.org
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH net-next 0/2] net: sched: act_ctinfo: fixes
Date:   Mon, 17 Jun 2019 11:03:25 +0100
Message-Id: <20190617100327.24796-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is first attempt at sending a small series.  Order is important
because one bug (policy validation) prevents us from encountering the
more important 'OOPS' generating bug in action creation.  Fix the OOPS
first.

Confession time: Until very recently, development of this module has
been done on 'net-next' tree to 'clean compile' level with run-time
testing on backports to 4.14 & 4.19 kernels under openwrt.  It turns out
that sched: action: based code has been under more active change than I
realised.

During the back & forward porting during development & testing, the
critical ACT_P_CREATED return code got missed despite being in the 4.14
& 4.19 backports.  I have now gone through the init functions, using
act_csum as reference with a fine toothed comb and am happy they do the
same things.

This issue hadn't been caught till now due to another issue caused by
new strict nla_parse_nested function failing parsing validation before
action creation.

Thanks to Marcelo Leitner <marcelo.leitner@gmail.com> for flagging
extack deficiency (fixed in 733f0766c3de sched: act_ctinfo: use extack
error reporting) which led to b424e432e770 ("netlink: add validation of
NLA_F_NESTED flag") and 8cb081746c03 ("netlink: make validation more
configurable for future strictness”) which led to the policy validation
fix, which then led to the action creation fix both contained in this
series.

If I ever get to a developer conference please feel free to
tar/feather/apply cone of shame.

Kevin Darbyshire-Bryant (2):
  net: sched: act_ctinfo: fix action creation
  net: sched: act_ctinfo: fix policy validation

 net/sched/act_ctinfo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.20.1 (Apple Git-117)

