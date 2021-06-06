Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B462739D14A
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhFFUTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 16:19:14 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:55590 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230110AbhFFUTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 16:19:12 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.17.119.101])
        by smtp-35.iol.local with ESMTPA
        id pzCol3UwhsptipzCvlruID; Sun, 06 Jun 2021 22:17:19 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1623010639; bh=3x546FnpmE1FY0fBqC7pJ3epPtBvLCOvSsuTgQVDW9g=;
        h=From;
        b=theIT3MQI+h67OsBRAUMLJtKVr19tANRJ+aAVr40BpjglefqZQP0H4Gh83JD3D4JN
         8AIHsV1MTEgweZtsU0fCL047vB+LQYYDMY9RCqw2bRxDIE4SYTWU5EuIlZbxmvJtTL
         Dt2qZ8XzqByld4qDjfTzzlAtplo7pxbSwxICUHrdbqDB43YFSUaPd80wzrnX4WqXli
         dtfXDt3HGrrPkO4iq65xEZqtTPvX8fTqN+Kjd7GDTcpXkmUu+bvnEGyvw50D42bsV5
         fviuXd3tKflUReuFdVoMmni1wN+2g4glhiaod6pzTvX3ivctdEiVkDE0mZfSfQ6yOy
         Nn1qV1gGU1akw==
X-CNFS-Analysis: v=2.4 cv=Bo1Yfab5 c=1 sm=1 tr=0 ts=60bd2d4f cx=a_exe
 a=do1bHx4A/kh2kuTIUQHSxQ==:117 a=do1bHx4A/kh2kuTIUQHSxQ==:17
 a=X8-5zgEFGoXRYfRO6I8A:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/3] can: c_can: cache frames to operate as a true FIFO
Date:   Sun,  6 Jun 2021 22:17:02 +0200
Message-Id: <20210606201705.31307-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfEigeVgfGzfYsUw+nlXrrTI+4nn6l8rAIFrAow8hFZtgZEyocdbXmzmVZhAN00WjUvaxQhlq1NwZ05MpZyeLxncHQSMZJDbR4AQvx0wgtGyzdGOwUy8/
 s72raGwdPeHj/t7onlgGMpdB2l5uSi7g340Bh0tNIckR/jcvITMm3rreWuu/dSGXqpjz5YB/722dUY98+wbr8v0yzwDwHO4aD86ZR87xxv9/ajUGWeFQUDcY
 rXmREEjnnJgww8WWd0PTpn5S0jHM1Mdr/0S9AZicegv4djlQJjuTvQpE0KK75xYTuYOh2MhiC9GPg4b2V8UHLr2E1jXusxAR1Ph76FKr2InNKF6UqBI2yM7a
 0p2iTiml6uy4kRHZdyuCxu/T2330iiD7EO56h1lzK6ZwvO6Bjun1o32SWvXuO6hI7ZHeg0EF8+DfJsIshyJODvnM+o2Va2q8bc0qnwImq3sMEvzZ+ANaf9uA
 5OKG/6kNq9KVmHuERYAwo5AA8Uj/sgNJ2UtiruNyJ2FJO9JiCMxQ7DuXnMnsH8EDM0BSK/wYpHXITT4KKZdPhVjdElsUrIrsExGP52yD8jUX+idUVHrQC6m9
 EbOV3d31cA/W8147xLWp7EvmPJ8LCq07ZqEdj0gXis6b+SwOYxJ3aCrlp74KBQbwh6w8XzNyyyGtmvrCE77ETWis
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Performance tests of the c_can driver led to the patch that gives the
series its name.


Dario Binacchi (3):
  can: c_can: exit c_can_do_tx() early if no frames have been sent
  can: c_can: support tx ring algorithm
  can: c_can: cache frames to operate as a true FIFO

 drivers/net/can/c_can/c_can.c | 100 ++++++++++++++++++++++++++--------
 drivers/net/can/c_can/c_can.h |  25 ++++++++-
 2 files changed, 101 insertions(+), 24 deletions(-)

-- 
2.17.1

