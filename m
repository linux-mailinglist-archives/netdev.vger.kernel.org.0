Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCFDCDAD6
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfJGDxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 23:53:45 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43292 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfJGDxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 23:53:45 -0400
Received: by mail-qt1-f194.google.com with SMTP id c4so4612977qtn.10
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 20:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ywt0fo5XmlCz/yUduJq/61+r/9DqWVmIDqG57sndQNw=;
        b=oO0d7um2Q7A91+SDWRNc0ZNdXoaU7RLKCUaYVQeH1i5mK8j7/8o3JuZaIWnobFtN8O
         T1PTRu5s+muQqdiedsR/FxAMIJ3eoI09LyQD5nWckoMC+CD8dH4jTA/4O0MjawDbbs/t
         L/xb+D5IcjRfkAs7IUMzjk38oAZInH4xbMKcdKENDc9CcfhntJn7BJvRLdo9qhJuFxIp
         8UdfA2kaFOKMahLanO/0eXCXUuO4er6ZAre3ZPycFSzZav/gCMC3DzPeet8wmGUJUTNj
         wPLylDaPcYzRdM0u9dZfyfIJW2nihMyxr28jHKdwlBUkv37oTSfeQrth/ED3TjLeJsXm
         tE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ywt0fo5XmlCz/yUduJq/61+r/9DqWVmIDqG57sndQNw=;
        b=kL8FaYEEh2t1xf2U69WECZSg+w695CdVoCiyXL4Hrb3zrkDEFlefh+gbF4atWrxZps
         rvU9fUXsRee0m1J9dG47sveKMDRkDorCCM1GfOY+NYNqeRwZqT2KaXsgMEYANR2I3STh
         4EsxJCtcpVP/kljtszxjW8jIF66xpx4JCwu9Ze6UFdhMW95dKXVDrqqX/a3nlRWNSQoZ
         Lm0JOCknzpeRgJ7JaHaZaLcVCEFcNZ4QtgDBbiADI2DhAph9D3DY8Zh0PUte+PXDpzsA
         K6A5r+s2UvyGKwaKO3BWRtHbpDMD5sOEM85PHmOMqRKsn8FfBaHLf3Z5N/Bl6LYwxKWk
         V9GQ==
X-Gm-Message-State: APjAAAUflcXTB4Iy/Zp71us2QtfAwtsoyuubW0/27ps4qoM5yQ1HiPgr
        WLeVkGIqOcrIPyaKLJoKLqpnvigMFuY=
X-Google-Smtp-Source: APXvYqzXkf/v3GsSlgnS6A1mxGg8MCLOtAEqQ2i61zcW6I0aUSL6yInnAjznpsnnIubANLA3r16Z0g==
X-Received: by 2002:ad4:4649:: with SMTP id y9mr21716056qvv.247.1570420424079;
        Sun, 06 Oct 2019 20:53:44 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 4sm7469863qtf.87.2019.10.06.20.53.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 20:53:43 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        willemb@google.com
Cc:     oss-drivers@netronome.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [RFC 2/2] selftests/tls: test the small receive buffer case
Date:   Sun,  6 Oct 2019 20:53:23 -0700
Message-Id: <20191007035323.4360-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007035323.4360-1-jakub.kicinski@netronome.com>
References: <20191007035323.4360-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS requires the entire record to fit into the receive buffer.
If user sets the receive buffer too low when larger record
arrives strparser returns EMSGSIZE.

Add a test case for this situation.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 tools/testing/selftests/net/tls.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 4c285b6e1db8..39dfbc4a3652 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -694,6 +694,34 @@ TEST_F(tls, recv_lowat)
 	EXPECT_EQ(memcmp(send_mem, recv_mem + 10, 5), 0);
 }
 
+TEST_F(tls, recv_rcvbuf)
+{
+	char send_mem[4096];
+	char recv_mem[4096];
+	int rcv_buf = 1024;
+
+	memset(send_mem, 0x1c, sizeof(send_mem));
+
+	EXPECT_EQ(setsockopt(self->cfd, SOL_SOCKET, SO_RCVBUF,
+			     &rcv_buf, sizeof(rcv_buf)), 0);
+
+	EXPECT_EQ(send(self->fd, send_mem, 512, 0), 512);
+	memset(recv_mem, 0, sizeof(recv_mem));
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), 512);
+	EXPECT_EQ(memcmp(send_mem, recv_mem, 512), 0);
+
+	if (self->notls)
+		return;
+
+	EXPECT_EQ(send(self->fd, send_mem, 4096, 0), 4096);
+	memset(recv_mem, 0, sizeof(recv_mem));
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), -1);
+	EXPECT_EQ(errno, EMSGSIZE);
+
+	EXPECT_EQ(recv(self->cfd, recv_mem, sizeof(recv_mem), 0), -1);
+	EXPECT_EQ(errno, EMSGSIZE);
+}
+
 TEST_F(tls, bidir)
 {
 	char const *test_str = "test_read";
-- 
2.21.0

