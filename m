Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F086456E23
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfFZP4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:56:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41535 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZP4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:56:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so3335732wrm.8
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YFN1V81z/US3l+OrAj1q6RyEj/K+BvKjZL8+vYegMlY=;
        b=Uc5e8uVqA4Zk5KGVrOD+I19Ejmn6vx5W8Bt6Eom4Ep968OBfbI+kqbQXj/Nln4N18w
         sTi73U4TT7Nbwg/h3IKSh4nurofKXx7T8GXjnLneQozv8lXorrLvD0Yhw9mxJtrYm28n
         llTSHsJurhCrZbs3IJWWETXgW+rSWYtTkfaH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YFN1V81z/US3l+OrAj1q6RyEj/K+BvKjZL8+vYegMlY=;
        b=QLUIsq4KFGTKEK8vNzt2OtmEVxqAy0YBEU0r9R0cvH+rxs/TmQll23/Va+Kdo/8dEV
         7PkQ+qkvtRDXFTOgLTFxyqgPT8XGTyGBkxOtJEQJT8lWoTl7TVrWlUpAunVYvo89IT11
         hi5p5VMCDa+NyMYZ6Dum0iDLyEnL1Iudg5JTvKAXa02y1yqJXBQ8xOKhkyt4VxM9j9uU
         DO92SOCRZt0bmzk0twqu9sG7kmdMCWo0Cfx45Js1TLXRBxQmWFjfKUMCHLOPhLp7zqol
         fR6eIwCGlAcXWGYS8a+QTz06wH8JG8rWgCu1W7cvPiXTaq+ay+v0wLiAq6YvCkL14au4
         nRLw==
X-Gm-Message-State: APjAAAWN7JtUlzxMnUiyyJHOUAz6vpymsv+Gb5pyxwSssx1wpki8OMfG
        LXQoKbvrUX6LMC1i6hNiXPs/2Q+kpF4=
X-Google-Smtp-Source: APXvYqzh9VlkknJikp8S5YTR0Juhj0aS7LpA9f2XdOYu/uhmB2K1zoYcLjPfek5My52KtYh1kXOqTw==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr4366989wrs.151.1561564588036;
        Wed, 26 Jun 2019 08:56:28 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id h8sm1832556wmf.12.2019.06.26.08.56.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 08:56:27 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 0/4] em_ipt: add support for addrtype
Date:   Wed, 26 Jun 2019 18:56:11 +0300
Message-Id: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
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
the user-specified one. The first 3 patches make em_ipt match only on IP
traffic (currently both policy and addrtype recognize such traffic
only) and make it pass the actual packet's protocol instead of the xt
match family when it's unspecified. They also add support for NFPROTO_UNSPEC
xt matches. The last patch allows to add addrtype rules via em_ipt.

v2: change patch 02 to set the nfproto only when unspecified and drop
    patch 04 from v1 (Eyal Birger)

Thank you,
  Nikolay Aleksandrov


Nikolay Aleksandrov (4):
  net: sched: em_ipt: match only on ip/ipv6 traffic
  net: sched: em_ipt: set the family based on the packet if it's
    unspecified
  net: sched: em_ipt: keep the user-specified nfproto and use it
  net: sched: em_ipt: add support for addrtype matching

 net/sched/em_ipt.c | 49 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

-- 
2.20.1

