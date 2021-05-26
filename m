Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5749D391234
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 10:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhEZI0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 04:26:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230384AbhEZI0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 04:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622017479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=h/IiZdevU24C6iPRKe1yVzH4pkUf/4vRqKB2RZ+6Gak=;
        b=hFfQ8on5SziwOgjapf0WZoT7Hc65Zlkz/OlQavC9X+mTXgKu3nqQjoz75wK9oQrEbAAj3+
        yn8rnIUsKGtyZWyc0IeAI1coDTULr98FC8ehcgWkXDq1+jEyXgyvwRERE5aZdOylROzx+u
        u5/O+0EKV+VPBaPcVrPSJE/eTQflmHI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-W6ARPQVtPEa8mYZ_f_jSpQ-1; Wed, 26 May 2021 04:24:36 -0400
X-MC-Unique: W6ARPQVtPEa8mYZ_f_jSpQ-1
Received: by mail-wr1-f72.google.com with SMTP id c13-20020a5d6ccd0000b029010ec741b84bso17452wrc.23
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 01:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=h/IiZdevU24C6iPRKe1yVzH4pkUf/4vRqKB2RZ+6Gak=;
        b=K8JThhUTiFOfSdS0Lw1X8Ib3hoM7tsh4/dTYwTLhd4+D0m3UUzBa3FoUenJtiBnK6d
         gJw771ztUWmjGyoWS2YL449TuVs7bSduTBFDOGG+roRfPG4PL6qnI+KeSbPG/C6melQ7
         t0QMGlX/WCPINIW0K5KtMP0wx+tf87TtilirgWSpNp5xtR0p8MEMFN5PF5wo+YOAsdE3
         YSSPun4iVb4pK4UXId5TlXEMceWWPNwlv5N8c/KuMlI0zAYRVhaal1ReaWuc/+NvFidI
         /oqlut6UiG4rin795zLVpCrZuv3XiChexTlq5Uf4xspkwUKJ7ucsV3DZ1UM/HBBkIl4R
         VH+g==
X-Gm-Message-State: AOAM532w6R/jBxXcMyGxuRctvZHTH1VxDO1oh9d/PM3r8PCHMypAbw1Z
        NCHZBu3A+IlbjEO2qNtB2LSGuMaNAiViOUJcDh55qR05TAKuGHkJyANcQoORYMhBwSvCydupN4Q
        tTiaYTkdiusrEuZPA
X-Received: by 2002:a05:6000:22f:: with SMTP id l15mr31043315wrz.316.1622017474987;
        Wed, 26 May 2021 01:24:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCiZwAZaoPLnVZeYjw1jGMxvTHDr/fij7cEsvVkrjAJeTC0ZTaZikGLvMscL1b2PuHa1A7HA==
X-Received: by 2002:a05:6000:22f:: with SMTP id l15mr31043301wrz.316.1622017474846;
        Wed, 26 May 2021 01:24:34 -0700 (PDT)
Received: from redhat.com ([2a10:8006:fcda:0:90d:c7e7:9e26:b297])
        by smtp.gmail.com with ESMTPSA id n2sm17372318wmb.32.2021.05.26.01.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 01:24:34 -0700 (PDT)
Date:   Wed, 26 May 2021 04:24:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 0/4] virtio net: spurious interrupt related fixes
Message-ID: <20210526082423.47837-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


With the implementation of napi-tx in virtio driver, we clean tx
descriptors from rx napi handler, for the purpose of reducing tx
complete interrupts. But this introduces a race where tx complete
interrupt has been raised, but the handler finds there is no work to do
because we have done the work in the previous rx interrupt handler.
A similar issue exists with polling from start_xmit, it is however
less common because of the delayed cb optimization of the split ring -
but will likely affect the packed ring once that is more common.

In particular, this was reported to lead to the following warning msg:
[ 3588.010778] irq 38: nobody cared (try booting with the
"irqpoll" option)
[ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
5.3.0-19-generic #20~18.04.2-Ubuntu
[ 3588.017940] Call Trace:
[ 3588.017942]  <IRQ>
[ 3588.017951]  dump_stack+0x63/0x85
[ 3588.017953]  __report_bad_irq+0x35/0xc0
[ 3588.017955]  note_interrupt+0x24b/0x2a0
[ 3588.017956]  handle_irq_event_percpu+0x54/0x80
[ 3588.017957]  handle_irq_event+0x3b/0x60
[ 3588.017958]  handle_edge_irq+0x83/0x1a0
[ 3588.017961]  handle_irq+0x20/0x30
[ 3588.017964]  do_IRQ+0x50/0xe0
[ 3588.017966]  common_interrupt+0xf/0xf
[ 3588.017966]  </IRQ>
[ 3588.017989] handlers:
[ 3588.020374] [<000000001b9f1da8>] vring_interrupt
[ 3588.025099] Disabling IRQ #38

This patchset attempts to fix this by cleaning up a bunch of races
related to the handling of sq callbacks (aka tx interrupts).
Somewhat tested but I couldn't reproduce the original issues
reported, sending out for help with testing.

Wei, does this address the spurious interrupt issue you are
observing? Could you confirm please?

Thanks!

changes from v2:
	Fixed a race condition in start_xmit: enable_cb_delayed was
	done as an optimization (to push out event index for
	split ring) so we did not have to care about it
	returning false (recheck). Now that we actually disable the cb
	we have to do test the return value and do the actual recheck.


Michael S. Tsirkin (4):
  virtio_net: move tx vq operation under tx queue lock
  virtio_net: move txq wakeups under tx q lock
  virtio: fix up virtio_disable_cb
  virtio_net: disable cb aggressively

 drivers/net/virtio_net.c     | 49 ++++++++++++++++++++++++++++--------
 drivers/virtio/virtio_ring.c | 26 ++++++++++++++++++-
 2 files changed, 64 insertions(+), 11 deletions(-)

-- 
MST

