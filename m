Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12526CB113
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbfJCV04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:26:56 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36475 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfJCV04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:26:56 -0400
Received: by mail-ed1-f67.google.com with SMTP id h2so4006676edn.3
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=fRdNXYEQuJqZCNgkZZW0LMm3TY4+goDrQ3dFWV6ltAw=;
        b=j2bZB6FTOZS/skJhzF4ZbCdaNW34WI5R1fv9oo+84D6PRP6jOTBaAX8sJ4BohOm2qw
         lBQ/yBLPcW7BaLyw1b/bUIgJTwzr4miHvH/3nkdLplajAFfoXJcmkQcJ8ZbhsBuF1ru9
         d8nGO8Z63Rx6x0EnizsKCo33QQ++pbSVERJ3qvVN/KNpTb3oMb0ZaOlgbxYZIM5b6QH0
         B9AVGtd7dFK+txrO9l+1t9fasM90jATHFsn00aeB+RqWYzrm2bY/eT5jdUizfhiYxQDu
         F7NGcbBkAi8Ix4Smo+jraJOsxT+uosbrESBmfrDkmUe7SuU0W1KERj063UIbWUezZiIp
         MTug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=fRdNXYEQuJqZCNgkZZW0LMm3TY4+goDrQ3dFWV6ltAw=;
        b=cScNrgdfHsgE/V5skWvvFUfmqZKRFZGDRmvat4/hbheXpvwplbLi9bQTHFJCau07DI
         tRg+wlDHj0MrgodngnupBdn8sWC8cfXbJpB31NuaTXMKtylHpbXfsgs+4uzHPGegjec/
         Lr0SpvR+sPzCzEDVhWkzKpLpayFbgwSxMj6TO79309EIiR0a5TgpUKVL5Lgh2DYXG7vo
         ZhN9RX0SK81uPCMs4SNl6fkH21CMJyVRZtI4GrUOuySuIr+YJX8HmauuyswDKFMbPq4g
         BtR1Zedk6/2VHqu8K4sXXk8qsk5by7+CwOdBnLu++2DolV65UcemyO6DiCMxO90OrfeH
         naeg==
X-Gm-Message-State: APjAAAUzEk4nTfwDh0tlyUxrltssCGRiP3rzkd5LE1T5mPvtGPHN0nCl
        JK/Z8stOgO542FlsVaISIVTg+rc=
X-Google-Smtp-Source: APXvYqzAhAN0FEMCQgwh0IW9ktD+gsr+fQn/48Gf9xHP2T2oSf4qEoWfnBuZNrfoyf6Us6rtCBSm9w==
X-Received: by 2002:a50:bb22:: with SMTP id y31mr12307631ede.58.1570138014397;
        Thu, 03 Oct 2019 14:26:54 -0700 (PDT)
Received: from avx2 ([46.53.250.203])
        by smtp.gmail.com with ESMTPSA id f6sm679171edr.12.2019.10.03.14.26.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 14:26:53 -0700 (PDT)
Date:   Fri, 4 Oct 2019 00:26:52 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH] igmp: uninline ip_mc_validate_checksum()
Message-ID: <20191003212652.GA13122@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is only used via function pointer.

"inline" doesn't hurt given that taking address of an inline function
forces out-of-line version but it doesn't help either.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/igmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1563,7 +1563,7 @@ static int ip_mc_check_igmp_msg(struct sk_buff *skb)
 	}
 }
 
-static inline __sum16 ip_mc_validate_checksum(struct sk_buff *skb)
+static __sum16 ip_mc_validate_checksum(struct sk_buff *skb)
 {
 	return skb_checksum_simple_validate(skb);
 }
