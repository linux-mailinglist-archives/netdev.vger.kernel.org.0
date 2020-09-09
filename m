Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4455C262C33
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgIIJnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgIIJml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:42:41 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4002C061786
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 02:42:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u13so1691951pgh.1
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 02:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cJ2b5yC6U6sZBSPpf2NMndA3c8MuYwyg/EbWONDGDEQ=;
        b=lRr0iV7jW0zq00Y+PI9+C7cOPYDyM1oIQtYgXGw2Jok5nCprEdhOZiwh5Vp+h7I5bK
         sDVm/tVXX/1Feq/Yn7thUALZCMh8wcsS13njzNpVOyy+NKgPOQxkgpwOHjheAOj5H8PN
         jPS12IkBQ5rM8aOk+DU5/JDyzG2RLZTleokG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cJ2b5yC6U6sZBSPpf2NMndA3c8MuYwyg/EbWONDGDEQ=;
        b=H0BeHgcqE2Z0xvkLKNbWdf0eO+XqYRoRELBQOjULBKY3NJkqQgQm3058ZkVUduOfXi
         EUuiXs5N1T//M9CpIsfV9dOuUYfr1d/a1m9cMMi4xpz3ZSdr3fA47I6l3tbDb7lqS5OF
         6JfQYAAeK/XNbUvZfiwtUwpTNQYLHorgW81FG6P6pbLfo+bp4eiGFxM8hn2HBrUt+Ig3
         na/bdjR3uPI/CDSIqNm9+7zReUnOS8QHyjfgB7fU92m8S2aG4WmK+nUEGChyXNuDfdqs
         9giDsMA+RINPaU+6uY2WWSzfOepiR8B2Jays/Mx4JjHRzqsK0ef8wdopeVLVMREnfPAM
         e2Yw==
X-Gm-Message-State: AOAM531H1TD6mYCJ1+jpdhT/TKerTVsRUsgtxSMwojmLyp4KrUYTAPvq
        mgNaRwGdjdT65zL32+6XVOo72w==
X-Google-Smtp-Source: ABdhPJy0kQhiImzPyvMTXIoe3S5XBcVzI1ubsHTbbUHt8tNPKWinvH0asFzNdG96HgDS858kUtEN9w==
X-Received: by 2002:a17:902:9349:b029:d0:cb2d:f26c with SMTP id g9-20020a1709029349b02900d0cb2df26cmr156960plp.5.1599644559530;
        Wed, 09 Sep 2020 02:42:39 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:de4a:3eff:fe7d:ff5f])
        by smtp.gmail.com with ESMTPSA id a23sm1692275pgv.86.2020.09.09.02.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 02:42:39 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] Bluetooth: sco: expose WBS packet length in socket option
Date:   Wed,  9 Sep 2020 17:42:02 +0800
Message-Id: <20200909174129.v2.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
In-Reply-To: <20200909094202.3863687-1-josephsih@chromium.org>
References: <20200909094202.3863687-1-josephsih@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is desirable to expose the wideband speech packet length via
a socket option to the user space so that the user space can set
the value correctly in configuring the sco connection.

Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Joseph Hwang <josephsih@chromium.org>
---

(no changes since v1)

 net/bluetooth/sco.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index dcf7f96ff417e6..79ffcdef0b7ad5 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1001,6 +1001,12 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
 			err = -EFAULT;
 		break;
 
+	case BT_SNDMTU:
+	case BT_RCVMTU:
+		if (put_user(sco_pi(sk)->conn->mtu, (u32 __user *)optval))
+			err = -EFAULT;
+		break;
+
 	default:
 		err = -ENOPROTOOPT;
 		break;
-- 
2.28.0.526.ge36021eeef-goog

