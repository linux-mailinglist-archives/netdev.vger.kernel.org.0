Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA751B2613
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgDUMbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUMbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:31:18 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF102C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:31:17 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z6so3481793wml.2
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k15wueO+Fciig+o8uYQsqwChAch8chW+/8OeKM0K7bA=;
        b=kzDMT4OANa32opluvu+rACrDybJT2AQPchu2+PCJYbe3dmJURaOi+LIJMOEhRP566z
         5U8v6AjFM5mF2x2gO3lqXVB+opZp5kAPW+M2EfDCQeoFUquYpgVJ88EH9o62LSNIexFE
         ouLeV5fHasRYekb7wp3+lqMAbgpLQs+Mg0/I5Sl7CJAomnYqkgQJVuKuYiWsEJ99Fg/8
         aBKtGcazKVP7OvJ20LQXERU/IJmDBJ7p7CJ5AUsD/OMRmRNXKFwudy5VuiFEP1Fl5uns
         OsRBX+cOKptX/2WAyHaaEKdipiByJMRs6Zi1zgqMlEQO575axLgqRV7PEg9yLj2yNVRa
         arrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k15wueO+Fciig+o8uYQsqwChAch8chW+/8OeKM0K7bA=;
        b=CsMm/JJH2nWj2Bp89uRzxgmDqW9m8G1xOypRn9jnGKGR9yOmC4puGaoduzreZs3TLi
         1gQeagrjXFVvS1s1mp0A28cazwD2oDjJBqkCbKnA+9qH0lrowGZ7Oe66Wb/+Htj1o6bf
         9ugj/RnKztFVlCeauwuJ9CFJJ/vs/lOjiopECMXbR7cmP8thr/ysmUo7VdQ7VPRP6oqT
         8WYprpdZt8Mqvwfh7ga7sulTBjel+m83/JOEHLJsmMYAbnLcyCBZNRqgHCeUeK3s6KQh
         g/JWHoue2NmexC0u+mBbl8WHdDwo5oo72+bgKyS08X1kVqpYoQd5kPuT3akZypX2Emgl
         w5bA==
X-Gm-Message-State: AGi0PuZySyqd8s3/51EviaVkSXq/kUuZt40xGh+XWudXKdrEgtydV1Mj
        5AXQE4Q8CsbeNVWxzRR2Y60=
X-Google-Smtp-Source: APiQypKO22r2AcehaKKEAEdaXpZRQ4UNwU8o5BcQ2j7KO4y4pmG6ewqB1oX27motjTzZi1xvsckgzg==
X-Received: by 2002:a1c:f312:: with SMTP id q18mr4649890wmq.175.1587472276533;
        Tue, 21 Apr 2020 05:31:16 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id q8sm3256009wmg.22.2020.04.21.05.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:31:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, o.rempel@pengutronix.de
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/2] MTU fixes for DSA
Date:   Tue, 21 Apr 2020 15:31:08 +0300
Message-Id: <20200421123110.13733-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This small series aims to address the complaints about a regression in
DSA that were formulated here:

https://lore.kernel.org/netdev/CA+h21ho2YnUfzMja1Y7=B7Yrqk=WD6jm-OoKKzX4uS3WJiU5aw@mail.gmail.com/T/#t

Vladimir Oltean (2):
  net: dsa: be compatible with DSA masters with max_mtu of 1500 or less
  net: dsa: don't fail to probe if we couldn't set the MTU

 net/dsa/slave.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.17.1

