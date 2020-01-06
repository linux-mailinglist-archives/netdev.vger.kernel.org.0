Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89129130B76
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgAFB0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:26:50 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37985 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgAFB0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:26:49 -0500
Received: by mail-pg1-f193.google.com with SMTP id a33so26104310pgm.5
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=j+2h6tvzT6ljDYJOqve6ilMGGYQ//lzxKUSA/QblZrM=;
        b=guRtAE3ofoeGsNcUuU3T0whiPl24G0e0JIa6SNJtlggaNtgk5xLf0tmI+QuCWl4vYH
         MConK9TYcpGPDsqDMUgqpkmkuPad6XQQVXdGZghVaZsnNpKiLHMJ8HM/WLGPFLmWeuXY
         uQn63fd9mF7Hf3BRqCjnOB6FvpAYCXTSlCu7dgl1XWSa6WL/Uvp/Jeq74iTaGOqSl5US
         QCSAShI0QrEVNLRNNolL0RqpEkBd1zWeYyQYPZyX8JhFHhrU/GgDtaHlqywi8ASiRsXr
         HvKcmKEMiphfhBp2BCZ809Q6mBnrJoC0LYxiNmjPOfWo9gG6XqU6l3fP7KYFqTIjfNc9
         3xEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=j+2h6tvzT6ljDYJOqve6ilMGGYQ//lzxKUSA/QblZrM=;
        b=FMdMv9PQ6888dySKquA/yq1qndXWrp/NJ7QEYxTAbz2lFyeWMHUMGbNFyk/jAXfY3K
         +2mJUACov7tgFliahyyEJCZNDUCqCzi6LS9JUzLgvgANZP6AYTWNKC9fGfv/d/1Ib0j+
         +ciUsZaDVXWLrhgsNClIeIyRa0VdMMphNVG6UMOnhEztd4U9RvamTXKCcL4ApOxYnCUi
         zdYw44DINGXMqHFAy4w1C73V9ZD3jCVEGf/G0eAbxAKJEV8/r+rCPU5qJ56y5c0S9OcS
         vsGZvn8mmpkYjrUQTG0IoXAvOJi8v/G+17ejdofhjsNeOPj676YaxLBHnT12cthz0J/A
         ANzQ==
X-Gm-Message-State: APjAAAXiHLJFCpsS62ehw9Od02igk4Jvz9LuUYo7XDWihCtv/5euf+NT
        EKnl6rlwVc265zjs9gyJFejyzDoQ
X-Google-Smtp-Source: APXvYqw12RHVH0rHAiGi1MN54Gqnm9gE+Db+Kp1fozladVmVNJv/9pQTx7WTqlflrOkx6bKgt885wA==
X-Received: by 2002:a63:26c4:: with SMTP id m187mr109697897pgm.410.1578274008704;
        Sun, 05 Jan 2020 17:26:48 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:25de:66a4:163b:14df? ([2601:282:800:7a:25de:66a4:163b:14df])
        by smtp.googlemail.com with ESMTPSA id j17sm47719148pfa.28.2020.01.05.17.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2020 17:26:47 -0800 (PST)
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   David Ahern <dsahern@gmail.com>
Subject: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on debian
 buster
Message-ID: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
Date:   Sun, 5 Jan 2020 18:26:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am seeing ping failures to IPv6 linklocal addresses with Debian
buster. Easiest example to reproduce is:

$ ping -c1 -w1 ff02::1%eth1
connect: Invalid argument

$ ping -c1 -w1 ff02::1%eth1
PING ff02::01%eth1(ff02::1%eth1) 56 data bytes
64 bytes from fe80::e0:f9ff:fe0c:37%eth1: icmp_seq=1 ttl=64 time=0.059 ms


git bisect traced the failure to:

commit b9ef5513c99bf9c8bfd9c9e8051b67f52b2dee1e
Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Fri Apr 12 19:59:35 2019 +0900

    smack: Check address length before reading address family


Arguably ping is being stupid since the buster version is not setting
the address family properly (ping on stretch for example does):

$ strace -e connect ping6 -c1 -w1 ff02::1%eth1
connect(4, {sa_family=AF_UNSPEC,
sa_data="\4\1\0\0\0\0\377\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\3\0\0\0"}, 28) = 0

but the command works fine on kernels prior to this commit, so this is
breakage which goes against the Linux paradigm of "don't break userspace"
