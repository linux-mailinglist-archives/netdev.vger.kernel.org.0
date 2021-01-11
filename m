Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59EA2F1EA0
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390772AbhAKTHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:07:40 -0500
Received: from mail-ej1-f53.google.com ([209.85.218.53]:39796 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390003AbhAKTHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:07:40 -0500
Received: by mail-ej1-f53.google.com with SMTP id n26so1197186eju.6
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 11:07:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HzbTrvjtlGUYvgpKbuUUKzIL8QOc51MUAayKDc1J+mY=;
        b=qnF7BIo9denBQEYr9yN+FFgzhy3+IWU/Q7bfzJby6nIuUpXE0KS/r0SnCsSC7BAuqt
         2qsqB9RCEjqFf48R+6U28GDvMLIuTDEXH7ZtDSlFUZdA1SDx2lBevMI6RQu1TXj/dWum
         tewR33KD5ex4yNj0eq+izy2uiif0OQIlsOPxqCPiCh9dS04jeHf+19Wr0chaBWZuCWRk
         +zsq+MaKJkSe5aeaZlXnhDoAsdPMveKo5lx0tA73LMXGD570eJFw9kK8nDChiKL6UkJo
         koAdVvtbBv0hf01q4V7ATn1OobtE6vb+o5hEFQKJy283qrdtNdx+tJRrwY5HS5rN94Ti
         qYlg==
X-Gm-Message-State: AOAM532fKu4RT8ImZasjdpY/rpKPjwB4iTfXdUsKIeGJoTXV6Kodfldu
        4dOV8ry3vEjOhMCFTURiG3+J/ek8SSQMcQ==
X-Google-Smtp-Source: ABdhPJy1GfW6Vsy2jCQs8CSWNIm/buQY/55PiTRaenndLnu38pYYGyGFPX8wv2RC3ex8RTUj7tD02g==
X-Received: by 2002:a17:906:934c:: with SMTP id p12mr627252ejw.361.1610392017854;
        Mon, 11 Jan 2021 11:06:57 -0800 (PST)
Received: from msft-t490s.fritz.box (host-79-19-49-141.retail.telecomitalia.it. [79.19.49.141])
        by smtp.gmail.com with ESMTPSA id cb14sm193140ejb.105.2021.01.11.11.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 11:06:57 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next] ip: don't use program name to select command
Date:   Mon, 11 Jan 2021 20:05:45 +0100
Message-Id: <20210111190545.45606-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

ip has an ancient behaviour of looking at its program name to determine
the command to run. If the name is longer than 2 characters, the first two
letters are stripped and the others are interpreted as the command name:

    $ ln -s /sbin/ip iproute
    $ ln -s /sbin/ip ipa
    $ ./iproute
    default via 192.168.55.1 dev wlp0s20f3 proto dhcp metric 600
    192.168.55.0/24 dev wlp0s20f3 proto kernel scope link src 192.168.55.26 metric 600
    192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown
    $ ./ipa show dev lo
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever

This creates problems when the ip binary is renamed. For example, Yocto
renames it to 'ip.iproute2' when also the busybox implementation is
present, giving the following error:

    $ ip.iproute2
    Object ".iproute2" is unknown, try "ip help".

Since noone is using it, remove this undocumented feature.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 ip/ip.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/ip/ip.c b/ip/ip.c
index 40d2998a..9b772307 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -311,9 +311,6 @@ int main(int argc, char **argv)
 
 	rtnl_set_strict_dump(&rth);
 
-	if (strlen(basename) > 2)
-		return do_cmd(basename+2, argc, argv);
-
 	if (argc > 1)
 		return do_cmd(argv[1], argc-1, argv+1);
 
-- 
2.29.2

