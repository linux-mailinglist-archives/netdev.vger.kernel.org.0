Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5876374FF
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiKXJUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiKXJUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:20:12 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1DC10FED4
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:20:12 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s196so1109465pgs.3
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0+WGIeoTiO2ZvfjVc2PyqExuCpCfv2qAtBBFn98Kgzs=;
        b=BL6NU2f2psaQFoomipDAcn1gjydcC9v7070fOQ8OOaDL011jgAxf2rEwI+c8YF0VE9
         iqAY5z0RD+aJUZttkcsGnPQqelYcBHIH0DgaJBbuCSlISkuEmXLyw/ABjaEbzOh0pEAM
         Qg5tluV5cSpGeH6MaPOi7H890kNXV6Th2CJGfesrIxcVD6kYEBj7YeZKssO3fnD/0lpk
         WgDOXQyUUYrJmvuse7A6BySRmCy/CzOWdG49NqO43vkfbawbyUzVSBhae3OSiZgrzRXo
         EQiv1/73xuiUycySG01mC/dr/pidsnrRR5/txQSW4Nls90YYRxXBmCvNz1Zn00buyeuj
         ki9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0+WGIeoTiO2ZvfjVc2PyqExuCpCfv2qAtBBFn98Kgzs=;
        b=4uO/K2c6+auSza4TL9CsTxxtTewJeeOQuBRR1T3VqcWbCfGo31uG34BV7BcwcdClK9
         +AtgblUG+IS/UWzH+sQVc2qKwWxIt2c0xFHfVwY861pEGoLO28SuJ08hIuQ67cXzzFGz
         aE6aCLKZHfBm6Bp/XMvX2tAdTQPNXC7NuuJgvcjkVlVEZuLzOz4Hi0wQDKAFIuZVZjY9
         dNyFI+d1O5N+BCYrFMFHhmiv2gapZjuhKaO+NxxJKRXFfk4r5TSDO6VOVOICbAGFmtri
         6mR0XD1UpLJHPeYSIhoThfSJhgJ2tJpT/gqRNXkcB/ZmD9js0BwR1FcSCaYz063XQ7wl
         dwZw==
X-Gm-Message-State: ANoB5plwfHaS2WKKSK4Ql7zj3KUrgkZFT3WFlX3wpo5+jPnAOkMRiwQT
        0TotKmPqm1auR/s4KpGhJERbDyc/Gd240WXcGLrCzT+BpuY=
X-Google-Smtp-Source: AA0mqf7jqq6z4gZPGX174J3f+zNh9QJ8NFgnANTxJg5EKut97eDFQgWdsJhT49qsjCAAT831R8Uk4kuLkesdKUleMvQ=
X-Received: by 2002:a63:4d09:0:b0:477:7dc8:57a8 with SMTP id
 a9-20020a634d09000000b004777dc857a8mr11134163pgb.506.1669281611830; Thu, 24
 Nov 2022 01:20:11 -0800 (PST)
MIME-Version: 1.0
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Thu, 24 Nov 2022 10:20:00 +0100
Message-ID: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
Subject: RTM_DELROUTE not sent anymore when deleting (last) nexthop of routes
 in 6.1
To:     Network Development <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

when an IPv4 route gets removed because its nexthop was deleted, the
kernel does not send a RTM_DELROUTE netlink notifications anymore in
6.1. A bisect lead me to 61b91eb33a69 ("ipv4: Handle attempt to delete
multipath route when fib_info contains an nh reference"), and
reverting it makes it work again.

It can be reproduced by doing the following and listening to netlink
(e.g. via ip monitor)

ip a a 172.16.1.1/24 dev veth1
ip nexthop add id 100 via 172.16.1.2 dev veth1
ip route add 172.16.101.0/24 nhid 100
ip nexthop del id 100

where the nexthop del will trigger a RTM_DELNEXTHOP message, but no
RTM_DELROUTE, but the route is gone afterwards anyways.

Doing the same thing with IPv6 still works as expected

ip a a 2001:db8:91::1/64 dev veth1
ip nexthop add id 100 via 2001:db8:91::2 dev veth1
ip route add 2001:db8:101::/64 nhid 100
ip nexthop del id 100

Here the kernel will send out both the RTM_DELNEXTHOP and the
RTM_DELROUTE netlink messages.

Unfortunately my net-foo is not good enough to propose a fix.

Best regards
Jonas
