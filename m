Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFDD22D33A
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGYAXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYAXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:23:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C985C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cv18so6521414pjb.1
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jL/ICIwwHZVtNxZOQzt1A8v6qVjvuIODVRlKYI1IwYc=;
        b=ATCQglHweeweJ3X0eKrZFn6JFqzrX7DCgPhge1jJpTHuzyTZrB4vOzvYL7YzhtzljS
         CH4U7BxZEJWt7r0jo5t4kAGiQMEh6Jh+rNHs8fkvtyVQZ+BiTXrkuw/5yNLdqKH8CHdz
         CK4CT3t2L19Ou5tUYRqz6be3grhJZxBDin6m8sRXtQhJAOKJ1v6lYDLHdNp+Es1ZabnE
         758sRjzcgRYdXXlT1K3PtWmjiamD6VVCy7xUSS5rpjlqZ6VCj6GExPZVdgBHbuMTUKZ+
         0/23In+2lQGfFHgN6nq8QdE5kUerocyY8yGn04sk3yiKrxWFPgKvPdVC5ypJmLoFbk/O
         +rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jL/ICIwwHZVtNxZOQzt1A8v6qVjvuIODVRlKYI1IwYc=;
        b=bTmXEt1u808G+O4Vme4U5AxdiWSNjMd3nUrRdFBu0tLcaXv062yWCDYye9P8U6FRjS
         Z/YPARKvm0FJIYbd/K/12rYnQpKbbj0iMEPvZ/Tf29zbFyrZYlKexRjEZVjDNR8WR6Xm
         QBhjGkTGdqS4FS2NNdohNKR7mp7mDxaksL62q5wwoGDHQ8iBLKJThv6hPFmVBQ0WwPag
         pnr3sy6nW/WyB7cZfp+StLkupRV+1yLS28mfnMZyDL+hxaTfTtW3QBWLGYFI6QUiGdg3
         shExgEphIKi5MhnUIIh7ZlI8zkJtJCP+hPqsKIxBzbx9LAHbE7pwan0EjYVDNKSxjDju
         g9Aw==
X-Gm-Message-State: AOAM531+icwyR273IG+2FT8xmhKbX7nBOswA37NZfsH1eLyxhl4r1Gnk
        m4le4xIDt2QaRMIPSsxhCoQGYWsosl4=
X-Google-Smtp-Source: ABdhPJxDBx3oaCaPW0RxmfIOgwvnWfY5ScX3SalrZo0r5o9Gw4ZxQaYx2Cdd9y4I9UIIWHAlyxiLmA==
X-Received: by 2002:a17:90a:6281:: with SMTP id d1mr7728160pjj.231.1595636613524;
        Fri, 24 Jul 2020 17:23:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id lr1sm8400368pjb.27.2020.07.24.17.23.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 17:23:32 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/4] ionic txrx updates
Date:   Fri, 24 Jul 2020 17:23:22 -0700
Message-Id: <20200725002326.41407-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few patches to do some cleanup in the packet
handling and give us more flexibility in tuning performance
by allowing us to put Tx handling on separate interrupts
when it makes sense for particular traffic loads.

Shannon Nelson (4):
  ionic: use fewer firmware doorbells on rx fill
  ionic: recover from ringsize change failure
  ionic: tx separate servicing
  ionic: separate interrupt for Tx and Rx

 .../ethernet/pensando/ionic/ionic_ethtool.c   | 118 +++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  42 +++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   5 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 188 ++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   2 +
 5 files changed, 267 insertions(+), 88 deletions(-)

-- 
2.17.1

