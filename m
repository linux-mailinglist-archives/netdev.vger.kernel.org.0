Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A3B29CC36
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374987AbgJ0WzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:55:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49820 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374977AbgJ0WzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:24 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+/ecoziKoJodJKTT7o/UwwiCBG7QroeEJmAgktvLhzY=;
        b=wYJh8TecCJUTXhZuSrSp5ylLddMcQOB6uBNJosQiQqu0AWxStl2sXOqoDZFSV4lopKMudj
        9ev6+9/8clVjjHH1qop1zpaReraf2pNwpeOgP6Ubhfnv3Ij+7CUQNqRPLdqwtRS1XFon98
        EFCHR5L8sO0qa9fv7bnt56kNL19WdB/td7ELFaxACijIqUZMTDyC4lRwYo++4+uUH3tJhZ
        lw9n8opRptHRVprVn9vIjuFD0wqAe3hkoBvBgmrrlQAOPt/prP81EM9YfSb8d+UGUaoliz
        PpzElBLfVgBYOhW/Z/iwSkna+VELswNnxRCWPMDr0Bc8ZPqaPW3Kwc4KQTLuPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+/ecoziKoJodJKTT7o/UwwiCBG7QroeEJmAgktvLhzY=;
        b=aMRfL0JaulAb81YMhS3JkaJjxQnZy5Lb7ytie9xAlSd4X7i+x4QHc1shdAMexXN3aU+Eq2
        iLwAP6V0gwgGNaBA==
To:     netdev@vger.kernel.org
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Daniel Drake <dsd@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Jon Mason <jdmason@kudzu.us>,
        Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Samuel Chessman <chessman@tux.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 00/15] in_interrupt() cleanup, part 2
Date:   Tue, 27 Oct 2020 23:54:39 +0100
Message-Id: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,

in the discussion about preempt count consistency across kernel configurati=
ons:

  https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/

Linus clearly requested that code in drivers and libraries which changes
behaviour based on execution context should either be split up so that
e.g. task context invocations and BH invocations have different interfaces
or if that's not possible the context information has to be provided by the
caller which knows in which context it is executing.

This includes conditional locking, allocation mode (GFP_*) decisions and
avoidance of code paths which might sleep.

In the long run, usage of 'preemptible, in_*irq etc.' should be banned from
driver code completely.

This is part two addressing remaining drivers except for orinoco-usb.

Sebastian
