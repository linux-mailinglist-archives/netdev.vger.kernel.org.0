Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50B02A573A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbgKCVkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732326AbgKCVj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:39:27 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93224C0613D1;
        Tue,  3 Nov 2020 13:39:27 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id b19so9226630pld.0;
        Tue, 03 Nov 2020 13:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yuupg0c1D0Ih5Ju03L0WwdvLwQwoMb4nyLHRVSNf0Ks=;
        b=M840EW4b6gw1qYhqVaIJU/OAPyKoAmUECTZSOnoc9GIWCxI2BHp1U2WCCIFiHDWxHB
         Ony1okNLiSHpl/3VeyVHTotLk7RARJpZKeBH01ahW6fHLajTo0ilFvPiQzJz4b4mQ3/e
         x1AGSS81jWeaUedhZc9hev5q66lNCk5bOrQK/3CLeXuLRaltDyM29SE+EpXXcoB7iZzS
         IlI7w0p7HhM+MWC8Kzdlt+yILyr4DJYu7QLnEkOg/UBjTLtHOb3RhG8SayVrW966OQrv
         8HGcDPld/5EAkO0UbXSo8w+RWOciUUL+/1SIyr8pBs9P67eAfM3TsdJ7eFcN5kPvjwW/
         xqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yuupg0c1D0Ih5Ju03L0WwdvLwQwoMb4nyLHRVSNf0Ks=;
        b=D4uZKb0HvtmIKS30pQPQjJXQ7c2FgBzeMFRcZDuSuGLErrr3ABeojo4GnkfUnlipt3
         zixxIVKwfFlDHkFqS38QsrSEKp9XUmBBovHFIvuV9djKFNAwBRy78ndsfBWK4UpU+RwC
         et62iSkFpWLzg4yySYYYCF8hT4kj7q35JEqY6cUThkNs5tyC1LJQ7eDMEd49wBJRgXRt
         9l/w2udBxOpjy3cPHlD6V7PBeFtFdyONGPdLeiflHixxBK08Vou+SLQIB/l+t/HANaJt
         OmJuu990lc2VlVUpDil4vkSa4t7wTXuPmeZ3VMrhPP+IWzju3a+fgKrwztSse83GPiRk
         XI8w==
X-Gm-Message-State: AOAM531crg/ScBvdGuOrb9R+PPzpy8iY02Pz2AfZfCphB4f+SzOfnKLL
        SAi8MRQucgXKdxgbzkKT+vc=
X-Google-Smtp-Source: ABdhPJyM1UuoA2z+TC3CwU5JNeFaqyWsdrUPP63AH6Ql47E4JSyF2723/UlxJnfZ1n/5HjnR05DX3Q==
X-Received: by 2002:a17:902:aa47:b029:d6:ac0f:fe76 with SMTP id c7-20020a170902aa47b02900d6ac0ffe76mr18878761plr.42.1604439566912;
        Tue, 03 Nov 2020 13:39:26 -0800 (PST)
Received: from localhost.localdomain ([49.207.221.93])
        by smtp.gmail.com with ESMTPSA id 15sm16420108pgs.52.2020.11.03.13.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:39:25 -0800 (PST)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: [PATCH 0/2] prevent potential access of uninitialized members in can_rcv() and canfd_rcv()
Date:   Wed,  4 Nov 2020 03:09:04 +0530
Message-Id: <20201103213906.24219-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In both can_rcv(), and canfd_rcv(), when skb->len = 0, cfd->len 
(which is uninitialized) is accessed by pr_warn_once().

Performing the validation check for cfd->len separately, after the 
validation check for skb->len is done, resolves this issue in both 
instances, without compromising the degree of detail provided in the
log messages.

Anant Thazhemadam (2):
  can: af_can: prevent potential access of uninitialized member in
    can_rcv()
  can: af_can: prevent potential access of uninitialized member in
    canfd_rcv()

 net/can/af_can.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

-- 
2.25.1

