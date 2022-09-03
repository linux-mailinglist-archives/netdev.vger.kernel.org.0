Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551B25ABD0F
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiICEiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiICEiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:38:02 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D7640E29
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 21:38:01 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q3so3719532pjg.3
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 21:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=8nxHAJjNJIWIS9zp8ReO9CFJ5l6F+DeHqEeikcdRx8A=;
        b=X3lVsVyiXuVeUrPc0SfBRYXsv+r0wXnzDinfXhWzg0rcwgVH00dNuGxyp8ILJbrzKe
         FhVA4UE2lXfoDl2VC5CrLsJyA1NrdVmISCVYcMuorCm5ahdWpcFshtng/mI+zvKlZuEX
         3dD3MkRXOKpFlUQo6Yp0wZyGx9Jm/4p2eTryw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8nxHAJjNJIWIS9zp8ReO9CFJ5l6F+DeHqEeikcdRx8A=;
        b=W3o7QAPHq10uMP8HOcQyqb8Dd7OqzMdag/vzcWO49PQfPhJxla8qJgECvNcEO2i/Uy
         OKa2SD0RjHab33dt/dNMEFLnnXNXnVSBUvk0m+omxcx+qjQUbeAnS7PMKA9urkL/ncpE
         Qw+ILaSHj7ToSt1XKWeryUdT9aA2N1WPNvoOWLNQgBtqJFOBiusXBgSnfSBGCv8SmesA
         sSAwhr5EpmTsk+JzYlu1Jd7pENMlRdMPZdkeMYoneRVIqn5AlNvAOr6k4LV/MHgpndGD
         vo1FySsDKDp3PeM+vJ0Ul8iILDF0xzRer7AQTxLTs1TwrD1B/snVo2E1tpBUGJPMhgyN
         cOAQ==
X-Gm-Message-State: ACgBeo2G6e4yBAgIGOQWd8XdgGZVEPP+cIdIPgh4IzVCK91SbKpQVD8i
        fOCAbI4k+pJwiV978HQulM3mKQ==
X-Google-Smtp-Source: AA6agR4tHbhmttrlfXXBLnYW6bC7tSeb/QIaCb2aEofXok4fszW2M01DOX72YVzujYwLN4janJeuvg==
X-Received: by 2002:a17:90b:4f44:b0:1f5:1310:9e7f with SMTP id pj4-20020a17090b4f4400b001f513109e7fmr8267103pjb.235.1662179880957;
        Fri, 02 Sep 2022 21:38:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ot17-20020a17090b3b5100b001fb3522d53asm6106848pjb.34.2022.09.02.21.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 21:37:59 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v4] netlink: Bounds-check struct nlmsgerr creation
Date:   Fri,  2 Sep 2022 21:37:49 -0700
Message-Id: <20220903043749.3102675-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3165; h=from:subject; bh=+867zmYG0ld3KfCtaWXXbDBtt9S0k+MtCYquudNfT9Q=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjEtocUmRItUSNtW/RTth/KU3s4KwnEmu+44cDc5a/ nPduHrKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYxLaHAAKCRCJcvTf3G3AJvy3EA C0NT7YlazAAErZVQ5th3Ygbrxza2BA+hg90Sou5UwTF20tyTpRMy2yyXiLuObjL+ztWexEY4y7y1e+ t+iC7eg5RiLysFTGfbBAHoRzvnA+2RsINYiG6jzux01QYm0cfdyIRjO3+kmBsqXamAe10yey74wyEy 51SFpBVb3oUf1nelP/JwsZfQbworKmB3uvhc/eGV/nFItFNk/zwLTeCHjxKKfPOlU5QPhhb67XlJt0 2bUH3UMOqNE7k3ksE4Evem4E5TkgvbqntVcE5U1ND7P0SnGeUaYP8iFisX8TMVk5GImU1T6lcyhMk/ uwhy+ULjLiDaDIH9dvMqsV4Zu1E+vJmgmL0WVRB2/fLA6pUkR0/7+GB2GmCpHay1yK1NsQLHtmZOWl rBO02Io72jB2ID91gCgkSHFrleBBWUqUg06+PCYcmpAK+CzQch4nW+KNU6rbU/10nVYkJtB+S72KFn TQP/6uSRqyim3bMMjYyE85iMq+AeMSMAfCtIF6NAoT/YSNa/Tj4n6Wv3EtLdHDLy3wFV1njy+vkWkI ATBbd/OSj9xMUtIzHdnJBRD5jyaYPGqH5z6N9pUkNHVoYT+9GNxRnjBsuOMF3HS65I/FxnjIj0ZBkq zwo/flWB1PpdNUBcCbi+F/bSsl3mDFlWiqBXdHturSUMBuyC2ZOm3DxFfkEg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE doing bounds-check on memcpy(),
switch from __nlmsg_put to nlmsg_put(), and explain the bounds check
for dealing with the memcpy() across a composite flexible array struct.
Avoids this future run-time warning:

  memcpy: detected field-spanning write (size 32) of single field "&errmsg->msg" at net/netlink/af_netlink.c:2447 (size 16)

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: syzbot <syzkaller@googlegroups.com>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220901071336.1418572-1-keescook@chromium.org
---
v4:
 - switch to nlmsg_put() instead of __nlmsg_put() (kuba)
v3: https://lore.kernel.org/lkml/20220901071336.1418572-1-keescook@chromium.org
v2: https://lore.kernel.org/lkml/20220901064858.1417126-1-keescook@chromium.org
v1: https://lore.kernel.org/lkml/20220901030610.1121299-3-keescook@chromium.org
---
 net/netfilter/ipset/ip_set_core.c | 8 +++++---
 net/netlink/af_netlink.c          | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 16ae92054baa..6b31746f9be3 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1719,11 +1719,13 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		skb2 = nlmsg_new(payload, GFP_KERNEL);
 		if (!skb2)
 			return -ENOMEM;
-		rep = __nlmsg_put(skb2, NETLINK_CB(skb).portid,
-				  nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
+		rep = nlmsg_put(skb2, NETLINK_CB(skb).portid,
+				nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
 		errmsg = nlmsg_data(rep);
 		errmsg->error = ret;
-		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
+		unsafe_memcpy(&errmsg->msg, nlh, nlh->nlmsg_len,
+			      /* Bounds checked by the skb layer. */);
+
 		cmdattr = (void *)&errmsg->msg + min_len;
 
 		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f89ba302ac6e..a662e8a5ff84 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2494,11 +2494,13 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		return;
 	}
 
-	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
-			  NLMSG_ERROR, payload, flags);
+	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
+			NLMSG_ERROR, payload, flags);
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
-	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
+	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
+					 ? nlh->nlmsg_len : sizeof(*nlh),
+		      /* Bounds checked by the skb layer. */);
 
 	if (tlvlen)
 		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
-- 
2.34.1

