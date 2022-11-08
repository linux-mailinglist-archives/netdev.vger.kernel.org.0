Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6536214F6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiKHOHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiKHOHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:07:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0809686AD
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667916372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sl3yRy218aHzyQly56lFG09Q5E7qWzHqb5L/W0IjWek=;
        b=X0POqJU/TI5Rz4ak6BWbpvvWjRNlydZwzxLx4xVsklY6uDuvXUqu0yxyRH7Y7Jc6kpIBWJ
        RNsYkr1o+85wb/RFxr1S8XtzVFk/k6k7jxPrFxstzNejXiNcTBbkoILQFJLtJCcIQILdQi
        jokwQAaRxiNixzj27O1bZgWWxNG4Dfc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-562-cwpmC9nUO5iN-68k74lP9A-1; Tue, 08 Nov 2022 09:06:08 -0500
X-MC-Unique: cwpmC9nUO5iN-68k74lP9A-1
Received: by mail-ej1-f72.google.com with SMTP id nc4-20020a1709071c0400b0078a5ceb571bso8397015ejc.4
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:06:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sl3yRy218aHzyQly56lFG09Q5E7qWzHqb5L/W0IjWek=;
        b=J+OqmsjKzn4d/Z7BpoOOjtihzQOw5TneXxZygeLwgSgE1GWUBEmUWCjnWHycO6GrHF
         dDHsaG58Znqjjb/d00gGnhZKbHcVKMALkIQj44N5t7hT64EiY/66BV5P7t2L9HNt/La+
         qQ72+5jQCedaP0lbb+xhTnVz9m6PNK5k29gkauQyq6jAU8RYqgodK1/506ZxOlkH4pp7
         6dEFBEFKCEgKqyxNxmLhsVuMHkRS7x+FFRws7xFKs72NF4j3wCeacxE7yOBBTHQuYkFM
         FHT2KYOcMEX1Zpk8PdJimLMtJS6GHBF6XTnMLc8RPjOcm/vofS7lbjEpuI6bVQOgPBuA
         SUXQ==
X-Gm-Message-State: ACrzQf1fBn8B4C7EV4XzTle9Je9UlhfLFewbW7JWkmYJ1v/ux2+yvDOh
        0MeHwojvmpsz/mm+c8+4BgebCkq9tjJW8zN96DLHBFagAzYdjKbjDVwaG1+62ThWqd+x4wbLLrS
        lMyFjwV92sMOZMKNr
X-Received: by 2002:a05:6402:22f1:b0:462:f6eb:6c6b with SMTP id dn17-20020a05640222f100b00462f6eb6c6bmr55960114edb.365.1667916365697;
        Tue, 08 Nov 2022 06:06:05 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5NJ2carxvOY0HrxOeFub8azKnPISPzrmR2iGDEEi5HaGLkHXFnfsllxFWTzbboNTOG2giGoA==
X-Received: by 2002:a05:6402:22f1:b0:462:f6eb:6c6b with SMTP id dn17-20020a05640222f100b00462f6eb6c6bmr55959945edb.365.1667916363837;
        Tue, 08 Nov 2022 06:06:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a16-20020a170906369000b0078d9c2c8250sm4679728ejc.84.2022.11.08.06.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:06:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E65E278152D; Tue,  8 Nov 2022 15:06:02 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 1/3] dev: Move received_rps counter next to RPS members in softnet data
Date:   Tue,  8 Nov 2022 15:05:59 +0100
Message-Id: <20221108140601.149971-2-toke@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108140601.149971-1-toke@redhat.com>
References: <20221108140601.149971-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the received_rps counter value next to the other RPS-related members
in softnet_data. This closes two four-byte holes in the structure, making
room for another pointer in the first two cache lines without bumping the
xmit struct to its own line.

Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4b5052db978f..31c53d409743 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3114,7 +3114,6 @@ struct softnet_data {
 	/* stats */
 	unsigned int		processed;
 	unsigned int		time_squeeze;
-	unsigned int		received_rps;
 #ifdef CONFIG_RPS
 	struct softnet_data	*rps_ipi_list;
 #endif
@@ -3147,6 +3146,7 @@ struct softnet_data {
 	unsigned int		cpu;
 	unsigned int		input_queue_tail;
 #endif
+	unsigned int		received_rps;
 	unsigned int		dropped;
 	struct sk_buff_head	input_pkt_queue;
 	struct napi_struct	backlog;
-- 
2.38.1

