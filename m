Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7ED6BD3F6
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbjCPPhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjCPPhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:37:18 -0400
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0F0BE5D6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:35:11 -0700 (PDT)
Received: by mail-qk1-f202.google.com with SMTP id x18-20020a05620a099200b00745c25b2fa3so1116044qkx.16
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rC1VGMFv7zzu7CU91Nhp8bI0nzDwaHiXVvVPl87M8n0=;
        b=ayNhyTokX3WN18Gg3kZ4n+m7b7o1cO1N4bRcOn8ncxpwB+UOri4TCjYjcUmLXo/gEt
         cUcZ0Hzjght0yFxY0FJBQX8trXSQluOYmnjqAz0W/IYt+YZfPIqWd7YJDgN7pa3wTUNg
         uFoq4hAFsquOWXRIzrXsBWLFaEaO8tpvWkOAPVbBKwEHmcw44yr2yEXnU4et2fSXTY3d
         fZSqv0a0OKvIaOBtQx+4EQVGPG2HXhRkY2fCmOTUrckkUZ00gfBMbm1PwknW8fMP4J+w
         JLIypLCWMPj2z5opM42kK8lb8Ie+DARVESHRkCfHXySMzZHODTAy0ey/q+xR3Nfa6xgp
         LH6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rC1VGMFv7zzu7CU91Nhp8bI0nzDwaHiXVvVPl87M8n0=;
        b=wf3zj8Itpfc+rEOuxIxn27GJKK1fFhjUA863AXuLvcCSDlMxXE/h5Rhlt8cp/27pGD
         vN9105U0/EZrLupLWKHhXARFb77gJnyKmnYe/Xs7zllzot/8ShYSzSLtW/uoEmuxOiXq
         zd/I6EPIaG9z5w/4DlaMfXFavyCqKRuegX6GSq7bocQZtH2HMbOctK10sjVxpGWaP2dD
         jESMU+jyoMSFPea+7DOrmqoGoJ4+B93WeUEh5WyzQYuqSLxZTaxIuhsJA4O0MVg8caGH
         01o2OiL7+K9mi5nASK/7PEXqoO2DQXMuNAf5PXiehypd4gb2+w8oDXE51u/sc2fJ4eTo
         VqBQ==
X-Gm-Message-State: AO0yUKV3d8NFtl1cLN3LejiX49ANfEdFgZYlJAAmxWRnqnMs4+oTWI7/
        tfcBokpmlWUcEL50sfdBbAQSR7bxfwXKjQ==
X-Google-Smtp-Source: AK7set//rHVycL0+uZI7J10zkSywuanHuQLp1zOelBKnySZv9ib7h4ts66w5WLTkEYygSExMEoufkDDZuqSZTw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ac8:4044:0:b0:3bf:d798:8ca7 with SMTP id
 j4-20020ac84044000000b003bfd7988ca7mr1167098qtl.0.1678980737484; Thu, 16 Mar
 2023 08:32:17 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:32:02 +0000
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316153202.1354692-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-9-edumazet@google.com>
Subject: [PATCH v2 net-next 8/8] inet_diag: constify raw_lookup() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now both raw_v4_match() and raw_v6_match() accept a const socket,
raw_lookup() can do the same to clarify its role.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/ipv4/raw_diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 999321834b94a8f7f2a4996575b7cfaafb6fa2b7..bca49a844f01083cdfdade6f52852d48ddb36d70 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -34,7 +34,7 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
  * use helper to figure it out.
  */
 
-static bool raw_lookup(struct net *net, struct sock *sk,
+static bool raw_lookup(struct net *net, const struct sock *sk,
 		       const struct inet_diag_req_v2 *req)
 {
 	struct inet_diag_req_raw *r = (void *)req;
-- 
2.40.0.rc2.332.ga46443480c-goog

