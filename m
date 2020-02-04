Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B4A151F7B
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgBDRbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:31:24 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39293 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgBDRbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:31:24 -0500
Received: by mail-qt1-f196.google.com with SMTP id c5so14937196qtj.6
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 09:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vJ/tPyfFBTjhMDBma2s8ALCTPACKNtvGZmXrnx0pUl0=;
        b=qwJgx5DzNfrJz1AfuzKx44xkTRAZgucpiLkXlnZCUQ8KrLy6mhJv7Ur1b+YNqaPXaV
         PiFxB02SYAKQ1leIU7InO58AWhabJlLX6uZ3uF6dSnNiXLtDtxMROKmCfz583f2r5Aol
         mARmhYBlBL0AQbbcF6AKBVTKy4+QABh+1glBtXjQUpWftTUuxwOTE/wrHUZl6jxknqM5
         VaPgBuK4PMRizXwdGOhUBxMEzHez18JNUP+R/mCGNYYPQCotXr9oa06wC5pdDR6QtTLa
         swQgohPVQFMaIFZP/JhB72/N4NnB1XeJANPcW/bJpVWxGDx9LWylWB+1ZiftFOLT7Di+
         Okpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vJ/tPyfFBTjhMDBma2s8ALCTPACKNtvGZmXrnx0pUl0=;
        b=SHSClyRqhgwcPVWvGjopzHeJLBvpjrGBD4xEg6Ov08BNweEC9LYhHfC/fKaHkk3ULl
         FqY3/OHJ7Cjf647kfVpnV/83OyDm5M1VygcjzN+iqwqEaQhGvbkW/zNDvDh42V8Ndc6N
         W6fhDqtVq32YiIuzru7wDQMV0fWmD/IVitO22Nwd+BDSxjhswqQQrt8rbF308x7ycdFj
         Kv+o2eJ7NNW+baH+mMDprx2GkMCBKrgWXgk4ClNAXwb0/LBzzFhP2IgmOC+nIVHEnxyx
         Ns4FwwWevpURD0Kd+4i75+4GOu1mB/z9sW5Yphlj+tvoiLTmLrFSFUtym5Mtzixsv+0V
         ZsHw==
X-Gm-Message-State: APjAAAWGWzwv8OanzC3cadVIHXb1U88RSedDw+oJuDHA4ngsC/1EIAqW
        /42/jh3ZQ+m6vRS7FZGaSApm5N2A
X-Google-Smtp-Source: APXvYqy+kqDcPKAq8dzCRFt+sKW8km99pDf+i6RVf5ckDz3ZAYSCYKQsFqFPr0Nyb/LYOYv+ilAXXg==
X-Received: by 2002:ac8:4b70:: with SMTP id g16mr29330069qts.296.1580837483281;
        Tue, 04 Feb 2020 09:31:23 -0800 (PST)
Received: from localhost.localdomain ([45.72.237.143])
        by smtp.gmail.com with ESMTPSA id m54sm12466623qtf.67.2020.02.04.09.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 09:31:22 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, andrea.mayer@uniroma2.it,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCH net 0/2] net: ipv6: seg6: headroom fixes
Date:   Tue,  4 Feb 2020 12:30:17 -0500
Message-Id: <20200204173019.4437-1-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

This patch series fixes issues which I discovered while implementing RPL
source routing for 6LoWPAN interfaces. 6LoWPAN interfaces are using a MTU
of 1280 which is the IPv6 minimum MTU. I suppose this is the right fix to
do that according to my explanation that tunnels which acting before L3
need to set this headroom. So far I see only segmentation route is affected
to it. Maybe BPF tunnels, but it depends on the case... Maybe a comment
need to be added there as well to not getting confused. If wanted I can
send another patch for a comment for net-next or even net? May the
variable should be renamed to l2_headroom?

I splitted this fix in two patches, I only tested the first one and I
think the second one. The second one should fix issues as well.

Open to discuss my patches and if isn't the real fix... how we fix it?

I cc'ed all necessary people and Andrea which seems to have some net-next
patches around who should consider this fix in their new patches.

- Alex

Alexander Aring (2):
  net: ipv6: seg6_iptunnel: set tunnel headroom to zero
  net: ipv6: seg6_local: don't set headroom

 net/ipv6/seg6_iptunnel.c | 2 --
 net/ipv6/seg6_local.c    | 7 -------
 2 files changed, 9 deletions(-)

-- 
2.20.1

