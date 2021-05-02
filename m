Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C27370F3C
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 23:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhEBVMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 17:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhEBVMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 17:12:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BEDC06174A;
        Sun,  2 May 2021 14:11:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p17so1955545pjz.3;
        Sun, 02 May 2021 14:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jv77pgq1Y7LM3XGObRm+OWJ3fXpqRB641MwUUwlIcCk=;
        b=crBhwq7Yyifj0i1PjAlTBF8L5vqb1++8ZH0VgwCKJxGvtQ9TbHyQT0ETZlgsZqjqRY
         G4MpZ3TeRyM52I76SE3dYa6d4lytrUlCnWSvtUB/lwo3aME9qGelQ8nLpvYMsVpIxfS2
         7XFNwhDnFBa/xPo7xEfDMwP3/6yuX6G4ailaXT7mjBeeexg22mbHZSqc6iTORiR6tuVy
         v08vzfYlhY/GQGTFcXd4yqagb9NRPuKWpgakgDZrkB7nQNPrAI7XsWPGCYwFrDNFvdtn
         gNQci/+TpmFrWnbnnYbGE/xK+vpGi3qQnYq0eoG+efQkFax6T0s1XaVGIxwnJTpfQNiQ
         PP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jv77pgq1Y7LM3XGObRm+OWJ3fXpqRB641MwUUwlIcCk=;
        b=NxsrwDXyGwXQpY/r2M8yNOXRQOEyBs24ah/WhF0dtp2uFWLbgG7+Nfe2OREgBJdfE4
         XQkDuZR+LaMXprUYIQ2WbOCbExD1vNHUM5tMhWMfiX1SVmue5CTCkcayfx0I5O3+N6G5
         4Bkw/so8VqAytgQSIrNvAv22tAdpJVvpiNx4Ve5RRKKX3fzI/NgRCkgLrdgOZ7ZtWK7L
         Z+R+FPlsXj9HyRapfsSUfvL4/9DSxTDu+D+xblqjpmEn7jco5DqtHbgVSUzUsfQK5R7i
         TrfOA/ewqIPJGUdlG92E4wATlM1dYfM2bg8OvxMICX8LJ4ERvJkGOUWX6AU1kKByhwBi
         0DOA==
X-Gm-Message-State: AOAM531srbxDQo2RrgaMpnpGxsGzSA4nybulstg1WCciejFr0OkrxbBG
        HHc1+GSpKUK/3j0JzZxvCRkWW/DK52zkBBsq
X-Google-Smtp-Source: ABdhPJwJxnWwruD1zFVLC7neaUNUFds+fv2uHvxjs5aS6Y0qgJObcTdXZb1Nn/a54MXZVqk7mICVWw==
X-Received: by 2002:a17:90a:77c8:: with SMTP id e8mr28026082pjs.69.1619989911090;
        Sun, 02 May 2021 14:11:51 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x12sm7066376pfn.138.2021.05.02.14.11.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 May 2021 14:11:50 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Or Cohen <orcohen@paloaltonetworks.com>
Subject: [PATCH net 0/2] sctp: fix the race condition in sctp_destroy_sock in a proper way
Date:   Mon,  3 May 2021 05:11:40 +0800
Message-Id: <cover.1619989856.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original fix introduced a dead lock, and has to be removed in
Patch 1/2, and we will get a proper way to fix it in Patch 2/2.

Xin Long (2):
  Revert "net/sctp: fix race condition in sctp_destroy_sock"
  sctp: delay auto_asconf init until binding the first addr

 net/sctp/socket.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

-- 
2.1.0

