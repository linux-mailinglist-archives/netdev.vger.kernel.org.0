Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394853B6DC2
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 06:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhF2Ewq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 00:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhF2Ewo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 00:52:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7458EC061574;
        Mon, 28 Jun 2021 21:49:49 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id s137so8541739pfc.4;
        Mon, 28 Jun 2021 21:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=tNHQWqsPBjj0yKLYweJTmYfQXLdv5jACBGV47l7LzU0=;
        b=VRW61Egj7WXBdR2Iw8XwKEMUMYtL8WeRfWEuhOxv9NjcTRw+ptRSAvlpogQfPh4FOW
         3PJWIFtaaQ4wxsVwSKS5fmELWr38kH4P7A61D4dZWyZtRuDfWctAgfy99z4JlRyXwR4Y
         KvPGzM41hu+46HoLMB40m7bKsk2NRJ84QXNJ6frO9KuIqQ+CYz3fFzaA11fIco0w2CIa
         BuQZxAOSCjV7lPvD8z+ZvHbLedwp1jfGCdGkT8xgoFlO2vMfLQWkzDkwGeibajL2b5o7
         c8lV2Y8jDzxo2nnZkTwUfKnzW5iufMwGpPlrGLVUcLhOjLWnlYCtOULeR+sA5y+H9DaU
         aoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tNHQWqsPBjj0yKLYweJTmYfQXLdv5jACBGV47l7LzU0=;
        b=puxozhH1KC//2+rffMO8B8I3AL7+RY/2VjoYoGC6n5yPwqHo3m7pxYCZGR/1ukq3ID
         n8RaMSvSRUxFK1sB+cuDj/uEWrNmFr0RBNHbxar4hnWYWO9lYAHQ4M7A1Y0OH3sFF5Mj
         hPHtAaHPUpfCxpDHiuzOQi6UkqVypj4ZbQGsMajXDI7WsS8m2+Pp9M3okQUSZTsfNa++
         7T4D2MwnUfK9cHMBArsf0LUZ9E4SBF44lHOTeRfyexoLqjXBslk9EYqfHFpRb9nI2wD4
         v6w1uVsirv2p0Qx1bWz6X6YC1Y61FBcv9BMrolSwYP0JrSAe9QdMqEX0afVQx2KSdPz1
         Y6uA==
X-Gm-Message-State: AOAM533EDg8zU/CPd3Ciw2dd46RyAafyHEdQfxZzum8dfTM0NHt9hTtN
        ouX3qeeYN9V3uiSyZHGJZnFdvn1QH59coSutopt768GhZio=
X-Google-Smtp-Source: ABdhPJxl0ENo2BNOqLmm6Uinxiso/YG8UoSx6uPCF6BjQGsTZNnT4nePKygJlw9PB/inoSzwHDgn3oI31oOywp7Gr/0=
X-Received: by 2002:a63:f65:: with SMTP id 37mr15881590pgp.367.1624942188665;
 Mon, 28 Jun 2021 21:49:48 -0700 (PDT)
MIME-Version: 1.0
From:   Davis <davikovs@gmail.com>
Date:   Tue, 29 Jun 2021 07:48:00 +0300
Message-ID: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
Subject: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings!

Could it be possible that
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.12.13&id=a8c4d76a8dd4fb9666fc8919a703d85fb8f44ed8
or at least its backport to 4.4 has the potential for memory
corruption due to incorrect pointer calculation?
Shouldn't the line:
  struct ethhdr *ehdr = (void *)skb_mac_header(skb);
be:
  struct ethhdr *ehdr = (struct ethhdr *) skb->data;

Later ehdr->h_dest is referenced, read and (when not equal to expected
value) written:
  if (unlikely(skb->protocol == sdata->control_port_protocol &&
      !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
    ether_addr_copy(ehdr->h_dest, sdata->vif.addr);

In my case after cherry-picking
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.4.273&id=e3d4030498c304d7c36bccc6acdedacf55402387
to 4.4 kernel of an ARM device occasional memory corruption was observed.

To investigate this issue logging was added - the pointer calculation
was expressed as:
  struct ethhdr *ehdr = (void *)skb_mac_header(skb);
  struct ethhdr *ehdr2 = (struct ethhdr *) skb->data;
and memory writing was replaced by logging:
  if (unlikely(skb->protocol == sdata->control_port_protocol &&
      (!ether_addr_equal(ehdr->h_dest, sdata->vif.addr) ||
!ether_addr_equal(ehdr2->h_dest, sdata->vif.addr))))
    printk(KERN_ERR "Matching1: %u, matching2: %u, addr1: %px, addr2:
%px", !ether_addr_equal(ehdr->h_dest, sdata->vif.addr),
!ether_addr_equal(ehdr2->h_dest, sdata->vif.addr), ehdr->h_dest,
ehdr2->h_dest);

During normal use of wifi (in residential environment) logging was
triggered several times, in all cases matching1 was 1 and matching2
was 0.
This makes me think that normal control frames were received and
correctly validated by !ether_addr_equal(ehdr2->h_dest,
sdata->vif.addr), however !ether_addr_equal(ehdr->h_dest,
sdata->vif.addr) was checking incorrect buffer and identified the
frames as malformed/correctable.
This also explains memory corruption - offset difference between both
buffers (addr1 and addr2) was close to 64 KB in all cases, virtually
always a random memory location (around 64 KB away from the correct
buffer) will belong to something else, will have a value that differs
from the expected MAC address and will get overwritten by the
cherry-picked code.

Br,
Davis
