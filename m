Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DCD5681C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFZMBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:01:04 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39820 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZMBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 08:01:04 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so1817031wma.4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 05:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L+TLxcyKQnZrZRVwlylPXb1dhFsuGyc7vzuJUjzre6M=;
        b=LYIX/VAh/P4ebykGtsH+ski7kBGMsCsgHCMoLZeZ4eqkMphs9mk4My9+G0gi3G+nFz
         3a60L2YL5LAULU4MKx5vgqfSeWDJcQBDhUwY9CEXJSPu+lRbcjv9PB6vyh4ArdAyvYFX
         sAv8P5ZRFsaz/RQAJopJXKX1/dEqvGhfRZsPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L+TLxcyKQnZrZRVwlylPXb1dhFsuGyc7vzuJUjzre6M=;
        b=Vijo/NgNAv7HlWdtt+eSqqGuRD10b0LDt+nKk/CzJI1d9QEy0z5kw+V+NNVCTVFaPf
         BAyesy3+vIkyvWJXU8VUo6ZENChoziBE1PI3pGL/p+Bhel4fD4Vqmtk2Fw4sxpZT1n0I
         V9gi8ztBiTZEZHDbd5rffx9DAKBaasHxckykOU/d/tpaSYfN99j5zTwQxMYTLz4N6no5
         KiTxFALA9EkYuBoDi8rUbR2hCd/NutUgZ/1TGWbgL7hKfpX5mgUdRHOa75E9q8vC6BeA
         jqNmskNSqvn2x2sCw8LjatBmUJvrUPgTDZOl87Bp/vCKgWPKV2SxPqiGg2to8plGDQdi
         QAZg==
X-Gm-Message-State: APjAAAXBLrIfJZBkrzWaVJSbgQGbsl9xu7lDubZ86pNsup8bvNR8kGfM
        kaxgD1XE6NNwRkqwNeU6uvq578H3swA=
X-Google-Smtp-Source: APXvYqw8eSa75B4HIsdJABr6Joxl1dH5ZddfuXUq2ISukfQOwCJtIheOKFT3q6xVwLMstkPzb7bMzQ==
X-Received: by 2002:a1c:c6:: with SMTP id 189mr2541773wma.112.1561550461989;
        Wed, 26 Jun 2019 05:01:01 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id f190sm1676818wmg.13.2019.06.26.05.01.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 05:01:01 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/5] em_ipt: add support for addrtype
Date:   Wed, 26 Jun 2019 14:58:50 +0300
Message-Id: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
We would like to be able to use the addrtype from tc for ACL rules and
em_ipt seems the best place to add support for the already existing xt
match. The biggest issue is that addrtype revision 1 (with ipv6 support)
is NFPROTO_UNSPEC and currently em_ipt can't differentiate between v4/v6
if such xt match is used because it passes the match's family instead of
the user-specified one. The first 4 patches make em_ipt match only on IP
traffic (currently both policy and addrtype recognize such traffic
only) and make it pass the actual packet's protocol instead of the xt
match family. They also add support for NFPROTO_UNSPEC xt matches.
The last patch allows to add addrtype rules via em_ipt.


Thank you,
  Nikolay Aleksandrov

Nikolay Aleksandrov (5):
  net: sched: em_ipt: match only on ip/ipv6 traffic
  net: sched: em_ipt: set the family based on the protocol when matching
  net: sched: em_ipt: restrict matching to the respective protocol
  net: sched: em_ipt: keep the user-specified nfproto and use it
  net: sched: em_ipt: add support for addrtype matching

 net/sched/em_ipt.c | 52 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

-- 
2.20.1

