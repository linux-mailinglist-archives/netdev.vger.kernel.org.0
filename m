Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1580A520E7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 05:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfFYDIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 23:08:18 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46912 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfFYDIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 23:08:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so8636819pfy.13
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 20:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8wFOOZobSMXR2Ozogj+mX21ZRt7xd/su4rY5KVbYVt0=;
        b=eXdptYKGAEBv3lL90mdyAN1/TVQWLm4tzP3pIFwisfgHE5/8hiwyRsCBLSJ78quKNc
         ZvHyktUyXm7C0E9PoU0VIfWZ9Lzi5Ho1Vi5WZ5c+1u6FzW7XNoiyJqG5Dk0DuOPuTzN1
         lF9iGNdzUl87aKQDM5a6389pW9QrWLqTBaTL/opdsWi6NA4HwAm0lJ1sMdAx+F2vDAsY
         AYa/XbJHW+CM3IX0XevYqPodbU79AWIy9snbiQD22DFZOjrxbThIKLHU5SdNJlq1Aksa
         zuTgP0rly01lf0C3vv8xMQkd9LN1Ei1YiSWUGxcBp8aET2VErzFZiNN3XaMKQokjpY74
         lwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8wFOOZobSMXR2Ozogj+mX21ZRt7xd/su4rY5KVbYVt0=;
        b=IOezaCqcxW+pySm+soAOQisXZS10zp79s5y85DylEa8zkulKFaJNO2e5/YjqGl6QpN
         OEEYAD9WO3UHYkMl9jCXOssjwbER3qO5DuToqC98JK9+4mtSP10Ky2ExJahFEf6dKpZS
         sFRz2JSlbnBdKlzY2eOkC8Jh9EUPZVYywWRL8lBA/oembUuDVds94YQSJYrsJyqiXby8
         b5/UX2zTXCH7fHS0CUzthwqlJa7xEle9N8isvlz5CfEpwzrkXjWnVRHPqb20gB0lCS7V
         bIZ2LbB9c7rXmpFn/H7g7tN2gNcQKPZ8dOldqhy2orATzxSx4e0MtQ/ImJ1MXfLzcPCl
         jkyg==
X-Gm-Message-State: APjAAAUKTuh2tQWjVn/tq3hVVWV004O5p/0Cxh0ovxWF00qrLDCKNiRb
        rB3L3/6QgNpGi9o+8EmGEjzEB6LwaDE=
X-Google-Smtp-Source: APXvYqx9kDVf4UgM+Z/4m4KWUvV7KMBMR+JS4IZs0RnR4mbeWf2PKFlyeKEw83OidETVozhLpKCCiQ==
X-Received: by 2002:a17:90a:cf8f:: with SMTP id i15mr27707097pju.110.1561432097511;
        Mon, 24 Jun 2019 20:08:17 -0700 (PDT)
Received: from localhost.localdomain (p2517222-ipngn21701marunouchi.tokyo.ocn.ne.jp. [118.7.246.222])
        by smtp.gmail.com with ESMTPSA id d4sm708016pju.31.2019.06.24.20.08.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 20:08:16 -0700 (PDT)
From:   Eiichi Tsukata <devel@etsukata.com>
To:     gregkh@linuxfoundation.org, jslaby@suse.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH 1/2] tty: ldisc: Fix misuse of proc_dointvec "ldisc_autoload"
Date:   Tue, 25 Jun 2019 12:08:00 +0900
Message-Id: <20190625030801.24538-1-devel@etsukata.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/sys/dev/tty/ldisc_autoload assumes given value to be 0 or 1. Use
proc_dointvec_minmax instead of proc_dointvec.

Fixes: 7c0cca7c847e "(tty: ldisc: add sysctl to prevent autoloading of ldiscs)"
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 drivers/tty/tty_ldisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index e38f104db174..a8ea7a35c94e 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -863,7 +863,7 @@ static struct ctl_table tty_table[] = {
 		.data		= &tty_ldisc_autoload,
 		.maxlen		= sizeof(tty_ldisc_autoload),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-- 
2.21.0

