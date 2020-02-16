Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A216050D
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 18:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgBPR2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 12:28:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35284 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgBPR2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 12:28:20 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so5773993plt.2;
        Sun, 16 Feb 2020 09:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=li9wRD+trYzeYRrIDTG7VErShRh4YzHNS/3QPJhsHYs=;
        b=R9a6Mac428S9opSV3aq/ZhqE30jY6lafTCf7S2d1eJ1E99RSCGWcpDXTeZ3Vg3+GyD
         ihz21YJzlyYeM3anV69vpMgMV6lksRliQJ0HCBJbYfSLI+6QzXpoQOwW0aU0izce8Ky+
         BvU/CsSiIhoznN0iXSXvbX23to+afL5HRUjQ/g0BjQj+mjhbeXlEqW0wLFe15ZHEn8Ip
         VZjDKptRZCNYMvxaU/Ngrb0Ps89+DO1AkcGFEVdK/ApL+P+Exqzjhlh3gNRNjQnnyuqJ
         MzGQYvNnAP301j1JSOtlVfkSF9EnxwP70stmA832B99N7jjUloV4FBtKk5SXhWB1f6Wf
         EL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=li9wRD+trYzeYRrIDTG7VErShRh4YzHNS/3QPJhsHYs=;
        b=iaA5Q+1xyKP1pbhr56lv/UDb+60N4WfU2CkhyiesjpEZk1tNfwoxgk7Co294bNA1Fa
         f1aYZYX6knoLVyAnRBCI2D2/3HQHIys3fXFm9Nxgkd6J5V2ehz9lke7yrtZ92yirtLWU
         qaB0VViWdipKJS00h8ZF20SHyzN2w6Kyamh8c2njePoxrgzM7l4lRPcpe6gXn/qNxOll
         T6HcPL0+BAxwXw+X8r0vm2AKtEi4JT0rtGwqZSi00LKHBb+kq86aaYsDulG0YG9utp5k
         f67y46QBBbPlSKrZ0KWpAbIZf0xj1tikg3gQ8xmWYOBtA2LAjY4w/NQzKbjGwq77cI+q
         kdNA==
X-Gm-Message-State: APjAAAXWiJqvZEWHExDCv4HSVatTIy+Af+9sAu0Xc5nTNNOs2cJ+QR7i
        unvrGnFXO6s/K8jZBjXGvX4=
X-Google-Smtp-Source: APXvYqwnA7pjS1054IxgkOuF4Ptq6AKSK3rxTwoaU0ILSWvT53J2OayxuX5Dez18xr9oJSMfJG/xXg==
X-Received: by 2002:a17:902:6a88:: with SMTP id n8mr12421746plk.265.1581874098693;
        Sun, 16 Feb 2020 09:28:18 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.250])
        by smtp.googlemail.com with ESMTPSA id iq22sm13836213pjb.9.2020.02.16.09.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 09:28:18 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH] netfilter: ipset: Pass lockdep expression to RCU lists
Date:   Sun, 16 Feb 2020 22:56:54 +0530
Message-Id: <20200216172653.19772-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_set_type_list is traversed using list_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of ip_set_type_mutex.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index cf895bc80871..97c851589160 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -86,7 +86,8 @@ find_set_type(const char *name, u8 family, u8 revision)
 {
 	struct ip_set_type *type;
 
-	list_for_each_entry_rcu(type, &ip_set_type_list, list)
+	list_for_each_entry_rcu(type, &ip_set_type_list, list,
+				lockdep_is_held(&ip_set_type_mutex))
 		if (STRNCMP(type->name, name) &&
 		    (type->family == family ||
 		     type->family == NFPROTO_UNSPEC) &&
-- 
2.24.1

