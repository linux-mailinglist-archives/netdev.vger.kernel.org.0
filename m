Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D7E6BBDF3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjCOU1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCOU1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:27:46 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967F27EDA
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:27:44 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id x19-20020a4a3953000000b00525191358b6so2989524oog.12
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678912064;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YB8bCi0OFAJV1cNy2JUVpeOZKfBWS8MkybFkIp+Rpbk=;
        b=51uZjduJt9l2N1CJkqQbkRVdaAb3f5hNoLz1BMyG9dU5WFap3z4wpp4gfRYMI6mYIC
         AeysHEUDWKxo/PyiwsMEawPMMllVgRoFczloet9qzdcgvY3CE4VulYIaz6HWoQZhRnDy
         t23A8TUFxhudTyEXmCIIKy0Ja8KWxg1UH+LQfvH7Tl8m87IynQ8p351I1J3jo7NujMHw
         Klq5C5+AD6haKokxGm1ek2ggifkd6YE4qtJS4+McFvrh6l6xhqD390z7poQh+f6uxey4
         w7lZiQqnKmowXHnLTVOWinw1KCud1SVjx/l1XoieuRkMQydpRw8gIR2KoCGQhdHucqCI
         /eQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678912064;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YB8bCi0OFAJV1cNy2JUVpeOZKfBWS8MkybFkIp+Rpbk=;
        b=jtRH9cEDTX6pqvmBGBO3Ev9UMPTUg7RkXA2Yz/2oKczIZ/xuyuaPvrCvu2Eg5SDfUN
         EPvspRMYN5Ueytk5p3U4jcSW6Mk3E/IT+b2XAb7qg56GbZ46wT1Ory9p0WrL1Igc5rQt
         0YZ7WNVZb1s2zjYm8Q69gzni8W70rJWX9Gx/vsOVPAwfdTBSEnV2zuYm+BJ9usM9vXw9
         UvzBmko0xwx7SM/z6t8oLXKMRMbFuEHI7Z8O2GQeBKr+CXkRuYJZas074YcVzYi4JF7v
         2o9chv7YUj0HngANbbZ6+wPJgX50tyVIukaDS2ElZPpI63FOILK/9VhejCvjpNgo+rzN
         6YoQ==
X-Gm-Message-State: AO0yUKWJ826S1YpPIfgnVtmwhR+cqghss35Qx93CsOZklF9vBNScgjJI
        Hx5tPRasOq9W5f/w7dp7ZE9aXA==
X-Google-Smtp-Source: AK7set9JgcH7RFZcxUhQC2vyLMxD0/MdwkTcPNT6rjc4/UwtMUP8EM4p0QOtSDBhY8RN8QRKSpVHtg==
X-Received: by 2002:a05:6820:1522:b0:520:f76:11e2 with SMTP id ay34-20020a056820152200b005200f7611e2mr21175882oob.9.1678912062878;
        Wed, 15 Mar 2023 13:27:42 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n5-20020a4a8485000000b005252d376caesm2614518oog.22.2023.03.15.13.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 13:27:42 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 15 Mar 2023 21:25:17 +0100
Subject: [PATCH net] hsr: ratelimit only when errors are printed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230315-net-20230315-hsr_framereg-ratelimit-v1-1-61d2ef176d11@tessares.net>
X-B4-Tracking: v=1; b=H4sIAKwpEmQC/z2NwQrCMBAFf6Xs2YWmaUX8FRFJ05dmwUbZBBFK/
 920B48zh5mVMlSQ6dqspPhIlleqYE4N+ejSDJapMnVtZ1trBk4o/IeY9RHULVDMrK7gKYsUtv4
 Swhm9HYyhWhpdBo/qko97qyZ2+1YE+R7v2+Hu2/YDFce4/pAAAAA=
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kristian Overskeid <koverskeid@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2026;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=992nLemSMOYGix02WD9DtzNzaFETn4pgWDlUvy2fi6o=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkEio6GjK4kj/mz2zubIAqSUbe7RZLNfXBmaxki
 quQEiHNBC6JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZBIqOgAKCRD2t4JPQmmg
 c8LFD/9Jjda822CqNJnIzNOgj9PmPXHKXfTpSpEnUFS17XyfykO8h5mpUl3khEQnwRmRQkeG30d
 7MVdQIJD89iA+zCiwNPhxeH4lt1Vf6671/ckE3ERNcIDaGRefOrwd0BLGNyDttcttMY+EY8sDrw
 lrbLKuWQBQ+o26HdYm+bH+nuusIOwRfR/NoSYqwEDhPx++E0YCVpcIx/DIuKeGjNJwbH/MOzidc
 Ed3gyo1RUtlxbHepW4EUiRbgVBkMnYYlWQ/cQ/umc0paMkg4pklnHE/kMvzsCH/5jlOnUYRReRN
 R5HwIWPiM/REVKZHj29nwX3EyfS7KCOms+XozbLUm9WZc+wc03NVy2tB+gFIjPS6UK0oU4+bOfN
 +WYkEjs6T4Cvh6N2MIhT04HCzCfwgksY0W3z5vVWqQzXStfW/eby4P8ZB6Lru7ekGqmI9okXEA3
 Zlx0KH7Xs7KrjoZxSRfHhqtgt6eTmSNlQZJWHWyKPL4potZdrioJqBEvP9RvKc3G8O0pstmx3g5
 vKhotU7HlYDuToiPb3wlNPydwGROlMeBtfYrdlKhfLAwKLfhrcOG35y5pcwkpY7ghrtPvYSveZp
 BKivy9MRWmIo9F6G1T6RLcrdfViFsmU7gD+rmry3tXkEVWVW1aN6xef6aSAMu66WXcfQZKEYPjP
 GL2NoudBREa/jRQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently, when automatically merging -net and net-next in MPTCP devel
tree, our CI reported [1] a conflict in hsr, the same as the one
reported by Stephen in netdev [2].

When looking at the conflict, I noticed it is in fact the v1 [3] that
has been applied in -net and the v2 [4] in net-next. Maybe the v1 was
applied by accident.

As mentioned by Jakub Kicinski [5], the new condition makes more sense
before the net_ratelimit(), not to update net_ratelimit's state which is
unnecessary if we're not going to print either way.

Here, this modification applies the v2 but in -net.

Link: https://github.com/multipath-tcp/mptcp_net-next/actions/runs/4423171069 [1]
Link: https://lore.kernel.org/netdev/20230315100914.53fc1760@canb.auug.org.au/ [2]
Link: https://lore.kernel.org/netdev/20230307133229.127442-1-koverskeid@gmail.com/ [3]
Link: https://lore.kernel.org/netdev/20230309092302.179586-1-koverskeid@gmail.com/ [4]
Link: https://lore.kernel.org/netdev/20230308232001.2fb62013@kernel.org/ [5]
Fixes: 28e8cabe80f3 ("net: hsr: Don't log netdev_err message on unknown prp dst node")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/hsr/hsr_framereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 865eda39d601..b77f1189d19d 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -415,7 +415,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		if (net_ratelimit() && port->hsr->prot_version != PRP_V1)
+		if (port->hsr->prot_version != PRP_V1 && net_ratelimit())
 			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}

---
base-commit: 75014826d0826d175aa9e36cd8e118793263e3f4
change-id: 20230315-net-20230315-hsr_framereg-ratelimit-3c8ff6e43511

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

