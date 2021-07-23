Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C9A3D3BBD
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhGWNoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:44:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235302AbhGWNns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 09:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627050260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FqfS7gAK0wNDj14pMenh1x9I4kuwfwt1GFYOe1tqy1c=;
        b=K4vWE+PyoHoQ4PqxyR9ecu9OFwYD8kIObiiQ7KbdHOa2Xpfu4JAl30DiVgSgBEp2EKJTJj
        eEa9XgQqfzUzJTZBeAV7Ro+pUjf1WIK9nW7SFi0Vtf/dHguF8pNFeUZ44fYDyXOTNZdQB+
        Nz58GX7uGoHTJwHdgaHQHWi7fgfzVxo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-zkk4h-gjP7yah86oDJgUCg-1; Fri, 23 Jul 2021 10:24:19 -0400
X-MC-Unique: zkk4h-gjP7yah86oDJgUCg-1
Received: by mail-wm1-f69.google.com with SMTP id g187-20020a1c20c40000b02902458d430db6so141160wmg.9
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FqfS7gAK0wNDj14pMenh1x9I4kuwfwt1GFYOe1tqy1c=;
        b=Kw14C9KuHhv5BDBcsx2K7ZPkuO5ALIFcfdCe/mjl0NzJKSYyJUz86/lqMlRUiirfOh
         rlOx2cxmkfYPslDQjrMUw3qLWchCaFtLc6RvH+YpHv7JXg5JuSv/OPQW+W2oZG0eyW++
         RKyCtqPvUsG8iqHlnusDK2zKt9JzgmxL7vn14BuEjdOAj+gbvuXIGevI6j91zRDvnxeL
         eN4ijvXU98915p0UtG7DOI3dfXw0h+X5nrPSk4hxXy60Vms4rDnmgABCmd/DloPRKNEd
         c4CgfgiUJHCKBsNxEEGsnYpDZwiSvVsrYDc7h8Z9rf1UezYgS1rx2y6pBQSw3QPZloed
         Ecpw==
X-Gm-Message-State: AOAM531ZG/0OUbz0aIhqJILuaoHycq1JtPmBpsxpW729FNhzeYfwt9LP
        RGtumaRjaOqCGzYuV/yWZqtYA1x+7guKlsoiywBqI2b9WUevWFlqwtUQD2rpsfny5A8U64i6PfV
        RScJ/yi2aZmb6oK7qO0ADmHD7tkcvEODZ9ao3mgdYzdI73a8JD9nwAHp1gox8dz77OW9hrFE2
X-Received: by 2002:a7b:c08f:: with SMTP id r15mr4625178wmh.173.1627050258165;
        Fri, 23 Jul 2021 07:24:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYyYv19cd/opMdw/aj+OAnIOBXA+L5wcgJMD9RrgYihxiBGFP1QigryY1B6Kkx8eDhPfGWig==
X-Received: by 2002:a7b:c08f:: with SMTP id r15mr4625160wmh.173.1627050257954;
        Fri, 23 Jul 2021 07:24:17 -0700 (PDT)
Received: from wsfd-netdev76.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p2sm27182180wmg.6.2021.07.23.07.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 07:24:17 -0700 (PDT)
From:   Mark Gray <mark.d.gray@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        Mark Gray <mark.d.gray@redhat.com>
Subject: [PATCH net-next 0/3] openvswitch: per-cpu upcall patchwork issues
Date:   Fri, 23 Jul 2021 10:24:11 -0400
Message-Id: <20210723142414.55267-1-mark.d.gray@redhat.com>
X-Mailer: git-send-email 2.27.0
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some issues were raised by patchwork at:=0D
https://patchwork.kernel.org/project/netdevbpf/patch/20210630095350.817785-=
1-mark.d.gray@redhat.com/#24285159=0D
=0D
Mark Gray (3):=0D
  openvswitch: update kdoc OVS_DP_ATTR_PER_CPU_PIDS=0D
  openvswitch: fix alignment issues=0D
  openvswitch: fix sparse warning incorrect type=0D
=0D
 include/uapi/linux/openvswitch.h |  6 +++---=0D
 net/openvswitch/actions.c        |  6 ++++--=0D
 net/openvswitch/datapath.c       | 18 +++++++++++-------=0D
 3 files changed, 18 insertions(+), 12 deletions(-)=0D
=0D
-- =0D
2.27.0=0D
=0D

