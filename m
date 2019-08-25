Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA459C59B
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 20:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfHYSqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 14:46:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40619 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728806AbfHYSqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 14:46:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id c3so13192935wrd.7
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 11:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NR5JG57RPNJTQFGoYBPMnw5QTN6+pqqGztf1B4CAnNw=;
        b=dDDjmW/Sf0PAGfKnfgvBy2dllNHaaVzTZKuqTyCX12aENDK4SAwCfLwk6F+k8Ouc8c
         V8Xh64ml48s6ajgsU0dwDi5RxnESOsARSsy8P504XVsAnUtZpfjB9E1K5VawrsEBLQTS
         wO0wX/XAaoqUT7ECitr8dqPI4fI8WMwHYpqEVZ398dMPoMnMozZ5tGENChRsjfmkR37l
         wtCV749wzt+tj5/TD/Vt7EYIulHw0Qha06k0RjtUMNwUHgaH8IeNT4QB06dubVaH0h98
         e5g681pBqJ3dtYKna97Va0G3hOv0H3klEf9p/GLPo2ZM8s68vOsh3GVUiQ6hMyh5R9xg
         x2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NR5JG57RPNJTQFGoYBPMnw5QTN6+pqqGztf1B4CAnNw=;
        b=FOWoUEu5s6MlHNRq9/u/TbkLyaz/PydzZcp98F4MSsmND3WK/OAP60b7TNz0jWB00A
         CYfAYugxMaD3zl5EqVhOXRIeOif0I4rWMRgW9A4RCeZZc7HVD18x2/opwZxtcJ0CIhqu
         +Jm5dse1yFrfTaao4bJd6ms/TL16Z54h96C2PorIxncfjxcyhcQzluShYLbLlMSl4AGH
         JlRabKIyOdux0RB4C183ejCqVg3hxaDQmuD/69krVzOYPuby+CjMAKSV8wtmhuUJ91Zc
         T8Ls0kiEZya5q26qRiYtzplDvKjFduLnzJ9tPQ4/Xel3DYB5Kg7ZH05m/6Ste602jdub
         Yx/A==
X-Gm-Message-State: APjAAAWnNkjzAGqw1SKfxBC8tEK6Al4uc1EUy0SwHqnPA9q4xe3UUACU
        5Jq3BSDFBSAbPk0ViVKcaEE=
X-Google-Smtp-Source: APXvYqwzteDNV7YYCpadAnA8z7q3ZMZknFi1/togq1HTnBkRv0j17cskjAkh92/m3cTGO5dpCL8viA==
X-Received: by 2002:adf:f304:: with SMTP id i4mr19182814wro.61.1566758761841;
        Sun, 25 Aug 2019 11:46:01 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id b136sm25603112wme.18.2019.08.25.11.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 11:46:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 0/2] Dynamic toggling of vlan_filtering for SJA1105 DSA
Date:   Sun, 25 Aug 2019 21:44:52 +0300
Message-Id: <20190825184454.14678-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset addresses a limitation in dsa_8021q where this sequence of
commands was causing the switch to stop forwarding traffic:

  ip link add name br0 type bridge vlan_filtering 0
  ip link set dev swp2 master br0
  echo 1 > /sys/class/net/br0/bridge/vlan_filtering
  echo 0 > /sys/class/net/br0/bridge/vlan_filtering

The issue has to do with the VLAN table manipulations that dsa_8021q
does without notifying the bridge layer. The solution is to always
restore the VLANs that the bridge knows about, when disabling tagging.

Depends on Vivien Didelot's patchset:
https://patchwork.ozlabs.org/project/netdev/list/?series=127197&state=*

Also see this discussion thread:
https://www.spinics.net/lists/netdev/msg581042.html

Vladimir Oltean (2):
  net: bridge: Populate the pvid flag in br_vlan_get_info
  net: dsa: tag_8021q: Restore bridge VLANs when enabling vlan_filtering

 net/bridge/br_vlan.c |  2 +
 net/dsa/tag_8021q.c  | 91 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 73 insertions(+), 20 deletions(-)

-- 
2.17.1

