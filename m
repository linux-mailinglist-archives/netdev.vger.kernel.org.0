Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7499627CFE6
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgI2Nu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbgI2Nu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:50:56 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22346C061755;
        Tue, 29 Sep 2020 06:50:56 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 7so3918392pgm.11;
        Tue, 29 Sep 2020 06:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=+wk7LoqYbQetQmR+hUJz4dTqK7qk9HGpsFOcpBKxn78=;
        b=S9mj+8ve0KZHeSRdDA4NmfnitNx12B6I2bf5xAelUSUVnZEcbbryncmGxAcMXelZmM
         K0ESMhAb+m05Yg71qQ9mWI/IGr3YQ2+wTvBAqvyK2BumgzXJyM/iexEKtsXVTqwOupJX
         uw6GJqpOrMwZwBzTli7u3vn7gUyyUNIigVqB0B27S61oL87iPCxDvOdBjkJdWXLFtzMh
         weXc38YF3eZah/KqIormfppwsyygnC+ZpAB4L8JyIy0Jq30lgkki/Vrruukg0bmUmr6M
         wuhr+vpHzrPP/v6QoHT59srfUkshZuSRLpEkELKgf1se9L0TlNlOZrBVbgDMTnp5X3wf
         PX7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=+wk7LoqYbQetQmR+hUJz4dTqK7qk9HGpsFOcpBKxn78=;
        b=ojJt2mGt37OTKhBE1QKKphy4+WgijwHJlAoscsmmqJRVZ/aW7WjiwSMdUYI4SFajwN
         UurMrePvPlxC5qLknNPhHTbC3WOKe5N7b3dJxzFmqcZQ/je2q/rSusnlE0vq+R3fNIQL
         V5B0jX88npFdc1DRPj1DwDWM75gfrvmcjreJ62xUuVYiqWtoPN3yFvnIBx8iq++FWvUa
         KFQIWLdNbvIaacm2zoxwK5VWWjWaNry5BO/iwjNqtcGLFD2Lbv6tBdokUrXqrYQD47H9
         tMNoErFFZr2zqmZCbIaHPT31QwAtwFVy9EMWtbzRMJlSn+UpniY5MQnH69Lsw8nn2wMO
         AAoQ==
X-Gm-Message-State: AOAM533R/GJNjHoN2xvL2oklEyACNAC68fNGkEsZn787XDCnXlj3PBbT
        bnUvPClVZmFxWlOecwb6/X0eK9P/Kb8=
X-Google-Smtp-Source: ABdhPJxs7ybb4B1o5EMBKQvlHqrX8y2UYiCCZtFM/TeDqGWhMTydajK+pClFXZwOhV6xXW2HaPrSiQ==
X-Received: by 2002:a17:902:c40d:b029:d2:93e8:1f4b with SMTP id k13-20020a170902c40db02900d293e81f4bmr3529034plk.29.1601387455211;
        Tue, 29 Sep 2020 06:50:55 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gm17sm4674915pjb.46.2020.09.29.06.50.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:50:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 11/15] sctp: add udphdr to overhead when udp_port is set
Date:   Tue, 29 Sep 2020 21:49:03 +0800
Message-Id: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
 <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
 <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
 <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_mtu_payload() is for calculating the frag size before making
chunks from a msg. So we should only add udphdr size to overhead
when udp socks are listening, as only then sctp can handling the
incoming sctp over udp packets and outgoing sctp over udp packets
will be possible.

Note that we can't do this according to transport->encap_port, as
different transports may be set to different values, while the
chunks were made before choosing the transport, we could not be
able to meet all rfc6951#section-5.6 requires.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index bfd87a0..6408bbb 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -578,10 +578,13 @@ static inline __u32 sctp_mtu_payload(const struct sctp_sock *sp,
 {
 	__u32 overhead = sizeof(struct sctphdr) + extra;
 
-	if (sp)
+	if (sp) {
 		overhead += sp->pf->af->net_header_len;
-	else
+		if (sock_net(&sp->inet.sk)->sctp.udp_port)
+			overhead += sizeof(struct udphdr);
+	} else {
 		overhead += sizeof(struct ipv6hdr);
+	}
 
 	if (WARN_ON_ONCE(mtu && mtu <= overhead))
 		mtu = overhead;
-- 
2.1.0

