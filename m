Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1AA20C0DD
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 12:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgF0KzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 06:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgF0KzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 06:55:18 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D630C03E979
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 03:55:18 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id k15so5798716qti.22
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 03:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2mGLRB8uPJH0YAc6/MnuRKvu/ULwpMyORujULmy6i+Y=;
        b=CFSyJ0bICK6PSFwxqgsKeGzYSTf3+XF6VyPV1mxWmPtx/T7LIDNx3b7BhCtOBIIDDx
         saGvGu2IHmNTAOrP8wRR096LqlWYrXj6vX3u9H9hb1gR2ZT9gChh2qHo7CuK6xU26mTh
         ugeGeXGZ9MbvssjMHININc8bbLPjlLXPkoCIiEPwf7GUa9OOYY7gS4hG174IOCKxcRQB
         52/ocKW0PH3or+OyzC+1CMniDj0bgj2WboitomX96J2RhgbQvs3x3UQ3ta0s1ihzYn3J
         e8rOzsvk4k1kOM2ylfw4mG90zyfUw+UALtIWI3DKROLFhN7b9lRxzdSBmdSFytYy0S1q
         gm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2mGLRB8uPJH0YAc6/MnuRKvu/ULwpMyORujULmy6i+Y=;
        b=kMNJLmKrAxCNGoCqYT/K6NLl5PJDgiXpxYIqHCP8WQVzDD/25R7jWjH7+Owo1M0LLU
         dm6/qEDdOzfIDaVf9wB1wVSLEnLu68DlAUyfV/Ft17vxbHtwbTaFiuyR81B8vSdfq4I+
         J1knaQt6Ag7MeTFPVi2W1KmQ952jO0d+/LX28LD8xCi0e6LnwBDipBbg1QoDFXVVjy/B
         M8rw89Fc87BlGqoRSB1tsWGpl0nupgZvXffY7kPzckA6p/z8B7+YzghkykkThxmB0mjf
         Itldb2MxsB34fKkFQ8jcnaa8FL0y+xU4+Vu1OV1Io6C3EWSO8clpYvEK23yupYtrMJHr
         h/pw==
X-Gm-Message-State: AOAM5322V6ZUk/aAgEC51vZydVaKVFn/ayyq0/vGuk2HUAEZOIMKYSMV
        tsXlIoUg8a0zLQr04masitsVJQZ8MexE
X-Google-Smtp-Source: ABdhPJzFb0bs+uHa25I0jEdxFh7meeHE5nAwPlh1GDjMeAg0Vyn7GKxVw0jxJChgt4g//OSkf+6aRc6Oouf/
X-Received: by 2002:a05:6214:5a3:: with SMTP id by3mr7193441qvb.201.1593255315932;
 Sat, 27 Jun 2020 03:55:15 -0700 (PDT)
Date:   Sat, 27 Jun 2020 18:54:35 +0800
Message-Id: <20200627105437.453053-1-apusaka@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [RFC PATCH v1 0/2] handle USB endpoint race condition
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

On platforms with USB transport, events and data are transferred via
different endpoints. This could potentially cause ordering problems,
where the order of processed information is different than the actual
order.

One such a case is we receive a ACL packet before receiving the
connect complete event. This could be frequently observed on ChromeOS
auto test setup.

> ACL Data RX: Handle 256 flags 0x02 dlen 12       #6 [hci0] 9.314240
      L2CAP: Connection Request (0x02) ident 1 len 4
        PSM: 1 (0x0001)
        Source CID: 1536
> HCI Event: Connect Complete (0x03) plen 11       #7 [hci0] 9.333236
        Status: Success (0x00)
        Handle: 256
        Address: 70:BF:92:CF:95:B7 (OUI 70-BF-92)
        Link type: ACL (0x01)
        Encryption: Disabled (0x00)

If this happens, we will simply discard the ACL packet, since no
corresponding handle is registered yet. The situation where the ACL
packet is not replied by us is handled differently by each peripheral:
some will resend the ACL packet (which will be successful, since the
handle can be found now), but some will get upset and disconnect.

To prevent this from happening, we propose to introduce a queue. So,
instead of discarding those packets without handle, we put them in a
queue. Then, we will process this queue when we receive a connect
completion event for the matching handle. The queued packets will be
cleared if after 2 seconds we still don't receive the corresponding
connect complete event.

Similarly, there is a chance that the incoming L2CAP connection
request comes before HCI encryption change event. When this happens,
the incoming connection will be refused.
> ACL Data RX: Handle 256 flags 0x02 dlen 12      #46 [hci0] 9.275297
      L2CAP: Connection Request (0x02) ident 4 len 4
        PSM: 3 (0x0003)
        Source CID: 256
< ACL Data TX: Handle 256 flags 0x00 dlen 16      #47 [hci0] 9.275393
      L2CAP: Connection Response (0x03) ident 4 len 8
        Destination CID: 0
        Source CID: 256
        Result: Connection refused - security block (0x0003)
        Status: No further information available (0x0000)
> HCI Event: Encryption Change (0x08) plen 4      #51 [hci0] 9.314109
        Status: Success (0x00)
        Handle: 256
        Encryption: Enabled with E0 (0x01)

We propose to handle this case with a similar solution: queuing the
L2CAP connection request until we receive HCI encryption change.

The proposed patch is tested with a special Intel firmware which
allows us to purposely delay the "connect complete" event.

We plan to merge this change to ChromeOS auto test setup to see
whether this could fix the problem there, but we also would like
to have your input on this in the meantime.

Thanks,
Archie


Archie Pusaka (2):
  Bluetooth: queue ACL packets if no handle is found
  Bluetooth: queue L2CAP conn req if encryption is needed

 include/net/bluetooth/bluetooth.h |  6 +++
 include/net/bluetooth/hci_core.h  |  8 +++
 include/net/bluetooth/l2cap.h     |  6 +++
 net/bluetooth/hci_core.c          | 84 ++++++++++++++++++++++++++---
 net/bluetooth/hci_event.c         |  5 ++
 net/bluetooth/l2cap_core.c        | 87 +++++++++++++++++++++++++++----
 6 files changed, 179 insertions(+), 17 deletions(-)

-- 
2.27.0.212.ge8ba1cc988-goog

