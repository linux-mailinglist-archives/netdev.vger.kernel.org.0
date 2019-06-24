Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6198351E07
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfFXWOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:14:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46043 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFXWOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:14:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id a14so23897687edv.12
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=F5uoCLl+kutJ88IJ0fDqbErIfNVWLByRHTp9VJP6FDM=;
        b=LvfjGu30eizUsx6dZAA7d9AbBjm3PZQWcjoH0sZzJNhsT/MJzZ1M5HXS2aPSTMtN9X
         /Hv9Sy8mKGE2ntvJR9c2G78F1zawm13G1xGD7Uq++TEzS/tyW8KQvVmQ/Sb2FxKFiZZq
         nThKFUkHeAyHBECj++kaKQp8zDTbsf1PXlirzteiQeg98mLO+rHjFU9Er78pqZRdgZJ3
         Q5OOLlM20rqd+kgQalOZuetNZxYZNvUdEM4X+JeCfuorEXHFgs3z7Q3h6jvrNRRsX7ip
         Bf401hRZjWk57gEsmjbDfLUhaYF7CUYRFuSVR4nUscX5jJuFNQ+F1jk8VixUQL0uzIjD
         E0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F5uoCLl+kutJ88IJ0fDqbErIfNVWLByRHTp9VJP6FDM=;
        b=iLGrUT1lX0AJb75hX1ZguBP+AJMpEJIwy+aJrqPcUA/dw8Jr+TNs/2Hr2NfoH5X048
         IEq0cpzVUmDmx3k0v0K1lzRrE2g66xepGSzx0JAbufIgenKu1nGWy2T3xOLj+hRCNhrb
         aMW4QgWiIlYSVee7H5tSfae/UMUl1hSzFU22NKCKGtCNLKdvb93SzYxAih65XtD0mFx/
         eSBGf1tc252GihbIm5Tzl3DFjE/nWiwDY8b4DQK4owNe0BNMXkPKD81u5n2m1/xTL6Y7
         GpVoXSKh2JPdanPDB1MvP1Xv6O2QJVqmvJ186KU7C3dhb5CNRhN79J572+P4J+c0il9h
         XGoA==
X-Gm-Message-State: APjAAAW8Uairbh92AFMOp/zZBNwwDYhuSFBY64DupKifrhgG+8LEQ701
        aG4KjN+5vnrlF9vLU425z/iqyTylRls=
X-Google-Smtp-Source: APXvYqy1ejwgTjQkp7vqOcIS2+0mxOobXfXkrz26snzcKlP5PuqMtXx/fJk82s9RfT3P4POi+Ou2mg==
X-Received: by 2002:a17:906:5042:: with SMTP id e2mr64039656ejk.220.1561414485416;
        Mon, 24 Jun 2019 15:14:45 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id y3sm4046025edr.27.2019.06.24.15.14.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Jun 2019 15:14:44 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, jhs@mojatatu.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 0/2] Track recursive calls in TC act_mirred
Date:   Mon, 24 Jun 2019 23:13:34 +0100
Message-Id: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches aim to prevent act_mirred causing stack overflow events from
recursively calling packet xmit or receive functions. Such events can
occur with poor TC configuration that causes packets to travel in loops
within the system.

Florian Westphal advises that a recursion crash and packets looping are
separate issues and should be treated as such. David Miller futher points
out that pcpu counters cannot track the precise skb context required to
detect loops. Hence these patches are not aimed at detecting packet loops,
rather, preventing stack flows arising from such loops.

John Hurley (2):
  net: sched: refactor reinsert action
  net: sched: protect against stack overflow in TC act_mirred

 include/net/pkt_cls.h     |  2 +-
 include/net/sch_generic.h |  2 +-
 net/core/dev.c            |  4 +---
 net/sched/act_mirred.c    | 17 ++++++++++++++++-
 4 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.7.4

