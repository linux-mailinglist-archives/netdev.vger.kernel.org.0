Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB2C3D4EA3
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhGYPbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:31:32 -0400
Received: from smtp-34.italiaonline.it ([213.209.10.34]:54687 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230010AbhGYPba (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 11:31:30 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.45.45.231])
        by smtp-34.iol.local with ESMTPA
        id 7gjJmU9oJLCum7gjNmo2Zz; Sun, 25 Jul 2021 18:12:00 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627229520; bh=ybTEgBqSGSk7CgeQhAXjaoIWf5L8GRxV3Eiz04dFePA=;
        h=From;
        b=EVvz+nAyBAWa1JQOmSPDnUxxwDBRN8WkDlJa7AttAOeIKkvkxAOlj473vc5f/AOKT
         QNHb5hdsBmcY7mzlljD5phfy1g7ojC/OF9ot86acdKYv4v/efgwwzdKBiedGPJPHXf
         GKrgEMsGmLnn4S54Z7N9/AVytL78Q/mfid3hPKh8H7TwkbYb6fZk2jh3uKVklR9RVI
         G8bWRdBCuJUb49o31/5hbWjw8U2Yg6T+AU5HeITt7N/4zJ16aNuEWYs7jbvRw+k3Ll
         6OuxsIC7WEf8HzbErxh+/lrWcAwpQpp75423WGp5yO8t8D0YZNuBVKGmBlfglPu8bE
         s+1IcjzIB23mw==
X-CNFS-Analysis: v=2.4 cv=a8D1SWeF c=1 sm=1 tr=0 ts=60fd8d50 cx=a_exe
 a=TX8r+oJM0yLPAmPh5WrBoQ==:117 a=TX8r+oJM0yLPAmPh5WrBoQ==:17
 a=X8-5zgEFGoXRYfRO6I8A:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RESEND PATCH 0/4] can: c_can: cache frames to operate as a true FIFO
Date:   Sun, 25 Jul 2021 18:11:46 +0200
Message-Id: <20210725161150.11801-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfJeXdyHedOw0ts0LyJhcJzHXuN79YT/uv4IU9SvVqG08qfRMLNlv01T3VreYJagfFelH1UkoxTG5hGKvwCIdVTCUWm9t9iBddkNTXrLCgUsDFDcYHipC
 rV3o9uuDGwfWkXjkyxhIirLue12LMjjo2PxzGhI4MlgU5uVqOW5BvqdcWM6KiOKaYVUI4bGglVZl+8NVRmkXIafGZxuLOYqx+lhMpx7ibk1iWdE+eh8jk2YV
 XLBjwWmy5bRB1HsXswaTrkA4uih8Ry8tVSwenikwDfI0AShUS0sw7U/dy3pP81oGywX6TSJnVj+uSUsiwcg185zmO5w5botcw6ihUlIQO+7PoPYKb3xGKbGn
 kEFTEFhqBKDdzPUOgju3TJbo+CNcBvzNcmSO8P3FwdH4wMWZX0uML9Y22Uc9dnQTe5C6IDKI/FLfFjHe3lV+sxkLssLU5KtwXXOwHqlswKOzJKap+YkEd6hv
 5VKghOjsF6TbJtWj0lKsWFxJz19BUoQ2+fy7cg6zR2rrNKQDkFXA2/+bVVH16VafHFVDpOMlYz8E44mcDMvp+7wWymnbX7crm2fg+sO8a/fKOqYpMKruiMvG
 zf7ShtGf5dh0UVW18WwK5855dPOYWpv8g0bmBUV5TEpIuQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Performance tests of the c_can driver led to the patch that gives the
series its name. I also added two patches not really related to the topic
of the series.


Dario Binacchi (4):
  can: c_can: remove struct c_can_priv::priv field
  can: c_can: exit c_can_do_tx() early if no frames have been sent
  can: c_can: support tx ring algorithm
  can: c_can: cache frames to operate as a true FIFO

 drivers/net/can/c_can/c_can.h          |  26 ++++++-
 drivers/net/can/c_can/c_can_main.c     | 100 +++++++++++++++++++------
 drivers/net/can/c_can/c_can_platform.c |   1 -
 3 files changed, 101 insertions(+), 26 deletions(-)

-- 
2.17.1

