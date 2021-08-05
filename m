Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486D33E1D3D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbhHEUTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:19:34 -0400
Received: from smtp-32.italiaonline.it ([213.209.10.32]:51036 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230398AbhHEUTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 16:19:32 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id BjpbmFmMJPvRTBjpgmCR62; Thu, 05 Aug 2021 22:19:14 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628194754; bh=SPGyU0naf4g6A156K3eldv0dQnY50rajzzE/aYfpdqA=;
        h=From;
        b=LIxEcPu3w9zUrXpwTSdXMynwV7+DmPGtWXTZK9GY9UJefKZEyZnVkNpuNadqzqbty
         fkbqhlcsA1ODBZzbjHXufQOx6ChiGz0G8sJDNif9JYulfnwm/rU0CySL04O4Cbi3Ea
         ZuGxqo6vdBZGG3ZbNdK30X5a7RCWBW3HTqmaXlm2EIRzg4qODD7ToYdbASusmrdzrS
         4shSaEXWlCy9Cyy//dKA2hO7flaSTbch40vJobq8R92HQGPfgfuzOwQA+aAJj/hG3E
         ObH0NAw6JFo7P0zWabKJWcNmC2bzOoixow7w1fUT19N9CUU5JWx4R3f0Wl4TyhWxrG
         q3yxPSlfdQW0w==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610c47c2 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17
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
Subject: [PATCH v2 0/4] can: c_can: cache frames to operate as a true FIFO
Date:   Thu,  5 Aug 2021 22:18:56 +0200
Message-Id: <20210805201900.23146-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfJp0TXbUyLPMF1nl9J5b7J0aWyvSyxfR8A+gIvtHczQxN14/2LO0pqqvIRUzex1G9W1KVSf7Z8WUhjlmNo2vlSpfRD7+W35GZk6TxBX41A5zb7edcQZ1
 Mos72FOeVXMvAlt3zEy5XDVbRouxPCZTSiuJ/1W53XpoCyepGyBPR3tMWpLrD94QFN0Nfr4RXIfRBgSqTOeUr+LnRpNDLnVT+KKCPrNLweKLT4JMooz9WrcW
 K6Q2jtnFraKbnV4BTXHO8iPuPTHwLJ+EQf7dZn3jlqMSSOBXbfs/ZHlAHevcPieN7QG997EAyFmut5u8Hf4INVDx1TUVvy5JqhbfKBNuKm08V5ilcz/Zfxa/
 rAZcqC1D71s+WeElSu1UIRcqiXlOFlbbiF1J02WI2WeexlUYL+rpD0g32ofy4eFk2Gorw2bicFp8MCym++DGBoOj+AMlwwX8SzrTH+zAUey2vsvRkIxoDpQJ
 mkRHqYmAQoZsTGbqsDm2omKn0s4r/G2TDBMQUZb9YguFoSybT42ESjpPTEMoWm0o5mbZkTwLoD8CzALO8Ok/5WNFiyRf/Ggs2EoZ4zchcvqvXIq08qJZdUvu
 WOLEvO1wE/kagviJa5m2WzU0WFRLnExE7e3nxVtd2mc7lw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Performance tests of the c_can driver led to the patch that gives the
series its name. I also added two patches not really related to the topic
of the series.

Changes in v2:
- Move c_can_get_tx_free() from c_can_main.c to c_can.h.

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

