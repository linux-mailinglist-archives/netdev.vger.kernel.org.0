Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD598B9F1D
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 19:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfIURMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 13:12:44 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:43788 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfIURMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 13:12:43 -0400
Received: by mail-lj1-f175.google.com with SMTP id n14so4884938ljj.10;
        Sat, 21 Sep 2019 10:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BDyXtpOUervuzaQV6afAdyUIWrNV4O1le4mtASsc0Hc=;
        b=F+/WC98oxaI5cHve/eoHTftl15Qnett4hL/oKJKm6zQJIPVQDPvBhCwrZ3CJTTDvqz
         DBGLwdX4higd+YEQv/agaB/TALabBFeG/rRFrZwWu1BULC/KVq3iNfWMpvyG7MfpOuGW
         Kn3XTPJUNGtlbOpQ75gWSjNWGSWJpIrsYIPQCFtSiVf5Mt0pKqt4OFad4pYGvE0WkzFJ
         iITMIFsOjf+sdNzAuYTt9Uk8jSY1yV65fpKzuVOhtsez0k18qHNwIcXXoKO+4ws5STKe
         yGg5QLbD44GHeqAZuyziyah+065p6Lzba245cqFKign/yDlYpnJzb+3DyPNDxgMCul2O
         BS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BDyXtpOUervuzaQV6afAdyUIWrNV4O1le4mtASsc0Hc=;
        b=kkB6mnTOayFwWAiMxzeY/Ke9b7kdZantX83mZcNtuUnAUFxHxOo4Tlqw2/VM4Mgc4r
         Ca/eW+u3ZBP8BGs55JN+vqp19xjWIo2rn9dSkes9/DKcK0jhK4s5Mp0x10bAqNkGhLQA
         l4pjob37ykKfLIfwbe04s7D7aFIYfRoBe4osjI2b6Ta/uSQpgpnCTi8lpTPx/nzvBc4j
         oPepUqMupew6LzcowiffF0rZhX5r25nZQYAytaGtY3SvuuWNDo3OmGb2SZ6clkeN7Ydq
         nwy9YCcnIajAARYBrJMgmbPT3EJ+h89sbKKEfP9JF7CQJVoUT9XzPflkLe9TdB11swT9
         TANw==
X-Gm-Message-State: APjAAAXBGE79AbgjAqsyV/70+3rXS5iTu+2MhdzloXCvYZ8UvyEDi4zk
        eTcktCx+hhjEB1x2QpWgOu/Kk6Hl
X-Google-Smtp-Source: APXvYqwPqJeIPFlIUuMAS8lkSmQCcsW0CT7tC8+IwvsS75HDZeqeCv/OjJ0cU0zxgjFR0dGqzG2gcg==
X-Received: by 2002:a2e:8802:: with SMTP id x2mr12547028ljh.113.1569085961114;
        Sat, 21 Sep 2019 10:12:41 -0700 (PDT)
Received: from [192.168.2.145] ([94.29.45.178])
        by smtp.googlemail.com with ESMTPSA id k7sm337509lja.19.2019.09.21.10.12.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 10:12:40 -0700 (PDT)
To:     Johannes Berg <johannes@sipsolutions.net>,
        Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From:   Dmitry Osipenko <digetx@gmail.com>
Subject: [next] regression: WiFi doesn't work after "nl80211: Add support for
 EDMG channels"
Message-ID: <e82fa5e1-c6a3-e4c4-92b0-64cc8285b825@gmail.com>
Date:   Sat, 21 Sep 2019 20:12:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Patch "nl80211: Add support for EDMG channels" broke brcmfmac driver on one of my devices, the newly
introduced cfg80211_chandef_is_edmg() erroneously returns "true" because chandef->edmg.bw_config !=
NULL. Apparently this happens because "chandef" is allocated on stack in nl80211.c (and other places),
the "edmg" field isn't zeroed while it should be. Please fix, thanks in advance.

WARNING: CPU: 0 PID: 409 at net/wireless/nl80211.c:3118 nl80211_send_chandef+0xd3/0xd8
Modules linked in:
CPU: 0 PID: 409 Comm: NetworkManager Tainted: G        W
5.3.0-next-20190920-00177-g89b36954c24f #2381
Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
(show_stack+0x11/0x14)
(dump_stack+0x7f/0x8c)
(__warn+0xc1/0xc4)
(warn_slowpath_fmt+0x45/0x78)
(nl80211_send_chandef+0xd3/0xd8)
(nl80211_send_iface+0x4db/0x6a0)
(nl80211_get_interface+0x39/0x68)
(genl_rcv_msg+0x14d/0x33c)
(netlink_rcv_skb+0x85/0xb8)
(genl_rcv+0x21/0x30)
(netlink_unicast+0xf3/0x144)
(netlink_sendmsg+0x12b/0x27c)
(sock_sendmsg+0x11/0x1c)
(___sys_sendmsg+0x1bb/0x1d0)
(__sys_sendmsg+0x39/0x58)
(ret_fast_syscall+0x1/0x28)
Exception stack(0xe1621fa8 to 0xe1621ff0)
1fa0:                   00000000 bea1b830 00000009 bea1b830 00000000 00000000
1fc0: 00000000 bea1b830 00000009 00000128 00644084 b6fd6930 00683d30 00645330
1fe0: 00000128 bea1b808 b6a1b3a5 b6a1c6b6
