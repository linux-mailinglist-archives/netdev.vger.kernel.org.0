Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A082E2E78E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfE2Vm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:42:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53130 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfE2Vm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:42:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so2602489wmm.2
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 14:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QT9REVzj/zN4pcNf/wgqbMS6z5Bkw3ZkieHoc+FddFY=;
        b=n1rh+yKFDTSjSefvAuzTlIP8jrQopyJAiQZE/Yjvvnq9kNEohdBGi+0lgKnCcoeOtX
         FUXXRtDklmzK6DJpRkRo8laa64KCzhGUmV6COUnKiDMYqeEa8e2SOw3pAowBz/QJ0Alf
         1S1b2oaOTk0OXzNe9lnBA3rMEjGhv/CrCLVhOVgqCho5Tg+wNUQfKpIEbn9LQEpVLXig
         VpU9nP3x1XXD8JquYq+BM3IeaOQaOnplVctdBnotgqdYpIz8QIjc/NmQb8LgCQzpJCDW
         MxU38LlqpnEmpVXH0CuVbXPw1/q/0iqw8kLiM23FbaT/B+5BTq+NhGjmy2XhuyVJzCxe
         CFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QT9REVzj/zN4pcNf/wgqbMS6z5Bkw3ZkieHoc+FddFY=;
        b=MABkwp11mts1XuxJRP++lnyN3YJ4d+PSHc1zAna/uPPpZt+X2GWnJXBqEhIRo1mf4D
         XECy0kGJ7FdQrk64VhM+So84Uu0Mf42zkeCxtLsmIB1jMHzGr2vu9BhFqLy4XIJ/7k1Q
         XnfT4z1RR4wjkqJasWN6QYKZe3Gkrs0t1Ne36IP+0ptntDD9G0hLENexKTLWGSyARMlD
         iLWArGeNYbqmZ479AvDvKH9cHWBEi2QGXz/ks8Cjs3mun7P3xvLcEkdEnipPE23E0YT3
         6IOtUGM50C5Upls0GzJHlgrn1gcyQ1a0mp6wXsj4EnCJGQrSvunPYD8IaB4gwoXC04ZZ
         Fukg==
X-Gm-Message-State: APjAAAVQhFEKJqG5X//kbrJxghGyXaqKtPHlmQ6mcaZTTYxOydFdJw4r
        dq9ahP5KMIJN+dt3irdiEGA=
X-Google-Smtp-Source: APXvYqzYu4c5mSznZXYkexehE/ozKrTvezVh16xU6CEUMNXoQLnGU/UKYwsJdxu3oVUrxTUHApOnfQ==
X-Received: by 2002:a1c:228b:: with SMTP id i133mr123375wmi.140.1559166177247;
        Wed, 29 May 2019 14:42:57 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id u19sm1421060wmu.41.2019.05.29.14.42.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 14:42:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 0/2] Fixes for DSA tagging using 802.1Q
Date:   Thu, 30 May 2019 00:42:29 +0300
Message-Id: <20190529214231.10485-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the prototyping for the "Decoupling PHYLINK from struct
net_device" patchset, the CPU port of the sja1105 driver was moved to a
different spot.  This uncovered an issue in the tag_8021q DSA code,
which used to work by mistake - the CPU port was the last hardware port
numerically, and this was masking an ordering issue which is very likely
to be seen in other drivers that make use of 802.1Q tags.

A question was also raised whether the VID numbers bear any meaning, and
the conclusion was that they don't, at least not in an absolute sense.
The second patch defines bit fields inside the DSA 802.1Q VID so that
tcpdump can decode it unambiguously (although the meaning is now clear
even by visual inspection).

Ioana Ciornei (1):
  net: dsa: tag_8021q: Change order of rx_vid setup

Vladimir Oltean (1):
  net: dsa: tag_8021q: Create a stable binary format

 net/dsa/tag_8021q.c | 79 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 14 deletions(-)

-- 
2.17.1

