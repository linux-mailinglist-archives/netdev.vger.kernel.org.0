Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4335F18CCEC
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCTLZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:25:33 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33479 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgCTLZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:25:33 -0400
Received: by mail-lf1-f65.google.com with SMTP id c20so4240422lfb.0
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 04:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0PRt/VgUMfU+Km7oQtNyegEwmqK7TcrIJ3oC/T2znis=;
        b=HqqXCZ+SdFe/gAHYE9t/D7bpvda+FpPaKEvItX1IoiJunT267+8UDApVkDk0p7/R1S
         KA35FvbBnxLGKJb5Oyz3hYCc7kzWtcAD9G+6wqoXHXO7PR2JXDDclMVf1jzzeUl4Rv/A
         Nyf22eCit7mLJKOLc3UrmCIjI22VH05KbJHaI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0PRt/VgUMfU+Km7oQtNyegEwmqK7TcrIJ3oC/T2znis=;
        b=FOgQwWzRzozD2OusHf5MAZuR1/ug2hCh103MglZ8Wcwo0poaQFX8KU6AkC0sLhaP4n
         zEyQzGIYZD1F8RZdnXGDyl/IFMbnrtqcHlQx0QrPIRWE9Gr9DX7LMqG/ASun/N/KV9TB
         yuQVX+fnaPt+0c8HqlwIPqAw2Jogjd1OfALF3pJA+/GVZ1bhicJ4Cqq7VTE8qtct2lhw
         gw3q0EXneIRG/6mts8vBUA6xKHYEpOlY2+YocvViVNWPRVJtVH6QgLYq2K75OgTPFx2j
         7RuCBhY9dYecBUaJr5TXR+O18dm4aF4FKCc3qgR8A5SvAyJYSZGRQAWc7JSRjNOSYi1N
         ChNg==
X-Gm-Message-State: ANhLgQ2ohpg0TdynfWJz43S3nbnZNUhU6Ri1zmwr1D+7pE2XTejE1h+E
        AhbbhDa9nHVIy1YSQdRThT3zUjRK/Es=
X-Google-Smtp-Source: ADFU+vueboEMNfTbHqOft9hp/WoMj83/40l67HvvW7qeeU6iS3NG6AB5qipsfQTAWThTJZKOFw8+zQ==
X-Received: by 2002:a19:550c:: with SMTP id n12mr5029902lfe.11.1584703529441;
        Fri, 20 Mar 2020 04:25:29 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l17sm3808616lje.81.2020.03.20.04.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 04:25:28 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/2] net: bridge: vlan options: nest the tunnel options
Date:   Fri, 20 Mar 2020 13:23:01 +0200
Message-Id: <20200320112303.81904-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
After a discussion with Roopa about the new tunnel vlan option, she
suggested that we'll be adding more tunnel options and attributes, so
it'd be better to have them all grouped together under one main vlan
entry tunnel attribute instead of making them all main attributes. Since
the tunnel code was added in this net-next cycle and still hasn't been
released we can easily nest the BRIDGE_VLANDB_ENTRY_TUNNEL_ID attribute
in BRIDGE_VLANDB_ENTRY_TUNNEL_INFO and allow for any new tunnel
attributes to be added there. In addition one positive side-effect is
that we can remove the outside vlan info flag which controlled the
operation (setlink/dellink) and move it under a new nested attribute so
user-space can specify it explicitly.

Thus the vlan tunnel format becomes:
 [BRIDGE_VLANDB_ENTRY]
     [BRIDGE_VLANDB_ENTRY_TUNNEL_INFO]
         [BRIDGE_VLANDB_TINFO_ID]
         [BRIDGE_VLANDB_TINFO_CMD]
         ...

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: bridge: vlan options: nest the tunnel id into a tunnel info
    attribute
  net: bridge: vlan options: move the tunnel command to the nested
    attribute

 include/uapi/linux/if_bridge.h | 18 +++++++-
 net/bridge/br_vlan.c           |  2 +-
 net/bridge/br_vlan_options.c   | 76 +++++++++++++++++++++++++---------
 3 files changed, 74 insertions(+), 22 deletions(-)

-- 
2.25.1

